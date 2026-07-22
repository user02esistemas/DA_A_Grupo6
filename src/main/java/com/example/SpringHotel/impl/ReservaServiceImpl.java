package com.example.SpringHotel.impl;

import com.example.SpringHotel.entity.Habitacion;
import com.example.SpringHotel.entity.Reserva;
import com.example.SpringHotel.repository.HabitacionRepository;
import com.example.SpringHotel.repository.ReservaRepository;
import com.example.SpringHotel.service.IReservaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ReservaServiceImpl implements IReservaService {

    @Autowired
    private ReservaRepository reservaRepository;

    @Autowired
    private HabitacionRepository habitacionRepository;

    @Override
    public List<Reserva> listarTodo() {
        return reservaRepository.findAll();
    }

    @Override
    public Optional<Reserva> buscarPorId(Integer id) {
        return reservaRepository.findById(id);
    }

    @Override
    public Reserva guardar(Reserva reserva) {
        if (reserva.getEstadoReserva() == null || reserva.getEstadoReserva().isBlank()) {
            reserva.setEstadoReserva("Confirmada");
        }

        aplicarCheckOutRealSiCorresponde(reserva, null);

        Reserva guardada = reservaRepository.save(reserva);
        recalcularEstadoHabitacion(guardada.getIdHabitacion());

        return guardada;
    }

    @Override
    public Reserva actualizar(Integer id, Reserva reservaDetalles) {
        Optional<Reserva> reservaOptional = reservaRepository.findById(id);
        if (reservaOptional.isPresent()) {
            Reserva reservaExistente = reservaOptional.get();

            Integer habitacionAnterior = reservaExistente.getIdHabitacion();
            LocalDateTime checkOutRealPrevio = reservaExistente.getFechaCheckOutReal();

            reservaExistente.setIdCliente(reservaDetalles.getIdCliente());
            reservaExistente.setIdHabitacion(reservaDetalles.getIdHabitacion());
            reservaExistente.setIdEmpleado(reservaDetalles.getIdEmpleado());
            reservaExistente.setFechaCheckIn(reservaDetalles.getFechaCheckIn());
            reservaExistente.setFechaCheckOutEsperada(reservaDetalles.getFechaCheckOutEsperada());
            reservaExistente.setFechaCheckOutReal(reservaDetalles.getFechaCheckOutReal());
            reservaExistente.setEstadoReserva(reservaDetalles.getEstadoReserva());

            aplicarCheckOutRealSiCorresponde(reservaExistente, checkOutRealPrevio);

            Reserva actualizada = reservaRepository.save(reservaExistente);

            // Se recalcula el estado de AMBAS habitaciones (la anterior, por si el
            // huésped se cambió de cuarto, y la nueva/actual) revisando todas sus
            // reservas activas, no solo suponiendo el resultado.
            if (habitacionAnterior != null && !habitacionAnterior.equals(actualizada.getIdHabitacion())) {
                recalcularEstadoHabitacion(habitacionAnterior);
            }
            recalcularEstadoHabitacion(actualizada.getIdHabitacion());

            return actualizada;
        } else {
            throw new RuntimeException("Reserva no encontrada con el ID: " + id);
        }
    }

    @Override
    public void eliminar(Integer id) {
        Optional<Reserva> reservaOptional = reservaRepository.findById(id);
        if (reservaOptional.isPresent()) {
            Reserva reserva = reservaOptional.get();
            reserva.setEstadoReserva("Cancelada");
            reservaRepository.save(reserva);

            recalcularEstadoHabitacion(reserva.getIdHabitacion());
        } else {
            throw new RuntimeException("No se puede eliminar. Reserva no encontrada con el ID: " + id);
        }
    }

    // ---------- MÉTODOS DE APOYO ----------

    private void aplicarCheckOutRealSiCorresponde(Reserva reserva, LocalDateTime checkOutRealPrevio) {
        boolean esFinalizada = "Finalizada".equalsIgnoreCase(reserva.getEstadoReserva());
        boolean noTeniaCheckOutRealAntes = checkOutRealPrevio == null;

        if (esFinalizada && noTeniaCheckOutRealAntes && reserva.getFechaCheckOutReal() == null) {
            reserva.setFechaCheckOutReal(LocalDateTime.now());
        }
    }

    // CORREGIDO: en vez de fijar el estado de la habitación basándose solo en la
    // reserva que se acaba de guardar (lo que podía desincronizarse si esa
    // habitación tenía otras reservas), ahora se revisan TODAS las reservas
    // activas de la habitación y se calcula el estado real:
    //   - Si tiene alguna reserva "Confirmada"  -> Ocupada
    //   - Si no, pero tiene alguna "Pendiente"  -> Reservada
    //   - Si no tiene ninguna activa             -> Libre
    private void recalcularEstadoHabitacion(Integer idHabitacion) {
        if (idHabitacion == null) return;

        Optional<Habitacion> habOpt = habitacionRepository.findById(idHabitacion);
        if (habOpt.isEmpty()) return;

        Habitacion habitacion = habOpt.get();

        List<Reserva> reservasDeLaHabitacion = reservaRepository.findAll().stream()
                .filter(r -> idHabitacion.equals(r.getIdHabitacion()))
                .toList();

        boolean tieneConfirmada = reservasDeLaHabitacion.stream()
                .anyMatch(r -> "Confirmada".equalsIgnoreCase(r.getEstadoReserva()));

        boolean tienePendiente = reservasDeLaHabitacion.stream()
                .anyMatch(r -> "Pendiente".equalsIgnoreCase(r.getEstadoReserva()));

        if (tieneConfirmada) {
            habitacion.setEstadoDisponibilidad("Ocupada");
        } else if (tienePendiente) {
            habitacion.setEstadoDisponibilidad("Reservada");
        } else {
            habitacion.setEstadoDisponibilidad("Libre");
        }

        habitacionRepository.save(habitacion);
    }
}