package com.example.SpringHotel.controller;

import com.example.SpringHotel.entity.TipoHabitacion;
import com.example.SpringHotel.service.ITipoHabitacionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/tipohabitaciones")
@CrossOrigin(origins = "*")
public class TipoHabitacionController {

    @Autowired
    private ITipoHabitacionService tipoHabitacionService;

    @GetMapping
    public List<TipoHabitacion> listarTipos() {
        return tipoHabitacionService.listarTodo();
    }

    @GetMapping("/{id}")
    public ResponseEntity<TipoHabitacion> obtenerTipoPorId(@PathVariable Integer id) {
        return tipoHabitacionService.buscarPorId(id)
                .map(tipo -> new ResponseEntity<>(tipo, HttpStatus.OK))
                .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<TipoHabitacion> guardarTipo(@RequestBody TipoHabitacion tipoHabitacion) {
        TipoHabitacion nuevoTipo = tipoHabitacionService.guardar(tipoHabitacion);
        return new ResponseEntity<>(nuevoTipo, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TipoHabitacion> actualizarTipo(@PathVariable Integer id, @RequestBody TipoHabitacion tipoDetalles) {
        try {
            TipoHabitacion tipoActualizado = tipoHabitacionService.actualizar(id, tipoDetalles);
            return new ResponseEntity<>(tipoActualizado, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarTipo(@PathVariable Integer id) {
        try {
            tipoHabitacionService.eliminar(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}