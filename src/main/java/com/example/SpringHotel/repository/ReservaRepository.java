package com.example.SpringHotel.repository;

import com.example.SpringHotel.entity.Reserva;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ReservaRepository extends JpaRepository<Reserva, Integer> {

    List<Reserva> findByEstadoReserva(String estadoReserva);

    List<Reserva> findByIdCliente(Integer idCliente);
}