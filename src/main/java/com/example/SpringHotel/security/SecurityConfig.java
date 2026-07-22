package com.example.SpringHotel.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Reglas de acceso del sistema:
 *
 *  - ADMIN         : acceso total (empleados, usuarios, tipos de habitación, finanzas, etc.)
 *  - RECEPCIONISTA : clientes, reservas, habitaciones, tipos de habitación y pagos (caja)
 *  - LIMPIEZA      : solo el estado de las habitaciones (ver y actualizar limpieza)
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    public static final String ROL_ADMIN = "ADMIN";
    public static final String ROL_RECEPCION = "RECEPCIONISTA";
    public static final String ROL_LIMPIEZA = "LIMPIEZA";

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new PlainTextPasswordEncoder();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider(CustomUserDetailsService userDetailsService,
                                                              PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder);
        return provider;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Las llamadas fetch() del frontend no envían token CSRF; se
            // desactiva solo para /api/** y se deja activo en el login.
            .csrf(csrf -> csrf.ignoringRequestMatchers("/api/**"))
            .authorizeHttpRequests(auth -> auth
                // Recursos públicos
                .requestMatchers("/login", "/css/**", "/js/**", "/images/**", "/webjars/**", "/favicon.ico").permitAll()

                // Empleados: Recepción solo puede CONSULTARLOS (los necesita para los
                // combos de Reservas y Pagos); crear/editar/eliminar es solo del Admin.
                .requestMatchers(HttpMethod.GET, "/api/empleados/**").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)
                .requestMatchers("/api/empleados/**").hasRole(ROL_ADMIN)

                // Solo Administrador
                .requestMatchers("/api/usuarios/**").hasRole(ROL_ADMIN)
                .requestMatchers("/finanzas-vista").hasRole(ROL_ADMIN)

                // Limpieza: únicamente puede ver y actualizar el estado de las habitaciones
                .requestMatchers(HttpMethod.GET, "/api/habitaciones/**").hasAnyRole(ROL_ADMIN, ROL_RECEPCION, ROL_LIMPIEZA)
                .requestMatchers(HttpMethod.PUT, "/api/habitaciones/**").hasAnyRole(ROL_ADMIN, ROL_RECEPCION, ROL_LIMPIEZA)
                .requestMatchers("/habitaciones-vista").hasAnyRole(ROL_ADMIN, ROL_RECEPCION, ROL_LIMPIEZA)
                .requestMatchers(HttpMethod.POST, "/api/habitaciones/**").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)
                .requestMatchers(HttpMethod.DELETE, "/api/habitaciones/**").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)

                // Recepción (y Administrador): clientes, reservas, tipos de habitación, pagos
                .requestMatchers("/checkin-vista").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)
                .requestMatchers("/api/clientes/**", "/clientes-vista").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)
                .requestMatchers("/api/reservas/**", "/reservas-vista").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)
                .requestMatchers("/api/tipohabitaciones/**", "/tipohabitacion-vista").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)
                .requestMatchers("/api/consulta-dni/**").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)
                .requestMatchers("/api/pagos/**", "/pagos-vista").hasAnyRole(ROL_ADMIN, ROL_RECEPCION)

                // Cualquier otra página requiere, como mínimo, estar logueado
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .successHandler(new RoleBasedAuthenticationSuccessHandler())
                .failureUrl("/login?error=1")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout=1")
                .permitAll()
            )
            .exceptionHandling(handling -> handling
                .accessDeniedPage("/login?sinPermiso=1")
            );

        return http.build();
    }
}
