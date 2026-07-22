package com.example.SpringHotel.repository;

import com.example.SpringHotel.entity.Habitacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HabitacionRepository extends JpaRepository<Habitacion, Integer> {

    List<Habitacion> findByActivoTrue();

    List<Habitacion> findByEstadoDisponibilidad(String estadoDisponibilidad);
}