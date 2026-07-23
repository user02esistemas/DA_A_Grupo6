<%-- 
    Document   : JspActualizarAcceso
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.AccesosClientes"%>
<%@page import="entidades.Clientes"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="conexion.connectionDriver"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Actualizando...</title>
    </head>
    <body>
        <%
    EntityManager em = null;
    try {
        String idParam = request.getParameter("idacceso");
        String idClienteParam = request.getParameter("idcliente");
        String motivoParam = request.getParameter("motivoVisita");

        if (idParam == null || idClienteParam == null
                || idParam.trim().isEmpty() || idClienteParam.trim().isEmpty()) {
            throw new Exception("Faltan datos en el formulario. Por favor, llena todos los campos.");
        }

        int idAcceso = Integer.parseInt(idParam.trim());
        int idCliente = Integer.parseInt(idClienteParam.trim());
        String motivo = motivoParam != null && !motivoParam.trim().isEmpty() ? motivoParam.trim() : "Huésped";

        em = connectionDriver.getEmf().createEntityManager();
        em.getTransaction().begin();

        AccesosClientes acceso = em.find(AccesosClientes.class, idAcceso);
        if (acceso == null) {
            throw new Exception("El registro de acceso con ID " + idAcceso + " no existe.");
        }

        Clientes cli = em.find(Clientes.class, idCliente);
        if (cli == null) {
            throw new Exception("El cliente seleccionado no existe.");
        }

        acceso.setIdcliente(cli);
        acceso.setMotivoVisita(motivo);

        em.merge(acceso);
        em.getTransaction().commit();

        em.getEntityManagerFactory().getCache().evictAll();

        out.println("<script>");
        out.println("alert('¡Registro de acceso actualizado con éxito!');");
        out.println("window.location.href='indexAccesosClientes.jsp';");
        out.println("</script>");

    } catch (Exception e) {
        if (em != null && em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
        out.println("<script>");
        out.println("alert('Error al actualizar: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
        out.println("window.location.href='indexAccesosClientes.jsp';");
        out.println("</script>");
    } finally {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
    %>
    </body>
</html>
