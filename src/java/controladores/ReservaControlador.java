/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;
import conexion.connectionDriver;
import entidades.Clientes;
import entidades.Empleados;
import entidades.Habitaciones;
import entidades.Reservas;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
/**
 *
 * @author dzs-1
 */
public class ReservaControlador {
     // Estados que consideramos "ocupando" la habitación físicamente.
    private static final List<String> ESTADOS_ACTIVOS = List.of("Pendiente", "Confirmada", "Activa");

    // Estados terminales: una vez aquí, la reserva ya vivió su ciclo completo
    // y no debe volver a modificarse ni reabrirse (solo consultarse/eliminarse
    // del historial si ya no se necesita).
    private static final List<String> ESTADOS_FINALES = List.of("Cancelada", "Finalizada");

    // ==============================================================================
    // 0. VALIDACIÓN DE CRUCE DE FECHAS (evita doble reserva de la misma habitación)
    // Se basa en el rango real de fechas de cada reserva activa, no solo en el
    // estado "Disponible/Ocupado" de la habitación, para poder detectar choques
    // aunque se trate de una reserva a futuro.
    // ==============================================================================
    private boolean existeSolapamiento(EntityManager em, int idHabitacion, Date checkIn, Date checkOut, Integer idReservaExcluir) {
        String jpql = "SELECT COUNT(r) FROM Reservas r "
                + "WHERE r.idHabitacion.idHabitacion = :idHabitacion "
                + "AND r.estadoReserva IN :estadosActivos "
                + "AND r.fechaCheckIn < :checkOut AND r.fechaCheckOutEsperada > :checkIn"
                + (idReservaExcluir != null ? " AND r.idReserva <> :idExcluir" : "");

        TypedQuery<Long> query = em.createQuery(jpql, Long.class)
                .setParameter("idHabitacion", idHabitacion)
                .setParameter("estadosActivos", ESTADOS_ACTIVOS)
                .setParameter("checkOut", checkOut)
                .setParameter("checkIn", checkIn);
        if (idReservaExcluir != null) {
            query.setParameter("idExcluir", idReservaExcluir);
        }
        return query.getSingleResult() > 0;
    }
 
