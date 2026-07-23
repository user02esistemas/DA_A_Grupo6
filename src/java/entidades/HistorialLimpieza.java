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
@Table(name = "HistorialLimpieza", catalog = "BdHotelOasis2", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "HistorialLimpieza.findAll", query = "SELECT h FROM HistorialLimpieza h"),
    @NamedQuery(name = "HistorialLimpieza.findByIdLimpieza", query = "SELECT h FROM HistorialLimpieza h WHERE h.idLimpieza = :idLimpieza"),
    @NamedQuery(name = "HistorialLimpieza.findByEstadoLimpieza", query = "SELECT h FROM HistorialLimpieza h WHERE h.estadoLimpieza = :estadoLimpieza"),
    @NamedQuery(name = "HistorialLimpieza.findByFechaHoraInicio", query = "SELECT h FROM HistorialLimpieza h WHERE h.fechaHoraInicio = :fechaHoraInicio"),
    @NamedQuery(name = "HistorialLimpieza.findByFechaHoraFin", query = "SELECT h FROM HistorialLimpieza h WHERE h.fechaHoraFin = :fechaHoraFin"),
    @NamedQuery(name = "HistorialLimpieza.findByObservaciones", query = "SELECT h FROM HistorialLimpieza h WHERE h.observaciones = :observaciones")})
public class HistorialLimpieza implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idLimpieza", nullable = false)
    private Integer idLimpieza;
    @Basic(optional = false)
    @Column(name = "estadoLimpieza", nullable = false, length = 30)
    private String estadoLimpieza;
    @Basic(optional = false)
    @Column(name = "fechaHoraInicio", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaHoraInicio;
    @Column(name = "fechaHoraFin")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaHoraFin;
    @Column(name = "observaciones", length = 255)
    private String observaciones;
    @JoinColumn(name = "idEmpleado", referencedColumnName = "idEmpleado", nullable = false)
    @ManyToOne(optional = false)
    private Empleados idEmpleado;
    @JoinColumn(name = "idHabitacion", referencedColumnName = "idHabitacion", nullable = false)
    @ManyToOne(optional = false)
    private Habitaciones idHabitacion;

    public HistorialLimpieza() {
    }

    public HistorialLimpieza(Integer idLimpieza) {
        this.idLimpieza = idLimpieza;
    }

    public HistorialLimpieza(Integer idLimpieza, String estadoLimpieza, Date fechaHoraInicio) {
        this.idLimpieza = idLimpieza;
        this.estadoLimpieza = estadoLimpieza;
        this.fechaHoraInicio = fechaHoraInicio;
    }

    public Integer getIdLimpieza() {
        return idLimpieza;
    }

    public void setIdLimpieza(Integer idLimpieza) {
        this.idLimpieza = idLimpieza;
    }

    public String getEstadoLimpieza() {
        return estadoLimpieza;
    }

    public void setEstadoLimpieza(String estadoLimpieza) {
        this.estadoLimpieza = estadoLimpieza;
    }

    public Date getFechaHoraInicio() {
        return fechaHoraInicio;
    }

    public void setFechaHoraInicio(Date fechaHoraInicio) {
        this.fechaHoraInicio = fechaHoraInicio;
    }

    public Date getFechaHoraFin() {
        return fechaHoraFin;
    }

    public void setFechaHoraFin(Date fechaHoraFin) {
        this.fechaHoraFin = fechaHoraFin;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
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
        hash += (idLimpieza != null ? idLimpieza.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof HistorialLimpieza)) {
            return false;
        }
        HistorialLimpieza other = (HistorialLimpieza) object;
        if ((this.idLimpieza == null && other.idLimpieza != null) || (this.idLimpieza != null && !this.idLimpieza.equals(other.idLimpieza))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.HistorialLimpieza[ idLimpieza=" + idLimpieza + " ]";
    }
    
}
