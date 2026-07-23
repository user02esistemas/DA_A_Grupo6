/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package conexion;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Cliente centralizado para consultar el DNI de un cliente o empleado contra
 * una API pública tipo RENIEC (por ejemplo api.apis.net.pe, apiperu.dev,
 * decolecta.com, etc.).
 *
 * El token y la URL del proveedor NO se dejan escritos en el código: se leen
 * desde web/WEB-INF/reniec.properties para que cada instalación del hotel
 * pueda configurar su propia cuenta/token sin tener que recompilar el
 * proyecto.
 *
 * Se evita agregar una librería externa de JSON (Gson/Jackson) para no
 * depender de nuevos .jar dentro del proyecto NetBeans/Ant; el JSON de
 * respuesta de estas APIs es siempre "plano" (sin objetos anidados), así que
 * se extrae con una expresión regular simple y confiable.
 *
 * @author dzs-1
 */
public class ReniecClient {

    private static final String RUTA_CONFIG = "/WEB-INF/reniec.properties";

    /**
     * Resultado de la consulta a RENIEC.
     */
    public static class ResultadoDni {

        private boolean encontrado;
        private String mensaje;
        private String dni;
        private String nombres;
        private String apellidoPaterno;
        private String apellidoMaterno;

        public boolean isEncontrado() {
            return encontrado;
        }

        public void setEncontrado(boolean encontrado) {
            this.encontrado = encontrado;
        }

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public String getDni() {
            return dni;
        }

        public void setDni(String dni) {
            this.dni = dni;
        }

        public String getNombres() {
            return nombres;
        }

        public void setNombres(String nombres) {
            this.nombres = nombres;
        }

        public String getApellidoPaterno() {
            return apellidoPaterno;
        }

        public void setApellidoPaterno(String apellidoPaterno) {
            this.apellidoPaterno = apellidoPaterno;
        }

        public String getApellidoMaterno() {
            return apellidoMaterno;
        }

        public void setApellidoMaterno(String apellidoMaterno) {
            this.apellidoMaterno = apellidoMaterno;
        }

        public String getApellidosCompletos() {
            StringBuilder sb = new StringBuilder();
            if (apellidoPaterno != null && !apellidoPaterno.trim().isEmpty()) {
                sb.append(apellidoPaterno.trim());
            }
            if (apellidoMaterno != null && !apellidoMaterno.trim().isEmpty()) {
                if (sb.length() > 0) {
                    sb.append(" ");
                }
                sb.append(apellidoMaterno.trim());
            }
            return sb.toString();
        }

