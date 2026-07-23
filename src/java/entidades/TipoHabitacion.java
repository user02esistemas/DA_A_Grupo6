/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entidades;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 *
 * @author dzs-1
 */
@Entity
@Table(name = "TipoHabitacion", catalog = "BdHotelOasis2", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "TipoHabitacion.findAll", query = "SELECT t FROM TipoHabitacion t"),
    @NamedQuery(name = "TipoHabitacion.findByIdTipo", query = "SELECT t FROM TipoHabitacion t WHERE t.idTipo = :idTipo"),
    @NamedQuery(name = "TipoHabitacion.findByNombreTipo", query = "SELECT t FROM TipoHabitacion t WHERE t.nombreTipo = :nombreTipo"),
    @NamedQuery(name = "TipoHabitacion.findByPrecioPorNoche", query = "SELECT t FROM TipoHabitacion t WHERE t.precioPorNoche = :precioPorNoche"),
    @NamedQuery(name = "TipoHabitacion.findByCapacidadPersonas", query = "SELECT t FROM TipoHabitacion t WHERE t.capacidadPersonas = :capacidadPersonas")})
public class TipoHabitacion implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idTipo", nullable = false)
    private Integer idTipo;
    @Basic(optional = false)
    @Column(name = "nombreTipo", nullable = false, length = 50)
    private String nombreTipo;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @Column(name = "precioPorNoche", nullable = false, precision = 10, scale = 2)
    private BigDecimal precioPorNoche;
    @Basic(optional = false)
    @Column(name = "capacidadPersonas", nullable = false)
    private int capacidadPersonas;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "idTipo")
    private Collection<Habitaciones> habitacionesCollection;

    public TipoHabitacion() {
    }

    public TipoHabitacion(Integer idTipo) {
        this.idTipo = idTipo;
    }

    public TipoHabitacion(Integer idTipo, String nombreTipo, BigDecimal precioPorNoche, int capacidadPersonas) {
        this.idTipo = idTipo;
        this.nombreTipo = nombreTipo;
        this.precioPorNoche = precioPorNoche;
        this.capacidadPersonas = capacidadPersonas;
    }

    public Integer getIdTipo() {
        return idTipo;
    }

    public void setIdTipo(Integer idTipo) {
        this.idTipo = idTipo;
    }

    public String getNombreTipo() {
        return nombreTipo;
    }

    public void setNombreTipo(String nombreTipo) {
        this.nombreTipo = nombreTipo;
    }

    public BigDecimal getPrecioPorNoche() {
        return precioPorNoche;
    }

    public void setPrecioPorNoche(BigDecimal precioPorNoche) {
        this.precioPorNoche = precioPorNoche;
    }

    public int getCapacidadPersonas() {
        return capacidadPersonas;
    }

    public void setCapacidadPersonas(int capacidadPersonas) {
        this.capacidadPersonas = capacidadPersonas;
    }

    public Collection<Habitaciones> getHabitacionesCollection() {
        return habitacionesCollection;
    }

    public void setHabitacionesCollection(Collection<Habitaciones> habitacionesCollection) {
        this.habitacionesCollection = habitacionesCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idTipo != null ? idTipo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TipoHabitacion)) {
            return false;
        }
        TipoHabitacion other = (TipoHabitacion) object;
        if ((this.idTipo == null && other.idTipo != null) || (this.idTipo != null && !this.idTipo.equals(other.idTipo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.TipoHabitacion[ idTipo=" + idTipo + " ]";
    }
    
}
