<%-- 
    Document   : indexHabitaciones
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="entidades.Habitaciones"%>
<%@page import="entidades.TipoHabitacion"%>
<%@page import="controladores.habitacionControlador"%>
<%@page import="controladores.TipoHabitacionControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Habitaciones | Sistema Hotelero</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
            body { background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%); color: #1e293b; min-height: 100vh; padding: 30px; display: flex; justify-content: center; align-items: center; }
            .container { display: grid; grid-template-columns: 400px 1fr; gap: 30px; width: 100%; max-width: 1400px; }
            .card { background-color: #ffffff; border-radius: 16px; padding: 30px; box-shadow: 0 10px 25px rgba(30, 41, 59, 0.05); border: 1px solid #e2e8f0; }
            .header { margin-bottom: 25px; border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; }
            .header h1 { font-size: 22px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
            .header h1 span { color: #1e40af; }
            .header p { font-size: 13px; color: #64748b; margin-top: 4px; }
            .module-banner {
                height: 130px;
                border-radius: 16px 16px 0 0;
                margin: -30px -30px 20px -30px;
                background-image: linear-gradient(180deg, rgba(15,23,42,0.1) 0%, rgba(15,23,42,0.8) 100%), url('images/hab-matrimonial.jpg');
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: flex-end;
                padding: 14px 20px;
            }
            .module-banner span { color: #fff; font-weight: 600; font-size: 12px; letter-spacing: 0.5px; text-transform: uppercase; }

            .input-wrapper { margin-bottom: 16px; }
            label { display: block; font-size: 12px; font-weight: 600; color: #475569; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
            input[type="text"], input[type="number"], select { width: 100%; padding: 11px 14px; font-size: 14px; color: #0f172a; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s ease; }
            input[type="text"]:focus, input[type="number"]:focus, select:focus { border-color: #1e40af; background-color: #ffffff; box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.15); }
            .btn { display: inline-flex; justify-content: center; align-items: center; padding: 12px; font-size: 14px; font-weight: 600; border: none; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; text-decoration: none; text-align: center; }
            .btn-primary { background-color: #1e40af; color: #ffffff; width: 100%; margin-bottom: 12px; }
            .btn-primary:hover { background-color: #1e3a8a; }
            .btn-grid-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 15px; }
            .btn-outline { background-color: #ffffff; color: #475569; border: 1px solid #cbd5e1; }
            .btn-outline:hover { background-color: #f1f5f9; }
            .btn-danger { background-color: #ffffff; color: #dc2626; border: 1px solid #fca5a5; }
            .btn-danger:hover { background-color: #fef2f2; }
            .table-responsive { width: 100%; overflow-x: auto; border-radius: 10px; border: 1px solid #e2e8f0; }
            table { width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; }
            th { background-color: #f8fafc; color: #475569; font-weight: 600; padding: 12px 16px; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; border-bottom: 2px solid #e2e8f0; }
            td { padding: 12px 16px; border-bottom: 1px solid #f1f5f9; color: #334155; }
            tr:hover td { background-color: #f8fafc; }
            .btn-edit-table { padding: 4px 8px; font-size: 12px; background-color: #eff6ff; color: #1e40af; border-radius: 4px; text-decoration: none; font-weight: 600; }
            .btn-edit-table:hover { background-color: #dbeafe; }
            .badge { padding: 3px 8px; border-radius: 6px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
            .badge-disponible { background-color: #dcfce7; color: #166534; }
            .badge-ocupada { background-color: #fee2e2; color: #991b1b; }
            .badge-mantenimiento { background-color: #fef9c3; color: #854d0e; }
            .badge-reservada { background-color: #dbeafe; color: #1e40af; }
        </style>
    </head>
    <body>
        <%
        String idHabCargado = "";
        String numeroCargado = "";
        String pisoCargado = "";
        String idTipoCargado = "";
        String dispCargado = "Disponible";
        String limpiezaCargado = "Limpio";
        String activoCargado = "true";
        boolean modoEdicion = false;

        String idBuscar = request.getParameter("idHabitacionBuscar");
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                habitacionControlador habControl = new habitacionControlador();
                Habitaciones h = habControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (h != null) {
                    idHabCargado = String.valueOf(h.getIdHabitacion());
                    numeroCargado = h.getNumeroHabitacion() != null ? h.getNumeroHabitacion() : "";
                    pisoCargado = String.valueOf(h.getPiso());
                    idTipoCargado = h.getIdTipo() != null ? String.valueOf(h.getIdTipo().getIdTipo()) : "";
                    dispCargado = h.getEstadoDisponibilidad() != null ? h.getEstadoDisponibilidad() : "Disponible";
                    limpiezaCargado = h.getEstadoLimpieza() != null ? h.getEstadoLimpieza() : "Limpio";
                    activoCargado = String.valueOf(h.getActivo());
                    modoEdicion = true;
                }
            } catch (Exception e) {
                System.err.println("Error al cargar para edición: " + e.getMessage());
            }
        }

        List<TipoHabitacion> tipos = null;
        try {
            tipos = new TipoHabitacionControlador().obtenerTipos();
        } catch (Exception e) {
            System.err.println("Error al cargar tipos: " + e.getMessage());
        }
        %>

        <div class="container">
            <div class="card">
                <div class="module-banner"><span>Control de habitaciones del hotel</span></div>
                <div class="header">
                    <h1>🛌 Gestión de <span>Habitaciones</span></h1>
                    <p>Registro y control de habitaciones del hotel</p>
                </div>

                <form id="habForm" method="post">
                    <div class="input-wrapper">
                        <label for="idhabitacion">ID Habitación</label>
                        <% if (modoEdicion) { %>
                            <input type="text" id="idhabitacion" name="idhabitacion" value="<%= idHabCargado %>" readonly style="background-color: #cbd5e1; color: #475569; font-weight: bold;">
                        <% } else { %>
                            <input type="text" id="idhabitacion" name="idhabitacion" placeholder="Autogenerado por el sistema" value="" readonly style="background-color: #e2e8f0; color: #64748b; font-style: italic; cursor: not-allowed;">
                        <% } %>
                    </div>

                    <div class="input-wrapper">
                        <label for="numeroHabitacion">Número de Habitación</label>
                        <input type="text" id="numeroHabitacion" name="numeroHabitacion" placeholder="Ej. 101, 202" value="<%= numeroCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="piso">Piso</label>
                        <input type="number" id="piso" name="piso" placeholder="Ej. 1" value="<%= pisoCargado %>" required min="0">
                    </div>

                    <div class="input-wrapper">
                        <label for="idTipo">Tipo de Habitación</label>
                        <select id="idTipo" name="idTipo" required>
                            <option value="" disabled <%= idTipoCargado.isEmpty() ? "selected" : "" %>>-- Seleccione un tipo --</option>
                            <%
                            if (tipos != null) {
                                for (TipoHabitacion t : tipos) {
                                    boolean isSelected = String.valueOf(t.getIdTipo()).equals(idTipoCargado);
                            %>
                                    <option value="<%= t.getIdTipo() %>" <%= isSelected ? "selected" : "" %>>
                                        <%= t.getNombreTipo() %> - S/. <%= String.format("%.2f", t.getPrecioPorNoche()) %>
                                    </option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="estadoDisponibilidad">Estado de Disponibilidad</label>
                        <select id="estadoDisponibilidad" name="estadoDisponibilidad" required>
                            <option value="Disponible" <%= dispCargado.equals("Disponible") ? "selected" : "" %>>Disponible</option>
                            <option value="Ocupada" <%= dispCargado.equals("Ocupada") ? "selected" : "" %>>Ocupada</option>
                            <option value="Reservada" <%= dispCargado.equals("Reservada") ? "selected" : "" %>>Reservada</option>
                            <option value="Mantenimiento" <%= dispCargado.equals("Mantenimiento") ? "selected" : "" %>>Mantenimiento</option>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="estadoLimpieza">Estado de Limpieza</label>
                        <select id="estadoLimpieza" name="estadoLimpieza" required>
                            <option value="Limpio" <%= limpiezaCargado.equals("Limpio") ? "selected" : "" %>>Limpio</option>
                            <option value="Sucio" <%= limpiezaCargado.equals("Sucio") ? "selected" : "" %>>Sucio</option>
                            <option value="En Proceso" <%= limpiezaCargado.equals("En Proceso") ? "selected" : "" %>>En Proceso</option>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="activo">Estado del Registro</label>
                        <select id="activo" name="activo" required>
                            <option value="true" <%= activoCargado.equals("true") ? "selected" : "" %>>Activo</option>
                            <option value="false" <%= activoCargado.equals("false") ? "selected" : "" %>>Inactivo</option>
                        </select>
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarHabitacion.jsp')" class="btn btn-primary">💾 Guardar Habitación</button>
                        <div class="btn-grid-actions">
                            <button type="button" onclick="alert('Seleccione un registro de la tabla para editar')" class="btn btn-outline">🔄 Actualizar</button>
                            <button type="button" onclick="enviarAccion('JspEliminarHabitacion.jsp')" class="btn btn-danger">❌ Eliminar</button>
                        </div>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarHabitacion.jsp')" class="btn btn-primary" style="background-color: #1e3a8a;">Confirmar Cambios</button>
                        <a href="indexHabitaciones.jsp" class="btn btn-outline" style="width: 100%; margin-bottom: 12px;">Cancelar Edición</a>
                    <% } %>

                    <a href="indexPrin.jsp" class="btn btn-outline" style="width: 100%;">← Volver al Menú Principal</a>
                </form>
            </div>

            <div class="card" style="overflow: hidden;">
                <div class="header">
                    <h1>📋 Habitaciones <span>Registradas</span></h1>
                    <p>Listado completo de habitaciones del hotel</p>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Número</th>
                                <th>Piso</th>
                                <th>Tipo</th>
                                <th>Disponibilidad</th>
                                <th>Limpieza</th>
                                <th>Activo</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                habitacionControlador habControlLista = new habitacionControlador();
                                List<Habitaciones> lista = habControlLista.obtenerHabitaciones();
                                if (lista != null && !lista.isEmpty()) {
                                    for (Habitaciones h : lista) {
                                        String dispClass = "badge-disponible";
                                        String estDisp = h.getEstadoDisponibilidad() != null ? h.getEstadoDisponibilidad() : "";
                                        if (estDisp.equalsIgnoreCase("Ocupada")) {
                                            dispClass = "badge-ocupada";
                                        } else if (estDisp.equalsIgnoreCase("Mantenimiento")) {
                                            dispClass = "badge-mantenimiento";
                                        } else if (estDisp.equalsIgnoreCase("Reservada")) {
                                            dispClass = "badge-reservada";
                                        }
                            %>
                                        <tr>
                                            <td><strong><%= h.getIdHabitacion() %></strong></td>
                                            <td><%= h.getNumeroHabitacion() %></td>
                                            <td><%= h.getPiso() %></td>
                                            <td><%= h.getIdTipo() != null ? h.getIdTipo().getNombreTipo() : "-" %></td>
                                            <td><span class="badge <%= dispClass %>"><%= h.getEstadoDisponibilidad() %></span></td>
                                            <td><%= h.getEstadoLimpieza() %></td>
                                            <td><%= h.getActivo() ? "Sí" : "No" %></td>
                                            <td><a href="indexHabitaciones.jsp?idHabitacionBuscar=<%= h.getIdHabitacion() %>" class="btn-edit-table">Editar</a></td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr><td colspan="8" style="text-align: center; color: #94a3b8;">No hay habitaciones registradas.</td></tr>
                            <%
                                }
                            } catch (Exception e) {
                            %>
                                <tr><td colspan="8" style="color: #dc2626;">Error al cargar datos: <%= e.getMessage() %></td></tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function enviarAccion(destino) {
                var form = document.getElementById('habForm');
                var inputId = document.getElementById('idhabitacion');
                var id = inputId.value.trim();
                var numero = document.getElementById('numeroHabitacion').value.trim();
                var piso = document.getElementById('piso').value.trim();
                var tipo = document.getElementById('idTipo').value.trim();

                if (destino === 'JspActualizarHabitacion.jsp' || destino === 'JspEliminarHabitacion.jsp') {
                    if (!id) {
                        alert('Seleccione un registro de la tabla para realizar esta acción.');
                        return;
                    }
                }

                if (destino !== 'JspEliminarHabitacion.jsp') {
                    if (!numero || !piso || !tipo) {
                        alert('Todos los campos obligatorios deben completarse.');
                        return;
                    }
                }

                if (destino === 'JspEliminarHabitacion.jsp' && !confirm('¿Seguro que deseas eliminar esta habitación?')) {
                    return;
                }

                if (destino === 'JspGrabarHabitacion.jsp' && !id) {
                    inputId.value = "0";
                }

                form.action = destino;
                form.submit();
            }
        </script>
    </body>
</html>
