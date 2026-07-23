<%-- 
    Document   : JspActualizarReserva
    Created on : 13 jul. 2026, 12:40:56 p. m.
    Author     : dzs-1
--%>

<%@page import="controladores.ReservaControlador"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Actualizando...</title>
    </head>
    <body>
        <%
        try {
            String idParam = request.getParameter("idreserva");
            String clienteParam = request.getParameter("idCliente");
            String habitacionParam = request.getParameter("idHabitacion");
            String empleadoParam = request.getParameter("idEmpleado");
            String checkInParam = request.getParameter("fechaCheckIn");
            String checkOutParam = request.getParameter("fechaCheckOutEsperada");

            if (idParam == null || clienteParam == null || habitacionParam == null || empleadoParam == null
                    || checkInParam == null || checkOutParam == null || idParam.trim().isEmpty()) {
                throw new Exception("Faltan datos en el formulario. Por favor, llena todos los campos.");
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date fechaCheckIn = sdf.parse(checkInParam.trim());
            Date fechaCheckOutEsperada = sdf.parse(checkOutParam.trim());

            ReservaControlador resControl = new ReservaControlador();
            resControl.actualizarReserva(
                    Integer.parseInt(idParam.trim()),
                    Integer.parseInt(clienteParam.trim()),
                    Integer.parseInt(habitacionParam.trim()),
                    Integer.parseInt(empleadoParam.trim()),
                    fechaCheckIn,
                    fechaCheckOutEsperada);

            out.println("<script>");
            out.println("alert('¡Reserva actualizada con éxito!');");
            out.println("window.location.href='indexReservas.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            out.println("<script>");
            out.println("alert('Error al actualizar: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
            out.println("window.location.href='indexReservas.jsp';");
            out.println("</script>");
        }
        %>
    </body>
</html>
