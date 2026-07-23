/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

import conexion.connectionDriver;
import entidades.AccesosClientes;
import entidades.Clientes;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;

/**
 *
 * @author dzs-1
 */
public class AccesosClientesControlador {

    // ==============================================================================
    // LISTAR TODOS LOS ACCESOS (con cliente ya cargado)
    // ==============================================================================
    public List<AccesosClientes> obtenerAccesos() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT a FROM AccesosClientes a "
                    + "LEFT JOIN FETCH a.idcliente "
                    + "ORDER BY a.horaEntrada DESC",
                    AccesosClientes.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar accesos de clientes: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // LISTAR ACCESOS DE UN CLIENTE ESPECÍFICO
    // ==============================================================================
    public List<AccesosClientes> listarPorCliente(int idCliente) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT a FROM AccesosClientes a WHERE a.idcliente.idcliente = :idCli "
                    + "ORDER BY a.horaEntrada DESC",
                    AccesosClientes.class)
                    .setParameter("idCli", idCliente)
                    .getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar accesos por cliente: " + e.getMessage());
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
    public AccesosClientes buscarPorId(int idAcceso) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(AccesosClientes.class, idAcceso);
        } catch (Exception e) {
            System.err.println("Error al buscar registro de acceso: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public Clientes buscarClientePorId(int idCliente) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(Clientes.class, idCliente);
        } catch (Exception e) {
            System.err.println("Error al buscar cliente: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // REGISTRAR ENTRADA (Marcar ingreso de un cliente/huésped)
    // (fechaRegistro y horaEntrada siempre se fijan al momento de la creación)
    // ==============================================================================
    public void insertarAcceso(AccesosClientes acceso) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            if (acceso.getHoraEntrada() == null) {
                acceso.setHoraEntrada(new Date());
            }
            if (acceso.getFechaRegistro() == null) {
                acceso.setFechaRegistro(new Date());
            }
            if (acceso.getMotivoVisita() == null || acceso.getMotivoVisita().trim().isEmpty()) {
                acceso.setMotivoVisita("Huésped");
            }

            em.persist(acceso);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar el acceso: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ACTUALIZAR UN REGISTRO EXISTENTE
    // ==============================================================================
    public void actualizarAcceso(AccesosClientes acceso) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.merge(acceso);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo actualizar el registro de acceso: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // REGISTRAR SALIDA (Marcar la hora de salida de un cliente/huésped)
    // ==============================================================================
    public void marcarSalida(int idAcceso) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            AccesosClientes acceso = em.find(AccesosClientes.class, idAcceso);
            if (acceso == null) {
                throw new Exception("El registro de acceso no existe.");
            }
            if (acceso.getHoraSalida() != null) {
                throw new Exception("Este registro ya tiene una hora de salida marcada.");
            }

            acceso.setHoraSalida(new Date());

            em.merge(acceso);
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
    // ELIMINAR UN REGISTRO DE ACCESO
    // ==============================================================================
    public void eliminarAcceso(int idAcceso) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            AccesosClientes acceso = em.find(AccesosClientes.class, idAcceso);
            if (acceso != null) {
                em.remove(acceso);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo eliminar el registro de acceso: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
