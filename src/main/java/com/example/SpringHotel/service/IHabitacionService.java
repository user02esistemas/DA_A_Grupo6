package com.example.SpringHotel.service;

import com.example.SpringHotel.entity.Habitacion;
import java.util.List;
import java.util.Optional;

public interface IHabitacionService {
    List<Habitacion> listarTodo();
    Optional<Habitacion> buscarPorId(Integer id);
    Habitacion guardar(Habitacion habitacion);
    Habitacion actualizar(Integer id, Habitacion habitacionDetalles);
    void eliminar(Integer id);
}