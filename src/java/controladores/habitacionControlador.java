package controladores;

import conexion.connectionDriver;
import entidades.Habitaciones;
import entidades.TipoHabitacion;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;

public class habitacionControlador {

    public List<Habitaciones> obtenerHabitaciones() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT h FROM Habitaciones h LEFT JOIN FETCH h.idTipo ORDER BY h.piso, h.numeroHabitacion",
                    Habitaciones.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar habitaciones: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Habitaciones> listarDisponiblesPorTipo(String nombreTipo) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            if (nombreTipo == null || nombreTipo.trim().isEmpty()) {
                return em.createQuery(
                        "SELECT h FROM Habitaciones h WHERE h.estadoDisponibilidad = 'Disponible' AND h.activo = true",
                        Habitaciones.class).getResultList();
            }
            return em.createQuery(
                    "SELECT h FROM Habitaciones h WHERE h.estadoDisponibilidad = 'Disponible' AND h.activo = true AND h.idTipo.nombreTipo = :tipo",
                    Habitaciones.class)
                    .setParameter("tipo", nombreTipo.trim())
                    .getResultList();
        } catch (Exception e) {
            System.err.println("Error al filtrar habitaciones disponibles: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public Habitaciones buscarPorId(int idHabitacion) {
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

    public void insertarHabitacion(Habitaciones hab) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.persist(hab);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar la habitación: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void actualizarHabitacion(Habitaciones hab) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.merge(hab);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void eliminarHabitacion(int idHabitacion) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            Habitaciones hab = em.find(Habitaciones.class, idHabitacion);
            if (hab != null) {
                em.remove(hab);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo eliminar la habitación. Verifique que no tenga reservas activas: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public TipoHabitacion buscarTipoPorId(int idTipo) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(TipoHabitacion.class, idTipo);
        } catch (Exception e) {
            System.err.println("Error al buscar tipo de habitación: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
