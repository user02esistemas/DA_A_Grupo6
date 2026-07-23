/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

import conexion.connectionDriver;
import entidades.Empleados;
import entidades.Usuarios;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;

/**
 *
 * @author dzs-1
 */
public class UsuariosControlador {

    // ==============================================================================
    // LISTAR TODOS LOS USUARIOS (con empleado ya cargado)
    // ==============================================================================
    public List<Usuarios> obtenerUsuarios() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery(
                    "SELECT u FROM Usuarios u "
                    + "LEFT JOIN FETCH u.idEmpleado "
                    + "ORDER BY u.username",
                    Usuarios.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // BUSCAR UN USUARIO POR ID
    // ==============================================================================
    public Usuarios buscarPorId(int idUsuario) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return null;
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.find(Usuarios.class, idUsuario);
        } catch (Exception e) {
            System.err.println("Error al buscar usuario: " + e.getMessage());
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
    // VERIFICAR SI UN USERNAME YA EXISTE (excluyendo, si se indica, un ID propio
    // para permitir que un usuario se actualice a sí mismo sin username)
    // ==============================================================================
    public boolean existeUsername(String username, Integer idUsuarioExcluir) {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return false;
            }
            em = connectionDriver.getEmf().createEntityManager();
            String jpql = "SELECT COUNT(u) FROM Usuarios u WHERE LOWER(u.username) = LOWER(:username)"
                    + (idUsuarioExcluir != null ? " AND u.idUsuario <> :idExcluir" : "");
            javax.persistence.Query q = em.createQuery(jpql)
                    .setParameter("username", username);
            if (idUsuarioExcluir != null) {
                q.setParameter("idExcluir", idUsuarioExcluir);
            }
            Long total = (Long) q.getSingleResult();
            return total != null && total > 0;
        } catch (Exception e) {
            System.err.println("Error al verificar username: " + e.getMessage());
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // REGISTRAR UN NUEVO ACCESO DE USUARIO
    // ==============================================================================
    public void insertarUsuario(Usuarios usuario) throws Exception {
        EntityManager em = null;
        try {
            if (existeUsername(usuario.getUsername(), null)) {
                throw new Exception("Ya existe un usuario registrado con ese nombre de usuario.");
            }

            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            em.persist(usuario);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo registrar el usuario: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ACTUALIZAR UN USUARIO EXISTENTE
    // (la contraseña solo se sobrescribe si se envía una nueva; en caso contrario
    // se conserva la que ya está guardada en la Base de Datos)
    // ==============================================================================
    public void actualizarUsuario(int idUsuario, Empleados empleado, String username, String nuevaPassword, String rolSistema, boolean activo) throws Exception {
        EntityManager em = null;
        try {
            if (existeUsername(username, idUsuario)) {
                throw new Exception("Ya existe otro usuario registrado con ese nombre de usuario.");
            }

            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Usuarios usuario = em.find(Usuarios.class, idUsuario);
            if (usuario == null) {
                throw new Exception("El usuario no fue encontrado en la Base de Datos.");
            }

            usuario.setIdEmpleado(empleado);
            usuario.setUsername(username);
            usuario.setRolSistema(rolSistema);
            usuario.setActivo(activo);
            if (nuevaPassword != null && !nuevaPassword.trim().isEmpty()) {
                usuario.setPassword(nuevaPassword.trim());
            }

            em.merge(usuario);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo actualizar el usuario: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ACTIVAR / DESACTIVAR EL ACCESO DE UN USUARIO (bloqueo rápido sin borrar)
    // ==============================================================================
    public void cambiarEstado(int idUsuario) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Usuarios usuario = em.find(Usuarios.class, idUsuario);
            if (usuario == null) {
                throw new Exception("El usuario no existe.");
            }
            usuario.setActivo(!usuario.getActivo());

            em.merge(usuario);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo cambiar el estado del usuario: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ELIMINAR UN USUARIO (revocar acceso de forma permanente)
    // ==============================================================================
    public void eliminarUsuario(int idUsuario) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            Usuarios usuario = em.find(Usuarios.class, idUsuario);
            if (usuario != null) {
                em.remove(usuario);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo eliminar el usuario: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
