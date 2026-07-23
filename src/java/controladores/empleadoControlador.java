/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;
import conexion.connectionDriver;
import entidades.Empleados;
import entidades.HistorialLimpieza;
import entidades.Reservas;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
/**
 *
 * @author dzs-1
 */
public class empleadoControlador {
    public List<Empleados> obtenerEmpleados() {
        EntityManager em = null;
        try {
            if (connectionDriver.getEmf() == null) {
                return new ArrayList<>();
            }
            em = connectionDriver.getEmf().createEntityManager();
            return em.createQuery("SELECT e FROM Empleados e ORDER BY e.nombre", Empleados.class).getResultList();
        } catch (Exception e) {
            System.err.println("Error al listar empleados: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
 
    public Empleados buscarPorId(int idEmpleado) {
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
 
    // Garantiza que exista al menos un empleado para poder registrar reservas.
    // Si la tabla está vacía crea uno de respaldo, igual que hace clienteControlador.
    public Empleados obtenerOcrearEmpleadoPorDefecto() throws Exception {
        List<Empleados> lista = obtenerEmpleados();
        if (lista != null && !lista.isEmpty()) {
            return lista.get(0);
        }
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();
            Empleados emp = new Empleados();
            emp.setNombre("Recepcionista");
            emp.setApellido("General");
            emp.setRol("Recepcion");
            emp.setDni("00000000");
            emp.setTelefono("999999999");
            em.persist(emp);
            em.getTransaction().commit();
            return emp;
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("No se pudo crear un empleado por defecto: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // INSERTAR UN NUEVO EMPLEADO
    // ==============================================================================
    public void insertarEmpleado(String nombre, String apellido, String rol, String dni, String telefono) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Empleados emp = new Empleados();
            emp.setNombre(nombre);
            emp.setApellido(apellido);
            emp.setRol(rol);
            emp.setDni(dni);
            emp.setTelefono(telefono);

            em.persist(emp);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("Error al registrar el empleado: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ACTUALIZAR DATOS DE UN EMPLEADO
    // ==============================================================================
    public void actualizarEmpleado(int idEmpleado, String nombre, String apellido, String rol, String dni, String telefono) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Empleados emp = em.find(Empleados.class, idEmpleado);
            if (emp == null) {
                throw new Exception("El empleado no fue encontrado en la Base de Datos.");
            }
            emp.setNombre(nombre);
            emp.setApellido(apellido);
            emp.setRol(rol);
            emp.setDni(dni);
            emp.setTelefono(telefono);

            em.merge(emp);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception("Error al actualizar el empleado: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ==============================================================================
    // ELIMINAR UN EMPLEADO
    // (Se bloquea la eliminación si el empleado tiene Reservas o registros de
    // Limpieza asociados, ya que esas llaves foráneas son ON DELETE NO ACTION en
    // la Base de Datos. Usuarios y AsistenciaPersonal sí están en CASCADE.)
    // ==============================================================================
    public void eliminarEmpleado(int idEmpleado) throws Exception {
        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            em.getTransaction().begin();

            Empleados emp = em.find(Empleados.class, idEmpleado);
            if (emp == null) {
                throw new Exception("El empleado no fue encontrado en la Base de Datos.");
            }

            Long totalReservas = em.createQuery(
                    "SELECT COUNT(r) FROM Reservas r WHERE r.idEmpleado = :emp", Long.class)
                    .setParameter("emp", emp)
                    .getSingleResult();
            if (totalReservas != null && totalReservas > 0) {
                throw new Exception("No se puede eliminar: el empleado tiene " + totalReservas + " reserva(s) registrada(s). Reasigne o elimine primero esas reservas.");
            }

            Long totalLimpieza = em.createQuery(
                    "SELECT COUNT(h) FROM HistorialLimpieza h WHERE h.idEmpleado = :emp", Long.class)
                    .setParameter("emp", emp)
                    .getSingleResult();
            if (totalLimpieza != null && totalLimpieza > 0) {
                throw new Exception("No se puede eliminar: el empleado tiene " + totalLimpieza + " registro(s) de limpieza asociado(s).");
            }

            em.remove(emp);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new Exception(e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
