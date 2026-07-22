USE [master]
GO

-- 1. CREAR LA BASE DE DATOS (deja que SQL Server elija la ruta por defecto)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'BdHotelOasis')
BEGIN
    CREATE DATABASE [BdHotelOasis];
END
GO

USE [BdHotelOasis]
GO

-- 2. TABLA: clientes
CREATE TABLE [dbo].[clientes](
	[idcliente] [int] IDENTITY(1,1) NOT NULL,
	[dni_ruc] [varchar](15) NOT NULL,
	[nombres] [varchar](100) NOT NULL,
	[apellidos] [varchar](100) NOT NULL,
	[telefono] [varchar](15) NULL,
	[email] [varchar](100) NULL,
	[estado] [varchar](20) NULL DEFAULT ('Activo'),
	PRIMARY KEY CLUSTERED ([idcliente] ASC),
	UNIQUE NONCLUSTERED ([dni_ruc] ASC)
);
GO

-- 3. TABLA: Empleados
CREATE TABLE [dbo].[Empleados](
	[idEmpleado] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[apellido] [varchar](100) NOT NULL,
	[rol] [varchar](50) NOT NULL DEFAULT ('Cuartelero'),
	[dni] [varchar](20) NULL,
	[telefono] [varchar](20) NULL,
	PRIMARY KEY CLUSTERED ([idEmpleado] ASC)
);
GO

-- 4. TABLA: TipoHabitacion
CREATE TABLE [dbo].[TipoHabitacion](
	[idTipo] [int] IDENTITY(1,1) NOT NULL,
	[nombreTipo] [varchar](50) NOT NULL,
	[precioPorNoche] [decimal](10, 2) NOT NULL,
	[capacidadPersonas] [int] NOT NULL DEFAULT ((2)),
	PRIMARY KEY CLUSTERED ([idTipo] ASC),
	UNIQUE NONCLUSTERED ([nombreTipo] ASC)
);
GO

-- 5. TABLA: Habitaciones
CREATE TABLE [dbo].[Habitaciones](
	[idHabitacion] [int] IDENTITY(1,1) NOT NULL,
	[numeroHabitacion] [varchar](10) NOT NULL,
	[piso] [int] NOT NULL,
	[idTipo] [int] NOT NULL,
	[estadoDisponibilidad] [varchar](20) NOT NULL DEFAULT ('Disponible'),
	[estadoLimpieza] [varchar](20) NOT NULL DEFAULT ('Limpio'),
	[fechaRegistro] [datetime] NOT NULL DEFAULT (getdate()),
	[activo] [bit] NOT NULL DEFAULT ((1)),
	PRIMARY KEY CLUSTERED ([idHabitacion] ASC),
	UNIQUE NONCLUSTERED ([numeroHabitacion] ASC),
	CONSTRAINT [FK_Habitaciones_Tipo] FOREIGN KEY([idTipo]) REFERENCES [dbo].[TipoHabitacion] ([idTipo])
);
GO

-- 6. TABLA: HistorialLimpieza
CREATE TABLE [dbo].[HistorialLimpieza](
	[idLimpieza] [int] IDENTITY(1,1) NOT NULL,
	[idHabitacion] [int] NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[estadoLimpieza] [varchar](20) NOT NULL DEFAULT ('En Proceso'),
	[fechaHoraInicio] [datetime] NOT NULL DEFAULT (getdate()),
	[fechaHoraFin] [datetime] NULL,
	[observaciones] [varchar](255) NULL,
	PRIMARY KEY CLUSTERED ([idLimpieza] ASC),
	CONSTRAINT [FK_Limpieza_Empleado] FOREIGN KEY([idEmpleado]) REFERENCES [dbo].[Empleados] ([idEmpleado]),
	CONSTRAINT [FK_Limpieza_Habitacion] FOREIGN KEY([idHabitacion]) REFERENCES [dbo].[Habitaciones] ([idHabitacion])
);
GO

-- 7. TABLA: Reservas
CREATE TABLE [dbo].[Reservas](
	[idReserva] [int] IDENTITY(1,1) NOT NULL,
	[id_cliente] [int] NOT NULL,
	[idHabitacion] [int] NOT NULL,
	[idEmpleado] [int] NULL,
	[fechaCheckIn] [datetime] NOT NULL DEFAULT (getdate()),
	[fechaCheckOutEsperada] [datetime] NOT NULL DEFAULT (getdate()),
	[estadoReserva] [varchar](20) NOT NULL DEFAULT ('Activa'),
	[fechaCheckOutReal] [datetime2](7) NULL,
	PRIMARY KEY CLUSTERED ([idReserva] ASC),
	CONSTRAINT [FK_Reservas_Clientes] FOREIGN KEY([id_cliente]) REFERENCES [dbo].[clientes] ([idcliente]) ON DELETE CASCADE,
	CONSTRAINT [FK_Reservas_Empleados] FOREIGN KEY([idEmpleado]) REFERENCES [dbo].[Empleados] ([idEmpleado]) ON DELETE SET NULL,
	CONSTRAINT [FK_Reservas_Habitaciones] FOREIGN KEY([idHabitacion]) REFERENCES [dbo].[Habitaciones] ([idHabitacion]) ON DELETE CASCADE
);
GO

-- 8. TABLA: Pago
CREATE TABLE [dbo].[Pago](
	[idPago] [int] IDENTITY(1,1) NOT NULL,
	[idReserva] [int] NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[monto] [decimal](10, 2) NOT NULL,
	[metodoPago] [varchar](30) NOT NULL,
	[fechaPago] [datetime] NOT NULL DEFAULT (getdate()),
	[estadoPago] [varchar](20) NOT NULL DEFAULT ('Confirmado'),
	[observaciones] [varchar](255) NULL,
	[nroOperacion] [varchar](30) NULL,
	CONSTRAINT [PK_Pago] PRIMARY KEY CLUSTERED ([idPago] ASC),
	CONSTRAINT [FK_Pago_Empleados] FOREIGN KEY([idEmpleado]) REFERENCES [dbo].[Empleados] ([idEmpleado]),
	CONSTRAINT [FK_Pago_Reservas] FOREIGN KEY([idReserva]) REFERENCES [dbo].[Reservas] ([idReserva]) ON DELETE CASCADE,
	CONSTRAINT [CK_Pago_Estado] CHECK ([estadoPago]='Anulado' OR [estadoPago]='Confirmado'),
	CONSTRAINT [CK_Pago_Metodo] CHECK ([metodoPago]='Plin' OR [metodoPago]='Yape' OR [metodoPago]='Transferencia' OR [metodoPago]='Tarjeta' OR [metodoPago]='Efectivo'),
	CONSTRAINT [CK_Pago_Monto] CHECK ([monto]>(0))
);
GO

-- Índice para optimizar búsquedas de pagos por reserva
CREATE NONCLUSTERED INDEX [IX_Pago_Reserva] ON [dbo].[Pago] ([idReserva] ASC);
GO

-- 9. TABLA: Usuarios
CREATE TABLE [dbo].[Usuarios](
	[idUsuario] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](255) NOT NULL,
	[rolSistema] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL DEFAULT ((1)),
	PRIMARY KEY CLUSTERED ([idUsuario] ASC),
	UNIQUE NONCLUSTERED ([username] ASC),
	CONSTRAINT [FK_Usuarios_Empleado] FOREIGN KEY([idEmpleado]) REFERENCES [dbo].[Empleados] ([idEmpleado])
);
GO
