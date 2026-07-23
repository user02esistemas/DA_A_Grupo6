/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;
import conexion.connectionDriver;
import entidades.TipoHabitacion;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
/**
 *
 * @author dzs-1
 */
public class TipoHabitacionControlador {
    public List<TipoHabitacion> obtenerTipos() {
        if (connectionDriver.getEmf() == null) {
            System.err.println("Error: No hay conexión con la base de datos en TipoHabitacionControlador.");
            return new ArrayList<>();
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery("select t from TipoHabitacion t", TipoHabitacion.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar tipos de habitación: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void insertarTipo(TipoHabitacion tipo) throws Exception {
        if (connectionDriver.getEmf() == null) {
            throw new Exception("Error: No hay conexión con la base de datos.");
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.persist(tipo);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo insertar el tipo de habitación: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void actualizarTipo(TipoHabitacion tipo) throws Exception {
        if (connectionDriver.getEmf() == null) {
            throw new Exception("Error: No hay conexión con la base de datos.");
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.merge(tipo);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Error al actualizar tipo: " + e.getMessage());
            throw new Exception("No se pudo actualizar el tipo de habitación: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void eliminarTipo(int idTipo) throws Exception {
        if (connectionDriver.getEmf() == null) {
            throw new Exception("Error: No hay conexión con la base de datos.");
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            TipoHabitacion tipo = em.find(TipoHabitacion.class, idTipo);
            if (tipo != null) {
                em.remove(tipo);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Error al eliminar tipo: " + e.getMessage());
            throw new Exception("No se pudo eliminar el tipo de habitación. Verifique que no tenga habitaciones asociadas: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public TipoHabitacion buscarPorId(int idTipo) {
        if (connectionDriver.getEmf() == null) {
            return null;
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(TipoHabitacion.class, idTipo);
        } catch (Exception e) {
            System.err.println("Error al buscar tipo por ID: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
