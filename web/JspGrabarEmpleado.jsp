<%-- 
    Document   : JspGrabarEmpleado
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="controladores.empleadoControlador"%>
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
        // Evita que las tildes y la 'ñ' se guarden mal en la BD
        request.setCharacterEncoding("UTF-8");

        try {
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String rol = request.getParameter("rol");
            String dni = request.getParameter("dni");
            String telefono = request.getParameter("telefono");

            if (nombre == null || nombre.trim().isEmpty()) {
                throw new Exception("El campo Nombres es obligatorio para el registro.");
            }
            if (apellido == null || apellido.trim().isEmpty()) {
                throw new Exception("El campo Apellidos es obligatorio para el registro.");
            }
            if (dni == null || dni.trim().isEmpty()) {
                throw new Exception("El número de DNI es obligatorio para el registro.");
            }
            if (rol == null || rol.trim().isEmpty()) {
                throw new Exception("Debe seleccionar un rol para el empleado.");
            }

            controladores.empleadoControlador controlEmp = new controladores.empleadoControlador();
            controlEmp.insertarEmpleado(nombre, apellido, rol, dni, telefono);

            out.println("<script>");
            out.println("alert('¡Empleado registrado con éxito!');");
            out.println("window.location.href='indexEmpleado.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            String errorOriginal = (e.getMessage() != null) ? e.getMessage() : "";
            String mensajeAmigable;

            if (errorOriginal.contains("UNIQUE KEY") || errorOriginal.contains("duplicate key")) {
                mensajeAmigable = "El número de DNI ya se encuentra registrado en el sistema. Por favor, verifique los datos e intente con otro.";
            } else if (errorOriginal.contains("obligatorio") || errorOriginal.contains("Debe seleccionar")) {
                mensajeAmigable = errorOriginal;
            } else {
                mensajeAmigable = "Ocurrió un inconveniente inesperado al procesar el registro. Por favor, inténtelo de nuevo más tarde.";
            }
        %>
            <div class="error-box">
                <h2>🚨 Aviso del Sistema</h2>
                <p><strong>Detalle:</strong> <%= mensajeAmigable %></p>
                <a href="indexEmpleado.jsp" class="btn">Regresar al Formulario</a>
            </div>
        <%
        }
        %>
    </body>
</html>
