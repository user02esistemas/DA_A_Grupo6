<%-- 
    Document   : index
    Created on : 13 jul. 2026, 9:29:33 a. m.
    Author     : dzs-1
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head lang="es">
         <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hotel Oasis | Bienvenido</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            :root {
                --hotel-navy: #0f172a;
                --hotel-gold: #d4af37;
                --hotel-light: #f8fafc;
            }
            body {
                font-family: 'Poppins', sans-serif;
                background-color: var(--hotel-light);
                min-height: 100vh;
                display: flex;
                align-items: stretch;
                justify-content: center;
                margin: 0;
            }
            .split-wrapper {
                display: flex;
                width: 100%;
                min-height: 100vh;
            }
            .split-image {
                flex: 1.1;
                position: relative;
                background-image: linear-gradient(180deg, rgba(15,23,42,0.15) 0%, rgba(15,23,42,0.75) 100%), url('images/fachada-hotel.webp');
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: flex-end;
                padding: 50px;
            }
            .split-image-text { color: #fff; }
            .split-image-text h3 { font-size: 1.6rem; font-weight: 700; margin-bottom: 8px; }
            .split-image-text p { font-size: 0.9rem; opacity: 0.85; max-width: 380px; }
            @media (max-width: 900px) { .split-image { display: none; } }
            .split-form {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .welcome-card {
                background: #ffffff;
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                padding: 40px 30px;
                max-width: 450px;
                width: 100%;
                text-align: center;
            }
            .hotel-logo {
                width: 90px;
                height: auto;
                margin-bottom: 10px;
            }
            .hotel-icon {
                font-size: 3.5rem;
                color: var(--hotel-navy);
                margin-bottom: 15px;
            }
            .btn-hotel-primary {
                background-color: var(--hotel-navy);
                color: white;
                border-radius: 12px;
                padding: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
            }
            .btn-hotel-primary:hover {
                background-color: #1e293b;
                color: #fff;
                transform: translateY(-2px);
            }
            .btn-hotel-secondary {
                background-color: transparent;
                color: var(--hotel-navy);
                border: 2px solid var(--hotel-navy);
                border-radius: 12px;
                padding: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
            }
            .btn-hotel-secondary:hover {
                background-color: var(--hotel-navy);
                color: white;
                transform: translateY(-2px);
            }
            .footer-text {
                font-size: 0.8rem;
                color: #94a3b8;
                margin-top: 30px;
            }
        </style>
    </head>
    <body>
        <div class="split-wrapper">
            <div class="split-image">
                <div class="split-image-text">
                    <h3>Bienvenido a Hotel Oasis</h3>
                    <p>Comodidad, confianza y buena atención en el corazón de Chiclayo. Gestiona tu hospedaje de forma simple y profesional.</p>
                </div>
            </div>
            <div class="split-form">
    <div class="welcome-card">
        <img src="images/logo.png" alt="Logo Hotel Oasis" class="hotel-logo">
        
        <h2 class="fw-bold mb-1" style="color: var(--hotel-navy);">Hotel Oasis</h2>
        <p class="text-muted small mb-4">Sistema de Gestión y Administración Interna</p>
        
        <hr class="my-4 text-muted opacity-25">
        
        <div class="d-grid gap-3">
            <a href="indexPrin.jsp" class="btn btn-hotel-primary d-flex align-items-center justify-content-center gap-2">
                <i class="bi bi-speedometer2 fs-5"></i>
                Ir al Menú Principal
            </a>
            
            <a href="indexClientes.jsp" class="btn btn-hotel-secondary d-flex align-items-center justify-content-center gap-2">
                <i class="bi bi-people-fill fs-5"></i>
                Gestión de Clientes
            </a>
             <a href="indexTipoHabitacion.jsp" class="btn btn-hotel-secondary d-flex align-items-center justify-content-center gap-2">
                <i class="bi bi-people-fill fs-5"></i>
                Gestión de Tipo Habitacion
            </a>
             <a href="indexHabitaciones.jsp" class="btn btn-hotel-secondary d-flex align-items-center justify-content-center gap-2">
                <i class="bi bi-people-fill fs-5"></i>
                Gestión Habitacion
            </a>
             <a href="indexEmpleado.jsp" class="btn btn-hotel-secondary d-flex align-items-center justify-content-center gap-2">
                <i class="bi bi-person-badge-fill fs-5"></i>
                Gestión de Empleados
            </a>
         </div>
        
         <p class="footer-text mb-0">© 2026 Sistema Hotelero Corporativo</p>
         </div>
            </div>
        </div>
         <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
