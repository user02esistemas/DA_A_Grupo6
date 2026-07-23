<%-- 
    Document   : JspEliminarCli
    Created on : 12 jul. 2026, 11:16:50 a. m.
    Author     : dzs-1
--%>


<%@page import="controladores.clienteControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Procesando Eliminación...</title>
    </head>
   <body style="font-family: sans-serif; background: #f4f4f9; padding: 20px;">
        <%
        try {
            // 1. Capturar el ID
            int id = Integer.parseInt(request.getParameter("idcliente"));

            // 2. Ejecutar la eliminación en el controlador
            clienteControlador control = new clienteControlador();
            control.eliminarCliente(id);

            // 3. Si todo sale bien, lanzamos la alerta y redireccionamos
            out.println("<script>");
            out.println("alert('¡Huésped eliminado permanentemente!');");
            out.println("window.location.href='indexClientes.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            // 🚨 SI ALGO FALLA, LO IMPRIMIMOS EN HTML PURO PARA QUE NO SE ROMPA JAVASCRIPT
        %>
            <div style="background: white; padding: 20px; border-radius: 8px; border-left: 6px solid #dc3545; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <h2 style="color: #dc3545; margin-top: 0;">🚨 Fallo en el Controlador o Base de Datos</h2>
                <p>El sistema no pudo eliminar al cliente por la siguiente razón:</p>

                <pre style="background: #e9ecef; padding: 15px; border-radius: 5px; color: #333; white-space: pre-wrap; word-wrap: break-word;">
                    <%= e.getMessage() %>
                </pre>

                <br>
                <a href="indexClientes.jsp" style="display: inline-block; padding: 10px 20px; background: #343a40; color: white; text-decoration: none; border-radius: 5px;">Regresar a Clientes</a>
            </div>
        <%
        }
        %>
    </body>
</html>
