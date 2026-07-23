/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entidades;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.UniqueConstraint;

/**
 *
 * @author dzs-1
 */
@Entity
@Table(name = "Habitaciones", catalog = "BdHotelOasis2", schema = "dbo", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"numeroHabitacion"})})
@NamedQueries({
    @NamedQuery(name = "Habitaciones.findAll", query = "SELECT h FROM Habitaciones h"),
    @NamedQuery(name = "Habitaciones.findByIdHabitacion", query = "SELECT h FROM Habitaciones h WHERE h.idHabitacion = :idHabitacion"),
    @NamedQuery(name = "Habitaciones.findByNumeroHabitacion", query = "SELECT h FROM Habitaciones h WHERE h.numeroHabitacion = :numeroHabitacion"),
    @NamedQuery(name = "Habitaciones.findByPiso", query = "SELECT h FROM Habitaciones h WHERE h.piso = :piso"),
    @NamedQuery(name = "Habitaciones.findByEstadoDisponibilidad", query = "SELECT h FROM Habitaciones h WHERE h.estadoDisponibilidad = :estadoDisponibilidad"),
    @NamedQuery(name = "Habitaciones.findByEstadoLimpieza", query = "SELECT h FROM Habitaciones h WHERE h.estadoLimpieza = :estadoLimpieza"),
    @NamedQuery(name = "Habitaciones.findByFecharegistro", query = "SELECT h FROM Habitaciones h WHERE h.fecharegistro = :fecharegistro"),
    @NamedQuery(name = "Habitaciones.findByActivo", query = "SELECT h FROM Habitaciones h WHERE h.activo = :activo")})
public class Habitaciones implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idHabitacion", nullable = false)
    private Integer idHabitacion;
    @Basic(optional = false)
    @Column(name = "numeroHabitacion", nullable = false, length = 10)
    private String numeroHabitacion;
    @Basic(optional = false)
    @Column(name = "piso", nullable = false)
    private int piso;
    @Basic(optional = false)
    @Column(name = "estadoDisponibilidad", nullable = false, length = 30)
    private String estadoDisponibilidad;
    @Basic(optional = false)
    @Column(name = "estadoLimpieza", nullable = false, length = 30)
    private String estadoLimpieza;
    @Basic(optional = false)
    @Column(name = "fecharegistro", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fecharegistro;
    @Basic(optional = false)
    @Column(name = "activo", nullable = false)
    private boolean activo;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "idHabitacion")
    private Collection<HistorialLimpieza> historialLimpiezaCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "idHabitacion")
    private Collection<Reservas> reservasCollection;
    @JoinColumn(name = "idTipo", referencedColumnName = "idTipo", nullable = false)
    @ManyToOne(optional = false)
    private TipoHabitacion idTipo;

    public Habitaciones() {
    }

    public Habitaciones(Integer idHabitacion) {
        this.idHabitacion = idHabitacion;
    }

    public Habitaciones(Integer idHabitacion, String numeroHabitacion, int piso, String estadoDisponibilidad, String estadoLimpieza, Date fecharegistro, boolean activo) {
        this.idHabitacion = idHabitacion;
        this.numeroHabitacion = numeroHabitacion;
        this.piso = piso;
        this.estadoDisponibilidad = estadoDisponibilidad;
        this.estadoLimpieza = estadoLimpieza;
        this.fecharegistro = fecharegistro;
        this.activo = activo;
    }

    public Integer getIdHabitacion() {
        return idHabitacion;
    }

    public void setIdHabitacion(Integer idHabitacion) {
        this.idHabitacion = idHabitacion;
    }

    public String getNumeroHabitacion() {
        return numeroHabitacion;
    }

    public void setNumeroHabitacion(String numeroHabitacion) {
        this.numeroHabitacion = numeroHabitacion;
    }

    public int getPiso() {
        return piso;
    }

    public void setPiso(int piso) {
        this.piso = piso;
    }

    public String getEstadoDisponibilidad() {
        return estadoDisponibilidad;
    }

    public void setEstadoDisponibilidad(String estadoDisponibilidad) {
        this.estadoDisponibilidad = estadoDisponibilidad;
    }

    public String getEstadoLimpieza() {
        return estadoLimpieza;
    }

    public void setEstadoLimpieza(String estadoLimpieza) {
        this.estadoLimpieza = estadoLimpieza;
    }

    public Date getFecharegistro() {
        return fecharegistro;
    }

    public void setFecharegistro(Date fecharegistro) {
        this.fecharegistro = fecharegistro;
    }

    public boolean getActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public Collection<HistorialLimpieza> getHistorialLimpiezaCollection() {
        return historialLimpiezaCollection;
    }

    public void setHistorialLimpiezaCollection(Collection<HistorialLimpieza> historialLimpiezaCollection) {
        this.historialLimpiezaCollection = historialLimpiezaCollection;
    }

    public Collection<Reservas> getReservasCollection() {
        return reservasCollection;
    }

    public void setReservasCollection(Collection<Reservas> reservasCollection) {
        this.reservasCollection = reservasCollection;
    }

    public TipoHabitacion getIdTipo() {
        return idTipo;
    }

    public void setIdTipo(TipoHabitacion idTipo) {
        this.idTipo = idTipo;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idHabitacion != null ? idHabitacion.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Habitaciones)) {
            return false;
        }
        Habitaciones other = (Habitaciones) object;
        if ((this.idHabitacion == null && other.idHabitacion != null) || (this.idHabitacion != null && !this.idHabitacion.equals(other.idHabitacion))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.Habitaciones[ idHabitacion=" + idHabitacion + " ]";
    }
    
}
