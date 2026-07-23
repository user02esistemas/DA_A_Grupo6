package controladores;

import entidades.Habitaciones;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ObtenerHabitacionesServlet", urlPatterns = {"/ObtenerHabitacionesServlet"})
public class ObtenerHabitacionesServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        String tipoHabitacion = request.getParameter("tipo");

        try (PrintWriter out = response.getWriter()) {
            habitacionControlador habControl = new habitacionControlador();
            List<Habitaciones> lista = habControl.listarDisponiblesPorTipo(tipoHabitacion);
            out.print(toJson(lista));
            out.flush();
        } catch (Exception e) {
            try (PrintWriter out = response.getWriter()) {
                out.print("[]");
                out.flush();
            }
        }
    }

    private String toJson(List<Habitaciones> lista) {
        StringBuilder json = new StringBuilder("[");
        if (lista != null) {
            for (int i = 0; i < lista.size(); i++) {
                Habitaciones h = lista.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{");
                json.append("\"idHabitacion\":").append(h.getIdHabitacion()).append(",");
                json.append("\"numeroHabitacion\":\"").append(escape(h.getNumeroHabitacion())).append("\",");
                json.append("\"piso\":").append(h.getPiso()).append(",");
                json.append("\"estadoDisponibilidad\":\"").append(escape(h.getEstadoDisponibilidad())).append("\",");
                json.append("\"estadoLimpieza\":\"").append(escape(h.getEstadoLimpieza())).append("\"");
                json.append("}");
            }
        }
        json.append("]");
        return json.toString();
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
