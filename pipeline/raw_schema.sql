-- =========================================================
-- ESQUEMA OLTP / RAW STAGING: MoviGo (Managua, Nicaragua)
-- Database: raw (Schema: public)
-- =========================================================

CREATE TABLE zonas_urbanas (
    id_zona INT PRIMARY KEY,
    nombre_zona VARCHAR(100) NOT NULL,
    estrato_socioeconomico VARCHAR(20) NOT NULL CHECK (estrato_socioeconomico IN ('alto', 'medio', 'popular', 'comercial')),
    latitud DECIMAL(9,6) NOT NULL,
    longitud DECIMAL(9,6) NOT NULL,
    radio_cobertura_km DECIMAL(4,2) NOT NULL,
    tarifa_base_bajada_bandera DECIMAL(8,2) NOT NULL
);

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    metodo_pago_preferido VARCHAR(30) NOT NULL CHECK (metodo_pago_preferido IN ('efectivo', 'tarjeta', 'billetera_digital')),
    calificacion_promedio DECIMAL(3,2) NOT NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE conductores (
    id_conductor INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo_servicio VARCHAR(20) NOT NULL CHECK (tipo_servicio IN ('movigo_estandar', 'movigo_comfort', 'movigo_moto')),
    modelo_vehiculo VARCHAR(100) NOT NULL,
    anio_vehiculo INT NOT NULL,
    placa VARCHAR(20) NOT NULL,
    calificacion_promedio DECIMAL(3,2) NOT NULL,
    tasa_aceptacion_pct DECIMAL(4,2) NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('activo', 'inactivo', 'en_viaje', 'desconectado'))
);

CREATE TABLE campanas_incentivos (
    id_campana INT PRIMARY KEY,
    nombre_bono VARCHAR(100) NOT NULL,
    costo_presupuesto_nio DECIMAL(10,2) NOT NULL,
    incremento_horas_conexion DECIMAL(10,2) NOT NULL,
    tipo_incentivo VARCHAR(30) NOT NULL CHECK (tipo_incentivo IN ('meta_viajes', 'hora_pico_lluvia', 'zona_alta_demanda')),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('activa', 'finalizada'))
);

CREATE TABLE clima_cuadrantes (
    fecha DATE PRIMARY KEY,
    precipitacion_mm DECIMAL(6,2) NOT NULL,
    temperatura_c DECIMAL(4,1) NOT NULL,
    indice_congestion DECIMAL(4,2) NOT NULL,
    condicion_cielo VARCHAR(20) NOT NULL CHECK (condicion_cielo IN ('despejado', 'nublado', 'lluvia_ligera', 'tormenta'))
);

CREATE TABLE viajes (
    id_viaje INT PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id_usuario),
    id_conductor INT REFERENCES conductores(id_conductor),
    id_zona_origen INT NOT NULL REFERENCES zonas_urbanas(id_zona),
    id_zona_destino INT NOT NULL REFERENCES zonas_urbanas(id_zona),
    fecha_hora_solicitud TIMESTAMP NOT NULL,
    fecha_hora_inicio TIMESTAMP,
    fecha_hora_fin TIMESTAMP,
    distancia_km DECIMAL(6,2) NOT NULL CHECK (distancia_km >= 0),
    duracion_minutos DECIMAL(6,2) NOT NULL CHECK (duracion_minutos >= 0),
    tarifa_base DECIMAL(8,2) NOT NULL,
    multiplicador_dinamico DECIMAL(4,2) NOT NULL DEFAULT 1.00 CHECK (multiplicador_dinamico >= 1.00),
    tarifa_final DECIMAL(8,2) NOT NULL CHECK (tarifa_final >= 0),
    metodo_pago VARCHAR(30) NOT NULL CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'billetera_digital')),
    estado_viaje VARCHAR(25) NOT NULL CHECK (estado_viaje IN ('completado', 'cancelado_usuario', 'cancelado_conductor', 'no_asignado')),
    calificacion_usuario DECIMAL(3,2),
    calificacion_conductor DECIMAL(3,2),
    propina DECIMAL(8,2) NOT NULL DEFAULT 0.0,
    motivo_cancelacion TEXT
);

CREATE TABLE telemetria_conductores (
    id_telemetria INT PRIMARY KEY,
    id_conductor INT NOT NULL REFERENCES conductores(id_conductor),
    id_zona INT NOT NULL REFERENCES zonas_urbanas(id_zona),
    fecha_hora TIMESTAMP NOT NULL,
    latitud DECIMAL(9,6) NOT NULL,
    longitud DECIMAL(9,6) NOT NULL,
    velocidad_kmh DECIMAL(5,2) NOT NULL,
    estado_disponibilidad VARCHAR(30) NOT NULL CHECK (estado_disponibilidad IN ('disponible', 'ocupado', 'en_camino_recogida'))
);

CREATE TABLE auditoria_viajes (
    id_auditoria SERIAL PRIMARY KEY,
    id_viaje INT NOT NULL,
    estado_anterior VARCHAR(25),
    estado_nuevo VARCHAR(25),
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_db VARCHAR(50) NOT NULL DEFAULT CURRENT_USER
);

-- Indices analiticos
CREATE INDEX idx_viajes_solicitud ON viajes(fecha_hora_solicitud);
CREATE INDEX idx_viajes_origen ON viajes(id_zona_origen);
CREATE INDEX idx_viajes_destino ON viajes(id_zona_destino);
CREATE INDEX idx_viajes_conductor ON viajes(id_conductor);
CREATE INDEX idx_telemetria_conductor ON telemetria_conductores(id_conductor);
