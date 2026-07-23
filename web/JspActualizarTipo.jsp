<%-- 
    Document   : JspActualizarTipo
    Created on : 12 jul. 2026, 11:14:47 a. m.
    Author     : dzs-1
--%>

<%@page import="entidades.TipoHabitacion"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="conexion.connectionDriver"%>
<%@page import="java.math.BigDecimal"%>
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
        // 1. Recibimos todos los parámetros desde el formulario
        String idParam = request.getParameter("idtipo");
        String nombreParam = request.getParameter("nombreTipo");
        String precioParam = request.getParameter("precioPorNoche");
        String capacidadParam = request.getParameter("capacidadPersonas");

        // 2. Validamos que no llegue ningún dato vacío
        if (idParam == null || nombreParam == null || precioParam == null || capacidadParam == null || idParam.trim().isEmpty()) {
            throw new Exception("Faltan datos en el formulario. Por favor, llena todos los campos.");
        }

        // 3. Convertimos los datos básicos
        int idTipo = Integer.parseInt(idParam.trim());
        String nombreTipo = nombreParam.trim();
        int capacidad = Integer.parseInt(capacidadParam.trim());
        
        // 4. Procesamos el precio para evitar errores con comas o símbolos de moneda
        String precioProcesado = precioParam.replace(",", ".");
        String precioLimpio = precioProcesado.replaceAll("[^0-9.]", "").trim();
        if (precioLimpio.isEmpty()) {
            precioLimpio = "0.0";
        }
        BigDecimal precioFinal = new BigDecimal(precioLimpio);

        // 5. Conectamos con la base de datos e iniciamos la transacción
        em = connectionDriver.getEmf().createEntityManager();
        em.getTransaction().begin();

        // 6. Buscamos la habitación existente por su ID
        TipoHabitacion tipo = em.find(TipoHabitacion.class, idTipo);
        
        if (tipo == null) {
            throw new Exception("El tipo de habitación con ID " + idTipo + " no existe.");
        }

        // 7. ACTUALIZAMOS TODOS LOS CAMPOS EN EL OBJETO
        tipo.setNombreTipo(nombreTipo);
        tipo.setPrecioPorNoche(precioFinal);   // ¡Aquí actualiza el precio!
        tipo.setCapacidadPersonas(capacidad); // ¡Aquí actualiza el número de personas!
        
        // 8. Guardamos los cambios y confirmamos (Commit)
        em.merge(tipo);
        em.getTransaction().commit();

        // 9. Truco: Limpiamos la caché de JPA para que los cambios se vean en tu tabla de inmediato
        em.getEntityManagerFactory().getCache().evictAll();

        // 10. Mensaje de éxito y redirección
        out.println("<script>");
        out.println("alert('¡Categoría actualizada con éxito!');");
        out.println("window.location.href='indexTipoHabitacion.jsp';");
        out.println("</script>");

    } catch (Exception e) {
        // Si algo falla, cancelamos los cambios en la BD para evitar datos corruptos
        if (em != null && em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
        out.println("<script>");
        out.println("alert('Error al actualizar: " + e.getMessage().replace("'", "\\'") + "');");
        out.println("window.location.href='indexTipoHabitacion.jsp';");
        out.println("</script>");
    } finally {
        // Cerramos la conexión siempre
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
    
    %>
    </body>
</html>
