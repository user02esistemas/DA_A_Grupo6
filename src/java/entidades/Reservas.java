/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entidades;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author dzs-1
 */
@Entity
@Table(name = "Reservas", catalog = "BdHotelOasis2", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "Reservas.findAll", query = "SELECT r FROM Reservas r"),
    @NamedQuery(name = "Reservas.findByIdReserva", query = "SELECT r FROM Reservas r WHERE r.idReserva = :idReserva"),
    @NamedQuery(name = "Reservas.findByFechaCheckIn", query = "SELECT r FROM Reservas r WHERE r.fechaCheckIn = :fechaCheckIn"),
    @NamedQuery(name = "Reservas.findByFechaCheckOutEsperada", query = "SELECT r FROM Reservas r WHERE r.fechaCheckOutEsperada = :fechaCheckOutEsperada"),
    @NamedQuery(name = "Reservas.findByFechaCheckOutReal", query = "SELECT r FROM Reservas r WHERE r.fechaCheckOutReal = :fechaCheckOutReal"),
    @NamedQuery(name = "Reservas.findByEstadoReserva", query = "SELECT r FROM Reservas r WHERE r.estadoReserva = :estadoReserva")})
public class Reservas implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idReserva", nullable = false)
    private Integer idReserva;
    @Basic(optional = false)
    @Column(name = "fechaCheckIn", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaCheckIn;
    @Basic(optional = false)
    @Column(name = "fechaCheckOutEsperada", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaCheckOutEsperada;
    @Column(name = "fechaCheckOutReal")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaCheckOutReal;
    @Basic(optional = false)
    @Column(name = "estadoReserva", nullable = false, length = 30)
    private String estadoReserva;
    @JoinColumn(name = "id_cliente", referencedColumnName = "idcliente", nullable = false)
    @ManyToOne(optional = false)
    private Clientes idCliente;
    @JoinColumn(name = "idEmpleado", referencedColumnName = "idEmpleado", nullable = false)
    @ManyToOne(optional = false)
    private Empleados idEmpleado;
    @JoinColumn(name = "idHabitacion", referencedColumnName = "idHabitacion", nullable = false)
    @ManyToOne(optional = false)
    private Habitaciones idHabitacion;

    public Reservas() {
    }

    public Reservas(Integer idReserva) {
        this.idReserva = idReserva;
    }

    public Reservas(Integer idReserva, Date fechaCheckIn, Date fechaCheckOutEsperada, String estadoReserva) {
        this.idReserva = idReserva;
        this.fechaCheckIn = fechaCheckIn;
        this.fechaCheckOutEsperada = fechaCheckOutEsperada;
        this.estadoReserva = estadoReserva;
    }

    public Integer getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(Integer idReserva) {
        this.idReserva = idReserva;
    }

    public Date getFechaCheckIn() {
        return fechaCheckIn;
    }

    public void setFechaCheckIn(Date fechaCheckIn) {
        this.fechaCheckIn = fechaCheckIn;
    }

    public Date getFechaCheckOutEsperada() {
        return fechaCheckOutEsperada;
    }

    public void setFechaCheckOutEsperada(Date fechaCheckOutEsperada) {
        this.fechaCheckOutEsperada = fechaCheckOutEsperada;
    }

    public Date getFechaCheckOutReal() {
        return fechaCheckOutReal;
    }

    public void setFechaCheckOutReal(Date fechaCheckOutReal) {
        this.fechaCheckOutReal = fechaCheckOutReal;
    }

    public String getEstadoReserva() {
        return estadoReserva;
    }

    public void setEstadoReserva(String estadoReserva) {
        this.estadoReserva = estadoReserva;
    }

    public Clientes getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Clientes idCliente) {
        this.idCliente = idCliente;
    }

    public Empleados getIdEmpleado() {
        return idEmpleado;
    }

    public void setIdEmpleado(Empleados idEmpleado) {
        this.idEmpleado = idEmpleado;
    }

    public Habitaciones getIdHabitacion() {
        return idHabitacion;
    }

    public void setIdHabitacion(Habitaciones idHabitacion) {
        this.idHabitacion = idHabitacion;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idReserva != null ? idReserva.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Reservas)) {
            return false;
        }
        Reservas other = (Reservas) object;
        if ((this.idReserva == null && other.idReserva != null) || (this.idReserva != null && !this.idReserva.equals(other.idReserva))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.Reservas[ idReserva=" + idReserva + " ]";
    }
    
}
