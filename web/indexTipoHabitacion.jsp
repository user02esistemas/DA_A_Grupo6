<%-- 
    Document   : indexTipoHabitacion
    Created on : 13 jul. 2026, 9:39:25 a. m.
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="entidades.TipoHabitacion"%>
<%@page import="controladores.TipoHabitacionControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Categorías de Habitaciones | Sistema Hotelero</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
            body { background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%); color: #1e293b; min-height: 100vh; padding: 30px; display: flex; justify-content: center; align-items: center; }
            .container { display: grid; grid-template-columns: 400px 1fr; gap: 30px; width: 100%; max-width: 1300px; }
            .card { background-color: #ffffff; border-radius: 16px; padding: 30px; box-shadow: 0 10px 25px rgba(30, 41, 59, 0.05); border: 1px solid #e2e8f0; }
            .header { margin-bottom: 25px; border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; }
            .header h1 { font-size: 22px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
            .header h1 span { color: #0284c7; }
            .header p { font-size: 13px; color: #64748b; margin-top: 4px; }
            .module-banner {
                height: 130px;
                border-radius: 16px 16px 0 0;
                margin: -30px -30px 20px -30px;
                background-image: linear-gradient(180deg, rgba(15,23,42,0.1) 0%, rgba(15,23,42,0.8) 100%), url('images/hab-suite.webp');
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: flex-end;
                padding: 14px 20px;
            }
            .module-banner span { color: #fff; font-weight: 600; font-size: 12px; letter-spacing: 0.5px; text-transform: uppercase; }

            .input-wrapper { margin-bottom: 16px; }
            label { display: block; font-size: 12px; font-weight: 600; color: #475569; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
            input[type="text"], input[type="number"] { width: 100%; padding: 11px 14px; font-size: 14px; color: #0f172a; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s ease; }
            input[type="text"]:focus, input[type="number"]:focus { border-color: #0284c7; background-color: #ffffff; box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15); }
            .btn { display: inline-flex; justify-content: center; align-items: center; padding: 12px; font-size: 14px; font-weight: 600; border: none; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; text-decoration: none; text-align: center; }
            .btn-primary { background-color: #0284c7; color: #ffffff; width: 100%; margin-bottom: 12px; }
            .btn-primary:hover { background-color: #0369a1; }
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
            .btn-edit-table { padding: 4px 8px; font-size: 12px; background-color: #f0fdf4; color: #166534; border-radius: 4px; text-decoration: none; font-weight: 600; }
            .btn-edit-table:hover { background-color: #dcfce7; }
        </style>
    </head>
    <body>
        <%
        String idTipoCargado = "";
        String nombreTipoCargado = "";
        String precioCargado = "";
        String capacidadCargada = "";
        boolean modoEdicion = false;

        String idBuscar = request.getParameter("idTipoBuscar");
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                TipoHabitacionControlador tipoControl = new TipoHabitacionControlador();
                TipoHabitacion th = tipoControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (th != null) {
                    idTipoCargado = String.valueOf(th.getIdTipo());
                    nombreTipoCargado = th.getNombreTipo() != null ? th.getNombreTipo() : "";
                    precioCargado = String.valueOf(th.getPrecioPorNoche());
                    capacidadCargada = String.valueOf(th.getCapacidadPersonas());
                    modoEdicion = true;
                }
            } catch (Exception e) {
                System.err.println("Error al cargar para edición: " + e.getMessage());
            }
        }
        %>

        <div class="container">
            <div class="card">
                <div class="module-banner"><span>Categorías y tarifas de habitación</span></div>
                <div class="header">
                    <h1>🛏️ Tipos de <span>Habitación</span></h1>
                    <p>Configuración de categorías y tarifas</p>
                </div>

                <form id="tipoForm" method="post">
                    <div class="input-wrapper">
                        <label for="idtipo">ID Categoría</label>
                        <% if (modoEdicion) { %>
                            <input type="text" id="idtipo" name="idtipo" value="<%= idTipoCargado %>" readonly style="background-color: #cbd5e1; color: #475569; font-weight: bold;">
                        <% } else { %>
                            <input type="text" id="idtipo" name="idtipo" placeholder="Autogenerado por el sistema" value="" readonly style="background-color: #e2e8f0; color: #64748b; font-style: italic; cursor: not-allowed;">
                        <% } %>
                    </div>

                    <div class="input-wrapper">
                        <label for="nombreTipo">Nombre de la Categoría</label>
                        <input type="text" id="nombreTipo" name="nombreTipo" placeholder="Ej. Suite, Simple, Doble" value="<%= nombreTipoCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="precioPorNoche">Precio por Noche (S/.)</label>
                        <input type="text" id="precioPorNoche" name="precioPorNoche" placeholder="Ej. 60.00" value="<%= precioCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="capacidadPersonas">Capacidad (Personas)</label>
                        <input type="number" id="capacidadPersonas" name="capacidadPersonas" placeholder="Ej. 2" value="<%= capacidadCargada %>" required min="1">
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarTipo.jsp')" class="btn btn-primary">💾 Guardar Categoría</button>
                        <div class="btn-grid-actions">
                            <button type="button" onclick="alert('Seleccione un registro de la tabla para editar')" class="btn btn-outline">🔄 Actualizar</button>
                            <button type="button" onclick="enviarAccion('JspEliminarTipo.jsp')" class="btn btn-danger">❌ Eliminar</button>
                        </div>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarTipo.jsp')" class="btn btn-primary" style="background-color: #0369a1;">Confirmar Cambios</button>
                        <a href="indexTipoHabitacion.jsp" class="btn btn-outline" style="width: 100%; margin-bottom: 12px;">Cancelar Edición</a>
                    <% } %>

                    <a href="index.jsp" class="btn btn-outline" style="width: 100%;">← Volver al Menú Principal</a>
                </form>
            </div>

            <div class="card" style="overflow: hidden;">
                <div class="header">
                    <h1>📋 Categorías Registradas</h1>
                    <p>Tipos de habitación configurados en el sistema</p>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 15%">ID Tipo</th>
                                <th style="width: 35%">Nombre</th>
                                <th style="width: 20%">Precio</th>
                                <th style="width: 15%">Capacidad</th>
                                <th style="width: 15%">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                TipoHabitacionControlador tipoControlLista = new TipoHabitacionControlador();
                                List<TipoHabitacion> lista = tipoControlLista.obtenerTipos();
                                if(lista != null && !lista.isEmpty()){
                                    for(TipoHabitacion t : lista){
                                    %>
                                        <tr>
                                            <td><strong><%= t.getIdTipo() %></strong></td>
                                            <td><%= t.getNombreTipo() %></td>
                                            <td>S/. <%= String.format("%.2f", t.getPrecioPorNoche()) %></td>
                                            <td>👥 <%= t.getCapacidadPersonas() %></td>
                                            <td><a href="indexTipoHabitacion.jsp?idTipoBuscar=<%= t.getIdTipo() %>" class="btn-edit-table">Editar</a></td>
                                        </tr>
                                    <%
                                    }
                                } else {
                                %>
                                    <tr><td colspan="5" style="text-align: center; color: #94a3b8;">No hay categorías registradas.</td></tr>
                                <%
                                }
                            } catch(Exception e) {
                            %>
                                <tr><td colspan="5" style="color: #dc2626;">Error al cargar datos: <%= e.getMessage() %></td></tr>
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
                var form = document.getElementById('tipoForm');
                var inputId = document.getElementById('idtipo');
                var id = inputId.value.trim();
                var nom = document.getElementById('nombreTipo').value.trim();
                var pre = document.getElementById('precioPorNoche').value.trim();
                var cap = document.getElementById('capacidadPersonas').value.trim();

                // Validación para Actualizar y Eliminar (Requieren ID sí o sí)
                if (destino === 'JspActualizarTipo.jsp' || destino === 'JspEliminarTipo.jsp') {
                    if (!id) {
                        alert('Seleccione un registro de la tabla para realizar esta acción.');
                        return;
                    }
                }

                // Validación de campos vacíos para Grabar y Actualizar
                if (destino !== 'JspEliminarTipo.jsp') {
                    if (!nom || !pre || !cap) { 
                        alert('Todos los campos son obligatorios.'); 
                        return; 
                    }
                }

                // Confirmación para eliminar
                if (destino === 'JspEliminarTipo.jsp' && !confirm('¿Seguro que deseas eliminar este tipo?')) {
                    return;
                }

                // TRUCO MAESTRO: Si vamos a grabar uno nuevo, y el ID está vacío porque el usuario no puede escribir,
                // le mandamos un "0" para que tu Java (Integer.parseInt) no se caiga. 
                // La BD ignorará el 0 y creará su propio ID autoincrementable.
                if (destino === 'JspGrabarTipo.jsp' && !id) {
                    inputId.value = "0";
                }

                form.action = destino;
                form.submit();
            }
        </script>
    </body>
</html>
