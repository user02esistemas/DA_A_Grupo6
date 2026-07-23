<%-- 
    Document   : JspEliminarHabitacion
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.Habitaciones"%>
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
                int idHabitacion = Integer.parseInt(request.getParameter("idhabitacion").trim());

                em = connectionDriver.getEmf().createEntityManager();
                em.getTransaction().begin();

                Habitaciones hab = em.find(Habitaciones.class, idHabitacion);
                if (hab == null) {
                    throw new Exception("La habitación ya no existe.");
                }

                em.remove(hab);
                em.getTransaction().commit();

                out.println("<script>");
                out.println("alert('¡Habitación eliminada permanentemente!');");
                out.println("window.location.href='indexHabitaciones.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                if (em != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                out.println("<script>");
                out.println("alert('No se pudo eliminar. Verifique que no tenga reservas o historial de limpieza asociado (Llave foránea activa).');");
                out.println("window.location.href='indexHabitaciones.jsp';");
                out.println("</script>");
            } finally {
                if (em != null && em.isOpen()) {
                    em.close();
                }
            }
        %>
    </body>
</html>
