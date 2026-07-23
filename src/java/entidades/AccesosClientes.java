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
@Table(name = "AccesosClientes", catalog = "BdHotelOasis2", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "AccesosClientes.findAll", query = "SELECT a FROM AccesosClientes a"),
    @NamedQuery(name = "AccesosClientes.findByIdAcceso", query = "SELECT a FROM AccesosClientes a WHERE a.idAcceso = :idAcceso"),
    @NamedQuery(name = "AccesosClientes.findByFechaRegistro", query = "SELECT a FROM AccesosClientes a WHERE a.fechaRegistro = :fechaRegistro"),
    @NamedQuery(name = "AccesosClientes.findByHoraEntrada", query = "SELECT a FROM AccesosClientes a WHERE a.horaEntrada = :horaEntrada"),
    @NamedQuery(name = "AccesosClientes.findByHoraSalida", query = "SELECT a FROM AccesosClientes a WHERE a.horaSalida = :horaSalida"),
    @NamedQuery(name = "AccesosClientes.findByMotivoVisita", query = "SELECT a FROM AccesosClientes a WHERE a.motivoVisita = :motivoVisita")})
public class AccesosClientes implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idAcceso", nullable = false)
    private Integer idAcceso;
    @Basic(optional = false)
    @Column(name = "fechaRegistro", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fechaRegistro;
    @Basic(optional = false)
    @Column(name = "horaEntrada", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date horaEntrada;
    @Column(name = "horaSalida")
    @Temporal(TemporalType.TIMESTAMP)
    private Date horaSalida;
    @Column(name = "motivoVisita", length = 150)
    private String motivoVisita;
    @JoinColumn(name = "idcliente", referencedColumnName = "idcliente", nullable = false)
    @ManyToOne(optional = false)
    private Clientes idcliente;

    public AccesosClientes() {
    }

    public AccesosClientes(Integer idAcceso) {
        this.idAcceso = idAcceso;
    }

    public AccesosClientes(Integer idAcceso, Date fechaRegistro, Date horaEntrada) {
        this.idAcceso = idAcceso;
        this.fechaRegistro = fechaRegistro;
        this.horaEntrada = horaEntrada;
    }

    public Integer getIdAcceso() {
        return idAcceso;
    }

    public void setIdAcceso(Integer idAcceso) {
        this.idAcceso = idAcceso;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
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

    public String getMotivoVisita() {
        return motivoVisita;
    }

    public void setMotivoVisita(String motivoVisita) {
        this.motivoVisita = motivoVisita;
    }

    public Clientes getIdcliente() {
        return idcliente;
    }

    public void setIdcliente(Clientes idcliente) {
        this.idcliente = idcliente;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idAcceso != null ? idAcceso.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AccesosClientes)) {
            return false;
        }
        AccesosClientes other = (AccesosClientes) object;
        if ((this.idAcceso == null && other.idAcceso != null) || (this.idAcceso != null && !this.idAcceso.equals(other.idAcceso))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.AccesosClientes[ idAcceso=" + idAcceso + " ]";
    }
    
}
