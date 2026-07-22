package com.example.SpringHotel.service;

import com.example.SpringHotel.entity.TipoHabitacion;
import java.util.List;
import java.util.Optional;

public interface ITipoHabitacionService {
    List<TipoHabitacion> listarTodo();
    Optional<TipoHabitacion> buscarPorId(Integer id);
    TipoHabitacion guardar(TipoHabitacion tipoHabitacion);
    TipoHabitacion actualizar(Integer id, TipoHabitacion tipoHabitacionDetalles);
    void eliminar(Integer id);
}