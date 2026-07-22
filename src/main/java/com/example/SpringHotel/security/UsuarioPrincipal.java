package com.example.SpringHotel.security;

import com.example.SpringHotel.entity.Usuario;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

/**
 * Envuelve a la entidad Usuario para que Spring Security pueda usarla como
 * principal de la sesión. Expone también el idEmpleado y el rol "limpio"
 * (sin el prefijo ROLE_) para poder mostrarlos en las vistas con
 * sec:authentication="principal.nombreRol", etc.
 */
public class UsuarioPrincipal implements UserDetails {

    private final Usuario usuario;

    public UsuarioPrincipal(Usuario usuario) {
        this.usuario = usuario;
    }

    public Integer getIdUsuario() {
        return usuario.getIdUsuario();
    }

    public Integer getIdEmpleado() {
        return usuario.getIdEmpleado();
    }

    /** Rol tal cual está en la BD (ADMIN, RECEPCIONISTA, LIMPIEZA), sin el prefijo ROLE_. */
    public String getNombreRol() {
        return usuario.getRolSistema();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + usuario.getRolSistema().toUpperCase()));
    }

    @Override
    public String getPassword() {
        return usuario.getPassword();
    }

    @Override
    public String getUsername() {
        return usuario.getUsername();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return usuario.isActivo();
    }
}
