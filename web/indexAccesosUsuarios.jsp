<%-- 
    Document   : indexAccesosUsuarios
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="entidades.Usuarios"%>
<%@page import="entidades.Empleados"%>
<%@page import="controladores.UsuariosControlador"%>
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
        <title>Accesos de Usuarios | Sistema Hotelero</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
            body { background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%); color: #1e293b; min-height: 100vh; padding: 30px; display: flex; justify-content: center; align-items: center; }
            .container { display: grid; grid-template-columns: 420px 1fr; gap: 30px; width: 100%; max-width: 1500px; }
            .card { background-color: #ffffff; border-radius: 16px; padding: 30px; box-shadow: 0 10px 25px rgba(30, 41, 59, 0.05); border: 1px solid #e2e8f0; }
            .header { margin-bottom: 25px; border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; }
            .header h1 { font-size: 22px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
            .header h1 span { color: #1e40af; }
            .header p { font-size: 13px; color: #64748b; margin-top: 4px; }
            .module-banner {
                height: 130px;
                border-radius: 16px 16px 0 0;
                margin: -30px -30px 20px -30px;
                background-image: linear-gradient(180deg, rgba(15,23,42,0.1) 0%, rgba(15,23,42,0.8) 100%), url('images/fachada-hotel.webp');
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: flex-end;
                padding: 14px 20px;
            }
            .module-banner span { color: #fff; font-weight: 600; font-size: 12px; letter-spacing: 0.5px; text-transform: uppercase; }

            .input-wrapper { margin-bottom: 16px; }
            label { display: block; font-size: 12px; font-weight: 600; color: #475569; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
            input[type="text"], input[type="password"], select { width: 100%; padding: 11px 14px; font-size: 14px; color: #0f172a; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s ease; font-family: inherit; }
            input:focus, select:focus { border-color: #1e40af; background-color: #ffffff; box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.15); }
            .hint { font-size: 12px; color: #94a3b8; margin-top: 4px; }
            .checkbox-wrapper { display: flex; align-items: center; gap: 10px; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; padding: 11px 14px; margin-bottom: 16px; }
            .checkbox-wrapper input { width: auto; }
            .checkbox-wrapper label { margin-bottom: 0; text-transform: none; font-size: 14px; color: #0f172a; font-weight: 500; }
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
            .btn-toggle-table { padding: 4px 8px; font-size: 12px; border-radius: 4px; font-weight: 600; border: none; cursor: pointer; margin-right: 4px; }
            .btn-toggle-on { background-color: #fef2f2; color: #b91c1c; }
            .btn-toggle-on:hover { background-color: #fee2e2; }
            .btn-toggle-off { background-color: #ecfdf5; color: #047857; }
            .btn-toggle-off:hover { background-color: #d1fae5; }
            .badge { padding: 3px 8px; border-radius: 6px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
            .badge-activo { background-color: #dcfce7; color: #166534; }
            .badge-inactivo { background-color: #fee2e2; color: #991b1b; }
            .badge-rol { display: inline-block; padding: 4px 8px; border-radius: 6px; font-weight: 600; font-size: 12px; border: 1px solid #bfdbfe; background-color: #eff6ff; color: #1e40af; }
        </style>
    </head>
    <body>
        <%
        String idCargado = "";
        String idEmpCargado = "";
        String usernameCargado = "";
        String rolCargado = "";
        boolean activoCargado = true;
        boolean modoEdicion = false;

        String idBuscar = request.getParameter("idUsuarioBuscar");
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                UsuariosControlador usuControl = new UsuariosControlador();
                Usuarios u = usuControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (u != null) {
                    idCargado = String.valueOf(u.getIdUsuario());
                    idEmpCargado = u.getIdEmpleado() != null ? String.valueOf(u.getIdEmpleado().getIdEmpleado()) : "";
                    usernameCargado = u.getUsername() != null ? u.getUsername() : "";
                    rolCargado = u.getRolSistema() != null ? u.getRolSistema() : "";
                    activoCargado = u.getActivo();
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

        String[] roles = {"Administrador", "Recepcion", "Limpieza", "Mantenimiento", "Seguridad", "Gerencia"};
        %>

        <div class="container">
            <div class="card">
                <div class="module-banner"><span>Seguridad y accesos al sistema</span></div>
                <div class="header">
                    <h1>🔐 Accesos de <span>Usuarios</span></h1>
                    <p>Cuentas del sistema vinculadas al personal del hotel</p>
                </div>

                <form id="usuarioForm" method="post">
                    <div class="input-wrapper">
                        <label for="idusuario">ID Usuario</label>
                        <% if (modoEdicion) { %>
                            <input type="text" id="idusuario" name="idusuario" value="<%= idCargado %>" readonly style="background-color: #cbd5e1; color: #475569; font-weight: bold;">
                        <% } else { %>
                            <input type="text" id="idusuario" name="idusuario" placeholder="Autogenerado por el sistema" value="" readonly style="background-color: #e2e8f0; color: #64748b; font-style: italic; cursor: not-allowed;">
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
                        <label for="username">Usuario (Username)</label>
                        <input type="text" id="username" name="username" placeholder="Nombre de usuario único" maxlength="50" value="<%= usernameCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="password">Contraseña</label>
                        <input type="password" id="password" name="password" placeholder="<%= modoEdicion ? "Dejar en blanco para no cambiarla" : "Contraseña de acceso" %>" autocomplete="new-password">
                        <% if (modoEdicion) { %><p class="hint">Deja este campo vacío si no deseas cambiar la contraseña actual.</p><% } %>
                    </div>

                    <div class="input-wrapper">
                        <label for="rolSistema">Rol del Sistema</label>
                        <select id="rolSistema" name="rolSistema" required>
                            <option value="" disabled <%= rolCargado.isEmpty() ? "selected" : "" %>>-- Seleccione un rol --</option>
                            <%
                            for (String r : roles) {
                                boolean sel = r.equalsIgnoreCase(rolCargado);
                            %>
                                <option value="<%= r %>" <%= sel ? "selected" : "" %>><%= r %></option>
                            <%
                            }
                            %>
                        </select>
                    </div>

                    <div class="checkbox-wrapper">
                        <input type="checkbox" id="activo" name="activo" <%= activoCargado ? "checked" : "" %>>
                        <label for="activo">Acceso activo (puede iniciar sesión)</label>
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarUsuario.jsp')" class="btn btn-primary">💾 Crear Acceso</button>
                        <div class="btn-grid-actions">
                            <button type="button" onclick="alert('Seleccione un registro de la tabla para editar')" class="btn btn-outline">🔄 Actualizar</button>
                            <button type="button" onclick="enviarAccion('JspEliminarUsuario.jsp')" class="btn btn-danger">❌ Eliminar</button>
                        </div>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarUsuario.jsp')" class="btn btn-primary" style="background-color: #1e3a8a;">Confirmar Cambios</button>
                        <a href="indexAccesosUsuarios.jsp" class="btn btn-outline" style="width: 100%; margin-bottom: 12px;">Cancelar Edición</a>
                    <% } %>

                    <a href="indexPrin.jsp" class="btn btn-outline" style="width: 100%;">← Volver al Menú Principal</a>
                </form>
            </div>

            <div class="card" style="overflow: hidden;">
                <div class="header">
                    <h1>📋 Cuentas de <span>Acceso</span></h1>
                    <p>Listado completo de usuarios habilitados en el sistema</p>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Usuario</th>
                                <th>Empleado</th>
                                <th>Rol Sistema</th>
                                <th>Estado</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                UsuariosControlador usuControlLista = new UsuariosControlador();
                                List<Usuarios> lista = usuControlLista.obtenerUsuarios();
                                if (lista != null && !lista.isEmpty()) {
                                    for (Usuarios u : lista) {
                                        boolean estaActivo = u.getActivo();
                            %>
                                        <tr>
                                            <td><strong><%= u.getIdUsuario() %></strong></td>
                                            <td><%= u.getUsername() %></td>
                                            <td><%= u.getIdEmpleado() != null ? (u.getIdEmpleado().getNombre() + " " + u.getIdEmpleado().getApellido()) : "-" %></td>
                                            <td><span class="badge-rol"><%= u.getRolSistema() %></span></td>
                                            <td><span class="badge <%= estaActivo ? "badge-activo" : "badge-inactivo" %>"><%= estaActivo ? "Activo" : "Inactivo" %></span></td>
                                            <td>
                                                <a href="indexAccesosUsuarios.jsp?idUsuarioBuscar=<%= u.getIdUsuario() %>" class="btn-edit-table">Editar</a>
                                                <form action="JspCambiarEstadoUsuario.jsp" method="post" style="display:inline;">
                                                    <input type="hidden" name="idusuario" value="<%= u.getIdUsuario() %>">
                                                    <button type="submit" class="btn-toggle-table <%= estaActivo ? "btn-toggle-on" : "btn-toggle-off" %>" onclick="return confirm('¿<%= estaActivo ? "Desactivar" : "Activar" %> el acceso de este usuario?');">
                                                        <%= estaActivo ? "Desactivar" : "Activar" %>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr><td colspan="6" style="text-align: center; color: #94a3b8;">No hay usuarios registrados.</td></tr>
                            <%
                                }
                            } catch (Exception e) {
                            %>
                                <tr><td colspan="6" style="color: #dc2626;">Error al cargar datos: <%= e.getMessage() %></td></tr>
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
                var form = document.getElementById('usuarioForm');
                var inputId = document.getElementById('idusuario');
                var id = inputId.value.trim();
                var idEmp = document.getElementById('idEmpleado').value.trim();
                var username = document.getElementById('username').value.trim();
                var password = document.getElementById('password').value.trim();
                var rol = document.getElementById('rolSistema').value.trim();

                if (destino === 'JspActualizarUsuario.jsp' || destino === 'JspEliminarUsuario.jsp') {
                    if (!id) {
                        alert('Seleccione un registro de la tabla para realizar esta acción.');
                        return;
                    }
                }

                if (destino !== 'JspEliminarUsuario.jsp') {
                    if (!idEmp) { alert('Debe seleccionar un empleado.'); return; }
                    if (!username) { alert('El nombre de usuario es obligatorio.'); return; }
                    if (!rol) { alert('Debe seleccionar un rol del sistema.'); return; }
                    if (destino === 'JspGrabarUsuario.jsp' && !password) { alert('La contraseña es obligatoria para crear un nuevo acceso.'); return; }
                }

                if (destino === 'JspEliminarUsuario.jsp' && !confirm('¿Seguro que deseas eliminar permanentemente este acceso de usuario?')) {
                    return;
                }

                if (destino === 'JspGrabarUsuario.jsp' && !id) {
                    inputId.value = "0";
                }

                form.action = destino;
                form.submit();
            }
        </script>
    </body>
</html>
