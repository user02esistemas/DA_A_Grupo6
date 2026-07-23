<%-- 
    Document   : JspEliminarLimpieza
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.HistorialLimpieza"%>
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
                int idLimpieza = Integer.parseInt(request.getParameter("idlimpieza").trim());

                em = connectionDriver.getEmf().createEntityManager();
                em.getTransaction().begin();

                HistorialLimpieza limpieza = em.find(HistorialLimpieza.class, idLimpieza);
                if (limpieza == null) {
                    throw new Exception("El registro de limpieza ya no existe.");
                }

                em.remove(limpieza);
                em.getTransaction().commit();

                out.println("<script>");
                out.println("alert('¡Registro de limpieza eliminado permanentemente!');");
                out.println("window.location.href='indexHistorialLimpieza.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                if (em != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                out.println("<script>");
                out.println("alert('No se pudo eliminar el registro de limpieza. Intente nuevamente.');");
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
