<%-- 
    Document   : JspActualizarEmpleado
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="controladores.empleadoControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    boolean exito = false;
    String msjError = "";

    try {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("idEmpleado");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String rol = request.getParameter("rol");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");

        if (idStr == null || idStr.trim().isEmpty()) {
            throw new Exception("Falta el ID del empleado para procesar la actualización.");
        }
        if (nombre == null || nombre.trim().isEmpty()) {
            throw new Exception("El campo Nombres es obligatorio.");
        }
        if (apellido == null || apellido.trim().isEmpty()) {
            throw new Exception("El campo Apellidos es obligatorio.");
        }
        if (dni == null || dni.trim().isEmpty()) {
            throw new Exception("El campo DNI es obligatorio.");
        }
        if (rol == null || rol.trim().isEmpty()) {
            throw new Exception("Debe seleccionar un rol para el empleado.");
        }

        int idEmpleado = Integer.parseInt(idStr.trim());

        empleadoControlador controlador = new empleadoControlador();
        controlador.actualizarEmpleado(idEmpleado, nombre, apellido, rol, dni, telefono);

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
                alert("¡Datos del empleado actualizados con éxito!");
                window.location.replace("indexEmpleado.jsp");
            </script>
        <% } else { %>
            <div class="error-box">
                <h2>🚨 Error al Actualizar Registro</h2>
                <p>Hubo un problema al procesar la actualización en la base de datos:</p>
                <pre><%= msjError %></pre>
                <a href="indexEmpleado.jsp" class="btn">Regresar al Módulo</a>
            </div>
        <% } %>
    </body>
</html>
