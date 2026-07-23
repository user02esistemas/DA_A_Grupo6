/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;
import conexion.connectionDriver;
import entidades.Clientes;
import entidades.Habitaciones;
import entidades.Reservas;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
/**
 *
 * @author dzs-1
 */
public class clienteControlador {
      // ==============================================================================
    // 🌟 MÉTODO: Integra el registro del cliente y la reserva con AMBOS Combobox
    // ==============================================================================
    public void registrarClienteYReserva(String nombre, String apellido, String documento, 
                                         String telefono, String correo, String idHabitacionStr) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            // 1. Insertar Cliente usando los nombres correctos de tus columnas de SQL Server
            String sqlInsertCliente = "INSERT INTO clientes (dni_ruc, nombres, apellidos, telefono, email, estado) " +
                                       "VALUES (?1, ?2, ?3, ?4, ?5, 'Activo')";
            em.createNativeQuery(sqlInsertCliente)
              .setParameter(1, documento)
              .setParameter(2, nombre)
              .setParameter(3, apellido)
              .setParameter(4, telefono)
              .setParameter(5, correo)
              .executeUpdate();

            // 2. Obtener el ID autogenerado del nuevo cliente de manera directa y segura con @@IDENTITY
            Object idClienteGenerated = em.createNativeQuery("SELECT @@IDENTITY").getSingleResult();
            if (idClienteGenerated == null) {
                throw new Exception("No se pudo recuperar el identificador único del huésped generado.");
            }
            int idClienteNuevo = ((Number) idClienteGenerated).intValue();

            // 3. Procesar y validar la habitación seleccionada desde el combobox desplegable
            if (idHabitacionStr == null || idHabitacionStr.trim().isEmpty() || idHabitacionStr.contains("Seleccione")) {
                throw new Exception("Debe seleccionar un número de habitación física asignada de la lista desplegable.");
            }
            int idHabitacionSeleccionada = Integer.parseInt(idHabitacionStr.trim());

            // 🌟 CORRECCIÓN: antes de reservar, verificamos que la habitación siga
            // realmente disponible. Sin esto, el sistema permitía asignar (y dejaba
            // aparecer en el combo) habitaciones que ya estaban "Ocupado", generando
            // dobles reservas sobre la misma habitación física.
            Habitaciones habitacionSeleccionada = em.find(Habitaciones.class, idHabitacionSeleccionada);
            if (habitacionSeleccionada == null) {
                throw new Exception("La habitación seleccionada no existe.");
            }
            if (!"Disponible".equalsIgnoreCase(habitacionSeleccionada.getEstadoDisponibilidad())) {
                throw new Exception("La habitación " + habitacionSeleccionada.getNumeroHabitacion()
                        + " ya no está disponible. Por favor seleccione otra.");
            }

            // 4. Cambiar el estado de la Habitación a 'Ocupado' en la Base de Datos
            em.createNativeQuery("UPDATE Habitaciones SET estadoDisponibilidad = 'Ocupado' WHERE idHabitacion = ?1")
              .setParameter(1, idHabitacionSeleccionada)
              .executeUpdate();

            // 5. 🚀 CONTROL DE SEGURIDAD: Buscar un empleado o crearlo si la tabla está vacía
            List<?> listaEmp = em.createNativeQuery("SELECT TOP 1 idEmpleado FROM Empleados").getResultList();
            Object idEmpleado;
            
            if (listaEmp.isEmpty()) {
                // Si borraste los empleados, el sistema creará uno de respaldo automáticamente para no fallar
                String sqlInsertEmpleadoBase = "INSERT INTO Empleados (nombre, apellido, rol, dni, telefono) VALUES ('Recepcionista', 'General', 'Recepcion', '00000000', '999999999')";
                em.createNativeQuery(sqlInsertEmpleadoBase).executeUpdate();
                idEmpleado = em.createNativeQuery("SELECT @@IDENTITY").getSingleResult();
            } else {
                idEmpleado = listaEmp.get(0);
            }

            // 6. Registrar la Reserva vinculando al Cliente, Habitación y Empleado de manera simultánea
            String sqlInsertReserva = "INSERT INTO Reservas (id_cliente, idHabitacion, idEmpleado, fechaCheckIn, fechaCheckOutEsperada, estadoReserva) " +
                                       "VALUES (?1, ?2, ?3, GETDATE(), DATEADD(day, 1, GETDATE()), 'Activa')";
            em.createNativeQuery(sqlInsertReserva)
              .setParameter(1, idClienteNuevo)
              .setParameter(2, idHabitacionSeleccionada)
              .setParameter(3, idEmpleado)
              .executeUpdate();

