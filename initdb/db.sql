CREATE DATABASE IF NOT EXISTS AranGes;
USE AranGes;

-- Crear la tabla de roles
CREATE TABLE roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Insertar los roles 'admin' y 'user'
INSERT INTO roles (nombre) VALUES ('admin'), ('user');

-- Crear la tabla de usuarios
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON DELETE SET NULL
);

-- Crear la tabla de trabajadores
CREATE TABLE trabajadores (
    id_trabajador INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    kilos DECIMAL(10,4),
    id_usuario INT,
    ganancia DECIMAL(10,2),
    precio_por_kilo DECIMAL(10,2),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

-- Crear la tabla de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

-- Crear la tabla de producciones
CREATE TABLE producciones (
    id_produccion INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    anio YEAR NOT NULL,
    totalKilos DECIMAL(10,4),
    totalGanancias DECIMAL(10,2),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

-- Crear la tabla de abonos
CREATE TABLE abonos (
    id_abono INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    nombre VARCHAR(100) NOT NULL,
    cantidad DECIMAL(10,4),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

-- Crear la tabla de productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla de ventas
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_usuario INT,
    id_producto INT,
    fecha DATE NOT NULL,
    cantidad DECIMAL(10,4) NOT NULL,
    ganancia DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE SET NULL
);

-- Crear la tabla de encargos
CREATE TABLE encargos (
    id_encargo INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_usuario INT,
    id_producto INT,
    cantidad DECIMAL(10,4) NOT NULL,
    fechaPrevista DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE SET NULL
);

-- Crear la tabla de recogidas
CREATE TABLE recogidas (
    id_recogida INT PRIMARY KEY AUTO_INCREMENT,
    fecha_recogida DATETIME,
    kilos DECIMAL(10,4),
    id_trabajador INT,
    FOREIGN KEY (id_trabajador) REFERENCES trabajadores(id_trabajador) ON DELETE SET NULL
);

-- Insertar usuario de prueba con rol 'user'
INSERT INTO usuarios (nombre, correo, contrasena, id_rol)
VALUES ('Prueba', 'prueba@example.com', 'password123', (SELECT id_rol FROM roles WHERE nombre = 'user'));

-- Insertar administrador llamado Hugo con rol 'admin'
INSERT INTO usuarios (nombre, correo, contrasena, id_rol)
VALUES ('Hugo', 'hugo@example.com', 'adminpass', (SELECT id_rol FROM roles WHERE nombre = 'admin'));
SET @last_user_id = LAST_INSERT_ID();

ALTER TABLE `AranGes`.`producto_encargo` 
CHANGE COLUMN `cantidad` `cantidad` DECIMAL(10,4) NULL ;

ALTER TABLE `AranGes`.`encargos` 
DROP COLUMN `fecha_prevista`,
CHANGE COLUMN `fechaPrevista` `fecha_prevista` DATE NOT NULL ;