<%-- 
    Document   : JspActualizarUsuario
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.UsuariosControlador"%>
<%@page import="entidades.Empleados"%>
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
        String idParam = request.getParameter("idusuario");
        String idEmpParam = request.getParameter("idEmpleado");
        String usernameParam = request.getParameter("username");
        String passwordParam = request.getParameter("password");
        String rolParam = request.getParameter("rolSistema");
        String activoParam = request.getParameter("activo");

        if (idParam == null || idEmpParam == null || usernameParam == null || rolParam == null
                || idParam.trim().isEmpty() || idEmpParam.trim().isEmpty()
                || usernameParam.trim().isEmpty() || rolParam.trim().isEmpty()) {
            throw new Exception("Faltan datos en el formulario. Por favor, llena todos los campos.");
        }

        int idUsuario = Integer.parseInt(idParam.trim());
        int idEmpleado = Integer.parseInt(idEmpParam.trim());
        boolean activo = activoParam != null;

        UsuariosControlador usuControl = new UsuariosControlador();
        Empleados emp = usuControl.buscarEmpleadoPorId(idEmpleado);
        if (emp == null) {
            throw new Exception("El empleado seleccionado no existe.");
        }

        usuControl.actualizarUsuario(idUsuario, emp, usernameParam.trim(), passwordParam, rolParam.trim(), activo);

        out.println("<script>");
        out.println("alert('¡Acceso de usuario actualizado con éxito!');");
        out.println("window.location.href='indexAccesosUsuarios.jsp';");
        out.println("</script>");

    } catch (Exception e) {
        out.println("<script>");
        out.println("alert('Error al actualizar: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
        out.println("window.location.href='indexAccesosUsuarios.jsp';");
        out.println("</script>");
    }
    %>
    </body>
</html>
