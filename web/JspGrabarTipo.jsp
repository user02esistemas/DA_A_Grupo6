<%-- 
    Document   : JspGrabarTipo
    Created on : 12 jul. 2026, 11:20:55 a. m.
    Author     : dzs-1
--%>


<%@page import="controladores.TipoHabitacionControlador"%>
<%@page import="entidades.TipoHabitacion"%>
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
            .btn-back { display: block; width: 100%; padding: 12px; background-color: #0284c7; color: #ffffff; text-decoration: none; font-size: 15px; font-weight: 600; border-radius: 6px; transition: background-color 0.2s ease; }
            .btn-back:hover { background-color: #0369a1; }
        </style>
    </head>
    <body>
        <%
        try {
            TipoHabitacionControlador tipoControl = new TipoHabitacionControlador();
            TipoHabitacion tipo = new TipoHabitacion();
            
            // Ya no recibimos el idParam porque la Base de Datos lo generará automáticamente
            String nombreParam = request.getParameter("nombreTipo");
            String precioParam = request.getParameter("precioPorNoche");
            String capacidadParam = request.getParameter("capacidadPersonas");

            // Quitamos idParam de la validación
            if (nombreParam != null && precioParam != null && capacidadParam != null) {
                
                // 1. Reemplazamos comas por puntos por si ingresan formatos como "60,50"
                String precioProcesado = precioParam.replace(",", ".");
                
                // 2. Limpiamos dejando únicamente números y puntos decimales
                String precioLimpio = precioProcesado.replaceAll("[^0-9.]", "").trim();
                
                // 3. Si se borró todo por error en el formulario, aseguramos un valor por defecto
                if (precioLimpio.isEmpty()) {
                    precioLimpio = "0.0";
                }
                
                // 4. Mapeo y asignación de datos a la Entidad
                // ELIMINAMOS la línea tipo.setIdTipo(...) para evitar el error IDENTITY_INSERT
                
                tipo.setNombreTipo(nombreParam.trim());
                tipo.setPrecioPorNoche(new java.math.BigDecimal(precioLimpio)); 
                tipo.setCapacidadPersonas(Integer.parseInt(capacidadParam.trim()));
                
                // 5. Inserción a la base de datos mediante el controlador
                tipoControl.insertarTipo(tipo);
        %>
                <div class="success-card">
                    <div class="success-icon">✓</div>
                    <h1>¡Grabación exitosa!</h1>
                    <p>El nuevo tipo de habitación se ha guardado correctamente en la base de datos.</p>
                    <a href="indexTipoHabitacion.jsp" class="btn-back">Volver al Inicio</a>
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
                <a href="indexTipoHabitacion.jsp" class="btn-back" style="background-color: #dc2626;">Intentar de Nuevo</a>
            </div>
        <%
        }
        %>

    </body>
</html>
