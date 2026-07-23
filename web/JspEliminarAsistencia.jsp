<%-- 
    Document   : JspEliminarAsistencia
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.AsistenciaPersonal"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="conexion.connectionDriver"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Eliminando...</title>
    </head>
    <body>
        <%
            EntityManager em = null;
            try {
                int idAsistencia = Integer.parseInt(request.getParameter("idasistencia").trim());

                em = connectionDriver.getEmf().createEntityManager();
                em.getTransaction().begin();

                AsistenciaPersonal asistencia = em.find(AsistenciaPersonal.class, idAsistencia);
                if (asistencia == null) {
                    throw new Exception("El registro de asistencia ya no existe.");
                }

                em.remove(asistencia);
                em.getTransaction().commit();

                out.println("<script>");
                out.println("alert('¡Registro de asistencia eliminado permanentemente!');");
                out.println("window.location.href='indexAsistenciaPersonal.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                if (em != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                out.println("<script>");
                out.println("alert('No se pudo eliminar el registro de asistencia. Intente nuevamente.');");
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
