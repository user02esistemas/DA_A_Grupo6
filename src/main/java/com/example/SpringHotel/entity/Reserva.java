package com.example.SpringHotel.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDateTime;

@Entity
@Table(name = "Reservas")
public class Reserva {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idReserva")
    private Integer idReserva;

    @Column(name = "id_cliente")
    private Integer idCliente;

    @Column(name = "idHabitacion")
    private Integer idHabitacion;

    @Column(name = "idEmpleado")
    private Integer idEmpleado;

    @Column(name = "fechaCheckIn")
    private LocalDateTime fechaCheckIn;

    @Column(name = "fechaCheckOutEsperada")
    private LocalDateTime fechaCheckOutEsperada;

    @Column(name = "fechaCheckOutReal")
    private LocalDateTime fechaCheckOutReal;

    @Column(name = "estadoReserva")
    private String estadoReserva;

    public Integer getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(Integer idReserva) {
        this.idReserva = idReserva;
    }

    public Integer getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Integer idCliente) {
        this.idCliente = idCliente;
    }

    public Integer getIdHabitacion() {
        return idHabitacion;
    }

    public void setIdHabitacion(Integer idHabitacion) {
        this.idHabitacion = idHabitacion;
    }

    public Integer getIdEmpleado() {
        return idEmpleado;
    }

    public void setIdEmpleado(Integer idEmpleado) {
        this.idEmpleado = idEmpleado;
    }

    public LocalDateTime getFechaCheckIn() {
        return fechaCheckIn;
    }

    public void setFechaCheckIn(LocalDateTime fechaCheckIn) {
        this.fechaCheckIn = fechaCheckIn;
    }

    public LocalDateTime getFechaCheckOutEsperada() {
        return fechaCheckOutEsperada;
    }

    public void setFechaCheckOutEsperada(LocalDateTime fechaCheckOutEsperada) {
        this.fechaCheckOutEsperada = fechaCheckOutEsperada;
    }

    public LocalDateTime getFechaCheckOutReal() {
        return fechaCheckOutReal;
    }

    public void setFechaCheckOutReal(LocalDateTime fechaCheckOutReal) {
        this.fechaCheckOutReal = fechaCheckOutReal;
    }

    public String getEstadoReserva() {
        return estadoReserva;
    }

    public void setEstadoReserva(String estadoReserva) {
        this.estadoReserva = estadoReserva;
    }
}