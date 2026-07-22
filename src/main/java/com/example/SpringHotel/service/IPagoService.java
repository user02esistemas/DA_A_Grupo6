package com.example.SpringHotel.service;

import com.example.SpringHotel.dto.SaldoReservaDTO;
import com.example.SpringHotel.entity.Pago;

import java.util.List;
import java.util.Optional;

public interface IPagoService {
    List<Pago> listarTodo();
    Optional<Pago> buscarPorId(Integer id);
    List<Pago> listarPorReserva(Integer idReserva);
    SaldoReservaDTO calcularSaldo(Integer idReserva);
    Pago guardar(Pago pago);
    Pago actualizar(Integer id, Pago pagoDetalles);
    void eliminar(Integer id);
}