        /**
         * Convierte el resultado a un JSON plano para responder al
         * fetch()/AJAX del navegador.
         */
        public String toJson() {
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\":").append(encontrado).append(",");
            json.append("\"dni\":\"").append(escaparJson(dni)).append("\",");
            json.append("\"nombres\":\"").append(escaparJson(nombres)).append("\",");
            json.append("\"apellidoPaterno\":\"").append(escaparJson(apellidoPaterno)).append("\",");
            json.append("\"apellidoMaterno\":\"").append(escaparJson(apellidoMaterno)).append("\",");
            json.append("\"apellidos\":\"").append(escaparJson(getApellidosCompletos())).append("\",");
            json.append("\"mensaje\":\"").append(escaparJson(mensaje)).append("\"");
            json.append("}");
            return json.toString();
        }
    }

    private ReniecClient() {
    }

    /**
     * Consulta un DNI de 8 dígitos contra el proveedor configurado en
     * reniec.properties y devuelve nombres/apellidos, o un mensaje de error
     * amigable si no se pudo resolver.
     *
     * @param dni DNI de 8 dígitos numéricos
     * @param rutaReal ruta física real de la aplicación web (se obtiene con
     * request.getServletContext().getRealPath("/") desde el JSP/Servlet que
     * llama a este método)
     */
    public static ResultadoDni consultarDni(String dni, String rutaReal) {
        ResultadoDni resultado = new ResultadoDni();
        resultado.setDni(dni);

        if (dni == null || !dni.matches("\\d{8}")) {
            resultado.setEncontrado(false);
            resultado.setMensaje("El DNI debe tener exactamente 8 dígitos numéricos.");
            return resultado;
        }

        Properties config = cargarConfiguracion(rutaReal);
        String urlBase = config.getProperty("reniec.api.url", "https://api.apis.net.pe/v2/reniec/dni").trim();
        String token = config.getProperty("reniec.api.token", "").trim();
        String parametroDni = config.getProperty("reniec.api.parametro", "numero").trim();

        if (token.isEmpty() || token.startsWith("PEGAR_")) {
            resultado.setEncontrado(false);
            resultado.setMensaje("La consulta a RENIEC no está configurada todavía. "
                    + "Complete 'reniec.api.token' en web/WEB-INF/reniec.properties con su token del proveedor.");
            return resultado;
        }

        HttpURLConnection con = null;
        try {
            String separador = urlBase.contains("?") ? "&" : "?";
            URL url = new URL(urlBase + separador + parametroDni + "=" + dni);
            con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Authorization", "Bearer " + token);
            con.setRequestProperty("Accept", "application/json");
            con.setConnectTimeout(6000);
            con.setReadTimeout(6000);

            int status = con.getResponseCode();
            InputStream is = (status >= 200 && status < 300) ? con.getInputStream() : con.getErrorStream();
            String cuerpo = leerCuerpo(is);

            if (status >= 200 && status < 300) {
                String nombres = extraerCampo(cuerpo, "nombres");
                String apPaterno = extraerCampo(cuerpo, "apellidoPaterno");
                String apMaterno = extraerCampo(cuerpo, "apellidoMaterno");

                if ((nombres == null || nombres.isEmpty()) && (apPaterno == null || apPaterno.isEmpty())) {
                    resultado.setEncontrado(false);
                    resultado.setMensaje("No se encontraron datos para el DNI ingresado.");
                    return resultado;
                }

                resultado.setEncontrado(true);
                resultado.setNombres(nombres);
                resultado.setApellidoPaterno(apPaterno);
                resultado.setApellidoMaterno(apMaterno);
                resultado.setMensaje("Datos encontrados en RENIEC.");
                return resultado;
            } else if (status == 401 || status == 403) {
                resultado.setEncontrado(false);
                resultado.setMensaje("El token configurado para RENIEC no es válido o expiró.");
                return resultado;
            } else if (status == 404) {
                resultado.setEncontrado(false);
                resultado.setMensaje("No se encontró ningún registro para el DNI " + dni + ".");
                return resultado;
            } else {
                resultado.setEncontrado(false);
                resultado.setMensaje("El servicio de RENIEC no respondió correctamente (código " + status + ").");
                return resultado;
            }
        } catch (IOException e) {
            resultado.setEncontrado(false);
            resultado.setMensaje("No se pudo conectar con el servicio de RENIEC. Verifique la conexión a Internet.");
            return resultado;
        } finally {
            if (con != null) {
                con.disconnect();
            }
        }
    }

    private static Properties cargarConfiguracion(String rutaReal) {
        Properties props = new Properties();
        if (rutaReal == null) {
            return props;
        }
        String ruta = rutaReal.endsWith("/") || rutaReal.endsWith("\\")
                ? rutaReal + "WEB-INF/reniec.properties"
                : rutaReal + RUTA_CONFIG;
        try (InputStream in = new FileInputStream(ruta)) {
            props.load(new InputStreamReader(in, StandardCharsets.UTF_8));
        } catch (IOException e) {
            System.err.println("Aviso: no se pudo leer WEB-INF/reniec.properties (" + e.getMessage() + ")");
        }
        return props;
    }

    private static String leerCuerpo(InputStream is) throws IOException {
        if (is == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                sb.append(linea);
            }
        }
        return sb.toString();
    }

    /**
     * Extrae un campo de tipo texto de un JSON plano: "clave":"valor".
     * Soporta variantes camelCase y snake_case del mismo campo (distintos
     * proveedores nombran los campos de forma distinta).
     */
    private static String extraerCampo(String json, String claveCamelCase) {
        String claveSnake = claveCamelCase.replaceAll("([A-Z])", "_$1").toLowerCase();
        String[] posiblesClaves = {claveCamelCase, claveSnake};
        for (String clave : posiblesClaves) {
            Pattern p = Pattern.compile("\"" + Pattern.quote(clave) + "\"\\s*:\\s*\"([^\"]*)\"");
            Matcher m = p.matcher(json);
            if (m.find()) {
                return m.group(1).trim();
            }
        }
        return "";
    }

    private static String escaparJson(String valor) {
        if (valor == null) {
            return "";
        }
        return valor.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
