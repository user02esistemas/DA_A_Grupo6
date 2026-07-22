package com.example.SpringHotel.repository;

import com.example.SpringHotel.entity.TipoHabitacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface TipoHabitacionRepository extends JpaRepository<TipoHabitacion, Integer> {

    // Útil para evitar nombres de tipo duplicados (ej. dos "Suite Ejecutiva")
    Optional<TipoHabitacion> findByNombreTipo(String nombreTipo);
}