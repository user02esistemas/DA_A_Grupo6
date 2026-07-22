package com.example.SpringHotel.dto;

import java.math.BigDecimal;

/**
 * Resumen de caja de una reserva: cuánto cuesta en total, cuánto se ha
 * pagado ya (sumando los pagos "Confirmado") y cuánto falta por cobrar.
 */
public class SaldoReservaDTO {

    private Integer idReserva;
    private BigDecimal montoTotal;
    private BigDecimal totalPagado;
    private BigDecimal saldoPendiente;

    public SaldoReservaDTO(Integer idReserva, BigDecimal montoTotal, BigDecimal totalPagado, BigDecimal saldoPendiente) {
        this.idReserva = idReserva;
        this.montoTotal = montoTotal;
        this.totalPagado = totalPagado;
        this.saldoPendiente = saldoPendiente;
    }

    public Integer getIdReserva() {
        return idReserva;
    }

    public BigDecimal getMontoTotal() {
        return montoTotal;
    }

    public BigDecimal getTotalPagado() {
        return totalPagado;
    }

    public BigDecimal getSaldoPendiente() {
        return saldoPendiente;
    }
}
