<%-- 
    Document   : indexHistorialLimpieza
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="entidades.HistorialLimpieza"%>
<%@page import="entidades.Habitaciones"%>
<%@page import="entidades.Empleados"%>
<%@page import="controladores.HistorialLimpiezaControlador"%>
<%@page import="controladores.habitacionControlador"%>
<%@page import="controladores.empleadoControlador"%>
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
        <title>Historial de Limpieza | Sistema Hotelero</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
            body { background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%); color: #1e293b; min-height: 100vh; padding: 30px; display: flex; justify-content: center; align-items: center; }
            .container { display: grid; grid-template-columns: 400px 1fr; gap: 30px; width: 100%; max-width: 1500px; }
            .card { background-color: #ffffff; border-radius: 16px; padding: 30px; box-shadow: 0 10px 25px rgba(30, 41, 59, 0.05); border: 1px solid #e2e8f0; }
            .header { margin-bottom: 25px; border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; }
            .header h1 { font-size: 22px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
            .header h1 span { color: #1e40af; }
            .header p { font-size: 13px; color: #64748b; margin-top: 4px; }
            .module-banner {
                height: 130px;
                border-radius: 16px 16px 0 0;
                margin: -30px -30px 20px -30px;
                background-image: linear-gradient(180deg, rgba(15,23,42,0.1) 0%, rgba(15,23,42,0.8) 100%), url('images/hab-personal.webp');
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: flex-end;
                padding: 14px 20px;
            }
            .module-banner span { color: #fff; font-weight: 600; font-size: 12px; letter-spacing: 0.5px; text-transform: uppercase; }

            .input-wrapper { margin-bottom: 16px; }
            label { display: block; font-size: 12px; font-weight: 600; color: #475569; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
            input[type="text"], input[type="number"], select, textarea { width: 100%; padding: 11px 14px; font-size: 14px; color: #0f172a; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s ease; font-family: inherit; }
            textarea { resize: vertical; min-height: 60px; }
            input:focus, select:focus, textarea:focus { border-color: #1e40af; background-color: #ffffff; box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.15); }
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
            th { background-color: #f8fafc; color: #475569; font-weight: 600; padding: 12px 16px; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; border-bottom: 2px solid #e2e8f0; white-space: nowrap; }
            td { padding: 12px 16px; border-bottom: 1px solid #f1f5f9; color: #334155; white-space: nowrap; }
            tr:hover td { background-color: #f8fafc; }
            .btn-edit-table { padding: 4px 8px; font-size: 12px; background-color: #eff6ff; color: #1e40af; border-radius: 4px; text-decoration: none; font-weight: 600; margin-right: 4px; }
            .btn-edit-table:hover { background-color: #dbeafe; }
            .btn-finalizar-table { padding: 4px 8px; font-size: 12px; background-color: #ecfdf5; color: #047857; border-radius: 4px; text-decoration: none; font-weight: 600; border: none; cursor: pointer; }
            .btn-finalizar-table:hover { background-color: #d1fae5; }
            .badge { padding: 3px 8px; border-radius: 6px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
            .badge-limpio { background-color: #dcfce7; color: #166534; }
            .badge-sucio { background-color: #fee2e2; color: #991b1b; }
            .badge-proceso { background-color: #fef9c3; color: #854d0e; }
        </style>
    </head>
    <body>
        <%
        String idCargado = "";
        String idHabCargado = "";
        String idEmpCargado = "";
        String estadoCargado = "En Proceso";
        String observacionesCargado = "";
        boolean modoEdicion = false;

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        String idBuscar = request.getParameter("idLimpiezaBuscar");
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                HistorialLimpiezaControlador limpControl = new HistorialLimpiezaControlador();
                HistorialLimpieza l = limpControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (l != null) {
                    idCargado = String.valueOf(l.getIdLimpieza());
                    idHabCargado = l.getIdHabitacion() != null ? String.valueOf(l.getIdHabitacion().getIdHabitacion()) : "";
                    idEmpCargado = l.getIdEmpleado() != null ? String.valueOf(l.getIdEmpleado().getIdEmpleado()) : "";
                    estadoCargado = l.getEstadoLimpieza() != null ? l.getEstadoLimpieza() : "En Proceso";
                    observacionesCargado = l.getObservaciones() != null ? l.getObservaciones() : "";
                    modoEdicion = true;
                }
            } catch (Exception e) {
                System.err.println("Error al cargar para edición: " + e.getMessage());
            }
        }

        List<Habitaciones> habitaciones = null;
        List<Empleados> empleados = null;
        try {
            habitaciones = new habitacionControlador().obtenerHabitaciones();
        } catch (Exception e) {
            System.err.println("Error al cargar habitaciones: " + e.getMessage());
        }
        try {
            empleados = new empleadoControlador().obtenerEmpleados();
        } catch (Exception e) {
            System.err.println("Error al cargar empleados: " + e.getMessage());
        }
        %>

        <div class="container">
            <div class="card">
                <div class="module-banner"><span>Estándares de limpieza y orden</span></div>
                <div class="header">
                    <h1>🧹 Historial de <span>Limpieza</span></h1>
                    <p>Registro y control de limpieza de habitaciones</p>
                </div>

                <form id="limpForm" method="post">
                    <div class="input-wrapper">
                        <label for="idlimpieza">ID Registro</label>
                        <% if (modoEdicion) { %>
                            <input type="text" id="idlimpieza" name="idlimpieza" value="<%= idCargado %>" readonly style="background-color: #cbd5e1; color: #475569; font-weight: bold;">
                        <% } else { %>
                            <input type="text" id="idlimpieza" name="idlimpieza" placeholder="Autogenerado por el sistema" value="" readonly style="background-color: #e2e8f0; color: #64748b; font-style: italic; cursor: not-allowed;">
                        <% } %>
                    </div>

                    <div class="input-wrapper">
                        <label for="idHabitacion">Habitación</label>
                        <select id="idHabitacion" name="idHabitacion" required>
                            <option value="" disabled <%= idHabCargado.isEmpty() ? "selected" : "" %>>-- Seleccione una habitación --</option>
                            <%
                            if (habitaciones != null) {
                                for (Habitaciones h : habitaciones) {
                                    boolean isSelected = String.valueOf(h.getIdHabitacion()).equals(idHabCargado);
                            %>
                                    <option value="<%= h.getIdHabitacion() %>" <%= isSelected ? "selected" : "" %>>
                                        Hab. <%= h.getNumeroHabitacion() %> (Piso <%= h.getPiso() %>)
                                    </option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="idEmpleado">Empleado Responsable</label>
                        <select id="idEmpleado" name="idEmpleado" required>
                            <option value="" disabled <%= idEmpCargado.isEmpty() ? "selected" : "" %>>-- Seleccione un empleado --</option>
                            <%
                            if (empleados != null) {
                                for (Empleados e : empleados) {
                                    boolean isSelected = String.valueOf(e.getIdEmpleado()).equals(idEmpCargado);
                            %>
                                    <option value="<%= e.getIdEmpleado() %>" <%= isSelected ? "selected" : "" %>>
                                        <%= e.getNombre() %> <%= e.getApellido() %> (<%= e.getRol() %>)
                                    </option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="estadoLimpieza">Estado de Limpieza</label>
                        <select id="estadoLimpieza" name="estadoLimpieza" required>
                            <option value="En Proceso" <%= estadoCargado.equals("En Proceso") ? "selected" : "" %>>En Proceso</option>
                            <option value="Limpio" <%= estadoCargado.equals("Limpio") ? "selected" : "" %>>Limpio</option>
                            <option value="Sucio" <%= estadoCargado.equals("Sucio") ? "selected" : "" %>>Sucio</option>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="observaciones">Observaciones</label>
                        <textarea id="observaciones" name="observaciones" placeholder="Notas adicionales (opcional)" maxlength="255"><%= observacionesCargado %></textarea>
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarLimpieza.jsp')" class="btn btn-primary">💾 Guardar Registro</button>
                        <div class="btn-grid-actions">
                            <button type="button" onclick="alert('Seleccione un registro de la tabla para editar')" class="btn btn-outline">🔄 Actualizar</button>
                            <button type="button" onclick="enviarAccion('JspEliminarLimpieza.jsp')" class="btn btn-danger">❌ Eliminar</button>
                        </div>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarLimpieza.jsp')" class="btn btn-primary" style="background-color: #1e3a8a;">Confirmar Cambios</button>
                        <a href="indexHistorialLimpieza.jsp" class="btn btn-outline" style="width: 100%; margin-bottom: 12px;">Cancelar Edición</a>
                    <% } %>

                    <a href="indexPrin.jsp" class="btn btn-outline" style="width: 100%;">← Volver al Menú Principal</a>
                </form>
            </div>

            <div class="card" style="overflow: hidden;">
                <div class="header">
                    <h1>📋 Registros de <span>Limpieza</span></h1>
                    <p>Listado completo del historial de limpieza</p>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Habitación</th>
                                <th>Empleado</th>
                                <th>Estado</th>
                                <th>Inicio</th>
                                <th>Fin</th>
                                <th>Observaciones</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                HistorialLimpiezaControlador limpControlLista = new HistorialLimpiezaControlador();
                                List<HistorialLimpieza> lista = limpControlLista.obtenerHistorial();
                                if (lista != null && !lista.isEmpty()) {
                                    for (HistorialLimpieza l : lista) {
                                        String estClass = "badge-proceso";
                                        String est = l.getEstadoLimpieza() != null ? l.getEstadoLimpieza() : "";
                                        if (est.equalsIgnoreCase("Limpio")) {
                                            estClass = "badge-limpio";
                                        } else if (est.equalsIgnoreCase("Sucio")) {
                                            estClass = "badge-sucio";
                                        }
                            %>
                                        <tr>
                                            <td><strong><%= l.getIdLimpieza() %></strong></td>
                                            <td><%= l.getIdHabitacion() != null ? l.getIdHabitacion().getNumeroHabitacion() : "-" %></td>
                                            <td><%= l.getIdEmpleado() != null ? (l.getIdEmpleado().getNombre() + " " + l.getIdEmpleado().getApellido()) : "-" %></td>
                                            <td><span class="badge <%= estClass %>"><%= l.getEstadoLimpieza() %></span></td>
                                            <td><%= l.getFechaHoraInicio() != null ? sdf.format(l.getFechaHoraInicio()) : "-" %></td>
                                            <td><%= l.getFechaHoraFin() != null ? sdf.format(l.getFechaHoraFin()) : "-" %></td>
                                            <td><%= l.getObservaciones() != null ? l.getObservaciones() : "-" %></td>
                                            <td>
                                                <a href="indexHistorialLimpieza.jsp?idLimpiezaBuscar=<%= l.getIdLimpieza() %>" class="btn-edit-table">Editar</a>
                                                <% if (l.getFechaHoraFin() == null) { %>
                                                <form action="JspFinalizarLimpieza.jsp" method="post" style="display:inline;">
                                                    <input type="hidden" name="idlimpieza" value="<%= l.getIdLimpieza() %>">
                                                    <button type="submit" class="btn-finalizar-table" onclick="return confirm('¿Marcar esta limpieza como finalizada?');">Finalizar</button>
                                                </form>
                                                <% } %>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr><td colspan="8" style="text-align: center; color: #94a3b8;">No hay registros de limpieza.</td></tr>
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
                var form = document.getElementById('limpForm');
                var inputId = document.getElementById('idlimpieza');
                var id = inputId.value.trim();
                var idHab = document.getElementById('idHabitacion').value.trim();
                var idEmp = document.getElementById('idEmpleado').value.trim();

                if (destino === 'JspActualizarLimpieza.jsp' || destino === 'JspEliminarLimpieza.jsp') {
                    if (!id) {
                        alert('Seleccione un registro de la tabla para realizar esta acción.');
                        return;
                    }
                }

                if (destino !== 'JspEliminarLimpieza.jsp') {
                    if (!idHab || !idEmp) {
                        alert('Todos los campos obligatorios deben completarse.');
                        return;
                    }
                }

                if (destino === 'JspEliminarLimpieza.jsp' && !confirm('¿Seguro que deseas eliminar este registro de limpieza?')) {
                    return;
                }

                if (destino === 'JspGrabarLimpieza.jsp' && !id) {
                    inputId.value = "0";
                }

                form.action = destino;
                form.submit();
            }
        </script>
    </body>
</html>
