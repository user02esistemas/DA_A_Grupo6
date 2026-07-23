/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

import conexion.connectionDriver;
import entidades.Empleados;
import entidades.Habitaciones;
import entidades.HistorialLimpieza;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;

/**
 *
 * @author dzs-1
 */
public class HistorialLimpiezaControlador {

    // ==============================================================================
    // LISTAR TODO EL HISTORIAL (con habitación y empleado ya cargados)
    // ==============================================================================
    public List<HistorialLimpieza> obtenerHistorial() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT h FROM HistorialLimpieza h "
                    + "LEFT JOIN FETCH h.idHabitacion "
                    + "LEFT JOIN FETCH h.idEmpleado "
                    + "ORDER BY h.fechaHoraInicio DESC",
                    HistorialLimpieza.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar historial de limpieza: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // LISTAR HISTORIAL DE UNA HABITACIÓN ESPECÍFICA
    // ==============================================================================
    public List<HistorialLimpieza> listarPorHabitacion(int idHabitacion) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT h FROM HistorialLimpieza h WHERE h.idHabitacion.idHabitacion = :idHab "
                    + "ORDER BY h.fechaHoraInicio DESC",
                    HistorialLimpieza.class)
                    .setParameter("idHab", idHabitacion)
                    .getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar historial por habitación: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // BUSCAR UN REGISTRO POR ID
    // ==============================================================================
    public HistorialLimpieza buscarPorId(int idLimpieza) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(HistorialLimpieza.class, idLimpieza);
        } catch (Exception e) {
            System.err.println("Error al buscar registro de limpieza: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public Habitaciones buscarHabitacionPorId(int idHabitacion) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(Habitaciones.class, idHabitacion);
        } catch (Exception e) {
            System.err.println("Error al buscar habitación: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public Empleados buscarEmpleadoPorId(int idEmpleado) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(Empleados.class, idEmpleado);
        } catch (Exception e) {
            System.err.println("Error al buscar empleado: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // INSERTAR UN NUEVO REGISTRO DE LIMPIEZA
    // (fechaHoraInicio siempre se fija al momento de la creación)
    // ==============================================================================
    public void insertarLimpieza(HistorialLimpieza limpieza) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            if (limpieza.getFechaHoraInicio() == null) {
                limpieza.setFechaHoraInicio(new Date());
            }

            em.persist(limpieza);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar la limpieza: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ACTUALIZAR UN REGISTRO EXISTENTE
    // ==============================================================================
    public void actualizarLimpieza(HistorialLimpieza limpieza) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.merge(limpieza);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo actualizar el registro de limpieza: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // FINALIZAR UNA LIMPIEZA EN CURSO
    // Marca fechaHoraFin = ahora, pone estadoLimpieza = 'Limpio' en el historial
    // y refleja el mismo estado en la habitación asociada.
    // ==============================================================================
    public void finalizarLimpieza(int idLimpieza) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            HistorialLimpieza limpieza = em.find(HistorialLimpieza.class, idLimpieza);
            if (limpieza == null) {
                throw new Exception("El registro de limpieza no existe.");
            }

            limpieza.setFechaHoraFin(new Date());
            limpieza.setEstadoLimpieza("Limpio");

            Habitaciones hab = limpieza.getIdHabitacion();
            if (hab != null) {
                hab.setEstadoLimpieza("Limpio");
                em.merge(hab);
            }

            em.merge(limpieza);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo finalizar la limpieza: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ELIMINAR UN REGISTRO DE LIMPIEZA
    // ==============================================================================
    public void eliminarLimpieza(int idLimpieza) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            HistorialLimpieza limpieza = em.find(HistorialLimpieza.class, idLimpieza);
            if (limpieza != null) {
                em.remove(limpieza);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo eliminar el registro de limpieza: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
