package com.example.SpringHotel.impl;

import com.example.SpringHotel.entity.Habitacion;
import com.example.SpringHotel.repository.HabitacionRepository;
import com.example.SpringHotel.service.IHabitacionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class HabitacionServiceImpl implements IHabitacionService {

    @Autowired
    private HabitacionRepository habitacionRepository;

    @Override
    public List<Habitacion> listarTodo() {
        return habitacionRepository.findAll();
    }

    @Override
    public Optional<Habitacion> buscarPorId(Integer id) {
        return habitacionRepository.findById(id);
    }

    @Override
    public Habitacion guardar(Habitacion habitacion) {
        if (habitacion.getFechaRegistro() == null) {
            habitacion.setFechaRegistro(LocalDate.now());
        }
        return habitacionRepository.save(habitacion);
    }

    @Override
    public Habitacion actualizar(Integer id, Habitacion habitacionDetalles) {
        Optional<Habitacion> habitacionOptional = habitacionRepository.findById(id);

        if (habitacionOptional.isPresent()) {
            Habitacion habitacionExistente = habitacionOptional.get();

            habitacionExistente.setNumeroHabitacion(habitacionDetalles.getNumeroHabitacion());
            habitacionExistente.setPiso(habitacionDetalles.getPiso());
            habitacionExistente.setIdTipo(habitacionDetalles.getIdTipo());
            habitacionExistente.setEstadoDisponibilidad(habitacionDetalles.getEstadoDisponibilidad());
            habitacionExistente.setEstadoLimpieza(habitacionDetalles.getEstadoLimpieza());
            habitacionExistente.setActivo(habitacionDetalles.isActivo());

            return habitacionRepository.save(habitacionExistente);
        } else {
            throw new RuntimeException("Habitación no encontrada con el ID: " + id);
        }
    }

    @Override
    public void eliminar(Integer id) {
        Optional<Habitacion> habitacionOptional = habitacionRepository.findById(id);
        if (habitacionOptional.isPresent()) {
            Habitacion habitacion = habitacionOptional.get();
            habitacion.setActivo(false); // Baja lógica
            habitacionRepository.save(habitacion);
        } else {
            throw new RuntimeException("No se puede eliminar. Habitación no encontrada con el ID: " + id);
        }
    }
}