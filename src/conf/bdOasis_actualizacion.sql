-- ==========================================================
-- ACTUALIZACIÓN DE BASE DE DATOS - SISTEMA DE LOGIN Y ROLES
-- Ejecutar DESPUÉS de bdOasis.txt (la BD ya debe existir)
-- ==========================================================
USE BdHotelOasis2;
GO

-- ==========================================================
-- 1. NUEVA TABLA: Incidencias (usada por el rol Seguridad)
-- ==========================================================
CREATE TABLE dbo.Incidencias (
    idIncidencia INT IDENTITY(1,1) NOT NULL,
    idEmpleado INT NOT NULL,               -- Personal de seguridad que registra
    fechaHora DATETIME NOT NULL CONSTRAINT DF_Incidencias_Fecha DEFAULT GETDATE(),
    tipoIncidencia VARCHAR(50) NOT NULL,   -- Ej: Robo, Ruido, Emergencia, Salud, Otro
    gravedad VARCHAR(20) NOT NULL CONSTRAINT DF_Incidencias_Gravedad DEFAULT 'Baja', -- Baja / Media / Alta
    descripcion VARCHAR(500) NOT NULL,
    lugar VARCHAR(100) NULL,
    estado VARCHAR(20) NOT NULL CONSTRAINT DF_Incidencias_Estado DEFAULT 'Abierta',  -- Abierta / Cerrada

    CONSTRAINT PK_Incidencias PRIMARY KEY CLUSTERED (idIncidencia),
    CONSTRAINT FK_Incidencias_Empleados FOREIGN KEY (idEmpleado)
        REFERENCES dbo.Empleados (idEmpleado) ON DELETE NO ACTION
);
GO

-- ==========================================================
-- 2. EMPLEADOS DE EJEMPLO (uno por cada rol del sistema)
--    OJO: si ya tienes empleados creados, omite este bloque
--    o ajusta los DNI para que no choquen con UQ_Empleados_dni
-- ==========================================================
INSERT INTO dbo.Empleados (nombre, apellido, rol, dni, telefono) VALUES
('Carlos',  'Vasquez',  'Gerente',        '10000001', '900000001'),
('Maria',   'Torres',   'Administrador',  '10000002', '900000002'),
('Lucia',   'Fernandez','Recepcionista',  '10000003', '900000003'),
('Pedro',   'Ramos',    'Limpieza',       '10000004', '900000004'),
('Jorge',   'Salazar',  'Seguridad',      '10000005', '900000005');
GO

-- ==========================================================
-- 3. USUARIOS DE ACCESO (login) PARA CADA EMPLEADO ANTERIOR
--    rolSistema debe ser EXACTAMENTE uno de:
--    GERENTE | ADMINISTRADOR | RECEPCIONISTA | LIMPIEZA | SEGURIDAD
--    Contraseña de ejemplo (texto plano) para cada uno: 12345
--    *** Cambien estas contraseñas antes de usar en producción ***
-- ==========================================================
INSERT INTO dbo.Usuarios (idEmpleado, username, password, rolSistema, activo)
SELECT idEmpleado, 'gerente',      '12345', 'GERENTE',       1 FROM dbo.Empleados WHERE dni = '10000001';
INSERT INTO dbo.Usuarios (idEmpleado, username, password, rolSistema, activo)
SELECT idEmpleado, 'administrador','12345', 'ADMINISTRADOR', 1 FROM dbo.Empleados WHERE dni = '10000002';
INSERT INTO dbo.Usuarios (idEmpleado, username, password, rolSistema, activo)
SELECT idEmpleado, 'recepcion',    '12345', 'RECEPCIONISTA', 1 FROM dbo.Empleados WHERE dni = '10000003';
INSERT INTO dbo.Usuarios (idEmpleado, username, password, rolSistema, activo)
SELECT idEmpleado, 'limpieza',     '12345', 'LIMPIEZA',      1 FROM dbo.Empleados WHERE dni = '10000004';
INSERT INTO dbo.Usuarios (idEmpleado, username, password, rolSistema, activo)
SELECT idEmpleado, 'seguridad',    '12345', 'SEGURIDAD',     1 FROM dbo.Empleados WHERE dni = '10000005';
GO
