<%-- 
    Document   : JspEliminarTipo
    Created on : 12 jul. 2026, 11:18:14 a. m.
    Author     : dzs-1
--%>

<%@page import="entidades.TipoHabitacion"%>
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
                int idTipo = Integer.parseInt(request.getParameter("idtipo").trim());

                em = connectionDriver.getEmf().createEntityManager();
                em.getTransaction().begin();

                TipoHabitacion tipo = em.find(TipoHabitacion.class, idTipo);
                if (tipo == null) {
                    throw new Exception("La categoría ya no existe.");
                }

                em.remove(tipo);
                em.getTransaction().commit();

                out.println("<script>");
                out.println("alert('¡Categoría eliminada permanentemente!');");
                out.println("window.location.href='indexTipoHabitacion.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                if (em != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                out.println("<script>");
                out.println("alert('No se pudo eliminar. Restricción de Base de Datos (Llave foránea activa).');");
                out.println("window.location.href='indexTipoHabitacion.jsp';");
                out.println("</script>");
            } finally {
                if (em != null && em.isOpen()) {
                    em.close();
                }
            }
        %>
    </body>
</html>
