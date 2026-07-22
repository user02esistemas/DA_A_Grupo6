package com.example.SpringHotel.impl;

import com.example.SpringHotel.dto.SaldoReservaDTO;
import com.example.SpringHotel.entity.Habitacion;
import com.example.SpringHotel.entity.Pago;
import com.example.SpringHotel.entity.Reserva;
import com.example.SpringHotel.entity.TipoHabitacion;
import com.example.SpringHotel.repository.HabitacionRepository;
import com.example.SpringHotel.repository.PagoRepository;
import com.example.SpringHotel.repository.ReservaRepository;
import com.example.SpringHotel.repository.TipoHabitacionRepository;
import com.example.SpringHotel.service.IPagoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class PagoServiceImpl implements IPagoService {

    @Autowired
    private PagoRepository pagoRepository;

    @Autowired
    private ReservaRepository reservaRepository;

    @Autowired
    private HabitacionRepository habitacionRepository;

    @Autowired
    private TipoHabitacionRepository tipoHabitacionRepository;

    @Override
    public List<Pago> listarTodo() {
        return pagoRepository.findAll();
    }

    @Override
    public Optional<Pago> buscarPorId(Integer id) {
        return pagoRepository.findById(id);
    }

    @Override
    public List<Pago> listarPorReserva(Integer idReserva) {
        return pagoRepository.findByIdReservaOrderByFechaPagoDesc(idReserva);
    }

    @Override
    public SaldoReservaDTO calcularSaldo(Integer idReserva) {
        BigDecimal montoTotal = calcularMontoTotalReserva(idReserva);

        BigDecimal totalPagado = listarPorReserva(idReserva).stream()
                .filter(p -> "Confirmado".equalsIgnoreCase(p.getEstadoPago()))
                .map(Pago::getMonto)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal saldo = montoTotal.subtract(totalPagado);
        if (saldo.compareTo(BigDecimal.ZERO) < 0) {
            saldo = BigDecimal.ZERO;
        }

        return new SaldoReservaDTO(idReserva, montoTotal, totalPagado, saldo);
    }

    @Override
    public Pago guardar(Pago pago) {
        if (pago.getMonto() == null || pago.getMonto().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("El monto del pago debe ser mayor a cero.");
        }
        if (!reservaRepository.existsById(pago.getIdReserva())) {
            throw new RuntimeException("La reserva indicada no existe.");
        }

        if (pago.getFechaPago() == null) {
            pago.setFechaPago(LocalDateTime.now());
        }
        if (pago.getEstadoPago() == null || pago.getEstadoPago().isBlank()) {
            pago.setEstadoPago("Confirmado");
        }

        return pagoRepository.save(pago);
    }

    @Override
    public Pago actualizar(Integer id, Pago pagoDetalles) {
        Optional<Pago> pagoOptional = pagoRepository.findById(id);
        if (pagoOptional.isEmpty()) {
            throw new RuntimeException("Pago no encontrado con el ID: " + id);
        }
        if (pagoDetalles.getMonto() == null || pagoDetalles.getMonto().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("El monto del pago debe ser mayor a cero.");
        }

        Pago pagoExistente = pagoOptional.get();
        pagoExistente.setMonto(pagoDetalles.getMonto());
        pagoExistente.setMetodoPago(pagoDetalles.getMetodoPago());
        pagoExistente.setEstadoPago(pagoDetalles.getEstadoPago());
        pagoExistente.setNroOperacion(pagoDetalles.getNroOperacion());
        pagoExistente.setObservaciones(pagoDetalles.getObservaciones());

        return pagoRepository.save(pagoExistente);
    }

    @Override
    public void eliminar(Integer id) {
        if (!pagoRepository.existsById(id)) {
            throw new RuntimeException("No se puede eliminar. Pago no encontrado con el ID: " + id);
        }
        pagoRepository.deleteById(id);
    }

    // ---------- MÉTODOS DE APOYO ----------

    // Monto total = precioPorNoche del TipoHabitacion x número de noches de la reserva.
    private BigDecimal calcularMontoTotalReserva(Integer idReserva) {
        Reserva reserva = reservaRepository.findById(idReserva)
                .orElseThrow(() -> new RuntimeException("La reserva indicada no existe."));

        Habitacion habitacion = habitacionRepository.findById(reserva.getIdHabitacion())
                .orElseThrow(() -> new RuntimeException("La habitación de la reserva no existe."));

        TipoHabitacion tipo = tipoHabitacionRepository.findById(habitacion.getIdTipo())
                .orElseThrow(() -> new RuntimeException("El tipo de habitación no existe."));

        LocalDateTime checkOutRef = reserva.getFechaCheckOutReal() != null
                ? reserva.getFechaCheckOutReal() : reserva.getFechaCheckOutEsperada();

        long noches = Math.max(1, Duration.between(reserva.getFechaCheckIn(), checkOutRef).toDays());

        return tipo.getPrecioPorNoche()
                .multiply(BigDecimal.valueOf(noches))
                .setScale(2, RoundingMode.HALF_UP);
    }
}
