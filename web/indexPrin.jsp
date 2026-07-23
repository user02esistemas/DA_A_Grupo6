<%-- 
    Document   : indexPrin
    Created on : 13 jul. 2026, 9:37:36 a. m.
    Author     : dzs-1
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Menú Principal | Sistema Hotelero Oasis</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
            body { 
                background-color: #f1f5f9; 
                color: #1e293b; 
                min-height: 100vh; 
                display: flex; 
            }

            /* PANEL LATERAL (SIDEBAR) */
            .sidebar { 
                width: 280px; 
                background-color: #0f172a; /* Azul marino / Oscuro empresarial */
                color: #ffffff; 
                display: flex; 
                flex-direction: column; 
                padding: 30px 20px;
                box-shadow: 4px 0 10px rgba(0,0,0,0.05);
            }
            .sidebar-brand { 
                font-size: 20px; 
                font-weight: 700; 
                margin-bottom: 40px; 
                padding-left: 10px;
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .sidebar-brand img { width: 42px; height: auto; }
            .sidebar-brand span { color: #3b82f6; }

            .welcome-banner {
                height: 170px;
                border-radius: 16px 16px 0 0;
                margin: -40px -40px 25px -40px;
                background-image: linear-gradient(180deg, rgba(15,23,42,0.15) 0%, rgba(15,23,42,0.85) 100%), url('images/fachada-hotel.webp');
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: flex-end;
                padding: 20px 25px;
            }
            .welcome-banner span { color: #fff; font-weight: 600; font-size: 14px; letter-spacing: 0.5px; }

            .discover-section { margin-top: 30px; max-width: 900px; }
            .discover-section h2 { font-size: 18px; color: #0f172a; margin-bottom: 14px; }
            .discover-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 18px; }
            .discover-card { position: relative; border-radius: 14px; overflow: hidden; height: 150px; box-shadow: 0 4px 14px rgba(0,0,0,0.06); }
            .discover-card img { width: 100%; height: 100%; object-fit: cover; display: block; transition: transform 0.3s ease; }
            .discover-card:hover img { transform: scale(1.08); }
            .discover-card .discover-label { position: absolute; bottom: 0; left: 0; right: 0; padding: 10px 14px; background: linear-gradient(0deg, rgba(15,23,42,0.85), transparent); color: #fff; font-size: 13px; font-weight: 600; }

            .menu-section { margin-bottom: 25px; }
            .menu-title { 
                font-size: 11px; 
                text-transform: uppercase; 
                color: #64748b; 
                letter-spacing: 1px; 
                font-weight: 700; 
                margin-bottom: 10px;
                padding-left: 10px;
            }

            .menu-item { 
                display: flex; 
                align-items: center; 
                gap: 12px; 
                padding: 12px 15px; 
                color: #cbd5e1; 
                text-decoration: none; 
                font-size: 14px; 
                font-weight: 500; 
                border-radius: 8px; 
                transition: all 0.2s ease; 
                margin-bottom: 5px;
            }
            .menu-item:hover { 
                background-color: #1e293b; 
                color: #ffffff; 
            }
            .menu-item.active { 
                background-color: #1e40af; 
                color: #ffffff; 
                font-weight: 600; 
            }

            /* CONTENIDO PRINCIPAL */
            .main-content { 
                flex: 1; 
                padding: 40px; 
                display: flex;
                flex-direction: column;
            }
            .welcome-card { 
                background-color: #ffffff; 
                padding: 40px; 
                border-radius: 16px; 
                box-shadow: 0 4px 20px rgba(0,0,0,0.02);
                border: 1px solid #e2e8f0;
                max-width: 900px;
            }
            .welcome-card h1 { font-size: 28px; color: #0f172a; margin-bottom: 10px; }
            .welcome-card h1 span { color: #1e40af; }
            .welcome-card p { color: #64748b; font-size: 15px; line-height: 1.6; }

            .stats-grid { 
                display: grid; 
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
                gap: 20px; 
                margin-top: 30px; 
                max-width: 900px;
            }
            .stat-box { 
                background: white; 
                padding: 20px; 
                border-radius: 12px; 
                border: 1px solid #e2e8f0; 
            }
            .stat-box h3 { font-size: 13px; color: #64748b; text-transform: uppercase; margin-bottom: 5px; }
            .stat-box p { font-size: 22px; font-weight: 700; color: #0f172a; }
            </style>
    </head>
    <body>
        <div class="sidebar">
        <div class="sidebar-brand">
            <img src="images/logo.png" alt="Logo Hotel Oasis">
            Hotel <span>Oasis</span>
        </div>
        
        <div class="menu-section">
            <div class="menu-title">Módulos de Caja</div>
            <a href="indexClientes.jsp" class="menu-item">
                <span>👤</span> Gestión de Clientes
            </a>
            <a href="indexHabitaciones.jsp" class="menu-item">
                <span>🛌</span> Control de Habitaciones
            </a>
            <a href="indexClientes.jsp" class="menu-item">
                <span>📅</span> Reservas / Recepción
            </a>
            <a href="indexEmpleado.jsp" class="menu-item">
                <span>🧑‍💼</span> Gestión de Empleados
            </a>
            <a href="indexHistorialLimpieza.jsp" class="menu-item">
                <span>🧹</span> Historial de Limpieza
            </a>
            <a href="indexAsistenciaPersonal.jsp" class="menu-item">
                <span>🕒</span> Asistencia de Personal
            </a>
            <a href="indexAccesosClientes.jsp" class="menu-item">
                <span>🚪</span> Accesos de Clientes
            </a>
        </div>

        <div class="menu-section">
            <div class="menu-title">Seguridad del Sistema</div>
            <a href="indexAccesosUsuarios.jsp" class="menu-item">
                <span>🔐</span> Accesos de Usuarios
            </a>
        </div>

        <div class="menu-section">
            <div class="menu-title">Reportes y Consultas</div>
            <a href="indexTipoHabitacion.jsp" class="menu-item">
                <span>🔍</span> Mantenimiento tipo habitacion
            </a>
            <a href="consultaClientes.jsp" class="menu-item">
                <span>📊</span> Reporte de Huéspedes
            </a>
        </div>
        </div>

        <div class="main-content">
            <div class="welcome-card">
                <div class="welcome-banner"><span>🏨 Hotel Oasis — Chiclayo, Lambayeque</span></div>
                <h1>Bienvenido al Sistema, <span>Administrador</span></h1>
                <p>Desde este panel corporativo puedes controlar el estado en tiempo real del hotel. Utiliza el menú de la izquierda para registrar nuevos huéspedes o consultar la base de datos mediante persistencias y JPA de manera segura.</p>

                <div class="stats-grid">
                    <div class="stat-box">
                        <h3>Estado del Servidor</h3>
                        <p style="color: #10b981;">Online (Tomcat)</p>
                    </div>
                    <div class="stat-box">
                        <h3>Base de Datos</h3>
                        <p style="color: #3b82f6;">SQL Server</p>
                    </div>
                    <div class="stat-box">
                        <h3>Persistencia</h3>
                        <p>JPA / EclipseLink</p>
                    </div>
                </div>
            </div>

            <div class="discover-section">
                <h2>🌴 Descubre Chiclayo</h2>
                <div class="discover-grid">
                    <div class="discover-card">
                        <img src="images/plaza-armas.jpg" alt="Plaza de Armas de Chiclayo">
                        <div class="discover-label">Plaza de Armas</div>
                    </div>
                    <div class="discover-card">
                        <img src="images/museo-sipan.jpg" alt="Museo Tumbas Reales de Sipán">
                        <div class="discover-label">Museo Tumbas Reales de Sipán</div>
                    </div>
                    <div class="discover-card">
                        <img src="images/muelle-pimentel.jpg" alt="Muelle de Pimentel">
                        <div class="discover-label">Muelle de Pimentel</div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
