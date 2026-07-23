<%-- 
    Document   : JspCambiarEstadoUsuario
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.UsuariosControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Actualizando estado...</title>
    </head>
    <body>
        <%
            try {
                int idUsuario = Integer.parseInt(request.getParameter("idusuario").trim());
                UsuariosControlador usuControl = new UsuariosControlador();
                usuControl.cambiarEstado(idUsuario);

                out.println("<script>");
                out.println("alert('¡Estado del acceso actualizado correctamente!');");
                out.println("window.location.href='indexAccesosUsuarios.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                out.println("<script>");
                out.println("alert('Error al cambiar el estado: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
                out.println("window.location.href='indexAccesosUsuarios.jsp';");
                out.println("</script>");
            }
        %>
    </body>
</html>
