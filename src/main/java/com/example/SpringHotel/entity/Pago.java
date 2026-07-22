package com.example.SpringHotel.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Pago")
public class Pago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idPago")
    private Integer idPago;

    @Column(name = "idReserva", nullable = false)
    private Integer idReserva;

    @Column(name = "idEmpleado", nullable = false)
    private Integer idEmpleado;

    @Column(name = "monto", nullable = false)
    private BigDecimal monto;

    // Valores esperados: Efectivo, Tarjeta, Transferencia, Yape, Plin
    @Column(name = "metodoPago", nullable = false, length = 30)
    private String metodoPago;

    @Column(name = "fechaPago", nullable = false)
    private LocalDateTime fechaPago;

    // Valores esperados: Confirmado, Anulado
    @Column(name = "estadoPago", nullable = false, length = 20)
    private String estadoPago;

    // Código de operación del pago digital (Yape, Plin, Transferencia) o voucher
    // del POS (Tarjeta). Sirve como comprobante para auditar el cobro.
    @Column(name = "nroOperacion", length = 30)
    private String nroOperacion;

    @Column(name = "observaciones", length = 255)
    private String observaciones;

    public Integer getIdPago() {
        return idPago;
    }

    public void setIdPago(Integer idPago) {
        this.idPago = idPago;
    }

    public Integer getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(Integer idReserva) {
        this.idReserva = idReserva;
    }

    public Integer getIdEmpleado() {
        return idEmpleado;
    }

    public void setIdEmpleado(Integer idEmpleado) {
        this.idEmpleado = idEmpleado;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    public LocalDateTime getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(LocalDateTime fechaPago) {
        this.fechaPago = fechaPago;
    }

    public String getEstadoPago() {
        return estadoPago;
    }

    public void setEstadoPago(String estadoPago) {
        this.estadoPago = estadoPago;
    }

    public String getNroOperacion() {
        return nroOperacion;
    }

    public void setNroOperacion(String nroOperacion) {
        this.nroOperacion = nroOperacion;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
}
