<%-- 
    Document   : JspMarcarSalida
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.AsistenciaPersonalControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Registrando salida...</title>
    </head>
    <body>
        <%
            try {
                int idAsistencia = Integer.parseInt(request.getParameter("idasistencia").trim());
                AsistenciaPersonalControlador asistControl = new AsistenciaPersonalControlador();
                asistControl.marcarSalida(idAsistencia);

                out.println("<script>");
                out.println("alert('¡Salida registrada correctamente!');");
                out.println("window.location.href='indexAsistenciaPersonal.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                out.println("<script>");
                out.println("alert('Error al registrar la salida: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
                out.println("window.location.href='indexAsistenciaPersonal.jsp';");
                out.println("</script>");
            }
        %>
    </body>
</html>
