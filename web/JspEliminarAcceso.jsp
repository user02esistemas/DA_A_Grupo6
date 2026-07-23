<%-- 
    Document   : JspEliminarAcceso
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.AccesosClientes"%>
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
                int idAcceso = Integer.parseInt(request.getParameter("idacceso").trim());

                em = connectionDriver.getEmf().createEntityManager();
                em.getTransaction().begin();

                AccesosClientes acceso = em.find(AccesosClientes.class, idAcceso);
                if (acceso == null) {
                    throw new Exception("El registro de acceso ya no existe.");
                }

                em.remove(acceso);
                em.getTransaction().commit();

                out.println("<script>");
                out.println("alert('¡Registro de acceso eliminado permanentemente!');");
                out.println("window.location.href='indexAccesosClientes.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                if (em != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                out.println("<script>");
                out.println("alert('No se pudo eliminar el registro de acceso. Intente nuevamente.');");
                out.println("window.location.href='indexAccesosClientes.jsp';");
                out.println("</script>");
            } finally {
                if (em != null && em.isOpen()) {
                    em.close();
                }
            }
        %>
    </body>
</html>
