package com.example.SpringHotel.service;

import com.example.SpringHotel.entity.Empleado;
import java.util.List;
import java.util.Optional;

public interface IEmpleadoService {
    List<Empleado> listarTodo();
    Optional<Empleado> buscarPorId(Integer id);
}