package com.example.SpringHotel.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/consulta-dni")
@CrossOrigin(origins = "*")
public class ConsultaDniController {

    // El token se guarda en application.properties, NUNCA en el código
    // ni en el frontend, para que no quede expuesto.
    @Value("${apiperu.token}")
    private String apiPeruToken;

    private static final String API_URL = "https://apiperu.dev/api/dni";

    // CORREGIDO: se usa RestTemplate (parte de spring-web, ya incluido)
    // en vez de com.fasterxml.jackson.databind directamente, porque esa
    // dependencia no está expuesta para uso manual en este proyecto.
    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/{dni}")
    public ResponseEntity<?> consultarDni(@PathVariable String dni) {

        Map<String, Object> resultado = new HashMap<>();

        if (dni == null || !dni.matches("\\d{8}")) {
            resultado.put("encontrado", false);
            resultado.put("mensaje", "El DNI debe tener exactamente 8 dígitos numéricos.");
            return new ResponseEntity<>(resultado, HttpStatus.BAD_REQUEST);
        }

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setAccept(List.of(MediaType.APPLICATION_JSON));
            headers.setBearerAuth(apiPeruToken);

            Map<String, String> cuerpo = new HashMap<>();
            cuerpo.put("dni", dni);

            HttpEntity<Map<String, String>> peticion = new HttpEntity<>(cuerpo, headers);

            ResponseEntity<Map> respuestaExterna = restTemplate.postForEntity(API_URL, peticion, Map.class);
            Map<String, Object> cuerpoRespuesta = respuestaExterna.getBody();

            boolean exito = cuerpoRespuesta != null && Boolean.TRUE.equals(cuerpoRespuesta.get("success"));

            if (exito && cuerpoRespuesta.get("data") instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> data = (Map<String, Object>) cuerpoRespuesta.get("data");

                resultado.put("encontrado", true);
                resultado.put("nombres", data.getOrDefault("nombres", ""));
                resultado.put("apellidoPaterno", data.getOrDefault("apellido_paterno", ""));
                resultado.put("apellidoMaterno", data.getOrDefault("apellido_materno", ""));
                return new ResponseEntity<>(resultado, HttpStatus.OK);
            } else {
                resultado.put("encontrado", false);
                resultado.put("mensaje", "No se encontraron datos para ese DNI. Completa los campos manualmente.");
                return new ResponseEntity<>(resultado, HttpStatus.OK);
            }

        } catch (Exception e) {
            resultado.put("encontrado", false);
            resultado.put("mensaje", "No se pudo conectar con el servicio de consulta DNI.");
            return new ResponseEntity<>(resultado, HttpStatus.SERVICE_UNAVAILABLE);
        }
    }
}