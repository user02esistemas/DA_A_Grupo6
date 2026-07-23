<%-- 
    Document   : JspActualizarCli
    Created on : 12 jul. 2026, 11:11:52 a. m.
    Author     : dzs-1
--%>

<%@page import="controladores.clienteControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    boolean exito = false;
    String msjError = "";
    
    try {
        request.setCharacterEncoding("UTF-8");
        
        // 1. Capturar los parámetros directos del formulario (UNIFICADOS CON EL INDEX)
        String idStr = request.getParameter("idcliente");
        String dni = request.getParameter("dni");
        String nombres = request.getParameter("nombre");          // Corregido: Antes decia "nombres"
        String apellidos = request.getParameter("apellido");      // Corregido: Antes decia "apellidos"
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("correo");            // Corregido: Antes decia "email"
        String idHabitaStr = request.getParameter("idHabitacionAsignada"); // Corregido: Antes decia "idhabitacion"

        // 🌟 VALIDACIÓN DE SEGURIDAD CONTRA NULOS
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new Exception("Falta el ID del cliente para procesar la actualización.");
        }
        if (idHabitaStr == null || idHabitaStr.trim().isEmpty()) {
            throw new Exception("No se recibió la habitación seleccionada. Verifica el flujo del formulario.");
        }

        int idCliente = Integer.parseInt(idStr.trim());
        int idHabitacionNueva = Integer.parseInt(idHabitaStr.trim());

        // 2. Ejecutar el método de tu controlador pasando las variables ya mapeadas
        clienteControlador controlador = new clienteControlador();
        controlador.actualizarClienteYHabitacion(idCliente, nombres, apellidos, dni, telefono, email, idHabitacionNueva);
        
        exito = true; 
        
    } catch (Exception e) {
        msjError = e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Procesando Actualización...</title>
        <style>
            body { font-family: 'Segoe UI', sans-serif; background-color: #f1f5f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
            .error-box { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center; max-width: 600px; border-top: 5px solid #dc2626; }
            h2 { color: #dc2626; margin-top: 0; }
            pre { background: #f8fafc; padding: 15px; border-radius: 8px; text-align: left; color: #334155; overflow-x: auto; white-space: pre-wrap; font-size: 13px; border: 1px solid #e2e8f0; }
            .btn { display: inline-block; padding: 10px 20px; background: #1e40af; color: white; border-radius: 6px; text-decoration: none; font-weight: 600; margin-top: 15px; }
        </style>
    </head>
    <body>
         <% if (exito) { %>
            <script>
                alert("¡Datos del huésped y habitación actualizados con éxito!");
                window.location.replace("indexClientes.jsp");
            </script>
        <% } else { %>
            <div class="error-box">
                <h2>🚨 Error al Actualizar Registro</h2>
                <p>Hubo un problema al procesar la actualización en la base de datos:</p>
                <pre><%= msjError %></pre>
                <a href="indexClientes.jsp" class="btn">Regresar al Módulo</a>
            </div>
        <% } %>
    </body>
</html>
