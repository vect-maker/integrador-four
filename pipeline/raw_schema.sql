-- =========================================================
-- ESQUEMA OLTP / RAW STAGING: MoviGo (Managua, Nicaragua)
-- Database: postgres (Schema: raw)
-- Versión 3.5.0: Arquitectura 3NF Normalizada
-- =========================================================

CREATE SCHEMA IF NOT EXISTS raw;
SET search_path TO raw, public;

CREATE TABLE IF NOT EXISTS urban_zones (
    zone_id INT PRIMARY KEY,
    zone_name VARCHAR(100) NOT NULL,
    socioeconomic_stratum VARCHAR(20) NOT NULL CHECK (socioeconomic_stratum IN ('alto', 'medio', 'popular', 'comercial')),
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    coverage_radius_km DECIMAL(4,2) NOT NULL,
    base_flag_drop_fare DECIMAL(8,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS quadrants (
    quadrant_id INT PRIMARY KEY,
    zone_id INT NOT NULL REFERENCES urban_zones(zone_id),
    quadrant_code VARCHAR(30) NOT NULL UNIQUE,
    quadrant_name VARCHAR(120) NOT NULL,
    grid_row INT NOT NULL,
    grid_col INT NOT NULL,
    lat_min DECIMAL(9,6) NOT NULL,
    lat_max DECIMAL(9,6) NOT NULL,
    lon_min DECIMAL(9,6) NOT NULL,
    lon_max DECIMAL(9,6) NOT NULL,
    mean_altitude_masl INT NOT NULL,
    flood_risk VARCHAR(20) NOT NULL CHECK (flood_risk IN ('bajo', 'medio', 'alto', 'critico')),
    main_drainage_channels VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS drainage_channels (
    channel_id INT PRIMARY KEY,
    channel_name VARCHAR(120) NOT NULL,
    zone_id INT NOT NULL REFERENCES urban_zones(zone_id),
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    critical_radius_km DECIMAL(4,2) NOT NULL,
    vulnerability_level VARCHAR(20) NOT NULL CHECK (vulnerability_level IN ('bajo', 'medio', 'alto', 'critico')),
    flow_direction VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    preferred_payment_method VARCHAR(30) NOT NULL CHECK (preferred_payment_method IN ('efectivo', 'tarjeta', 'billetera_digital')),
    average_rating DECIMAL(3,2) NOT NULL,
    registration_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS drivers (
    driver_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    average_rating DECIMAL(3,2) NOT NULL,
    acceptance_rate_pct DECIMAL(4,2) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('activo', 'inactivo', 'en_viaje', 'desconectado'))
);

CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id INT PRIMARY KEY,
    driver_id INT NOT NULL UNIQUE REFERENCES drivers(driver_id),
    service_type VARCHAR(20) NOT NULL CHECK (service_type IN ('movigo_estandar', 'movigo_comfort', 'movigo_moto')),
    vehicle_model VARCHAR(100) NOT NULL,
    vehicle_year INT NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    fuel_type VARCHAR(25) NOT NULL DEFAULT 'gasolina_regular' CHECK (fuel_type IN ('gasolina_regular', 'gasolina_super', 'diesel')),
    fuel_efficiency_km_l DECIMAL(5,2) NOT NULL DEFAULT 13.50,
    initial_odometer_km DECIMAL(9,2) NOT NULL DEFAULT 35000.00
);

CREATE TABLE IF NOT EXISTS incentive_campaigns (
    campaign_id INT PRIMARY KEY,
    target_zone_id INT NOT NULL REFERENCES urban_zones(zone_id),
    bonus_name VARCHAR(100) NOT NULL,
    budget_cost_nio DECIMAL(10,2) NOT NULL,
    online_hours_increase DECIMAL(10,2) NOT NULL,
    incentive_type VARCHAR(30) NOT NULL CHECK (incentive_type IN ('meta_viajes', 'hora_pico_lluvia', 'zona_alta_demanda')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('activa', 'finalizada'))
);

CREATE TABLE IF NOT EXISTS quadrant_weather (
    weather_id INT PRIMARY KEY,
    quadrant_id INT NOT NULL REFERENCES quadrants(quadrant_id),
    recorded_at TIMESTAMP NOT NULL,
    date DATE NOT NULL,
    hour INT NOT NULL CHECK (hour BETWEEN 0 AND 23),
    precipitation_mm DECIMAL(6,2) NOT NULL,
    channel_runoff_mm DECIMAL(6,2) NOT NULL,
    temperature_c DECIMAL(4,1) NOT NULL,
    congestion_index DECIMAL(4,2) NOT NULL,
    flooded_roads BOOLEAN NOT NULL DEFAULT FALSE,
    sky_condition VARCHAR(20) NOT NULL CHECK (sky_condition IN ('despejado', 'nublado', 'lluvia_ligera', 'tormenta'))
);

CREATE TABLE IF NOT EXISTS trips (
    trip_id INT PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    driver_id INT REFERENCES drivers(driver_id),
    origin_quadrant_id INT NOT NULL REFERENCES quadrants(quadrant_id),
    destination_quadrant_id INT NOT NULL REFERENCES quadrants(quadrant_id),
    origin_latitude DECIMAL(9,6) NOT NULL,
    origin_longitude DECIMAL(9,6) NOT NULL,
    destination_latitude DECIMAL(9,6) NOT NULL,
    destination_longitude DECIMAL(9,6) NOT NULL,
    requested_at TIMESTAMP NOT NULL,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    distance_km DECIMAL(6,2) NOT NULL CHECK (distance_km >= 0),
    duration_minutes DECIMAL(6,2) NOT NULL CHECK (duration_minutes >= 0),
    trip_status VARCHAR(25) NOT NULL CHECK (trip_status IN ('completado', 'cancelado_usuario', 'cancelado_conductor', 'no_asignado'))
);

CREATE TABLE IF NOT EXISTS trip_payments (
    payment_id INT PRIMARY KEY,
    trip_id INT NOT NULL UNIQUE REFERENCES trips(trip_id),
    payment_method VARCHAR(30) NOT NULL CHECK (payment_method IN ('efectivo', 'tarjeta', 'billetera_digital')),
    base_fare DECIMAL(8,2) NOT NULL CHECK (base_fare >= 0),
    surge_multiplier DECIMAL(4,2) NOT NULL DEFAULT 1.00 CHECK (surge_multiplier >= 1.00),
    tip_amount DECIMAL(8,2) NOT NULL DEFAULT 0.0 CHECK (tip_amount >= 0),
    final_fare DECIMAL(8,2) NOT NULL CHECK (final_fare >= 0),
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('pagado', 'anulado'))
);

CREATE TABLE IF NOT EXISTS trip_ratings (
    rating_id INT PRIMARY KEY,
    trip_id INT NOT NULL UNIQUE REFERENCES trips(trip_id),
    user_rating DECIMAL(3,2) NOT NULL CHECK (user_rating BETWEEN 1.0 AND 5.0),
    driver_rating DECIMAL(3,2) NOT NULL CHECK (driver_rating BETWEEN 1.0 AND 5.0)
);

CREATE TABLE IF NOT EXISTS trip_cancellations (
    cancellation_id INT PRIMARY KEY,
    trip_id INT NOT NULL UNIQUE REFERENCES trips(trip_id),
    cancelled_by VARCHAR(20) NOT NULL CHECK (cancelled_by IN ('usuario', 'conductor')),
    cancellation_reason TEXT NOT NULL,
    wait_time_minutes DECIMAL(6,2) NOT NULL CHECK (wait_time_minutes >= 0),
    origin_active_requests INT NOT NULL CHECK (origin_active_requests >= 1),
    origin_available_drivers INT NOT NULL CHECK (origin_available_drivers >= 1)
);

CREATE TABLE IF NOT EXISTS driver_telemetry (
    telemetry_id INT PRIMARY KEY,
    driver_id INT NOT NULL REFERENCES drivers(driver_id),
    trip_id INT REFERENCES trips(trip_id),
    quadrant_id INT NOT NULL REFERENCES quadrants(quadrant_id),
    recorded_at TIMESTAMP NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    speed_kmh DECIMAL(5,2) NOT NULL,
    availability_status VARCHAR(30) NOT NULL CHECK (availability_status IN ('disponible', 'ocupado', 'en_camino_recogida', 'descanso'))
);

CREATE TABLE IF NOT EXISTS vehicle_maintenance (
    maintenance_id INT PRIMARY KEY,
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id),
    service_date DATE NOT NULL,
    maintenance_type VARCHAR(25) NOT NULL CHECK (maintenance_type IN ('preventivo', 'correctivo')),
    odometer_km DECIMAL(9,2) NOT NULL,
    description TEXT NOT NULL,
    cost_nio DECIMAL(10,2) NOT NULL,
    downtime_hours DECIMAL(4,1) NOT NULL,
    workshop_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS simulation_clock (
    clock_id INT PRIMARY KEY DEFAULT 1,
    earliest_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    latest_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    current_status VARCHAR(30) NOT NULL DEFAULT 'ready' CHECK (current_status IN ('ready', 'catching_up', 'hourly_wait')),
    total_hours_simulated INT NOT NULL DEFAULT 0,
    total_trips_simulated BIGINT NOT NULL DEFAULT 0,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_single_clock_row CHECK (clock_id = 1)
);

CREATE TABLE IF NOT EXISTS trip_audit_logs (
    audit_id SERIAL PRIMARY KEY,
    trip_id INT NOT NULL,
    previous_status VARCHAR(25),
    new_status VARCHAR(25),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    db_user VARCHAR(50) NOT NULL DEFAULT CURRENT_USER
);
