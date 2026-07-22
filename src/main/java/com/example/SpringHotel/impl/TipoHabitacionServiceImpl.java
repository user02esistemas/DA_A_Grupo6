package com.example.SpringHotel.impl;

import com.example.SpringHotel.entity.TipoHabitacion;
import com.example.SpringHotel.repository.TipoHabitacionRepository;
import com.example.SpringHotel.service.ITipoHabitacionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class TipoHabitacionServiceImpl implements ITipoHabitacionService {

    @Autowired
    private TipoHabitacionRepository tipoHabitacionRepository;

    @Override
    public List<TipoHabitacion> listarTodo() {
        return tipoHabitacionRepository.findAll();
    }

    @Override
    public Optional<TipoHabitacion> buscarPorId(Integer id) {
        return tipoHabitacionRepository.findById(id);
    }

    @Override
    public TipoHabitacion guardar(TipoHabitacion tipoHabitacion) {
        return tipoHabitacionRepository.save(tipoHabitacion);
    }

    @Override
    public TipoHabitacion actualizar(Integer id, TipoHabitacion tipoHabitacionDetalles) {
        Optional<TipoHabitacion> tipoOptional = tipoHabitacionRepository.findById(id);

        if (tipoOptional.isPresent()) {
            TipoHabitacion tipoExistente = tipoOptional.get();

            tipoExistente.setNombreTipo(tipoHabitacionDetalles.getNombreTipo());
            tipoExistente.setPrecioPorNoche(tipoHabitacionDetalles.getPrecioPorNoche());
            tipoExistente.setCapacidadPersonas(tipoHabitacionDetalles.getCapacidadPersonas());

            return tipoHabitacionRepository.save(tipoExistente);
        } else {
            throw new RuntimeException("Tipo de Habitación no encontrado con el ID: " + id);
        }
    }

    @Override
    public void eliminar(Integer id) {
        Optional<TipoHabitacion> tipoOptional = tipoHabitacionRepository.findById(id);
        if (tipoOptional.isPresent()) {
            tipoHabitacionRepository.deleteById(id);
        } else {
            throw new RuntimeException("No se puede eliminar. Tipo de Habitación no encontrado con el ID: " + id);
        }
    }
}