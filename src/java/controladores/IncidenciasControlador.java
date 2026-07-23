/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

import conexion.connectionDriver;
import entidades.Empleados;
import entidades.Incidencias;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;

/**
 *
 * @author dzs-1
 */
public class IncidenciasControlador {

    // ==============================================================================
    // LISTAR TODAS LAS INCIDENCIAS (más recientes primero)
    // ==============================================================================
    public List<Incidencias> obtenerIncidencias() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT i FROM Incidencias i LEFT JOIN FETCH i.idEmpleado ORDER BY i.fechaHora DESC",
                    Incidencias.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar incidencias: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public Incidencias buscarPorId(int idIncidencia) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(Incidencias.class, idIncidencia);
        } catch (Exception e) {
            System.err.println("Error al buscar incidencia: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void registrarIncidencia(int idEmpleado, String tipoIncidencia, String gravedad,
            String descripcion, String lugar) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Empleados empleado = em.find(Empleados.class, idEmpleado);
            if (empleado == null) {
                throw new Exception("El empleado de seguridad indicado no existe.");
            }

            Incidencias inc = new Incidencias();
            inc.setIdEmpleado(empleado);
            inc.setFechaHora(new Date());
            inc.setTipoIncidencia(tipoIncidencia);
            inc.setGravedad(gravedad);
            inc.setDescripcion(descripcion);
            inc.setLugar(lugar);
            inc.setEstado("Abierta");

            em.persist(inc);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar la incidencia: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void actualizarIncidencia(int idIncidencia, String tipoIncidencia, String gravedad,
            String descripcion, String lugar, String estado) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Incidencias inc = em.find(Incidencias.class, idIncidencia);
            if (inc == null) {
                throw new Exception("La incidencia no fue encontrada.");
            }
            inc.setTipoIncidencia(tipoIncidencia);
            inc.setGravedad(gravedad);
            inc.setDescripcion(descripcion);
            inc.setLugar(lugar);
            inc.setEstado(estado);

            em.merge(inc);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo actualizar la incidencia: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void eliminarIncidencia(int idIncidencia) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            Incidencias inc = em.find(Incidencias.class, idIncidencia);
            if (inc != null) {
                em.remove(inc);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo eliminar la incidencia: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
