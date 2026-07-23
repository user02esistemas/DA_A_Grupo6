<%-- 
    Document   : JspEliminarUsuario
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.UsuariosControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Eliminando...</title>
    </head>
    <body>
        <%
            try {
                int idUsuario = Integer.parseInt(request.getParameter("idusuario").trim());

                UsuariosControlador usuControl = new UsuariosControlador();
                usuControl.eliminarUsuario(idUsuario);

                out.println("<script>");
                out.println("alert('¡Acceso de usuario eliminado permanentemente!');");
                out.println("window.location.href='indexAccesosUsuarios.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                out.println("<script>");
                out.println("alert('No se pudo eliminar el acceso de usuario. Intente nuevamente.');");
                out.println("window.location.href='indexAccesosUsuarios.jsp';");
                out.println("</script>");
            }
        %>
    </body>
</html>
