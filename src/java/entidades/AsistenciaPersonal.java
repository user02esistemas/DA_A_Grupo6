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
@Table(name = "AsistenciaPersonal", catalog = "BdHotelOasis2", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "AsistenciaPersonal.findAll", query = "SELECT a FROM AsistenciaPersonal a"),
    @NamedQuery(name = "AsistenciaPersonal.findByIdAsistencia", query = "SELECT a FROM AsistenciaPersonal a WHERE a.idAsistencia = :idAsistencia"),
    @NamedQuery(name = "AsistenciaPersonal.findByFecha", query = "SELECT a FROM AsistenciaPersonal a WHERE a.fecha = :fecha"),
    @NamedQuery(name = "AsistenciaPersonal.findByHoraEntrada", query = "SELECT a FROM AsistenciaPersonal a WHERE a.horaEntrada = :horaEntrada"),
    @NamedQuery(name = "AsistenciaPersonal.findByHoraSalida", query = "SELECT a FROM AsistenciaPersonal a WHERE a.horaSalida = :horaSalida"),
    @NamedQuery(name = "AsistenciaPersonal.findByObservaciones", query = "SELECT a FROM AsistenciaPersonal a WHERE a.observaciones = :observaciones")})
public class AsistenciaPersonal implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idAsistencia", nullable = false)
    private Integer idAsistencia;
    @Basic(optional = false)
    @Column(name = "fecha", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fecha;
    @Basic(optional = false)
    @Column(name = "horaEntrada", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date horaEntrada;
    @Column(name = "horaSalida")
    @Temporal(TemporalType.TIMESTAMP)
    private Date horaSalida;
    @Column(name = "observaciones", length = 255)
    private String observaciones;
    @JoinColumn(name = "idEmpleado", referencedColumnName = "idEmpleado", nullable = false)
    @ManyToOne(optional = false)
    private Empleados idEmpleado;

    public AsistenciaPersonal() {
    }

    public AsistenciaPersonal(Integer idAsistencia) {
        this.idAsistencia = idAsistencia;
    }

    public AsistenciaPersonal(Integer idAsistencia, Date fecha, Date horaEntrada) {
        this.idAsistencia = idAsistencia;
        this.fecha = fecha;
        this.horaEntrada = horaEntrada;
    }

    public Integer getIdAsistencia() {
        return idAsistencia;
    }

    public void setIdAsistencia(Integer idAsistencia) {
        this.idAsistencia = idAsistencia;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public Date getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(Date horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public Date getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(Date horaSalida) {
        this.horaSalida = horaSalida;
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

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idAsistencia != null ? idAsistencia.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AsistenciaPersonal)) {
            return false;
        }
        AsistenciaPersonal other = (AsistenciaPersonal) object;
        if ((this.idAsistencia == null && other.idAsistencia != null) || (this.idAsistencia != null && !this.idAsistencia.equals(other.idAsistencia))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.AsistenciaPersonal[ idAsistencia=" + idAsistencia + " ]";
    }
    
}
