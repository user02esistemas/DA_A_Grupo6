package com.example.SpringHotel.controller;

import com.example.SpringHotel.entity.Habitacion;
import com.example.SpringHotel.service.IHabitacionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/habitaciones")
@CrossOrigin(origins = "*")
public class HabitacionController {

    @Autowired
    private IHabitacionService habitacionService;

    @GetMapping
    public List<Habitacion> listarHabitaciones() {
        return habitacionService.listarTodo();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Habitacion> obtenerHabitacionPorId(@PathVariable Integer id) {
        return habitacionService.buscarPorId(id)
                .map(habitacion -> new ResponseEntity<>(habitacion, HttpStatus.OK))
                .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<Habitacion> guardarHabitacion(@RequestBody Habitacion habitacion) {
        Habitacion nuevaHabitacion = habitacionService.guardar(habitacion);
        return new ResponseEntity<>(nuevaHabitacion, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Habitacion> actualizarHabitacion(@PathVariable Integer id, @RequestBody Habitacion habitacionDetalles) {
        try {
            Habitacion habitacionActualizada = habitacionService.actualizar(id, habitacionDetalles);
            return new ResponseEntity<>(habitacionActualizada, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarHabitacion(@PathVariable Integer id) {
        try {
            habitacionService.eliminar(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}