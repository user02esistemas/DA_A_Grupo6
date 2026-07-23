<%-- 
    Document   : indexReservas
    Created on : 13 jul. 2026, 12:18:42 p. m.
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="entidades.Reservas"%>
<%@page import="entidades.Clientes"%>
<%@page import="entidades.Empleados"%>
<%@page import="entidades.Habitaciones"%>
<%@page import="controladores.ReservaControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Gestión de Reservas | Sistema Hotelero</title>
            <style>
                @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
                * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
                body { background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%); color: #1e293b; min-height: 100vh; padding: 30px; display: flex; justify-content: center; align-items: flex-start; }
                .container { display: grid; grid-template-columns: 400px 1fr; gap: 30px; width: 100%; max-width: 1500px; }
                .card { background-color: #ffffff; border-radius: 16px; padding: 30px; box-shadow: 0 10px 25px rgba(30, 41, 59, 0.05); border: 1px solid #e2e8f0; }
                .header { margin-bottom: 25px; border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; }
                .header h1 { font-size: 22px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
                .header h1 span { color: #1e40af; }
                .header p { font-size: 13px; color: #64748b; margin-top: 4px; }
                .input-wrapper { margin-bottom: 16px; }
                label { display: block; font-size: 12px; font-weight: 600; color: #475569; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
                input[type="text"], input[type="datetime-local"], select { width: 100%; padding: 11px 14px; font-size: 14px; color: #0f172a; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s ease; }
                input:focus, select:focus { border-color: #1e40af; background-color: #ffffff; box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.15); }
                .btn { display: inline-flex; justify-content: center; align-items: center; padding: 12px; font-size: 14px; font-weight: 600; border: none; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; text-decoration: none; text-align: center; }
                .btn-primary { background-color: #1e40af; color: #ffffff; width: 100%; margin-bottom: 12px; }
                .btn-primary:hover { background-color: #1e3a8a; }
                .btn-outline { background-color: #ffffff; color: #475569; border: 1px solid #cbd5e1; width: 100%; margin-bottom: 12px; }
                .btn-outline:hover { background-color: #f1f5f9; }
                .table-responsive { width: 100%; overflow-x: auto; border-radius: 10px; border: 1px solid #e2e8f0; }
                table { width: 100%; border-collapse: collapse; text-align: left; font-size: 13px; }
                th { background-color: #f8fafc; color: #475569; font-weight: 600; padding: 12px 14px; text-transform: uppercase; font-size: 10.5px; letter-spacing: 0.5px; border-bottom: 2px solid #e2e8f0; white-space: nowrap; }
                td { padding: 10px 14px; border-bottom: 1px solid #f1f5f9; color: #334155; white-space: nowrap; }
                tr:hover td { background-color: #f8fafc; }
                .badge { padding: 3px 8px; border-radius: 6px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
                .badge-activa { background-color: #dbeafe; color: #1e40af; }
                .badge-finalizada { background-color: #dcfce7; color: #166534; }
                .badge-pendiente { background-color: #fef9c3; color: #854d0e; }
                .badge-cancelada { background-color: #fee2e2; color: #991b1b; }
                .actions-cell { display: flex; gap: 6px; }
                .btn-mini { padding: 4px 8px; font-size: 11px; border-radius: 4px; text-decoration: none; font-weight: 600; border: none; cursor: pointer; }
                .btn-edit-table { background-color: #eff6ff; color: #1e40af; }
                .btn-edit-table:hover { background-color: #dbeafe; }
                .btn-checkout-table { background-color: #ecfdf5; color: #059669; }
                .btn-checkout-table:hover { background-color: #d1fae5; }
                .btn-delete-table { background-color: #fef2f2; color: #dc2626; }
                .btn-delete-table:hover { background-color: #fee2e2; }
            </style>
    </head>
    <body>
        <%
        String idResCargado = "";
        String idClienteCargado = "";
        String idHabitacionCargado = "";
        String idEmpleadoCargado = "";
        String checkInCargado = "";
        String checkOutCargado = "";
        boolean modoEdicion = false;

        ReservaControlador resControl = new ReservaControlador();
        SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

        String idBuscar = request.getParameter("idReservaBuscar");
        Reservas reservaEditar = null;
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                reservaEditar = resControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (reservaEditar != null) {
                    idResCargado = String.valueOf(reservaEditar.getIdReserva());
                    idClienteCargado = reservaEditar.getIdCliente() != null ? String.valueOf(reservaEditar.getIdCliente().getIdcliente()) : "";
                    idHabitacionCargado = reservaEditar.getIdHabitacion() != null ? String.valueOf(reservaEditar.getIdHabitacion().getIdHabitacion()) : "";
                    idEmpleadoCargado = reservaEditar.getIdEmpleado() != null ? String.valueOf(reservaEditar.getIdEmpleado().getIdEmpleado()) : "";
                    checkInCargado = reservaEditar.getFechaCheckIn() != null ? sdfInput.format(reservaEditar.getFechaCheckIn()) : "";
                    checkOutCargado = reservaEditar.getFechaCheckOutEsperada() != null ? sdfInput.format(reservaEditar.getFechaCheckOutEsperada()) : "";
                    modoEdicion = true;
                }
            } catch (Exception e) {
                System.err.println("Error al cargar reserva para edición: " + e.getMessage());
            }
        }

        List<Clientes> clientes = resControl.obtenerClientes();
        List<Empleados> empleados = resControl.obtenerEmpleados();
        Integer idHabActualParaCombo = modoEdicion && !idHabitacionCargado.isEmpty() ? Integer.parseInt(idHabitacionCargado) : null;
        List<Habitaciones> habitacionesCombo = resControl.obtenerHabitacionesParaCombo(idHabActualParaCombo);

        SimpleDateFormat sdfTabla = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>

        <div class="container">
            <div class="card">
                <div class="header">
                    <h1>📅 Gestión de <span>Reservas</span></h1>
                    <p>Registro de check-in, check-out y control de estadía</p>
                </div>

                <form id="resForm" method="post">
                    <div class="input-wrapper">
                        <label for="idreserva">ID Reserva</label>
                        <% if (modoEdicion) { %>
                            <input type="text" id="idreserva" name="idreserva" value="<%= idResCargado %>" readonly style="background-color: #cbd5e1; color: #475569; font-weight: bold;">
                        <% } else { %>
                            <input type="text" id="idreserva" name="idreserva" placeholder="Autogenerado por el sistema" value="" readonly style="background-color: #e2e8f0; color: #64748b; font-style: italic; cursor: not-allowed;">
                        <% } %>
                    </div>

                    <div class="input-wrapper">
                        <label for="idCliente">Huésped</label>
                        <select id="idCliente" name="idCliente" required>
                            <option value="" disabled <%= idClienteCargado.isEmpty() ? "selected" : "" %>>-- Seleccione un huésped --</option>
                            <%
                            if (clientes != null) {
                                for (Clientes c : clientes) {
                                    boolean sel = String.valueOf(c.getIdcliente()).equals(idClienteCargado);
                            %>
                                    <option value="<%= c.getIdcliente() %>" <%= sel ? "selected" : "" %>>
                                        <%= c.getNombres() %> <%= c.getApellidos() %> - <%= c.getDniRuc() %>
                                    </option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="idHabitacion">Habitación</label>
                        <select id="idHabitacion" name="idHabitacion" required>
                            <option value="" disabled <%= idHabitacionCargado.isEmpty() ? "selected" : "" %>>-- Seleccione una habitación --</option>
                            <%
                            if (habitacionesCombo != null) {
                                for (Habitaciones h : habitacionesCombo) {
                                    boolean sel = String.valueOf(h.getIdHabitacion()).equals(idHabitacionCargado);
                            %>
                                    <option value="<%= h.getIdHabitacion() %>" <%= sel ? "selected" : "" %>>
                                        Hab. <%= h.getNumeroHabitacion() %> (Piso <%= h.getPiso() %>)<%= h.getIdTipo() != null ? " - " + h.getIdTipo().getNombreTipo() : "" %>
                                    </option>
                            <%
                                }
                            }
                            if (habitacionesCombo == null || habitacionesCombo.isEmpty()) {
                            %>
                                <option value="" disabled>No hay habitaciones disponibles</option>
                            <% } %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="idEmpleado">Recepcionista</label>
                        <select id="idEmpleado" name="idEmpleado" required>
                            <option value="" disabled <%= idEmpleadoCargado.isEmpty() ? "selected" : "" %>>-- Seleccione un empleado --</option>
                            <%
                            if (empleados != null) {
                                for (Empleados e : empleados) {
                                    boolean sel = String.valueOf(e.getIdEmpleado()).equals(idEmpleadoCargado);
                            %>
                                    <option value="<%= e.getIdEmpleado() %>" <%= sel ? "selected" : "" %>>
                                        <%= e.getNombre() %> <%= e.getApellido() %> (<%= e.getRol() %>)
                                    </option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="fechaCheckIn">Fecha / Hora Check-In</label>
                        <input type="datetime-local" id="fechaCheckIn" name="fechaCheckIn" value="<%= checkInCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="fechaCheckOutEsperada">Fecha / Hora Check-Out Esperado</label>
                        <input type="datetime-local" id="fechaCheckOutEsperada" name="fechaCheckOutEsperada" value="<%= checkOutCargado %>" required>
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarReserva.jsp')" class="btn btn-primary">💾 Registrar Reserva</button>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarReserva.jsp')" class="btn btn-primary" style="background-color: #1e3a8a;">Confirmar Cambios</button>
                        <a href="indexReservas.jsp" class="btn btn-outline">Cancelar Edición</a>
                    <% } %>

                    <a href="indexPrin.jsp" class="btn btn-outline">← Volver al Menú Principal</a>
                </form>
            </div>

            <div class="card" style="overflow: hidden;">
                <div class="header">
                    <h1>📋 Reservas <span>Registradas</span></h1>
                    <p>Listado completo de reservas del hotel</p>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Huésped</th>
                                <th>Habitación</th>
                                <th>Empleado</th>
                                <th>Check-In</th>
                                <th>Check-Out Esperado</th>
                                <th>Check-Out Real</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                List<Reservas> lista = resControl.obtenerReservas();
                                if (lista != null && !lista.isEmpty()) {
                                    for (Reservas r : lista) {
                                        String estado = r.getEstadoReserva() != null ? r.getEstadoReserva() : "";
                                        String badgeClass = "badge-pendiente";
                                        if (estado.equalsIgnoreCase("Activa")) {
                                            badgeClass = "badge-activa";
                                        } else if (estado.equalsIgnoreCase("Finalizada")) {
                                            badgeClass = "badge-finalizada";
                                        } else if (estado.equalsIgnoreCase("Cancelada")) {
                                            badgeClass = "badge-cancelada";
                                        }
                            %>
                                        <tr>
                                            <td><strong><%= r.getIdReserva() %></strong></td>
                                            <td><%= r.getIdCliente() != null ? r.getIdCliente().getNombres() + " " + r.getIdCliente().getApellidos() : "-" %></td>
                                            <td><%= r.getIdHabitacion() != null ? r.getIdHabitacion().getNumeroHabitacion() : "-" %></td>
                                            <td><%= r.getIdEmpleado() != null ? r.getIdEmpleado().getNombre() : "-" %></td>
                                            <td><%= r.getFechaCheckIn() != null ? sdfTabla.format(r.getFechaCheckIn()) : "-" %></td>
                                            <td><%= r.getFechaCheckOutEsperada() != null ? sdfTabla.format(r.getFechaCheckOutEsperada()) : "-" %></td>
                                            <td><%= r.getFechaCheckOutReal() != null ? sdfTabla.format(r.getFechaCheckOutReal()) : "-" %></td>
                                            <td><span class="badge <%= badgeClass %>"><%= estado %></span></td>
                                            <td>
                                                <div class="actions-cell">
                                                    <a href="indexReservas.jsp?idReservaBuscar=<%= r.getIdReserva() %>" class="btn-mini btn-edit-table">Editar</a>
                                                    <% if (!estado.equalsIgnoreCase("Finalizada")) { %>
                                                    <a href="javascript:void(0)" onclick="hacerCheckOut(<%= r.getIdReserva() %>)" class="btn-mini btn-checkout-table">Check-out</a>
                                                    <% } %>
                                                    <a href="javascript:void(0)" onclick="eliminarReserva(<%= r.getIdReserva() %>)" class="btn-mini btn-delete-table">Eliminar</a>
                                                </div>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr><td colspan="9" style="text-align: center; color: #94a3b8;">No hay reservas registradas.</td></tr>
                            <%
                                }
                            } catch (Exception e) {
                            %>
                                <tr><td colspan="9" style="color: #dc2626;">Error al cargar datos: <%= e.getMessage() %></td></tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <form id="checkoutForm" method="post" action="JspCheckOutReserva.jsp" style="display:none;">
            <input type="hidden" id="idReservaCheckout" name="idreserva" value="">
        </form>
        <form id="eliminarForm" method="post" action="JspEliminarReserva.jsp" style="display:none;">
            <input type="hidden" id="idReservaEliminar" name="idreserva" value="">
        </form>

        <script>
            function enviarAccion(destino) {
                var form = document.getElementById('resForm');
                var cliente = document.getElementById('idCliente').value.trim();
                var habitacion = document.getElementById('idHabitacion').value.trim();
                var empleado = document.getElementById('idEmpleado').value.trim();
                var checkIn = document.getElementById('fechaCheckIn').value.trim();
                var checkOut = document.getElementById('fechaCheckOutEsperada').value.trim();

                if (!cliente || !habitacion || !empleado || !checkIn || !checkOut) {
                    alert('Todos los campos obligatorios deben completarse.');
                    return;
                }

                var idInput = document.getElementById('idreserva');
                if (destino === 'JspGrabarReserva.jsp' && !idInput.value.trim()) {
                    idInput.value = "0";
                }

                form.action = destino;
                form.submit();
            }

            function hacerCheckOut(id) {
                if (confirm('¿Confirmar el check-out de esta reserva? La habitación quedará disponible para limpieza.')) {
                    document.getElementById('idReservaCheckout').value = id;
                    document.getElementById('checkoutForm').submit();
                }
            }

            function eliminarReserva(id) {
                if (confirm('¿Seguro que deseas eliminar esta reserva? Esta acción no se puede deshacer.')) {
                    document.getElementById('idReservaEliminar').value = id;
                    document.getElementById('eliminarForm').submit();
                }
            }
        </script>
    </body>
</html>
