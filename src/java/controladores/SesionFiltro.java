/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Filtro único que se ejecuta ANTES de cualquier página o servlet del
 * sistema. Se encarga de dos cosas:
 *
 * 1) Exigir que exista una sesión iniciada (login) para acceder a
 *    cualquier página que no sea pública.
 * 2) Restringir cada "módulo" del sistema según el rol del usuario
 *    conectado (rolSistema), de acuerdo al mapa MODULOS_POR_ROL.
 *
 * Roles del sistema (columna rolSistema de dbo.Usuarios):
 *   GERENTE        -> accede a TODO el sistema (solo consulta/reportes)
 *   ADMINISTRADOR  -> gestiona clientes, empleados, habitaciones, tipos de
 *                     habitación, reservas, usuarios y el reporte de
 *                     ingreso mensual
 *   RECEPCIONISTA  -> gestiona clientes, habitaciones, reservas y el
 *                     reporte del día
 *   LIMPIEZA       -> registra su asistencia y el estado de limpieza de
 *                     las habitaciones
 *   SEGURIDAD      -> registra incidencias, su asistencia y el control
 *                     de accesos de huéspedes
 *
 * @author dzs-1
 */
@WebFilter("/*")
public class SesionFiltro implements Filter {

    // ==============================================================
    // 1. PÁGINAS PÚBLICAS: no requieren sesión iniciada
    // ==============================================================
    private static final Set<String> PUBLICAS = new HashSet<>(Arrays.asList(
            "/index.jsp", "/", "/LoginServlet", "/menuHotel.jsp"
    ));

    // Prefijos que nunca se bloquean (recursos estáticos)
    private static final String[] PREFIJOS_LIBRES = {
        "/images/", "/css/", "/js/", "/webjars/", "/META-INF/"
    };

    // ==============================================================
    // 2. PÁGINAS DE USO COMÚN: cualquier usuario CON sesión puede verlas
    // ==============================================================
    private static final Set<String> COMUNES = new HashSet<>(Arrays.asList(
            "/indexPrin.jsp", "/LogoutServlet",
            // Utilidad de consulta RENIEC: la usan tanto el formulario de
            // Clientes como el de Empleados, así que cualquier usuario con
            // sesión iniciada puede llamarla (solo consulta nombres/apellidos
            // por DNI, no expone datos sensibles del sistema).
            "/JspProxyDni.jsp"
    ));

    // ==============================================================
    // 3. MÓDULOS: cada página de acción se agrupa en un módulo lógico
    // ==============================================================
    private static final Map<String, String> PAGINA_A_MODULO = new HashMap<>();
    static {
        // --- Clientes ---
        for (String p : new String[]{"/indexClientes.jsp", "/JspGrabarCli.jsp",
            "/JspActualizarCli.jsp", "/JspEliminarCli.jsp",
            "/consultaClientes.jsp"}) {
            PAGINA_A_MODULO.put(p, "CLIENTES");
        }
        // --- Habitaciones ---
        for (String p : new String[]{"/indexHabitaciones.jsp", "/JspGrabarHabitacion.jsp",
            "/JspActualizarHabitacion.jsp", "/JspEliminarHabitacion.jsp",
            "/ObtenerHabitacionesServlet"}) {
            PAGINA_A_MODULO.put(p, "HABITACIONES");
        }
        // --- Tipo de Habitación ---
        for (String p : new String[]{"/indexTipoHabitacion.jsp", "/JspGrabarTipo.jsp",
            "/JspActualizarTipo.jsp", "/JspEliminarTipo.jsp"}) {
            PAGINA_A_MODULO.put(p, "TIPOHABITACION");
        }
        // --- Empleados ---
        for (String p : new String[]{"/indexEmpleado.jsp", "/JspGrabarEmpleado.jsp",
            "/JspActualizarEmpleado.jsp", "/JspEliminarEmpleado.jsp"}) {
            PAGINA_A_MODULO.put(p, "EMPLEADOS");
        }
        // --- Reservas ---
        for (String p : new String[]{"/indexReservas.jsp", "/JspGrabarReserva.jsp",
            "/JspActualizarReserva.jsp", "/JspEliminarReserva.jsp", "/JspCheckOutReserva.jsp"}) {
            PAGINA_A_MODULO.put(p, "RESERVAS");
        }
        // --- Limpieza de habitaciones ---
        for (String p : new String[]{"/indexHistorialLimpieza.jsp", "/JspGrabarLimpieza.jsp",
            "/JspActualizarLimpieza.jsp", "/JspEliminarLimpieza.jsp", "/JspFinalizarLimpieza.jsp"}) {
            PAGINA_A_MODULO.put(p, "LIMPIEZA");
        }
        // --- Asistencia del personal ---
        for (String p : new String[]{"/indexAsistenciaPersonal.jsp", "/JspGrabarAsistencia.jsp",
            "/JspActualizarAsistencia.jsp", "/JspEliminarAsistencia.jsp", "/JspMarcarSalida.jsp"}) {
            PAGINA_A_MODULO.put(p, "ASISTENCIA");
        }
        // --- Accesos de clientes (control de huéspedes) ---
        for (String p : new String[]{"/indexAccesosClientes.jsp", "/JspGrabarAcceso.jsp",
            "/JspActualizarAcceso.jsp", "/JspEliminarAcceso.jsp", "/JspMarcarSalidaCliente.jsp"}) {
            PAGINA_A_MODULO.put(p, "ACCESOSCLIENTES");
        }
        // --- Usuarios del sistema (seguridad de accesos) ---
        for (String p : new String[]{"/indexAccesosUsuarios.jsp", "/JspGrabarUsuario.jsp",
            "/JspActualizarUsuario.jsp", "/JspEliminarUsuario.jsp", "/JspCambiarEstadoUsuario.jsp"}) {
            PAGINA_A_MODULO.put(p, "USUARIOS");
        }
        // --- Incidencias (seguridad física del hotel) ---
        for (String p : new String[]{"/indexIncidencias.jsp", "/JspGrabarIncidencia.jsp",
            "/JspActualizarIncidencia.jsp", "/JspEliminarIncidencia.jsp"}) {
            PAGINA_A_MODULO.put(p, "INCIDENCIAS");
        }
        // --- Reportes ---
        PAGINA_A_MODULO.put("/reporteIngresoMensual.jsp", "REPORTE_INGRESOS");
        PAGINA_A_MODULO.put("/reporteDelDia.jsp", "REPORTE_DIA");
    }

