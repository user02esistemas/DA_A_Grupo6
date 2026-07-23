<%-- 
    Document   : indexEmpleado
    Created on : 13 jul. 2026
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="entidades.Empleados"%>
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
        <title>Gestión de Empleados | Sistema Hotelero</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
            body {
                background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
                color: #1e293b;
                min-height: 100vh;
                padding: 30px;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .container {
                display: grid;
                grid-template-columns: 420px 1fr;
                gap: 30px;
                width: 100%;
                max-width: 1300px;
            }
            .card {
                background-color: #ffffff;
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0 10px 25px rgba(30, 41, 59, 0.05);
                border: 1px solid #e2e8f0;
            }
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
            .input-group-search { display: flex; gap: 8px; }
            label { display: block; font-size: 12px; font-weight: 600; color: #475569; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
            input[type="text"], select { width: 100%; padding: 11px 14px; font-size: 14px; color: #0f172a; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s ease; }
            input[type="text"]:focus, select:focus { border-color: #1e40af; background-color: #ffffff; box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.15); }

            .btn { display: inline-flex; justify-content: center; align-items: center; padding: 12px; font-size: 14px; font-weight: 600; border: none; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; text-decoration: none; text-align: center; }
            .btn-primary { background-color: #1e40af; color: #ffffff; width: 100%; margin-bottom: 12px; }
            .btn-primary:hover { background-color: #1e3a8a; }
            .btn-search { background-color: #f1f5f9; color: #1e40af; border: 1px solid #cbd5e1; padding: 0 16px; font-weight: 600; border-radius: 8px; cursor: pointer; }
            .btn-search:hover { background-color: #e2e8f0; }
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
            .badge-rol { display: inline-block; padding: 4px 8px; border-radius: 6px; font-weight: 600; font-size: 12px; border: 1px solid #fde68a; background-color: #fef3c7; color: #b45309; }
        </style>
    </head>
    <body>
        <%
        String idEmpCargado = "";
        String nombreCargado = "";
        String apellidoCargado = "";
        String rolCargado = "";
        String dniCargado = "";
        String telCargado = "";
        boolean modoEdicion = false;

        String idBuscar = request.getParameter("idEmpleadoBuscar");
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                empleadoControlador empControl = new empleadoControlador();
                Empleados enc = empControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (enc != null) {
                    idEmpCargado = String.valueOf(enc.getIdEmpleado());
                    nombreCargado = enc.getNombre();
                    apellidoCargado = enc.getApellido();
                    rolCargado = enc.getRol();
                    dniCargado = enc.getDni();
                    telCargado = enc.getTelefono() != null ? enc.getTelefono() : "";
                    modoEdicion = true;
                } else {
                    out.println("<script>alert('Empleado no encontrado.');</script>");
                }
            } catch (Exception e) {}
        }
        %>

        <div class="container">
            <div class="card">
                <div class="module-banner"><span>Nuestro equipo de trabajo</span></div>
                <div class="header">
                    <h1>🧑‍💼 Módulo de <span>Empleados</span></h1>
                    <p>Registro y control del personal del hotel</p>
                </div>

                <form id="empleadoForm" method="post">
                    <div class="input-wrapper">
                        <label for="idEmpleado">ID Interno de Sistema</label>
                        <div class="input-group-search">
                            <input type="text" id="idEmpleado" name="idEmpleado" placeholder="ID autogenerado" value="<%= idEmpCargado %>" readonly style="background-color: #e2e8f0;">
                            <% if (!modoEdicion) { %>
                                <input type="text" id="idBuscarAux" placeholder="ID a Buscar" style="width: 100px; padding: 5px;">
                                <button type="button" onclick="buscarEmpleado()" class="btn-search">🔍</button>
                            <% } else { %>
                                <a href="indexEmpleado.jsp" class="btn btn-outline" style="padding: 0 10px; font-size: 12px; display: flex; align-items: center;">X</a>
                            <% } %>
                        </div>
                    </div>

                    <div class="input-wrapper">
                        <label for="nombre">Nombres</label>
                        <input type="text" id="nombre" name="nombre" placeholder="Nombres del empleado" value="<%= nombreCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="apellido">Apellidos</label>
                        <input type="text" id="apellido" name="apellido" placeholder="Apellidos del empleado" value="<%= apellidoCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="rol">Rol / Cargo</label>
                        <select id="rol" name="rol" required>
                            <option value="" disabled <%= rolCargado.isEmpty() ? "selected" : "" %>>-- Seleccione un rol --</option>
                            <%
                                String[] roles = {"Administrador", "Recepcion", "Limpieza", "Mantenimiento", "Seguridad", "Gerencia"};
                                for (String r : roles) {
                                    boolean sel = r.equalsIgnoreCase(rolCargado);
                            %>
                                    <option value="<%= r %>" <%= sel ? "selected" : "" %>><%= r %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="dni">DNI</label>
                        <input type="text" id="dni" name="dni" placeholder="Número de documento" value="<%= dniCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="telefono">Teléfono</label>
                        <input type="text" id="telefono" name="telefono" placeholder="Número celular" value="<%= telCargado %>">
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarEmpleado.jsp')" class="btn btn-primary">💾 Guardar Empleado</button>
                        <div class="btn-grid-actions">
                            <button type="button" onclick="alert('Busque un empleado primero para habilitar los cambios')" class="btn btn-outline">🔄 Actualizar</button>
                            <button type="button" onclick="alert('Busque un empleado primero para habilitar la eliminación')" class="btn btn-danger">❌ Eliminar</button>
                        </div>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarEmpleado.jsp')" class="btn btn-primary" style="background-color: #1e3a8a;">Confirmar Cambios</button>
                        <button type="button" onclick="enviarAccion('JspEliminarEmpleado.jsp')" class="btn btn-danger" style="width: 100%; margin-bottom: 12px;">❌ Eliminar Permanentemente</button>
                    <% } %>

                    <a href="indexPrin.jsp" class="btn btn-outline" style="width: 100%;">← Volver al Menú Principal</a>
                </form>
            </div>

            <div class="card" style="overflow: hidden;">
                <div class="header">
                    <h1>📋 Registros Actuales en la Base de Datos</h1>
                    <p>Tabla dinámica conectada mediante JPA</p>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>DNI</th>
                                <th>Empleado</th>
                                <th>Rol</th>
                                <th>Teléfono</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                empleadoControlador control = new empleadoControlador();
                                List<Empleados> lista = control.obtenerEmpleados();

                                if(lista != null && !lista.isEmpty()){
                                    for(Empleados e : lista){
                            %>
                                        <tr>
                                            <td><strong><%= e.getDni() %></strong></td>
                                            <td><%= e.getApellido() %>, <%= e.getNombre() %></td>
                                            <td><span class="badge-rol"><%= e.getRol() %></span></td>
                                            <td><%= e.getTelefono() != null && !e.getTelefono().isEmpty() ? e.getTelefono() : "-" %></td>
                                            <td><a href="indexEmpleado.jsp?idEmpleadoBuscar=<%= e.getIdEmpleado() %>" class="btn-edit-table">Seleccionar</a></td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr><td colspan="5" style="text-align: center; color: #94a3b8;">No hay empleados registrados en el hotel.</td></tr>
                            <%
                                }
                            } catch(Exception e) {
                            %>
                                <tr><td colspan="5" style="color: #dc2626;">Error de Base de Datos: <%= e.getMessage() %></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function buscarEmpleado() {
                var idInput = document.getElementById('idBuscarAux');
                var id = idInput ? idInput.value.trim() : "";
                if(!id) { alert('Digite un ID numérico válido para buscar.'); return; }
                window.location.href = 'indexEmpleado.jsp?idEmpleadoBuscar=' + encodeURIComponent(id);
            }

            function enviarAccion(destino) {
                var form = document.getElementById('empleadoForm');
                var nom = document.getElementById('nombre').value.trim();
                var ape = document.getElementById('apellido').value.trim();
                var dni = document.getElementById('dni').value.trim();
                var rol = document.getElementById('rol').value;

                if(destino !== 'JspEliminarEmpleado.jsp' && !nom) { alert('El campo Nombres es obligatorio.'); return; }
                if(destino !== 'JspEliminarEmpleado.jsp' && !ape) { alert('El campo Apellidos es obligatorio.'); return; }
                if(destino !== 'JspEliminarEmpleado.jsp' && !dni) { alert('El campo DNI es obligatorio.'); return; }
                if(destino !== 'JspEliminarEmpleado.jsp' && !rol) { alert('Debe seleccionar un rol.'); return; }
                if(destino === 'JspEliminarEmpleado.jsp' && !confirm('¿Estás seguro de eliminar permanentemente a este empleado?')) return;

                form.action = destino;
                form.submit();
            }
        </script>
    </body>
</html>
