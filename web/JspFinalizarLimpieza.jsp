<%-- 
    Document   : JspFinalizarLimpieza
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="controladores.HistorialLimpiezaControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Finalizando...</title>
    </head>
    <body>
        <%
            try {
                int idLimpieza = Integer.parseInt(request.getParameter("idlimpieza").trim());
                HistorialLimpiezaControlador limpControl = new HistorialLimpiezaControlador();
                limpControl.finalizarLimpieza(idLimpieza);

                out.println("<script>");
                out.println("alert('¡Limpieza finalizada! La habitación quedó marcada como Limpia.');");
                out.println("window.location.href='indexHistorialLimpieza.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                out.println("<script>");
                out.println("alert('Error al finalizar la limpieza: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
                out.println("window.location.href='indexHistorialLimpieza.jsp';");
                out.println("</script>");
            }
        %>
    </body>
</html>
