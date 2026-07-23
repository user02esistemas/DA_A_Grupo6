/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

import conexion.connectionDriver;
import entidades.AsistenciaPersonal;
import entidades.Empleados;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;

/**
 *
 * @author dzs-1
 */
public class AsistenciaPersonalControlador {

    // ==============================================================================
    // LISTAR TODA LA ASISTENCIA (con empleado ya cargado)
    // ==============================================================================
    public List<AsistenciaPersonal> obtenerAsistencias() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT a FROM AsistenciaPersonal a "
                    + "LEFT JOIN FETCH a.idEmpleado "
                    + "ORDER BY a.horaEntrada DESC",
                    AsistenciaPersonal.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar asistencia de personal: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // LISTAR ASISTENCIA DE UN EMPLEADO ESPECÍFICO
    // ==============================================================================
    public List<AsistenciaPersonal> listarPorEmpleado(int idEmpleado) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT a FROM AsistenciaPersonal a WHERE a.idEmpleado.idEmpleado = :idEmp "
                    + "ORDER BY a.horaEntrada DESC",
                    AsistenciaPersonal.class)
                    .setParameter("idEmp", idEmpleado)
                    .getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar asistencia por empleado: " + e.getMessage());
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
    public AsistenciaPersonal buscarPorId(int idAsistencia) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(AsistenciaPersonal.class, idAsistencia);
        } catch (Exception e) {
            System.err.println("Error al buscar registro de asistencia: " + e.getMessage());
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
    // REGISTRAR ENTRADA (Marcar ingreso de un empleado)
    // (fecha y horaEntrada siempre se fijan al momento de la creación)
    // ==============================================================================
    public void insertarAsistencia(AsistenciaPersonal asistencia) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            if (asistencia.getHoraEntrada() == null) {
                asistencia.setHoraEntrada(new Date());
            }
            if (asistencia.getFecha() == null) {
                asistencia.setFecha(new Date());
            }

            em.persist(asistencia);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar la asistencia: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ACTUALIZAR UN REGISTRO EXISTENTE
    // ==============================================================================
    public void actualizarAsistencia(AsistenciaPersonal asistencia) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.merge(asistencia);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo actualizar el registro de asistencia: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // REGISTRAR SALIDA (Marcar la hora de salida de un empleado)
    // ==============================================================================
    public void marcarSalida(int idAsistencia) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            AsistenciaPersonal asistencia = em.find(AsistenciaPersonal.class, idAsistencia);
            if (asistencia == null) {
                throw new Exception("El registro de asistencia no existe.");
            }
            if (asistencia.getHoraSalida() != null) {
                throw new Exception("Este registro ya tiene una hora de salida marcada.");
            }

            asistencia.setHoraSalida(new Date());

            em.merge(asistencia);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar la salida: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ELIMINAR UN REGISTRO DE ASISTENCIA
    // ==============================================================================
    public void eliminarAsistencia(int idAsistencia) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            AsistenciaPersonal asistencia = em.find(AsistenciaPersonal.class, idAsistencia);
            if (asistencia != null) {
                em.remove(asistencia);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo eliminar el registro de asistencia: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
