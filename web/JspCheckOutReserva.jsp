<%-- 
    Document   : JspCheckOutReserva
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.ReservaControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registrando Check-out...</title>
    </head>
    <body>
        <%
        try {
            String idParam = request.getParameter("idreserva");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new Exception("No se especificó la reserva para el check-out.");
            }

            ReservaControlador resControl = new ReservaControlador();
            resControl.registrarCheckOut(Integer.parseInt(idParam.trim()));

            out.println("<script>");
            out.println("alert('¡Check-out registrado! La habitación quedó disponible para limpieza.');");
            out.println("window.location.href='indexReservas.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            out.println("<script>");
            out.println("alert('Error al registrar el check-out: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
            out.println("window.location.href='indexReservas.jsp';");
            out.println("</script>");
        }
        %>
    </body>
</html>
