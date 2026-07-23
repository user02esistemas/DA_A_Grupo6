<%-- 
    Document   : JspGrabarReserva
    Created on : 13 jul. 2026, 12:40:39 p. m.
    Author     : dzs-1
--%>

<%@page import="controladores.ReservaControlador"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Procesando Reserva...</title>
        <style>
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
            body { background-color: #f4f6f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
            .success-card { background-color: #ffffff; width: 100%; max-width: 400px; padding: 40px 30px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08); text-align: center; }
            .success-icon { width: 70px; height: 70px; background-color: #ecfdf5; color: #10b981; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 36px; margin: 0 auto 20px auto; font-weight: bold; border: 2px solid #a7f3d0; }
            h1 { font-size: 24px; color: #1e293b; font-weight: 600; margin-bottom: 10px; }
            p { color: #64748b; font-size: 15px; margin-bottom: 30px; line-height: 1.5; }
            .btn-back { display: block; width: 100%; padding: 12px; background-color: #1e40af; color: #ffffff; text-decoration: none; font-size: 15px; font-weight: 600; border-radius: 6px; transition: background-color 0.2s ease; }
            .btn-back:hover { background-color: #1e3a8a; }
        </style>
    </head>
    <body>
        <%
        try {
            ReservaControlador resControl = new ReservaControlador();

            String clienteParam = request.getParameter("idCliente");
            String habitacionParam = request.getParameter("idHabitacion");
            String empleadoParam = request.getParameter("idEmpleado");
            String checkInParam = request.getParameter("fechaCheckIn");
            String checkOutParam = request.getParameter("fechaCheckOutEsperada");

            if (clienteParam != null && habitacionParam != null && empleadoParam != null
                    && checkInParam != null && checkOutParam != null
                    && !clienteParam.trim().isEmpty() && !habitacionParam.trim().isEmpty()
                    && !empleadoParam.trim().isEmpty() && !checkInParam.trim().isEmpty()
                    && !checkOutParam.trim().isEmpty()) {

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Date fechaCheckIn = sdf.parse(checkInParam.trim());
                Date fechaCheckOutEsperada = sdf.parse(checkOutParam.trim());

                resControl.registrarReserva(
                        Integer.parseInt(clienteParam.trim()),
                        Integer.parseInt(habitacionParam.trim()),
                        Integer.parseInt(empleadoParam.trim()),
                        fechaCheckIn,
                        fechaCheckOutEsperada);
        %>
                <div class="success-card">
                    <div class="success-icon">✓</div>
                    <h1>¡Reserva registrada!</h1>
                    <p>La reserva se guardó correctamente y la habitación fue marcada como ocupada.</p>
                    <a href="indexReservas.jsp" class="btn-back">Volver al Inicio</a>
                </div>
        <%
            } else {
                throw new Exception("Algunos campos del formulario llegaron vacíos.");
            }
        } catch (Exception e) {
        %>
            <div class="success-card" style="border-top: 4px solid #ef4444;">
                <div class="success-icon" style="background-color: #fef2f2; color: #ef4444; border-color: #fca5a5;">✕</div>
                <h1 style="color: #991b1b;">Error al Guardar</h1>
                <p style="color: #991b1b;"><%= e.getMessage() != null ? e.getMessage() : "Error desconocido." %></p>
                <a href="indexReservas.jsp" class="btn-back" style="background-color: #dc2626;">Intentar de Nuevo</a>
            </div>
        <%
        }
        %>
    </body>
</html>
