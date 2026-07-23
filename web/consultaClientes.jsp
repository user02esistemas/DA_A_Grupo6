<%-- 
    Document   : consultaClientes
    Created on : 13 jul. 2026, 9:28:06 a.m.
    Author     : dzs-1
--%>
<%@page import="java.util.List"%>
<%@page import="entidades.Reservas"%>
<%@page import="entidades.Clientes"%>
<%@page import="controladores.ReservaControlador"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
         <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reporte de Clientes | Hotel Oasis</title>
        <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; padding: 40px; display: flex; justify-content: center; }
        .container { width: 100%; max-width: 1100px; background: #ffffff; padding: 30px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
        .header { margin-bottom: 25px; border-bottom: 2px solid #f1f5f9; padding-bottom: 15px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { font-size: 24px; color: #0f172a; }
        .header h1 span { color: #1e40af; }
        .module-banner {
            height: 130px;
            border-radius: 16px 16px 0 0;
            margin: -30px -30px 20px -30px;
            background-image: linear-gradient(180deg, rgba(15,23,42,0.1) 0%, rgba(15,23,42,0.8) 100%), url('images/plaza-armas.jpg');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: flex-end;
            padding: 14px 20px;
        }
        .module-banner span { color: #fff; font-weight: 600; font-size: 12px; letter-spacing: 0.5px; text-transform: uppercase; }
        .search-box { margin-bottom: 20px; display: flex; gap: 10px; }
        input[type="text"] { flex: 1; padding: 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; }
        input[type="text"]:focus { border-color: #1e40af; box-shadow: 0 0 0 3px rgba(30,64,175,0.15); }
        .btn { padding: 12px 20px; font-size: 14px; font-weight: 600; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; text-align: center; }
        .btn-primary { background-color: #1e40af; color: white; }
        .btn-primary:hover { background-color: #1e3a8a; }
        .btn-outline { background-color: #f8fafc; color: #475569; border: 1px solid #cbd5e1; }
        .btn-outline:hover { background-color: #f1f5f9; }
        .table-responsive { width: 100%; overflow-x: auto; border: 1px solid #e2e8f0; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; }
        th { background-color: #f8fafc; color: #475569; font-weight: 600; padding: 14px; border-bottom: 2px solid #e2e8f0; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; }
        td { padding: 14px; border-bottom: 1px solid #f1f5f9; }
        tr:hover td { background-color: #f8fafc; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 6px; font-size: 12px; font-weight: 600; background: #eff6ff; color: #1e40af; }
        </style>
    </head>
    <body>
        <div class="container">
        <div class="module-banner"><span>Reporte general de huéspedes registrados</span></div>
        <div class="header">
            <h1>📊 Reporte General de <span>Huéspedes</span></h1>
            <a href="indexPrin.jsp" class="btn btn-outline">← Volver al Menú</a>
        </div>

        <form method="get" action="consultaClientes.jsp" class="search-box">
            <% 
                String txtBuscar = request.getParameter("txtBuscar");
                if(txtBuscar == null) txtBuscar = "";
            %>
            <input type="text" name="txtBuscar" placeholder="Filtrar por apellido, nombre, DNI o ID..." value="<%= txtBuscar %>">
            <button type="submit" class="btn btn-primary">🔍 Filtrar</button>
            <% if(!txtBuscar.isEmpty()) { %>
                <a href="consultaClientes.jsp" class="btn btn-outline">Limpiar Filtro</a>
            <% } %>
        </form>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>DNI / RUC</th>
                        <th>Apellidos y Nombres</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                        <th>Habitación</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        controladores.clienteControlador control = new controladores.clienteControlador();
                        List<Clientes> lista = control.obtenerClientes();
                        ReservaControlador resControl = new ReservaControlador();
                        List<Reservas> reservas = resControl.obtenerReservas();

                        int registrosContados = 0;
                        if (lista != null && !lista.isEmpty()) {
                            for (Clientes c : lista) {
                                if (!txtBuscar.trim().isEmpty()) {
                                    String filtro = txtBuscar.toLowerCase();
                                    boolean cumpleFiltro = String.valueOf(c.getIdcliente()).contains(filtro)
                                            || (c.getNombres() != null && c.getNombres().toLowerCase().contains(filtro))
                                            || (c.getApellidos() != null && c.getApellidos().toLowerCase().contains(filtro))
                                            || (c.getDniRuc() != null && c.getDniRuc().toLowerCase().contains(filtro));
                                    if (!cumpleFiltro) continue;
                                }

                                String habitacion = "Sin asignar";
                                if (reservas != null) {
                                    for (Reservas r : reservas) {
                                        if (r.getIdCliente() != null && r.getIdCliente().getIdcliente().equals(c.getIdcliente())) {
                                            if (r.getIdHabitacion() != null) {
                                                habitacion = "Hab. " + r.getIdHabitacion().getNumeroHabitacion();
                                            }
                                            break;
                                        }
                                    }
                                }

                                registrosContados++;
                    %>
                                <tr>
                                    <td><strong><%= c.getIdcliente() %></strong></td>
                                    <td><%= c.getDniRuc() %></td>
                                    <td><%= (c.getApellidos() != null ? c.getApellidos() : "") %>, <%= (c.getNombres() != null ? c.getNombres() : "") %></td>
                                    <td><%= (c.getTelefono() != null && !c.getTelefono().isEmpty()) ? c.getTelefono() : "-" %></td>
                                    <td><%= (c.getEmail() != null && !c.getEmail().isEmpty()) ? c.getEmail() : "-" %></td>
                                    <td><span class="badge"><%= habitacion %></span></td>
                                </tr>
                    <%
                            }
                        }

                        if (registrosContados == 0) {
                    %>
                            <tr><td colspan="6" style="text-align: center; color: #94a3b8; padding: 25px;">No se encontraron huéspedes registrados con ese criterio.</td></tr>
                    <%
                        }
                    } catch (Exception e) {
                    %>
                        <tr><td colspan="6" style="color: #dc2626; text-align: center; font-weight: bold; padding: 25px;">Error al ejecutar el reporte: <%= e.getMessage() %></td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    </body>
</html>
