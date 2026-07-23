<%-- 
    Document   : JspEliminarReserva
    Created on : 13 jul. 2026, 12:52:34 p. m.
    Author     : dzs-1
--%>

<%@page import="controladores.ReservaControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Eliminando...</title>
    </head>
    <body>
        <%
        try {
            String idParam = request.getParameter("idreserva");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new Exception("No se especificó la reserva a eliminar.");
            }

            ReservaControlador resControl = new ReservaControlador();
            resControl.eliminarReserva(Integer.parseInt(idParam.trim()));

            out.println("<script>");
            out.println("alert('¡Reserva eliminada con éxito! La habitación quedó disponible.');");
            out.println("window.location.href='indexReservas.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            out.println("<script>");
            out.println("alert('Error al eliminar: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
            out.println("window.location.href='indexReservas.jsp';");
            out.println("</script>");
        }
        %>
    </body>
</html>
