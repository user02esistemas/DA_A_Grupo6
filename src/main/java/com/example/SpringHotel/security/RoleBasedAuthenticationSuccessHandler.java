package com.example.SpringHotel.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;

import java.io.IOException;

/**
 * Al iniciar sesión, cada rol cae en el módulo que más usa:
 *  - ADMIN / RECEPCIONISTA -> Reservas (pantalla operativa principal)
 *  - LIMPIEZA              -> Habitaciones (para ver/actualizar el estado de limpieza)
 */
public class RoleBasedAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                         Authentication authentication) throws IOException, ServletException {

        boolean esLimpieza = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(rol -> rol.equals("ROLE_LIMPIEZA"));

        String destino = esLimpieza ? "/habitaciones-vista" : "/reservas-vista";
        getRedirectStrategy().sendRedirect(request, response, destino);
    }
}
