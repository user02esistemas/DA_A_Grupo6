<%-- 
    Document   : JspGrabarCli
    Created on : 12 jul. 2026, 11:19:48 a. m.
    Author     : dzs-1
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Procesando Registro...</title>
        <style>
            body { font-family: 'Segoe UI', sans-serif; background-color: #f1f5f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
            .error-box { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center; max-width: 500px; border-top: 5px solid #dc2626; }
            h2 { color: #dc2626; margin-top: 0; }
            p { color: #475569; font-size: 15px; line-height: 1.5; }
            .btn { display: inline-block; padding: 10px 20px; background: #1e40af; color: white; border-radius: 6px; text-decoration: none; font-weight: 600; margin-top: 15px; }
        </style>
    </head>
    <body>
         <%
        // ESTA LÍNEA ES CLAVE: Evita que las tildes y las 'ñ' se guarden mal en la BD
        request.setCharacterEncoding("UTF-8");
        
        try {
            // 1. Recibir los parámetros del formulario (Inputs de texto)
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            
            // CORRECCIÓN ANTERIOR: Cambiado "documento" por "dni" para que no llegue nulo
            String documento = request.getParameter("dni"); 
            
            String telefono = request.getParameter("telefono");
            String correo = request.getParameter("correo");
            
            // 🌟 CAPTURA CLAVE: Recibimos la habitación real elegida en el segundo combo
            String idHabitacionAsignada = request.getParameter("idHabitacionAsignada");

            // Validación básica
            if (documento == null || documento.trim().isEmpty()) {
                throw new Exception("El número de documento (DNI) es obligatorio para el registro.");
            }
            
            if (idHabitacionAsignada == null || idHabitacionAsignada.trim().isEmpty() || idHabitacionAsignada.contains("Seleccione")) {
                throw new Exception("Debe seleccionar un número de habitación disponible para el huésped.");
            }

            // 2. LLAMAR AL CONTROLADOR
            controladores.clienteControlador controlCli = new controladores.clienteControlador();
            
            // Enviamos el 'idHabitacionAsignada' como String para que coincida exactamente con tu controlador
            controlCli.registrarClienteYReserva(nombre, apellido, documento, telefono, correo, idHabitacionAsignada);

            // 3. Si no hubo errores en el controlador, redireccionamos con éxito
            out.println("<script>");
            out.println("alert('¡Huésped registrado y reserva generada con éxito!');");
            out.println("window.location.href='indexClientes.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            // 4. FILTRADO DE ERRORES: Analizamos el error antes de mostrárselo al usuario
            String errorOriginal = (e.getMessage() != null) ? e.getMessage() : "";
            String mensajeAmigable = "";

            // Si el error contiene palabras clave de Clave Única Duplicada de la BD
            if (errorOriginal.contains("UNIQUE KEY") || errorOriginal.contains("duplicate key")) {
                mensajeAmigable = "El número de documento (DNI/RUC) ya se encuentra registrado en el sistema. Por favor, verifique los datos e intente con otro.";
            } 
            // Si el error proviene de tus validaciones manuales de arriba, dejamos tu propio texto
            else if (errorOriginal.contains("obligatorio") || errorOriginal.contains("Debe seleccionar")) {
                mensajeAmigable = errorOriginal;
            } 
            // Cualquier otro error inesperado (Se cayó la base de datos, error de código, etc.)
            else {
                mensajeAmigable = "Ocurrió un inconveniente inesperado al procesar el registro. Por favor, inténtelo de nuevo más tarde.";
            }
        %>
            <div class="error-box">
                <h2>🚨 Aviso del Sistema</h2>
                <p><strong>Detalle:</strong> <%= mensajeAmigable %></p>
                <a href="indexClientes.jsp" class="btn">Regresar al Formulario</a>
            </div>
        <%
        } // Aquí se cierra correctamente el bloque catch de Java
        %>
    </body>
</html>
