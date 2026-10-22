-- =========================================================
-- ESQUEMA OLTP / RAW STAGING: Antojitos Express (Managua, Nicaragua)
-- =========================================================

DROP TABLE IF EXISTS detalle_ordenes CASCADE;
DROP TABLE IF EXISTS ordenes CASCADE;
DROP TABLE IF EXISTS clima_diario CASCADE;
DROP TABLE IF EXISTS promociones CASCADE;
DROP TABLE IF EXISTS platillos CASCADE;
DROP TABLE IF EXISTS categorias_platillo CASCADE;
DROP TABLE IF EXISTS repartidores CASCADE;
DROP TABLE IF EXISTS zonas CASCADE;

CREATE TABLE zonas (
    id_zona INT PRIMARY KEY,
    nombre_zona VARCHAR(100) NOT NULL,
    latitud DECIMAL(9,6) NOT NULL,
    longitud DECIMAL(9,6) NOT NULL,
    distancia_km DECIMAL(5,2) NOT NULL,
    tiempo_base_minutos INT NOT NULL,
    tarifa_envio_base DECIMAL(8,2) NOT NULL
);

CREATE TABLE repartidores (
    id_repartidor INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo_vehiculo VARCHAR(20) NOT NULL CHECK (tipo_vehiculo IN ('moto', 'bicicleta', 'auto')),
    calificacion_promedio DECIMAL(3,2) NOT NULL,
    capacidad_maxima_ordenes INT NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('activo', 'inactivo', 'descanso'))
);

CREATE TABLE categorias_platillo (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    margen_contribucion_pct DECIMAL(4,2) NOT NULL
);

CREATE TABLE platillos (
    id_platillo INT PRIMARY KEY,
    id_categoria INT NOT NULL REFERENCES categorias_platillo(id_categoria),
    nombre_platillo VARCHAR(100) NOT NULL,
    precio_unitario DECIMAL(8,2) NOT NULL CHECK (precio_unitario > 0),
    costo_ingredientes DECIMAL(8,2) NOT NULL CHECK (costo_ingredientes > 0),
    tiempo_preparacion_minutos DECIMAL(4,1) NOT NULL,
    requiere_horno BOOLEAN NOT NULL DEFAULT FALSE,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE promociones (
    id_promocion INT PRIMARY KEY,
    nombre_campana VARCHAR(100) NOT NULL,
    costo_campana DECIMAL(10,2) NOT NULL,
    retorno_esperado DECIMAL(10,2) NOT NULL,
    descuento_pct DECIMAL(4,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

CREATE TABLE clima_diario (
    fecha DATE PRIMARY KEY,
    precipitacion_mm DECIMAL(6,2) NOT NULL,
    temperatura_c DECIMAL(4,1) NOT NULL,
    condicion_cielo VARCHAR(20) NOT NULL CHECK (condicion_cielo IN ('despejado', 'lluvia_ligera', 'tormenta', 'nublado'))
);

CREATE TABLE ordenes (
    id_orden INT PRIMARY KEY,
    id_zona INT NOT NULL REFERENCES zonas(id_zona),
    id_repartidor INT REFERENCES repartidores(id_repartidor),
    id_promocion INT REFERENCES promociones(id_promocion),
    fecha_hora_creacion TIMESTAMP NOT NULL,
    fecha_hora_entrega TIMESTAMP,
    metodo_pago VARCHAR(20) NOT NULL CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'billetera_digital')),
    estado_orden VARCHAR(20) NOT NULL CHECK (estado_orden IN ('entregada', 'cancelada', 'en_camino', 'preparando')),
    total_orden DECIMAL(10,2) NOT NULL CHECK (total_orden >= 0),
    costo_envio DECIMAL(8,2) NOT NULL CHECK (costo_envio >= 0),
    propina DECIMAL(8,2) NOT NULL DEFAULT 0.0 CHECK (propina >= 0),
    notas_entrega TEXT,
    comentario_cliente TEXT,
    motivo_cancelacion TEXT
);

CREATE TABLE detalle_ordenes (
    id_detalle INT PRIMARY KEY,
    id_orden INT NOT NULL REFERENCES ordenes(id_orden) ON DELETE CASCADE,
    id_platillo INT NOT NULL REFERENCES platillos(id_platillo),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(8,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
);


