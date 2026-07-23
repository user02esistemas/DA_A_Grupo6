<%-- 
    Document   : JspGrabarLimpieza
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.HistorialLimpiezaControlador"%>
<%@page import="entidades.HistorialLimpieza"%>
<%@page import="entidades.Habitaciones"%>
<%@page import="entidades.Empleados"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Procesando Registro...</title>
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
            HistorialLimpiezaControlador limpControl = new HistorialLimpiezaControlador();
            HistorialLimpieza limpieza = new HistorialLimpieza();

            String idHabParam = request.getParameter("idHabitacion");
            String idEmpParam = request.getParameter("idEmpleado");
            String estadoParam = request.getParameter("estadoLimpieza");
            String observacionesParam = request.getParameter("observaciones");

            if (idHabParam != null && idEmpParam != null && estadoParam != null
                    && !idHabParam.trim().isEmpty() && !idEmpParam.trim().isEmpty()) {

                Habitaciones hab = limpControl.buscarHabitacionPorId(Integer.parseInt(idHabParam.trim()));
                if (hab == null) {
                    throw new Exception("La habitación seleccionada no existe.");
                }

                Empleados emp = limpControl.buscarEmpleadoPorId(Integer.parseInt(idEmpParam.trim()));
                if (emp == null) {
                    throw new Exception("El empleado seleccionado no existe.");
                }

                limpieza.setIdHabitacion(hab);
                limpieza.setIdEmpleado(emp);
                limpieza.setEstadoLimpieza(estadoParam.trim());
                limpieza.setObservaciones(observacionesParam != null ? observacionesParam.trim() : null);

                limpControl.insertarLimpieza(limpieza);
        %>
                <div class="success-card">
                    <div class="success-icon">✓</div>
                    <h1>¡Grabación exitosa!</h1>
                    <p>El nuevo registro de limpieza se ha guardado correctamente en la base de datos.</p>
                    <a href="indexHistorialLimpieza.jsp" class="btn-back">Volver al Inicio</a>
                </div>
        <%
            } else {
                throw new Exception("Error: Algunos campos del formulario llegaron vacíos.");
            }
        } catch (Exception e) {
        %>
            <div class="success-card" style="border-top: 4px solid #ef4444;">
                <div class="success-icon" style="background-color: #fef2f2; color: #ef4444; border-color: #fca5a5;">✕</div>
                <h1 style="color: #991b1b;">Error al Guardar</h1>
                <p style="color: #991b1b;"><%= e.getMessage() != null ? e.getMessage() : "Error desconocido." %></p>
                <a href="indexHistorialLimpieza.jsp" class="btn-back" style="background-color: #dc2626;">Intentar de Nuevo</a>
            </div>
        <%
        }
        %>
    </body>
</html>