    // ==============================================================================
    // 1. LISTAR TODAS LAS RESERVAS (con datos de cliente, habitación y empleado)
    // ==============================================================================
    public List<Reservas> obtenerReservas() {
        if (connectionDriver.getEmf() == null) {
            System.err.println("Error: No hay conexión con la base de datos en ReservaControlador.");
            return new ArrayList<>();
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            TypedQuery<Reservas> query = em.createQuery(
                    "SELECT r FROM Reservas r "
                    + "LEFT JOIN FETCH r.idCliente "
                    + "LEFT JOIN FETCH r.idHabitacion h "
                    + "LEFT JOIN FETCH h.idTipo "
                    + "LEFT JOIN FETCH r.idEmpleado "
                    + "ORDER BY r.fechaCheckIn DESC", Reservas.class);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Error al obtener la lista de reservas: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    // ==============================================================================
    // 1b. LISTAS DE APOYO PARA LOS COMBOS DEL FORMULARIO (Clientes, Empleados, Habitaciones)
    // ==============================================================================
    public List<Clientes> obtenerClientes() {
        if (connectionDriver.getEmf() == null) {
            return new ArrayList<>();
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT c FROM Clientes c WHERE c.estado = 'Activo' ORDER BY c.nombres, c.apellidos",
                    Clientes.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al obtener la lista de clientes: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Empleados> obtenerEmpleados() {
        if (connectionDriver.getEmf() == null) {
            return new ArrayList<>();
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT e FROM Empleados e ORDER BY e.nombre, e.apellido",
                    Empleados.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al obtener la lista de empleados: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Devuelve las habitaciones "Disponible" más -si estamos editando- la habitación
    // que la reserva ya tiene asignada (aunque esté "Ocupado"), para que no desaparezca del combo.
    public List<Habitaciones> obtenerHabitacionesParaCombo(Integer idHabitacionActual) {
        if (connectionDriver.getEmf() == null) {
            return new ArrayList<>();
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            List<Habitaciones> disponibles = em.createQuery(
                    "SELECT h FROM Habitaciones h LEFT JOIN FETCH h.idTipo "
                    + "WHERE h.estadoDisponibilidad = 'Disponible' AND h.activo = true "
                    + "ORDER BY h.piso, h.numeroHabitacion", Habitaciones.class).getResultList();

            if (idHabitacionActual != null) {
                boolean yaIncluida = disponibles.stream()
                        .anyMatch(h -> h.getIdHabitacion().equals(idHabitacionActual));
                if (!yaIncluida) {
                    Habitaciones actual = em.createQuery(
                            "SELECT h FROM Habitaciones h LEFT JOIN FETCH h.idTipo WHERE h.idHabitacion = :id",
                            Habitaciones.class)
                            .setParameter("id", idHabitacionActual)
                            .getResultStream().findFirst().orElse(null);
                    if (actual != null) {
                        disponibles.add(0, actual);
                    }
                }
            }
            return disponibles;
        } catch (Exception e) {
            System.err.println("Error al obtener habitaciones para el combo: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // 2. BUSCAR UNA RESERVA POR SU ID
    // ==============================================================================
    public Reservas buscarPorId(int idReserva) {
        if (connectionDriver.getEmf() == null) {
            return null;
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(Reservas.class, idReserva);
        } catch (Exception e) {
            System.err.println("Error al buscar la reserva: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    // ==============================================================================
    // 3. INSERTAR RESERVA (método básico ya existente, se conserva por compatibilidad)
    // ==============================================================================
    public void insertarReserva(Reservas res) throws Exception {
        if (connectionDriver.getEmf() == null) {
            throw new Exception("Error: No hay conexión con la base de datos.");
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.persist(res);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Error al insertar la reserva: " + e.getMessage());
            throw e;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    // ==============================================================================
    // 4. CREAR RESERVA COMPLETA (valida habitación disponible y la marca Ocupada)
    // ==============================================================================
    public void crearReserva(int idCliente, int idHabitacion, int idEmpleado,
            Date checkIn, Date checkOutEsperada, String estado) throws Exception {
 
        if (checkOutEsperada.before(checkIn)) {
            throw new Exception("La fecha de Check-Out esperada no puede ser anterior al Check-In.");
        }
 
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
 
            Clientes cliente = em.find(Clientes.class, idCliente);
            if (cliente == null) {
                throw new Exception("El huésped seleccionado no existe.");
            }
            Habitaciones habitacion = em.find(Habitaciones.class, idHabitacion);
            if (habitacion == null) {
                throw new Exception("La habitación seleccionada no existe.");
            }
            Empleados empleado = em.find(Empleados.class, idEmpleado);
            if (empleado == null) {
                throw new Exception("El empleado seleccionado no existe.");
            }
            if (!habitacion.getActivo()) {
                throw new Exception("La habitación " + habitacion.getNumeroHabitacion() + " está fuera de servicio y no puede reservarse.");
            }
            if (ESTADOS_ACTIVOS.contains(estado) && existeSolapamiento(em, idHabitacion, checkIn, checkOutEsperada, null)) {
                throw new Exception("La habitación " + habitacion.getNumeroHabitacion()
                        + " ya tiene otra reserva activa que se cruza con esas fechas. Elija otra habitación o corrija las fechas.");
            }
 
            Reservas res = new Reservas();
            res.setIdCliente(cliente);
            res.setIdHabitacion(habitacion);
            res.setIdEmpleado(empleado);
            res.setFechaCheckIn(checkIn);
            res.setFechaCheckOutEsperada(checkOutEsperada);
            res.setEstadoReserva(estado);
            em.persist(res);
 
            if (ESTADOS_ACTIVOS.contains(estado)) {
                habitacion.setEstadoDisponibilidad("Ocupado");
                em.merge(habitacion);
            }
 
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception(e.getMessage() != null ? e.getMessage() : "Error desconocido al crear la reserva.");
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    // ==============================================================================
    // 4b. REGISTRAR RESERVA (wrapper simple usado por JspGrabarReserva.jsp)
    // El formulario no pide un estado inicial, así que se crea como "Pendiente".
    // ==============================================================================
    public void registrarReserva(int idCliente, int idHabitacion, int idEmpleado,
            Date checkIn, Date checkOutEsperada) throws Exception {
        crearReserva(idCliente, idHabitacion, idEmpleado, checkIn, checkOutEsperada, "Pendiente");
    }

    // ==============================================================================
    // 5. ACTUALIZAR RESERVA (permite cambiar de habitación liberando la anterior)
    // ==============================================================================
    public void actualizarReserva(int idReserva, int idCliente, int idHabitacionNueva, int idEmpleado,
            Date checkIn, Date checkOutEsperada, String estado) throws Exception {
 
        if (checkOutEsperada.before(checkIn)) {
            throw new Exception("La fecha de Check-Out esperada no puede ser anterior al Check-In.");
        }
 
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
 
            Reservas res = em.find(Reservas.class, idReserva);
            if (res == null) {
                throw new Exception("La reserva con ID " + idReserva + " no existe.");
            }
            if (res.getEstadoReserva() != null && ESTADOS_FINALES.contains(res.getEstadoReserva())) {
                throw new Exception("Esta reserva ya está " + res.getEstadoReserva()
                        + " y no se puede modificar. Si el huésped necesita alojarse de nuevo, registre una reserva nueva.");
            }
            if (ESTADOS_FINALES.contains(estado) && !ESTADOS_FINALES.contains(res.getEstadoReserva())) {
                throw new Exception("Para cancelar o finalizar una reserva use las opciones 'Anular' o 'Check-out', "
                        + "así se registra correctamente la fecha de salida y la limpieza de la habitación.");
            }
            Clientes cliente = em.find(Clientes.class, idCliente);
            if (cliente == null) {
                throw new Exception("El huésped seleccionado no existe.");
            }
            Empleados empleado = em.find(Empleados.class, idEmpleado);
            if (empleado == null) {
                throw new Exception("El empleado seleccionado no existe.");
            }
            Habitaciones habitacionNueva = em.find(Habitaciones.class, idHabitacionNueva);
            if (habitacionNueva == null) {
                throw new Exception("La habitación seleccionada no existe.");
            }
            if (!habitacionNueva.getActivo()) {
                throw new Exception("La habitación " + habitacionNueva.getNumeroHabitacion() + " está fuera de servicio y no puede reservarse.");
            }
 
            Habitaciones habitacionAnterior = res.getIdHabitacion();
            boolean cambiaHabitacion = habitacionAnterior == null
                    || !habitacionAnterior.getIdHabitacion().equals(habitacionNueva.getIdHabitacion());
 
            if (ESTADOS_ACTIVOS.contains(estado)
                    && existeSolapamiento(em, idHabitacionNueva, checkIn, checkOutEsperada, idReserva)) {
                throw new Exception("La habitación " + habitacionNueva.getNumeroHabitacion()
                        + " ya tiene otra reserva activa que se cruza con esas fechas. Elija otra habitación o corrija las fechas.");
            }
 
            res.setIdCliente(cliente);
            res.setIdEmpleado(empleado);
            res.setFechaCheckIn(checkIn);
            res.setFechaCheckOutEsperada(checkOutEsperada);
            res.setEstadoReserva(estado);
            res.setIdHabitacion(habitacionNueva);
            em.merge(res);
 
            if (cambiaHabitacion && habitacionAnterior != null) {
                habitacionAnterior.setEstadoDisponibilidad("Disponible");
                em.merge(habitacionAnterior);
            }
 
            if (ESTADOS_ACTIVOS.contains(estado)) {
                habitacionNueva.setEstadoDisponibilidad("Ocupado");
            } else {
                habitacionNueva.setEstadoDisponibilidad("Disponible");
            }
            em.merge(habitacionNueva);
 
            em.getTransaction().commit();
            em.getEntityManagerFactory().getCache().evictAll();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception(e.getMessage() != null ? e.getMessage() : "Error desconocido al actualizar la reserva.");
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    // ==============================================================================
    // 5b. ACTUALIZAR RESERVA (sobrecarga sin estado, usada por JspActualizarReserva.jsp).
    // El formulario de edición no expone un combo de estado, así que se conserva
    // el estado que la reserva ya tenía.
    // ==============================================================================
    public void actualizarReserva(int idReserva, int idCliente, int idHabitacionNueva, int idEmpleado,
            Date checkIn, Date checkOutEsperada) throws Exception {
        String estadoActual = "Pendiente";
        Reservas existente = buscarPorId(idReserva);
        if (existente != null && existente.getEstadoReserva() != null) {
            estadoActual = existente.getEstadoReserva();
        }
        actualizarReserva(idReserva, idCliente, idHabitacionNueva, idEmpleado, checkIn, checkOutEsperada, estadoActual);
    }

    // ==============================================================================
    // 6. ELIMINAR RESERVA (libera automáticamente la habitación asociada)
    // ==============================================================================
    public void eliminarReserva(int idReserva) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
 
            Reservas res = em.find(Reservas.class, idReserva);
            if (res == null) {
                throw new Exception("La reserva ya no existe.");
            }
            if (res.getEstadoReserva() == null || !ESTADOS_FINALES.contains(res.getEstadoReserva())) {
                throw new Exception("Solo se pueden eliminar reservas ya 'Canceladas' o 'Finalizadas'. "
                        + "Primero use 'Anular' o registre el check-out; así no se corre el riesgo de "
                        + "liberar por error una habitación que ya esté ocupada por otro huésped.");
            }
            // Nota: no se toca aquí el estado de la habitación. Al llegar a un
            // estado final (Cancelada/Finalizada) la habitación YA quedó
            // liberada por cancelarReserva()/registrarCheckOut(); volver a
            // tocarla aquí podría liberar por error una habitación que ya fue
            // asignada a una reserva más reciente.
            em.remove(res);
 
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo eliminar la reserva: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    // ==============================================================================
    // 7. REGISTRAR CHECK-OUT (marca la salida real y libera la habitación)
    // ==============================================================================
    public void registrarCheckOut(int idReserva) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
 
            Reservas res = em.find(Reservas.class, idReserva);
            if (res == null) {
                throw new Exception("La reserva ya no existe.");
            }
            if (res.getEstadoReserva() != null && ESTADOS_FINALES.contains(res.getEstadoReserva())) {
                throw new Exception("Esta reserva ya está " + res.getEstadoReserva() + " y no admite un nuevo check-out.");
            }
            res.setFechaCheckOutReal(new Date());
            res.setEstadoReserva("Finalizada");
            em.merge(res);
 
            Habitaciones hab = res.getIdHabitacion();
            if (hab != null) {
                hab.setEstadoDisponibilidad("Disponible");
                hab.setEstadoLimpieza("Sucio");
                em.merge(hab);
            }
 
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar el check-out: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    // ==============================================================================
    // 8. CANCELAR RESERVA (libera la habitación sin registrar check-out real)
    // ==============================================================================
    public void cancelarReserva(int idReserva) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
 
            Reservas res = em.find(Reservas.class, idReserva);
            if (res == null) {
                throw new Exception("La reserva ya no existe.");
            }
            if (res.getEstadoReserva() != null && ESTADOS_FINALES.contains(res.getEstadoReserva())) {
                throw new Exception("Esta reserva ya está " + res.getEstadoReserva() + " y no se puede anular de nuevo.");
            }
            res.setEstadoReserva("Cancelada");
            em.merge(res);
 
            Habitaciones hab = res.getIdHabitacion();
            if (hab != null) {
                hab.setEstadoDisponibilidad("Disponible");
                em.merge(hab);
            }
 
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo cancelar la reserva: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