    // ==============================================================
    // 4. QUÉ MÓDULOS PUEDE VER CADA ROL
    // ==============================================================
    private static final Map<String, Set<String>> MODULOS_POR_ROL = new HashMap<>();
    static {
        // GERENTE: ve absolutamente todos los módulos del sistema
        MODULOS_POR_ROL.put("GERENTE", new HashSet<>(Arrays.asList(
                "CLIENTES", "HABITACIONES", "TIPOHABITACION", "EMPLEADOS", "RESERVAS",
                "LIMPIEZA", "ASISTENCIA", "ACCESOSCLIENTES", "USUARIOS", "INCIDENCIAS",
                "REPORTE_INGRESOS", "REPORTE_DIA"
        )));
        // ADMINISTRADOR: todo lo referente a registro/mantenimiento + ingreso mensual
        MODULOS_POR_ROL.put("ADMINISTRADOR", new HashSet<>(Arrays.asList(
                "CLIENTES", "HABITACIONES", "TIPOHABITACION", "EMPLEADOS", "RESERVAS",
                "USUARIOS", "REPORTE_INGRESOS"
        )));
        // RECEPCIONISTA: registro de clientes, habitaciones y reporte del día
        MODULOS_POR_ROL.put("RECEPCIONISTA", new HashSet<>(Arrays.asList(
                "CLIENTES", "HABITACIONES", "RESERVAS", "REPORTE_DIA"
        )));
        // LIMPIEZA: su asistencia y el estado de limpieza de habitaciones
        MODULOS_POR_ROL.put("LIMPIEZA", new HashSet<>(Arrays.asList(
                "LIMPIEZA", "ASISTENCIA"
        )));
        // SEGURIDAD: incidencias, su asistencia y accesos de huéspedes
        MODULOS_POR_ROL.put("SEGURIDAD", new HashSet<>(Arrays.asList(
                "INCIDENCIAS", "ASISTENCIA", "ACCESOSCLIENTES"
        )));
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // sin inicialización especial
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI().substring(contextPath.length());
        if (uri.isEmpty()) {
            uri = "/";
        }

        // Recursos estáticos: siempre libres
        for (String prefijo : PREFIJOS_LIBRES) {
            if (uri.startsWith(prefijo)) {
                chain.doFilter(req, res);
                return;
            }
        }

        // Páginas públicas (login): siempre libres
        if (PUBLICAS.contains(uri)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        String rol = (session != null) ? (String) session.getAttribute("rolSistema") : null;

        // Sin sesión iniciada -> redirige al login
        if (session == null || rol == null) {
            redirigirOResponder(uri, response, "index.jsp?expirada=1");
            return;
        }

        // Páginas comunes a cualquier usuario ya autenticado
        if (COMUNES.contains(uri)) {
            chain.doFilter(req, res);
            return;
        }

        String modulo = PAGINA_A_MODULO.get(uri);

        // Página no mapeada a ningún módulo conocido: se deja pasar
        // (por ejemplo, futuras páginas que aún no se hayan clasificado)
        if (modulo == null) {
            chain.doFilter(req, res);
            return;
        }

        Set<String> permitidos = MODULOS_POR_ROL.getOrDefault(rol, java.util.Collections.emptySet());
        if (permitidos.contains(modulo)) {
            chain.doFilter(req, res);
        } else {
            redirigirOResponder(uri, response, "accesoDenegado.jsp");
        }
    }

    // Para llamadas de tipo servicio/AJAX (terminan en "Servlet") responde 403
    // en vez de redirigir, para no romper el parseo de JSON en el navegador.
    private void redirigirOResponder(String uri, HttpServletResponse response, String destino) throws IOException {
        if (uri.endsWith("Servlet")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso no autorizado.");
        } else {
            response.sendRedirect(destino);
        }
    }

    @Override
    public void destroy() {
        // sin liberación especial
    }
}
