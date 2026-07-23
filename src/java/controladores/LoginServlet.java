/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

import conexion.connectionDriver;
import entidades.Empleados;
import entidades.Usuarios;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

/**
 * Valida las credenciales ingresadas en index.jsp contra la tabla Usuarios
 * (con su Empleado asociado) y, de ser correctas, crea la sesión con los
 * datos que usará SesionFiltro para restringir el acceso según el rol.
 *
 * @author dzs-1
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Debes ingresar tu usuario y tu contraseña.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        username = username.trim();

        if (connectionDriver.getEmf() == null) {
            request.setAttribute("error", "No hay conexión con la Base de Datos. Contacta al administrador.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        EntityManager em = null;
        try {
            em = connectionDriver.getEmf().createEntityManager();
            TypedQuery<Usuarios> query = em.createQuery(
                    "SELECT u FROM Usuarios u LEFT JOIN FETCH u.idEmpleado "
                    + "WHERE LOWER(u.username) = LOWER(:username)", Usuarios.class);
            query.setParameter("username", username);

            Usuarios usuario;
            try {
                usuario = query.getSingleResult();
            } catch (NoResultException nre) {
                usuario = null;
            }

            if (usuario == null || !usuario.getPassword().equals(password)) {
                request.setAttribute("error", "Usuario o contraseña incorrectos.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            if (!usuario.getActivo()) {
                request.setAttribute("error", "Tu acceso está deshabilitado. Contacta al administrador.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Rol normalizado en mayúsculas: GERENTE, ADMINISTRADOR, RECEPCIONISTA, LIMPIEZA, SEGURIDAD
            String rol = usuario.getRolSistema() == null ? "" : usuario.getRolSistema().trim().toUpperCase();
            Empleados empleado = usuario.getIdEmpleado();

            HttpSession session = request.getSession(true);
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("idUsuario", usuario.getIdUsuario());
            session.setAttribute("username", usuario.getUsername());
            session.setAttribute("rolSistema", rol);
            if (empleado != null) {
                session.setAttribute("idEmpleado", empleado.getIdEmpleado());
                session.setAttribute("nombreCompleto", empleado.getNombre() + " " + empleado.getApellido());
            } else {
                session.setAttribute("nombreCompleto", usuario.getUsername());
            }
            session.setMaxInactiveInterval(60 * 60); // 1 hora de inactividad

            response.sendRedirect("indexPrin.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Ocurrió un error al iniciar sesión: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
