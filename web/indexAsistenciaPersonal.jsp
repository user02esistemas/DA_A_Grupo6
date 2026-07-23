<%-- 
    Document   : indexAsistenciaPersonal
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="entidades.AsistenciaPersonal"%>
<%@page import="entidades.Empleados"%>
<%@page import="controladores.AsistenciaPersonalControlador"%>
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
        <title>Asistencia de Personal | Sistema Hotelero</title>
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
                background-image: linear-gradient(180deg, rgba(15,23,42,0.1) 0%, rgba(15,23,42,0.8) 100%), url('images/recepcion.jpg');
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
            .badge-presente { background-color: #fef9c3; color: #854d0e; }
            .badge-completo { background-color: #dcfce7; color: #166534; }
        </style>
    </head>
    <body>
        <%
        String idCargado = "";
        String idEmpCargado = "";
        String observacionesCargado = "";
        boolean modoEdicion = false;

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        String idBuscar = request.getParameter("idAsistenciaBuscar");
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                AsistenciaPersonalControlador asistControl = new AsistenciaPersonalControlador();
                AsistenciaPersonal a = asistControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (a != null) {
                    idCargado = String.valueOf(a.getIdAsistencia());
                    idEmpCargado = a.getIdEmpleado() != null ? String.valueOf(a.getIdEmpleado().getIdEmpleado()) : "";
                    observacionesCargado = a.getObservaciones() != null ? a.getObservaciones() : "";
                    modoEdicion = true;
                }
            } catch (Exception e) {
                System.err.println("Error al cargar para edición: " + e.getMessage());
            }
        }

        List<Empleados> empleados = null;
        try {
            empleados = new empleadoControlador().obtenerEmpleados();
        } catch (Exception e) {
            System.err.println("Error al cargar empleados: " + e.getMessage());
        }
        %>

        <div class="container">
            <div class="card">
                <div class="module-banner"><span>Control de asistencia del personal</span></div>
                <div class="header">
                    <h1>🕒 Asistencia de <span>Personal</span></h1>
                    <p>Control de horas de entrada y salida de empleados</p>
                </div>

                <form id="asistForm" method="post">
                    <div class="input-wrapper">
                        <label for="idasistencia">ID Registro</label>
                        <% if (modoEdicion) { %>
                            <input type="text" id="idasistencia" name="idasistencia" value="<%= idCargado %>" readonly style="background-color: #cbd5e1; color: #475569; font-weight: bold;">
                        <% } else { %>
                            <input type="text" id="idasistencia" name="idasistencia" placeholder="Autogenerado por el sistema" value="" readonly style="background-color: #e2e8f0; color: #64748b; font-style: italic; cursor: not-allowed;">
                        <% } %>
                    </div>

                    <div class="input-wrapper">
                        <label for="idEmpleado">Empleado</label>
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
                        <label for="observaciones">Observaciones</label>
                        <textarea id="observaciones" name="observaciones" placeholder="Notas adicionales (opcional)" maxlength="255"><%= observacionesCargado %></textarea>
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarAsistencia.jsp')" class="btn btn-primary">💾 Marcar Entrada</button>
                        <div class="btn-grid-actions">
                            <button type="button" onclick="alert('Seleccione un registro de la tabla para editar')" class="btn btn-outline">🔄 Actualizar</button>
                            <button type="button" onclick="enviarAccion('JspEliminarAsistencia.jsp')" class="btn btn-danger">❌ Eliminar</button>
                        </div>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarAsistencia.jsp')" class="btn btn-primary" style="background-color: #1e3a8a;">Confirmar Cambios</button>
                        <a href="indexAsistenciaPersonal.jsp" class="btn btn-outline" style="width: 100%; margin-bottom: 12px;">Cancelar Edición</a>
                    <% } %>

                    <a href="indexPrin.jsp" class="btn btn-outline" style="width: 100%;">← Volver al Menú Principal</a>
                </form>
            </div>

            <div class="card" style="overflow: hidden;">
                <div class="header">
                    <h1>📋 Registros de <span>Asistencia</span></h1>
                    <p>Listado completo de entradas y salidas del personal</p>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Empleado</th>
                                <th>Fecha</th>
                                <th>Entrada</th>
                                <th>Salida</th>
                                <th>Estado</th>
                                <th>Observaciones</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                AsistenciaPersonalControlador asistControlLista = new AsistenciaPersonalControlador();
                                List<AsistenciaPersonal> lista = asistControlLista.obtenerAsistencias();
                                if (lista != null && !lista.isEmpty()) {
                                    for (AsistenciaPersonal a : lista) {
                                        boolean tieneSalida = a.getHoraSalida() != null;
                            %>
                                        <tr>
                                            <td><strong><%= a.getIdAsistencia() %></strong></td>
                                            <td><%= a.getIdEmpleado() != null ? (a.getIdEmpleado().getNombre() + " " + a.getIdEmpleado().getApellido()) : "-" %></td>
                                            <td><%= a.getFecha() != null ? new SimpleDateFormat("dd/MM/yyyy").format(a.getFecha()) : "-" %></td>
                                            <td><%= a.getHoraEntrada() != null ? sdf.format(a.getHoraEntrada()) : "-" %></td>
                                            <td><%= tieneSalida ? sdf.format(a.getHoraSalida()) : "-" %></td>
                                            <td><span class="badge <%= tieneSalida ? "badge-completo" : "badge-presente" %>"><%= tieneSalida ? "Completo" : "Presente" %></span></td>
                                            <td><%= a.getObservaciones() != null ? a.getObservaciones() : "-" %></td>
                                            <td>
                                                <a href="indexAsistenciaPersonal.jsp?idAsistenciaBuscar=<%= a.getIdAsistencia() %>" class="btn-edit-table">Editar</a>
                                                <% if (!tieneSalida) { %>
                                                <form action="JspMarcarSalida.jsp" method="post" style="display:inline;">
                                                    <input type="hidden" name="idasistencia" value="<%= a.getIdAsistencia() %>">
                                                    <button type="submit" class="btn-finalizar-table" onclick="return confirm('¿Marcar la salida de este empleado?');">Marcar Salida</button>
                                                </form>
                                                <% } %>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr><td colspan="8" style="text-align: center; color: #94a3b8;">No hay registros de asistencia.</td></tr>
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
                var form = document.getElementById('asistForm');
                var inputId = document.getElementById('idasistencia');
                var id = inputId.value.trim();
                var idEmp = document.getElementById('idEmpleado').value.trim();

                if (destino === 'JspActualizarAsistencia.jsp' || destino === 'JspEliminarAsistencia.jsp') {
                    if (!id) {
                        alert('Seleccione un registro de la tabla para realizar esta acción.');
                        return;
                    }
                }

                if (destino !== 'JspEliminarAsistencia.jsp') {
                    if (!idEmp) {
                        alert('Debe seleccionar un empleado.');
                        return;
                    }
                }

                if (destino === 'JspEliminarAsistencia.jsp' && !confirm('¿Seguro que deseas eliminar este registro de asistencia?')) {
                    return;
                }

                if (destino === 'JspGrabarAsistencia.jsp' && !id) {
                    inputId.value = "0";
                }

                form.action = destino;
                form.submit();
            }
        </script>
    </body>
</html>
