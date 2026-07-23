<%-- 
    Document   : JspEliminarEmpleado
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="controladores.empleadoControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Procesando Eliminación...</title>
    </head>
   <body style="font-family: sans-serif; background: #f4f4f9; padding: 20px;">
        <%
        try {
            int id = Integer.parseInt(request.getParameter("idEmpleado"));

            empleadoControlador control = new empleadoControlador();
            control.eliminarEmpleado(id);

            out.println("<script>");
            out.println("alert('¡Empleado eliminado permanentemente!');");
            out.println("window.location.href='indexEmpleado.jsp';");
            out.println("</script>");

        } catch (Exception e) {
        %>
            <div style="background: white; padding: 20px; border-radius: 8px; border-left: 6px solid #dc3545; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <h2 style="color: #dc3545; margin-top: 0;">🚨 Fallo en el Controlador o Base de Datos</h2>
                <p>El sistema no pudo eliminar al empleado por la siguiente razón:</p>

                <pre style="background: #e9ecef; padding: 15px; border-radius: 5px; color: #333; white-space: pre-wrap; word-wrap: break-word;">
                    <%= e.getMessage() %>
                </pre>

                <br>
                <a href="indexEmpleado.jsp" style="display: inline-block; padding: 10px 20px; background: #343a40; color: white; text-decoration: none; border-radius: 5px;">Regresar a Empleados</a>
            </div>
        <%
        }
        %>
    </body>
</html>
