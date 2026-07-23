# Hotel Oasis — Sistema de Login y Accesos por Rol

Este documento resume TODO lo que se agregó al proyecto para que funcione con
inicio de sesión y permisos restringidos según el rol de cada usuario.
El proyecto sigue corriendo en **Apache NetBeans**, sobre **Tomcat**, tal
como estaba (JSP + Servlets + JPA/EclipseLink + SQL Server).

## 1. Pasos para dejarlo funcionando

1. Abre el proyecto en NetBeans (`Archivo > Abrir Proyecto`) igual que antes.
2. Ejecuta primero el script original **`bdOasis.txt`** en SQL Server (si
   todavía no lo hiciste), para crear la base `BdHotelOasis2` y sus tablas.
3. Ejecuta el nuevo script **`src/conf/bdOasis_actualizacion.sql`**. Este
   script:
   - Crea la tabla `Incidencias` (para el módulo de Seguridad).
   - Inserta 5 empleados y 5 usuarios de ejemplo, uno por cada rol del
     sistema, para que puedas probar el login de inmediato.
4. Verifica que `src/conf/persistence.xml` tenga tus credenciales reales de
   SQL Server (usuario, contraseña, instancia). Ya quedó registrada ahí la
   nueva entidad `Incidencias`.
5. Ejecuta el proyecto (clic derecho > Ejecutar) como siempre. NetBeans
   desplegará todo en Tomcat y abrirá `index.jsp`, que ahora es la
   **pantalla de inicio de sesión**.

## 2. Usuarios de prueba (creados por el script de actualización)

| Usuario         | Contraseña | Rol            |
|------------------|-----------|----------------|
| gerente          | 12345     | Gerente        |
| administrador    | 12345     | Administrador  |
| recepcion        | 12345     | Recepcionista  |
| limpieza         | 12345     | Limpieza       |
| seguridad        | 12345     | Seguridad      |

> ⚠️ Las contraseñas están en texto plano solo para que puedas probar el
> sistema rápido. Antes de usarlo en producción, cambia el criterio de
> `LoginServlet` para comparar contraseñas encriptadas (por ejemplo con
> `BCrypt`) en vez de texto plano.

Para crear más usuarios reales, usa el módulo **Accesos de Usuarios**
(`indexAccesosUsuarios.jsp`) que ya existía en el proyecto: solo asegúrate
de escribir el rol (`rolSistema`) exactamente como uno de estos 5 textos:
`GERENTE`, `ADMINISTRADOR`, `RECEPCIONISTA`, `LIMPIEZA`, `SEGURIDAD`
(en mayúsculas, sin tildes).

## 3. Cómo funciona el login

- **`index.jsp`** ahora es el formulario de usuario/contraseña.
- **`LoginServlet`** valida las credenciales contra la tabla `Usuarios`
  (unida con `Empleados`) y, si son correctas y el usuario está `activo`,
  crea la sesión con: `idUsuario`, `username`, `rolSistema`, `idEmpleado`
  y `nombreCompleto`.
- **`LogoutServlet`** cierra la sesión y regresa al login.
- **`SesionFiltro`** es un `Filter` (`@WebFilter("/*")`) que se ejecuta en
  **cada** petición del sistema: si no hay sesión, redirige al login; si
  hay sesión, revisa si el rol del usuario tiene permiso sobre la página
  solicitada. Esta es la pieza central de la restricción de accesos —
  funciona a nivel de servidor, así que no depende de que el usuario no
  intente escribir la URL directamente en el navegador.

## 4. Qué puede ver cada rol

| Rol            | Módulos habilitados |
|-----------------|---------------------|
| **Gerente**        | Todo el sistema (todos los módulos, en modo consulta y reportes) |
| **Administrador**  | Clientes, Empleados, Habitaciones, Tipo de Habitación, Reservas, Usuarios del sistema, Reporte de Ingreso Mensual |
| **Recepcionista**  | Clientes, Habitaciones, Reservas (check-in / check-out), Reporte del Día |
| **Limpieza**       | Su Asistencia de Personal, Historial e Historial/Estado de Limpieza de Habitaciones |
| **Seguridad**      | Incidencias de Seguridad, su Asistencia de Personal, Accesos de Clientes (control de entradas/salidas de huéspedes) |

Este mapeo está definido en un solo lugar del código:
`src/java/controladores/SesionFiltro.java`, en el mapa `MODULOS_POR_ROL`.
Si más adelante quieres cambiar qué puede ver cada rol, solo edita esa
clase (no hay que tocar cada página una por una).

El menú principal (`indexPrin.jsp`) también oculta automáticamente las
opciones que el usuario conectado no puede usar, para que la experiencia
sea más limpia (aunque la seguridad real la garantiza el filtro, no el
menú).

## 5. Módulos nuevos que se agregaron

- **Incidencias de Seguridad** (`indexIncidencias.jsp` +
  `JspGrabarIncidencia.jsp` / `JspActualizarIncidencia.jsp` /
  `JspEliminarIncidencia.jsp`): permite al personal de Seguridad registrar
  incidentes (tipo, gravedad, lugar, descripción, estado).
- **Reporte del Día** (`reporteDelDia.jsp`): check-ins de hoy, check-outs
  de hoy y ocupación de habitaciones en tiempo real. Pensado para
  Recepción.
- **Reporte de Ingreso Mensual** (`reporteIngresoMensual.jsp`): calcula el
  ingreso total del hotel para el mes/año que elijas, en base a las
  noches de cada reserva y el precio del tipo de habitación. Pensado para
  Administración y Gerencia.
- **`accesoDenegado.jsp`**: página que se muestra si un usuario intenta
  entrar a un módulo que su rol no tiene permitido.

## 6. Archivos nuevos / modificados (resumen técnico)

**Nuevos:**
- `src/java/controladores/LoginServlet.java`
- `src/java/controladores/LogoutServlet.java`
- `src/java/controladores/SesionFiltro.java`
- `src/java/entidades/Incidencias.java`
- `src/java/controladores/IncidenciasControlador.java`
- `web/indexIncidencias.jsp`, `web/JspGrabarIncidencia.jsp`,
  `web/JspActualizarIncidencia.jsp`, `web/JspEliminarIncidencia.jsp`
- `web/reporteDelDia.jsp`
- `web/reporteIngresoMensual.jsp`
- `web/accesoDenegado.jsp`
- `src/conf/bdOasis_actualizacion.sql`

**Modificados:**
- `web/index.jsp` (ahora es el login, antes era una página de bienvenida
  sin seguridad)
- `web/indexPrin.jsp` (menú dinámico según el rol + nombre de usuario +
  botón de cerrar sesión)
- `src/conf/persistence.xml` (se agregó la entidad `Incidencias`)