            em.getTransaction().commit();

        } catch (Exception e) {
            if (em != null && em.isOpen() && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("Fallo en la persistencia del hotel: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // 1. OBTENER TODOS LOS CLIENTES (Optimizado)
    // ==============================================================================
    public List<Clientes> obtenerClientes() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                System.err.println("Error: El EntityManagerFactory es nulo. Revisa la conexión.");
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery("SELECT c FROM Clientes c", Clientes.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al obtener lista de clientes: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }

    // ==============================================================================
    // 2. BUSCAR UN CLIENTE POR SU ID (Optimizado)
    // ==============================================================================
    public Clientes buscarPorId(int idCliente) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) return null;
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(Clientes.class, idCliente);
        } catch (Exception e) {
            System.err.println("Error al buscar cliente por ID: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }

    // ==============================================================================
    // 3. INSERTAR UN NUEVO CLIENTE (Básico - Solo Cliente)
    // ==============================================================================
    public void insertarCliente(Clientes cli) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.persist(cli);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }

    // ==============================================================================
    // 4. ACTUALIZAR DATOS DE UN CLIENTE
    // ==============================================================================
    public void actualizarCliente(Clientes cli) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.merge(cli);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }

    // ==============================================================================
    // 5. ELIMINAR UN CLIENTE (💥 AUTOMATIZADO: Libera la habitación y borra reservas)
    // ==============================================================================
    public void eliminarCliente(int idCliente) throws Exception {
    EntityManager em = null;
    try {
        em = connectionDriver.getEmf().createEntityManager();
        em.getTransaction().begin();

        // 🌟 CORRECCIÓN AQUÍ: Comparamos directamente el objeto 'idCliente' con el parámetro ':idCli'
        List<Reservas> reservasAsociadas = em.createQuery("SELECT r FROM Reservas r WHERE r.idCliente = :idCli", Reservas.class)
                                             .setParameter("idCli", em.find(Clientes.class, idCliente)) // Buscamos el objeto Clientes primero
                                             .getResultList();

        // B. Si tiene reserva(s), liberamos la habitación física SOLO si la reserva
        // que se está borrando es la que realmente la tiene ocupada ahora mismo.
        // 🌟 CORRECCIÓN: antes se liberaba la habitación por CADA reserva del cliente,
        // incluyendo reservas ya Finalizadas/Canceladas. Si esa habitación ya había
        // sido re-asignada a otro huésped con una reserva activa distinta, borrar a
        // este cliente antiguo la marcaba como "Disponible" por error, aunque
        // estuviera ocupada en ese momento por otra persona.
        java.util.List<String> estadosActivos = java.util.List.of("Pendiente", "Confirmada", "Activa");
        for (Reservas res : reservasAsociadas) {
            if (res.getIdHabitacion() != null && estadosActivos.contains(res.getEstadoReserva())) {
                Habitaciones hab = res.getIdHabitacion();
                hab.setEstadoDisponibilidad("Disponible"); // Cambia de Ocupado -> Disponible automáticamente
                em.merge(hab);
            }
            // C. Eliminamos la reserva para que no cause errores de llave foránea
            em.remove(res);
        }

        // D. Finalmente, borramos al cliente de forma segura
        Clientes cli = em.find(Clientes.class, idCliente);
        if (cli != null) {
            em.remove(cli);
        }
        
        em.getTransaction().commit();
    } catch (Exception e) {
        if (em != null && em.getTransaction().isActive()) em.getTransaction().rollback();
        throw new Exception("Error al eliminar cliente y liberar habitación de forma automática: " + e.getMessage());
    } finally {
        if (em != null && em.isOpen()) em.close();
    }
}

    // ==============================================================================
    // 6. ACTUALIZAR CLIENTE Y CAMBIAR SU HABITACIÓN
    // ==============================================================================
    // ==============================================================================
    // 6. ACTUALIZAR CLIENTE Y CAMBIAR SU HABITACIÓN (Corregido y Seguro)
    // ==============================================================================
    public void actualizarClienteYHabitacion(int idCliente, String nombre, String apellido, String documento, 
                                             String telefono, String correo, int idHabitacionNueva) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Clientes cli = em.find(Clientes.class, idCliente);
            if (cli != null) {
                cli.setNombres(nombre);
                cli.setApellidos(apellido);
                cli.setDniRuc(documento);
                cli.setTelefono(telefono);
                cli.setEmail(correo);
                em.merge(cli);
            } else {
                throw new Exception("Cliente no encontrado en la Base de Datos.");
            }

            // 🌟 CORRECCIÓN: antes se tomaba listaReservas.get(0) sin ORDER BY, es decir
            // una reserva cualquiera (podía ser una antigua ya Finalizada/Cancelada) en
            // vez de la reserva activa real del huésped. Ahora filtramos explícitamente
            // por el estado activo y tomamos la más reciente.
            List<Reservas> listaReservas = em.createQuery(
                    "SELECT r FROM Reservas r WHERE r.idCliente = :idCli "
                    + "AND r.estadoReserva IN ('Pendiente','Confirmada','Activa') "
                    + "ORDER BY r.fechaCheckIn DESC", Reservas.class)
                    .setParameter("idCli", cli)
                    .getResultList();

            if (!listaReservas.isEmpty()) {
                Reservas reservaActual = listaReservas.get(0);
                Habitaciones habVieja = reservaActual.getIdHabitacion();

                if (habVieja != null && !habVieja.getIdHabitacion().equals(idHabitacionNueva)) {

                    Habitaciones habNueva = em.find(Habitaciones.class, idHabitacionNueva);
                    if (habNueva == null) {
                        throw new Exception("La habitación seleccionada no existe.");
                    }
                    // 🌟 CORRECCIÓN: validar que la nueva habitación esté realmente disponible
                    // antes de moverla, para no generar una doble ocupación.
                    if (!"Disponible".equalsIgnoreCase(habNueva.getEstadoDisponibilidad())) {
                        throw new Exception("La habitación " + habNueva.getNumeroHabitacion() + " ya no está disponible.");
                    }

                    habVieja.setEstadoDisponibilidad("Disponible");
                    em.merge(habVieja);

                    habNueva.setEstadoDisponibilidad("Ocupado");
                    em.merge(habNueva);

                    reservaActual.setIdHabitacion(habNueva);
                    em.merge(reservaActual);
                }
            }
            
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }
}
