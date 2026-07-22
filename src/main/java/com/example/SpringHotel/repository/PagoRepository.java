package com.example.SpringHotel.repository;

import com.example.SpringHotel.entity.Pago;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PagoRepository extends JpaRepository<Pago, Integer> {

    List<Pago> findByIdReservaOrderByFechaPagoDesc(Integer idReserva);
}
