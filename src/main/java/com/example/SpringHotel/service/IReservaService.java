package com.example.SpringHotel.service;

import com.example.SpringHotel.entity.Reserva;
import java.util.List;
import java.util.Optional;

public interface IReservaService {
    List<Reserva> listarTodo();
    Optional<Reserva> buscarPorId(Integer id);
    Reserva guardar(Reserva reserva);
    Reserva actualizar(Integer id, Reserva reservaDetalles);
    void eliminar(Integer id);
}