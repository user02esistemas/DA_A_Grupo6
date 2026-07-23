<%-- 
    Document   : JspActualizarHabitacion
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>

<%@page import="entidades.Habitaciones"%>
<%@page import="entidades.TipoHabitacion"%>
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
        String idParam = request.getParameter("idhabitacion");
        String numeroParam = request.getParameter("numeroHabitacion");
        String pisoParam = request.getParameter("piso");
        String idTipoParam = request.getParameter("idTipo");
        String dispParam = request.getParameter("estadoDisponibilidad");
        String limpiezaParam = request.getParameter("estadoLimpieza");
        String activoParam = request.getParameter("activo");

        if (idParam == null || numeroParam == null || pisoParam == null || idTipoParam == null
                || dispParam == null || limpiezaParam == null || idParam.trim().isEmpty()) {
            throw new Exception("Faltan datos en el formulario. Por favor, llena todos los campos.");
        }

        int idHabitacion = Integer.parseInt(idParam.trim());
        String numero = numeroParam.trim();
        int piso = Integer.parseInt(pisoParam.trim());
        int idTipo = Integer.parseInt(idTipoParam.trim());
        String disponibilidad = dispParam.trim();
        String limpieza = limpiezaParam.trim();
        boolean activo = activoParam != null && Boolean.parseBoolean(activoParam.trim());

        em = connectionDriver.getEmf().createEntityManager();
        em.getTransaction().begin();

        Habitaciones hab = em.find(Habitaciones.class, idHabitacion);
        if (hab == null) {
            throw new Exception("La habitación con ID " + idHabitacion + " no existe.");
        }

        TipoHabitacion tipo = em.find(TipoHabitacion.class, idTipo);
        if (tipo == null) {
            throw new Exception("El tipo de habitación seleccionado no existe.");
        }

        hab.setNumeroHabitacion(numero);
        hab.setPiso(piso);
        hab.setIdTipo(tipo);
        hab.setEstadoDisponibilidad(disponibilidad);
        hab.setEstadoLimpieza(limpieza);
        hab.setActivo(activo);

        em.merge(hab);
        em.getTransaction().commit();

        em.getEntityManagerFactory().getCache().evictAll();

        out.println("<script>");
        out.println("alert('¡Habitación actualizada con éxito!');");
        out.println("window.location.href='indexHabitaciones.jsp';");
        out.println("</script>");

    } catch (Exception e) {
        if (em != null && em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
        out.println("<script>");
        out.println("alert('Error al actualizar: " + (e.getMessage() != null ? e.getMessage().replace("'", "\\'") : "Error desconocido") + "');");
        out.println("window.location.href='indexHabitaciones.jsp';");
        out.println("</script>");
    } finally {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
    %>
    </body>
</html>
