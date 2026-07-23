<%-- 
    Document   : JspMarcarSalidaCliente
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.AccesosClientesControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Registrando salida...</title>
    </head>
    <body>
        <%
            try {
                int idAcceso = Integer.parseInt(request.getParameter("idacceso").trim());
                AccesosClientesControlador accesoControl = new AccesosClientesControlador();
                accesoControl.marcarSalida(idAcceso);

                out.println("<script>");
                out.println("alert('¡Salida registrada correctamente!');");
                out.println("window.location.href='indexAccesosClientes.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                out.println("<script>");
                out.println("alert('Error al registrar la salida: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
                out.println("window.location.href='indexAccesosClientes.jsp';");
                out.println("</script>");
            }
        %>
    </body>
</html>
