package com.example.SpringHotel.security;

import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * La tabla Usuarios guarda las contraseñas en texto plano (VARCHAR 255, sin
 * hash). Este encoder simplemente compara el texto tal cual para no romper
 * los datos ya existentes en la base de datos.
 *
 * IMPORTANTE (para producción real): lo ideal sería migrar a BCrypt
 * (BCryptPasswordEncoder) y volver a registrar las contraseñas ya hasheadas.
 * Para este proyecto académico se deja en texto plano por simplicidad.
 */
public class PlainTextPasswordEncoder implements PasswordEncoder {

    @Override
    public String encode(CharSequence rawPassword) {
        return rawPassword.toString();
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }
        return rawPassword.toString().equals(encodedPassword);
    }
}
