<%-- 
    Document   : indexClientes
    Created on : 13 jul. 2026, 9:34:16 a. m.
    Author     : dzs-1
--%>
<%@page import="controladores.ReservaControlador"%>
<%@page import="entidades.Reservas"%>
<%@page import="entidades.Habitaciones"%>
<%@page import="controladores.habitacionControlador"%>
<%@page import="entidades.TipoHabitacion"%>
<%@page import="controladores.TipoHabitacionControlador"%>
<%@page import="java.util.List"%>
<%@page import="entidades.Clientes"%>
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
        <title>Gestión de Clientes | Sistema Hotelero</title>
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
            .badge-hab { display: inline-block; padding: 4px 8px; border-radius: 6px; font-weight: 600; font-size: 12px; border: 1px solid; }
            .badge-cat { background-color: #fef3c7; color: #b45309; padding: 4px 8px; border-radius: 6px; font-weight: 600; font-size: 12px; border: 1px solid #fde68a; display: inline-block; }
        </style>
    </head>
    <body>
        <%
        String idCliCargado = "";
        String nombreCargado = "";
        String apellidoCargado = "";
        String docCargado = "";
        String telCargado = "";
        String correoCargado = "";
        String habitacionCargada = "";
        String idHabitacionAsignadaCargada = "";
        boolean modoEdicion = false;

        String idBuscar = request.getParameter("idClienteBuscar");
        if (idBuscar != null && !idBuscar.trim().isEmpty()) {
            try {
                controladores.clienteControlador cliControl = new controladores.clienteControlador();
                Clientes enc = cliControl.buscarPorId(Integer.parseInt(idBuscar.trim()));
                if (enc != null) {
                    idCliCargado = String.valueOf(enc.getIdcliente());
                    nombreCargado = enc.getNombres();
                    apellidoCargado = enc.getApellidos();
                    docCargado = enc.getDniRuc();
                    telCargado = enc.getTelefono() != null ? enc.getTelefono() : "";
                    correoCargado = enc.getEmail() != null ? enc.getEmail() : "";
                    modoEdicion = true;

                    controladores.ReservaControlador resControl = new controladores.ReservaControlador();
                    List<Reservas> listaRes = resControl.obtenerReservas();
                    if (listaRes != null) {
                        for (Reservas r : listaRes) {
                            if (r.getIdCliente() != null && r.getIdCliente().getIdcliente().equals(enc.getIdcliente())) {
                                if (r.getIdHabitacion() != null) {
                                    idHabitacionAsignadaCargada = String.valueOf(r.getIdHabitacion().getIdHabitacion());
                                    if (r.getIdHabitacion().getIdTipo() != null) {
                                        habitacionCargada = r.getIdHabitacion().getIdTipo().getNombreTipo();
                                    }
                                }
                                break;
                            }
                        }
                    }
                } else {
                    out.println("<script>alert('Huésped no encontrado.');</script>");
                }
            } catch (Exception e) {}
        }
        %>

        <div class="container">
            <div class="card">
                <div class="module-banner"><span>Atención personalizada a nuestros huéspedes</span></div>
                <div class="header">
                    <h1>👤 Módulo de <span>Clientes</span></h1>
                    <p>Registro y control de huéspedes</p>
                </div>

                <form id="clienteForm" method="post">
                    <div class="input-wrapper">
                        <label for="idcliente">ID Interno de Sistema</label>
                        <div class="input-group-search">
                            <input type="text" id="idcliente" name="idcliente" placeholder="ID autogenerado" value="<%= idCliCargado %>" readonly style="background-color: #e2e8f0;">
                            <% if (!modoEdicion) { %>
                                <input type="text" id="idBuscarAux" placeholder="ID a Buscar" style="width: 100px; padding: 5px;">
                                <button type="button" onclick="buscarHuesped()" class="btn-search">🔍</button>
                            <% } else { %>
                                <a href="indexClientes.jsp" class="btn btn-outline" style="padding: 0 10px; font-size: 12px; display: flex; align-items: center;">X</a>
                            <% } %>
                        </div>
                    </div>

                    <div class="input-wrapper">
                        <label for="nombre">Nombres</label>
                        <input type="text" id="nombre" name="nombre" placeholder="Nombres del huésped" value="<%= nombreCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="apellido">Apellidos</label>
                        <input type="text" id="apellido" name="apellido" placeholder="Apellidos del huésped" value="<%= apellidoCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="documento">Número de Documento (DNI / RUC)</label>
                        <input type="text" id="documento" name="dni" placeholder="Escriba el número de DNI o RUC" value="<%= docCargado %>" required>
                    </div>

                    <div class="input-wrapper">
                        <label for="telefono">Teléfono</label>
                        <input type="text" id="telefono" name="telefono" placeholder="Número celular" value="<%= telCargado %>">
                    </div>

                    <div class="input-wrapper">
                        <label for="correo">Correo Electrónico</label>
                        <input type="text" id="correo" name="correo" placeholder="correo@ejemplo.com" value="<%= correoCargado %>">
                    </div>

                    <div class="input-wrapper">
                        <label for="tipoHabitacion">Tipo de Habitación Deseada</label>
                        <select id="tipoHabitacion" name="tipoHabitacion" onchange="filtrarHabitaciones()" required>
                            <option value="" disabled <%= habitacionCargada.isEmpty() ? "selected" : "" %>>-- Seleccione una categoría --</option>
                            <%
                                try {
                                    TipoHabitacionControlador thControl = new TipoHabitacionControlador();
                                    List<TipoHabitacion> listaTipos = thControl.obtenerTipos();
                                    if(listaTipos != null) {
                                        for(TipoHabitacion tipo : listaTipos) {
                                            boolean isSelected = tipo.getNombreTipo().equals(habitacionCargada);
                                %>
                                            <option value="<%= tipo.getNombreTipo() %>" <%= isSelected ? "selected" : "" %>>
                                                <%= tipo.getNombreTipo() %> (S/. <%= String.format("%.2f", tipo.getPrecioPorNoche()) %>)
                                            </option>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    out.println("<option value=''>Error al cargar categorías</option>");
                                }
                            %>
                        </select>
                    </div>

                    <div class="input-wrapper">
                        <label for="idHabitacionAsignada">Habitación a Asignar</label>
                        <select id="idHabitacionAsignada" name="idHabitacionAsignada" required>
                            <option value="" disabled <%= idHabitacionAsignadaCargada.isEmpty() ? "selected" : "" %>>-- Seleccione una habitación --</option>
                            <%
                                try {
                                    habitacionControlador habControl = new habitacionControlador();
                                    List<Habitaciones> listaHab = habControl.obtenerHabitaciones();
                                    if(listaHab != null) {
                                        for(Habitaciones hab : listaHab) {
                                            String num = hab.getNumeroHabitacion() != null ? hab.getNumeroHabitacion() : String.valueOf(hab.getIdHabitacion());
                                            String estado = hab.getEstadoDisponibilidad();
                                            String tipoDeEstaHab = hab.getIdTipo() != null ? hab.getIdTipo().getNombreTipo() : "";
                                            boolean isHabSelected = String.valueOf(hab.getIdHabitacion()).equals(idHabitacionAsignadaCargada);
                            %>
                                            <option value="<%= hab.getIdHabitacion() %>" data-tipo="<%= tipoDeEstaHab %>" <%= isHabSelected ? "selected" : "" %>>
                                                Hab. <%= num %> [<%= estado %>]
                                            </option>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    out.println("<option value=''>Error al cargar habitaciones</option>");
                                }
                            %>
                        </select>
                    </div>

                    <% if (!modoEdicion) { %>
                        <button type="button" onclick="enviarAccion('JspGrabarCli.jsp')" class="btn btn-primary">💾 Guardar Huésped</button>
                        <div class="btn-grid-actions">
                            <button type="button" onclick="alert('Busque un cliente primero para habilitar los cambios')" class="btn btn-outline">🔄 Actualizar</button>
                            <button type="button" onclick="alert('Busque un cliente primero para habilitar la eliminación')" class="btn btn-danger">❌ Eliminar</button>
                        </div>
                    <% } else { %>
                        <button type="button" onclick="enviarAccion('JspActualizarCli.jsp')" class="btn btn-primary" style="background-color: #1e3a8a;">Confirmar Cambios</button>
                        <button type="button" onclick="enviarAccion('JspEliminarCli.jsp')" class="btn btn-danger" style="width: 100%; margin-bottom: 12px;">❌ Eliminar Permanentemente</button>
                    <% } %>

                    <a href="index.jsp" class="btn btn-outline" style="width: 100%;">← Volver al Menú Principal</a>
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
                                <th>Documento (DNI/RUC)</th>
                                <th>Huésped</th>
                                <th>Teléfono</th>
                                <th>Categoría</th> 
                                <th>N° Hab.</th> 
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            try {
                                controladores.clienteControlador control = new controladores.clienteControlador();
                                List<Clientes> lista = control.obtenerClientes();
                                
                                controladores.ReservaControlador resControlTab = new controladores.ReservaControlador();
                                List<Reservas> todasLasReservas = resControlTab.obtenerReservas();
                                
                                if(lista != null && !lista.isEmpty()){
                                    for(Clientes c : lista){
                                        
                                        String tipoHab = "Sin asignar";
                                        String numeroFisico = "Sin asignar";
                                        
                                        if (todasLasReservas != null) {
                                            for (Reservas r : todasLasReservas) {
                                                if (r.getIdCliente() != null && r.getIdCliente().getIdcliente().equals(c.getIdcliente())) {
                                                    if (r.getIdHabitacion() != null) {
                                                        numeroFisico = "Hab. " + (r.getIdHabitacion().getNumeroHabitacion() != null ? r.getIdHabitacion().getNumeroHabitacion() : r.getIdHabitacion().getIdHabitacion());
                                                        if (r.getIdHabitacion().getIdTipo() != null) {
                                                            tipoHab = r.getIdHabitacion().getIdTipo().getNombreTipo();
                                                        }
                                                    }
                                                    break;
                                                }
                                            }
                                        }
                            %>
                                        <tr>
                                            <td><strong><%= c.getDniRuc() %></strong></td>
                                            <td><%= c.getApellidos() %>, <%= c.getNombres() %></td>
                                            <td><%= c.getTelefono() != null && !c.getTelefono().isEmpty() ? c.getTelefono() : "-" %></td>
                                            
                                            <td>
                                                <% if(!tipoHab.equals("Sin asignar")){ %>
                                                    <span class="badge-cat"><%= tipoHab %></span>
                                                <% } else { %>
                                                    <span style="color: #94a3b8; font-size: 12px;">Sin asignar</span>
                                                <% } %>
                                            </td>

                                            <td>
                                                <% if(!numeroFisico.equals("Sin asignar")){ %>
                                                    <span class="badge-hab" style="background-color: #eff6ff; color: #1e40af; border-color: #bfdbfe;">
                                                        <%= numeroFisico %>
                                                    </span>
                                                <% } else { %>
                                                    <span style="color: #94a3b8; font-size: 12px;">Sin asignar</span>
                                                <% } %>
                                            </td>

                                            <td><a href="indexClientes.jsp?idClienteBuscar=<%= c.getIdcliente() %>" class="btn-edit-table">Seleccionar</a></td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr><td colspan="6" style="text-align: center; color: #94a3b8;">No hay clientes registrados en el hotel.</td></tr>
                            <%
                                }
                            } catch(Exception e) {
                            %>
                                <tr><td colspan="6" style="color: #dc2626;">Error de Base de Datos: <%= e.getMessage() %></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function filtrarHabitaciones() {
                var categoriaSeleccionada = document.getElementById('tipoHabitacion').value;
                var comboHabitaciones = document.getElementById('idHabitacionAsignada');
                var opciones = comboHabitaciones.options;

                comboHabitaciones.value = ""; 

                for (var i = 0; i < opciones.length; i++) {
                    var opt = opciones[i];
                    var tipoHab = opt.getAttribute('data-tipo');

                    if (opt.value === "") {
                        opt.style.display = "block";
                        opt.disabled = false;
                    } else if (tipoHab === categoriaSeleccionada) {
                        opt.style.display = "block";
                        opt.disabled = false;
                    } else {
                        opt.style.display = "none";
                        opt.disabled = true;
                    }
                }
            }

            window.addEventListener('DOMContentLoaded', function() {
                var tipoInicial = document.getElementById('tipoHabitacion').value;
                if (tipoInicial !== "") {
                    var comboHabitaciones = document.getElementById('idHabitacionAsignada');
                    var opciones = comboHabitaciones.options;
                    for (var i = 0; i < opciones.length; i++) {
                        var opt = opciones[i];
                        var tipoHab = opt.getAttribute('data-tipo');
                        if (opt.value === "" || tipoHab === tipoInicial) {
                            opt.style.display = "block";
                            opt.disabled = false;
                        } else {
                            opt.style.display = "none";
                            opt.disabled = true;
                        }
                    }
                }
            });

            function buscarHuesped() {
                var idInput = document.getElementById('idBuscarAux');
                var id = idInput ? idInput.value.trim() : "";
                if(!id) { alert('Digite un ID numérico válido para buscar.'); return; }
                window.location.href = 'indexClientes.jsp?idClienteBuscar=' + encodeURIComponent(id);
            }

            function enviarAccion(destino) {
                var form = document.getElementById('clienteForm');
                var nom = document.getElementById('nombre').value.trim();
                var hab = document.getElementById('idHabitacionAsignada').value;
                var doc = document.getElementById('documento').value.trim();

                if(destino !== 'JspEliminarCli.jsp' && !doc) { alert('El campo Número de Documento (DNI / RUC) es totalmente obligatorio.'); return; }
                if(destino !== 'JspEliminarCli.jsp' && !nom) { alert('El campo Nombre es obligatorio.'); return; }
                if(destino !== 'JspEliminarCli.jsp' && !hab) { alert('Debe seleccionar una habitación válida para el huésped.'); return; }
                if(destino === 'JspEliminarCli.jsp' && !confirm('¿Estás seguro de eliminar permanentemente a este huésped?')) return;

                form.action = destino;
                form.submit();
            }
        </script>
    </body>
</html>
