<%-- 
    Document   : JspActualizarLimpieza
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.HistorialLimpieza"%>
<%@page import="entidades.Habitaciones"%>
<%@page import="entidades.Empleados"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="conexion.connectionDriver"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Actualizando...</title>
    </head>
    <body>
        <%
    EntityManager em = null;
    try {
        String idParam = request.getParameter("idlimpieza");
        String idHabParam = request.getParameter("idHabitacion");
        String idEmpParam = request.getParameter("idEmpleado");
        String estadoParam = request.getParameter("estadoLimpieza");
        String observacionesParam = request.getParameter("observaciones");

        if (idParam == null || idHabParam == null || idEmpParam == null || estadoParam == null
                || idParam.trim().isEmpty()) {
            throw new Exception("Faltan datos en el formulario. Por favor, llena todos los campos.");
        }

        int idLimpieza = Integer.parseInt(idParam.trim());
        int idHabitacion = Integer.parseInt(idHabParam.trim());
        int idEmpleado = Integer.parseInt(idEmpParam.trim());
        String estado = estadoParam.trim();
        String observaciones = observacionesParam != null ? observacionesParam.trim() : null;

        em = connectionDriver.getEmf().createEntityManager();
        em.getTransaction().begin();

        HistorialLimpieza limpieza = em.find(HistorialLimpieza.class, idLimpieza);
        if (limpieza == null) {
            throw new Exception("El registro de limpieza con ID " + idLimpieza + " no existe.");
        }

        Habitaciones hab = em.find(Habitaciones.class, idHabitacion);
        if (hab == null) {
            throw new Exception("La habitación seleccionada no existe.");
        }

        Empleados emp = em.find(Empleados.class, idEmpleado);
        if (emp == null) {
            throw new Exception("El empleado seleccionado no existe.");
        }

        limpieza.setIdHabitacion(hab);
        limpieza.setIdEmpleado(emp);
        limpieza.setEstadoLimpieza(estado);
        limpieza.setObservaciones(observaciones);

        em.merge(limpieza);
        em.getTransaction().commit();

        em.getEntityManagerFactory().getCache().evictAll();

        out.println("<script>");
        out.println("alert('¡Registro de limpieza actualizado con éxito!');");
        out.println("window.location.href='indexHistorialLimpieza.jsp';");
        out.println("</script>");

    } catch (Exception e) {
        if (em != null && em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
        out.println("<script>");
        out.println("alert('Error al actualizar: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
        out.println("window.location.href='indexHistorialLimpieza.jsp';");
        out.println("</script>");
    } finally {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
    %>
    </body>
</html>
