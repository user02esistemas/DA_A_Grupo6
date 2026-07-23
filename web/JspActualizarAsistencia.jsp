<%-- 
    Document   : JspActualizarAsistencia
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.AsistenciaPersonal"%>
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
        String idParam = request.getParameter("idasistencia");
        String idEmpParam = request.getParameter("idEmpleado");
        String observacionesParam = request.getParameter("observaciones");

        if (idParam == null || idEmpParam == null
                || idParam.trim().isEmpty() || idEmpParam.trim().isEmpty()) {
            throw new Exception("Faltan datos en el formulario. Por favor, llena todos los campos.");
        }

        int idAsistencia = Integer.parseInt(idParam.trim());
        int idEmpleado = Integer.parseInt(idEmpParam.trim());
        String observaciones = observacionesParam != null ? observacionesParam.trim() : null;

        em = connectionDriver.getEmf().createEntityManager();
        em.getTransaction().begin();

        AsistenciaPersonal asistencia = em.find(AsistenciaPersonal.class, idAsistencia);
        if (asistencia == null) {
            throw new Exception("El registro de asistencia con ID " + idAsistencia + " no existe.");
        }

        Empleados emp = em.find(Empleados.class, idEmpleado);
        if (emp == null) {
            throw new Exception("El empleado seleccionado no existe.");
        }

        asistencia.setIdEmpleado(emp);
        asistencia.setObservaciones(observaciones);

        em.merge(asistencia);
        em.getTransaction().commit();

        em.getEntityManagerFactory().getCache().evictAll();

        out.println("<script>");
        out.println("alert('¡Registro de asistencia actualizado con éxito!');");
        out.println("window.location.href='indexAsistenciaPersonal.jsp';");
        out.println("</script>");

    } catch (Exception e) {
        if (em != null && em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
        out.println("<script>");
        out.println("alert('Error al actualizar: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
        out.println("window.location.href='indexAsistenciaPersonal.jsp';");
        out.println("</script>");
    } finally {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
    %>
    </body>
</html>
