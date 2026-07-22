package com.example.SpringHotel.controller;

import com.example.SpringHotel.dto.SaldoReservaDTO;
import com.example.SpringHotel.entity.Pago;
import com.example.SpringHotel.service.IPagoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/pagos")
@CrossOrigin(origins = "*")
public class PagoController {

    @Autowired
    private IPagoService pagoService;

    @GetMapping
    public List<Pago> listarPagos() {
        return pagoService.listarTodo();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pago> obtenerPagoPorId(@PathVariable Integer id) {
        return pagoService.buscarPorId(id)
                .map(pago -> new ResponseEntity<>(pago, HttpStatus.OK))
                .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/reserva/{idReserva}")
    public List<Pago> listarPagosPorReserva(@PathVariable Integer idReserva) {
        return pagoService.listarPorReserva(idReserva);
    }

    @GetMapping("/reserva/{idReserva}/saldo")
    public ResponseEntity<?> obtenerSaldoReserva(@PathVariable Integer idReserva) {
        try {
            SaldoReservaDTO saldo = pagoService.calcularSaldo(idReserva);
            return new ResponseEntity<>(saldo, HttpStatus.OK);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", e.getMessage());
            return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping
    public ResponseEntity<?> guardarPago(@RequestBody Pago pago) {
        try {
            Pago nuevoPago = pagoService.guardar(pago);
            return new ResponseEntity<>(nuevoPago, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", e.getMessage());
            return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> actualizarPago(@PathVariable Integer id, @RequestBody Pago pagoDetalles) {
        try {
            Pago pagoActualizado = pagoService.actualizar(id, pagoDetalles);
            return new ResponseEntity<>(pagoActualizado, HttpStatus.OK);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", e.getMessage());
            return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarPago(@PathVariable Integer id) {
        try {
            pagoService.eliminar(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}
