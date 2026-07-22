package com.example.SpringHotel.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping("/")
    public String raiz() {
        // habitaciones-vista es el único módulo al que los 3 roles tienen acceso.
        return "redirect:/habitaciones-vista";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/checkin-vista")
    public String checkinRapido() {
        return "CheckinRapido";
    }

    @GetMapping("/pagos-vista")
    public String verPagos() {
        return "Pagos";
    }

@GetMapping("/finanzas-vista")
public String finanzas() {
    return "Finanzas";
}

    @GetMapping("/clientes-vista")
    public String verClientes() {
        return "Clientes";
    }

    @GetMapping("/tipohabitacion-vista")
    public String verTiposHabitacion() {
        return "TipoHabitacion";
    }

    @GetMapping("/habitaciones-vista")
    public String verHabitaciones() {
        return "Habitaciones";
    }

    @GetMapping("/reservas-vista")
    public String verReservas() {
        return "Reservas";
    }
}
