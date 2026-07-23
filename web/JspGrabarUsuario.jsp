<%-- 
    Document   : JspGrabarUsuario
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.UsuariosControlador"%>
<%@page import="entidades.Usuarios"%>
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
            UsuariosControlador usuControl = new UsuariosControlador();

            String idEmpParam = request.getParameter("idEmpleado");
            String usernameParam = request.getParameter("username");
            String passwordParam = request.getParameter("password");
            String rolParam = request.getParameter("rolSistema");
            String activoParam = request.getParameter("activo");

            if (idEmpParam == null || idEmpParam.trim().isEmpty()
                    || usernameParam == null || usernameParam.trim().isEmpty()
                    || passwordParam == null || passwordParam.trim().isEmpty()
                    || rolParam == null || rolParam.trim().isEmpty()) {
                throw new Exception("Debe completar empleado, usuario, contraseña y rol del sistema.");
            }

            Empleados emp = usuControl.buscarEmpleadoPorId(Integer.parseInt(idEmpParam.trim()));
            if (emp == null) {
                throw new Exception("El empleado seleccionado no existe.");
            }

            Usuarios usuario = new Usuarios();
            usuario.setIdEmpleado(emp);
            usuario.setUsername(usernameParam.trim());
            usuario.setPassword(passwordParam.trim());
            usuario.setRolSistema(rolParam.trim());
            usuario.setActivo(activoParam != null);

            usuControl.insertarUsuario(usuario);
        %>
                <div class="success-card">
                    <div class="success-icon">✓</div>
                    <h1>¡Acceso creado!</h1>
                    <p>La cuenta de usuario se ha guardado correctamente en la base de datos.</p>
                    <a href="indexAccesosUsuarios.jsp" class="btn-back">Volver al Inicio</a>
                </div>
        <%
        } catch (Exception e) {
        %>
            <div class="success-card" style="border-top: 4px solid #ef4444;">
                <div class="success-icon" style="background-color: #fef2f2; color: #ef4444; border-color: #fca5a5;">✕</div>
                <h1 style="color: #991b1b;">Error al Guardar</h1>
                <p style="color: #991b1b;"><%= e.getMessage() != null ? e.getMessage() : "Error desconocido." %></p>
                <a href="indexAccesosUsuarios.jsp" class="btn-back" style="background-color: #dc2626;">Intentar de Nuevo</a>
            </div>
        <%
        }
        %>
    </body>
</html>
