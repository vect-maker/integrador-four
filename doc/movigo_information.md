# Guía de Acceso y Análisis Vía API: Caso 3 - MoviGo (Managua)

Este documento contiene la especificación integral del caso de transporte urbano por aplicación móvil **MoviGo** en Managua, diseñado para el estudiante que interactuará con el sistema de simulación sintética **única y exclusivamente mediante la API REST**, sin acceso directo al motor de base de datos relacional.

---

## 1. Contexto del Negocio y Variables de la Simulación

**MoviGo** opera servicios de transporte de pasajeros en el área metropolitana de **Managua, Nicaragua** mediante tres categorías: `movigo_estandar`, `movigo_comfort` y `movigo_moto`.

### Dinámica Urbana Modelada
1. **Puntos Críticos de Tráfico:** Corredores principales y rotondas viales propensas a embotellamientos en horas pico (*Metrocentro, Rotonda Centroamérica, Rotonda Rubén Darío, Pista Juan Pablo II*).
2. **Impacto de Precipitaciones:** Las lluvias torrenciales provocan escorrentías e inundaciones en cauces, reduciendo la velocidad promedio de circulación e incrementando la demanda de viajes.
3. **Tarifa Dinámica (*Surge Pricing*):** Multiplicador continuo ($1.00\times$ a $2.80\times$, con picos de tormenta de hasta $3.20\times$) que penaliza la congestión y equilibra oferta y demanda.
4. **Segmentación de Medios de Pago:** Probabilidades condicionadas por el estrato socioeconómico de la zona de origen del pasajero (`alto`, `medio`, `comercial`, `popular`), garantizando una correlación significativa ($\chi^2$, $p < 0.01$).

---

## 2. Especificación de la API REST (`/movigo`)

Todos los endpoints se encuentran expuestos bajo el prefijo `/movigo`. Todas las respuestas de listas emplean el envoltorio estándar `PaginatedResponse[T]`:

```json
{
  "items": [...],
  "count": 50,
  "total": 65000,
  "offset": 0,
  "limit": 50
}
```

> **Parámetros comunes de paginación:**
> - `offset` (int, ge=0, por defecto: `0`): Índice de desplazamiento inicial.
> - `limit` (int, ge=1, le=200, por defecto: `50`): Registros máximos por página (máximo permitido: 200).
> - `sort` (str): Permite prefijo `-` para orden descendente (ej. `-tarifa_final`, `fecha`).

---

### Endpoint 1: Cuadrantes Urbanos
`GET /movigo/zonas`

Lista los sectores y cuadrantes urbanos de Managua con tarifas base de bajada de bandera y coordenadas.

- **Parámetros de consulta (Query Params):**
  - `estrato` (*str, opcional*): Filtro por estrato socioeconómico (`alto`, `medio`, `popular`, `comercial`).
  - `sort` (*str, opcional*): Columnas permitidas: `id_zona`, `nombre_zona`, `estrato_socioeconomico`, `radio_cobertura_km`, `tarifa_base_bajada_bandera`.
- **Estructura del elemento (`ZonaUrbanaOut`):**
  - `id_zona` (*int*): Identificador único del cuadrante.
  - `nombre_zona` (*str*): Nombre comercial o referencia (ej. *Metrocentro*, *Villa Fontana*).
  - `estrato_socioeconomico` (*str*): `alto`, `medio`, `popular`, `comercial`.
  - `latitud` (*float*), `longitud` (*float*): Coordenadas en grados decimales (WGS84).
  - `radio_cobertura_km` (*float*): Radio de servicio en kilómetros.
  - `tarifa_base_bajada_bandera` (*float*): Tarifa inicial fija en Córdobas (NIO) (C$ 30.0 a C$ 90.0).

---

### Endpoint 2: Usuarios Pasajeros
`GET /movigo/usuarios`

Directorio de pasajeros registrados en la plataforma.

- **Parámetros de consulta:**
  - `metodo_pago` (*str, opcional*): `efectivo`, `tarjeta`, `billetera_digital`.
  - `sort` (*str, opcional*): Columnas permitidas: `id_usuario`, `nombre`, `metodo_pago_preferido`, `calificacion_promedio`, `fecha_registro`.
- **Estructura del elemento (`UsuarioOut`):**
  - `id_usuario` (*int*): ID único del usuario.
  - `nombre` (*str*): Nombre del pasajero.
  - `telefono` (*str*): Número de contacto.
  - `metodo_pago_preferido` (*str*): Método configurado habitualmente.
  - `calificacion_promedio` (*float*): Puntuación como pasajero (1.0 a 5.0).
  - `fecha_registro` (*date*): Fecha de registro (ISO: `YYYY-MM-DD`).

---

### Endpoint 3: Socios Conductores y Flota
`GET /movigo/conductores`

Flota de conductores registrados, tipo de vehículo y métricas de desempeño.

- **Parámetros de consulta:**
  - `tipo_servicio` (*str, opcional*): `movigo_estandar`, `movigo_comfort`, `movigo_moto`.
  - `estado` (*str, opcional*): `activo`, `inactivo`, `en_viaje`, `desconectado`.
  - `calificacion_min` (*float, opcional*): Filtro por calificación mínima (1.0 a 5.0).
  - `sort` (*str, opcional*): Columnas permitidas: `id_conductor`, `nombre`, `tipo_servicio`, `calificacion_promedio`, `tasa_aceptacion_pct`, `estado`.
- **Estructura del elemento (`ConductorOut`):**
  - `id_conductor` (*int*): ID del conductor.
  - `nombre` (*str*): Nombre y apellido.
  - `tipo_servicio` (*str*): Categoría de servicio.
  - `modelo_vehiculo` (*str*): Marca y modelo.
  - `anio_vehiculo` (*int*): Año del vehículo.
  - `placa` (*str*): Matrícula (ej. `M 284-910`).
  - `calificacion_promedio` (*float*): Calificación histórica recibida (1.0 a 5.0).
  - `tasa_aceptacion_pct` (*float*): Tasa de aceptación histórica (0.00 a 1.00).
  - `estado` (*str*): Estado operativo.

---

### Endpoint 4: Campañas de Bonos e Incentivos
`GET /movigo/campanas`

Programas de incentivos para aumentar la oferta de conductores. Insumo para modelos de optimización (Problema de la Mochila).

- **Parámetros de consulta:**
  - `tipo_incentivo` (*str, opcional*): `meta_viajes`, `hora_pico_lluvia`, `zona_alta_demanda`.
  - `estado` (*str, opcional*): `activa`, `finalizada`.
- **Estructura del elemento (`CampanaIncentivoOut`):**
  - `id_campana` (*int*): ID único de campaña.
  - `nombre_bono` (*str*): Nombre descriptivo.
  - `costo_presupuesto_nio` (*float*): Costo del incentivo en NIO (peso en la mochila).
  - `incremento_horas_conexion` (*float*): Horas-hombre estimadas adicionales (valor a maximizar).
  - `tipo_incentivo` (*str*): Clasificación del programa.
  - `fecha_inicio` (*date*), `fecha_fin` (*date*): Periodo de vigencia.
  - `estado` (*str*): `activa` o `finalizada`.

---

### Endpoint 5: Clima Urbano y Congestión Vial
`GET /movigo/clima`

Series temporales de meteorología y saturación del tráfico en Managua. Variable exógena principal para análisis estadísticos.

- **Parámetros de consulta:**
  - `fecha_desde` (*date, opcional*): Fecha mínima (`YYYY-MM-DD`).
  - `fecha_hasta` (*date, opcional*): Fecha máxima (`YYYY-MM-DD`).
  - `condicion_cielo` (*str, opcional*): `despejado`, `nublado`, `lluvia_ligera`, `tormenta`.
  - `sort` (*str, opcional*): Columnas permitidas: `fecha`, `precipitacion_mm`, `indice_congestion`, `condicion_cielo`.
- **Estructura del elemento (`ClimaCuadranteOut`):**
  - `fecha` (*date*): Día del registro.
  - `precipitacion_mm` (*float*): Lluvia acumulada en mm.
  - `temperatura_c` (*float*): Temperatura en °C.
  - `indice_congestion` (*float*): Nivel de saturación vial (escala $1.00$ flujo libre hasta $3.50$ colapso por tormenta).
  - `condicion_cielo` (*str*): Condición del día.

---

### Endpoint 6: Histórico de Viajes y Tarifas
`GET /movigo/viajes`  
`GET /movigo/viajes/{id_viaje}`

Transacciones de viajes urbanos solicitados y ejecutados.

- **Parámetros de consulta (`GET /movigo/viajes`):**
  - `id_zona_origen` (*int, opcional*): Filtrar por ID de zona de partida.
  - `id_zona_destino` (*int, opcional*): Filtrar por ID de zona de destino.
  - `id_conductor` (*int, opcional*): Filtrar por conductor.
  - `id_usuario` (*int, opcional*): Filtrar por usuario.
  - `estado_viaje` (*str, opcional*): `completado`, `cancelado_usuario`, `cancelado_conductor`, `no_asignado`.
  - `metodo_pago` (*str, opcional*): `efectivo`, `tarjeta`, `billetera_digital`.
  - `sort` (*str, opcional*): Columnas permitidas: `id_viaje`, `fecha_hora_solicitud`, `distancia_km`, `duracion_minutos`, `multiplicador_dinamico`, `tarifa_final`. Por defecto: `-fecha_hora_solicitud`.
- **Estructura del elemento (`ViajeOut`):**
  - `id_viaje` (*int*): Identificador único del viaje.
  - `id_usuario` (*int*): Pasajero.
  - `id_conductor` (*int | null*): Conductor asignado (null si no fue atendido).
  - `id_zona_origen` (*int*), `id_zona_destino` (*int*): Cuadrantes de ruta.
  - `fecha_hora_solicitud` (*datetime ISO 8601*): Momento en que se solicitó el viaje.
  - `fecha_hora_inicio` (*datetime | null*): Abordaje del pasajero.
  - `fecha_hora_fin` (*datetime | null*): Desembarque en destino.
  - `distancia_km` (*float*): Kilómetros recorridos.
  - `duracion_minutos` (*float*): Minutos de trayecto.
  - `tarifa_base` (*float*): Tarifa calculada sin factor dinámico:
    $$\text{TarifaBase} = \text{BajadaBandera} + (18 \times \text{distancia\_km}) + (4.5 \times \text{duracion\_minutos})$$
  - `multiplicador_dinamico` (*float*): Factor multiplicador ($1.00\times$ a $2.80\times$, picos de $3.20\times$).
  - `tarifa_final` (*float*): Importe cobrado en Córdobas ($\text{TarifaBase} \times \text{multiplicador\_dinamico}$).
  - `metodo_pago` (*str*): Método utilizado (`efectivo`, `tarjeta`, `billetera_digital`).
  - `estado_viaje` (*str*): `completado`, `cancelado_usuario`, `cancelado_conductor`, `no_asignado`.
  - `calificacion_usuario` (*float | null*), `calificacion_conductor` (*float | null*): Puntuaciones (1.0 a 5.0).
  - `propina` (*float*): Monto voluntario en NIO.
  - `motivo_cancelacion` (*str | null*): Causa reportada en caso de anulación.

---

### Endpoint 7: Telemetría GPS de la Flota
`GET /movigo/telemetria`

Pings de posicionamiento GPS y velocidad instantánea emitidos por conductores en ruta.

- **Parámetros de consulta:**
  - `id_conductor` (*int, opcional*): Filtrar por conductor específico.
  - `id_zona` (*int, opcional*): Filtrar por cuadrante donde se emitió el ping.
  - `estado_disponibilidad` (*str, opcional*): `disponible`, `ocupado`, `en_camino_recogida`.
  - `sort` (*str, opcional*): Columnas permitidas: `id_telemetria`, `fecha_hora`, `velocidad_kmh`. Por defecto: `-fecha_hora`.
- **Estructura del elemento (`TelemetriaConductorOut`):**
  - `id_telemetria` (*int*): ID del ping telemétrico.
  - `id_conductor` (*int*): Conductor monitoreado.
  - `id_zona` (*int*): Cuadrante urbano.
  - `fecha_hora` (*datetime ISO 8601*): Timestamp del ping.
  - `latitud` (*float*), `longitud` (*float*): Coordenadas GPS del vehículo.
  - `velocidad_kmh` (*float*): Velocidad instantánea en km/h.
  - `estado_disponibilidad` (*str*): Estado operativo en ese segundo.

---

## 3. Guía de Extracción de Datos para el Estudiante

Dado que el estudiante no posee acceso SQL directo ni comandos COPY, debe implementar un cliente en Python (utilizando `httpx` o `requests`) para paginar y construir dataframes locales en **pandas** o exportar a **Parquet/CSV**.

### Patrón de Paginación Recomendado en Python:

```python
import httpx
import pandas as pd

BASE_URL = "http://localhost:8000/movigo" # Ajustar al host de la API

def fetch_all_records(endpoint: str, params: dict = None) -> pd.DataFrame:
    """Extrae la colección completa de un endpoint paginado."""
    if params is None:
        params = {}
    
    limit = 200 # Máximo permitido por la API
    offset = 0
    all_items = []
    
    with httpx.Client(base_url=BASE_URL, timeout=30.0) as client:
        while True:
            current_params = {**params, "limit": limit, "offset": offset}
            response = client.get(endpoint, params=current_params)
            response.raise_for_status()
            
            data = response.json()
            items = data.get("items", [])
            all_items.extend(items)
            
            total = data.get("total", 0)
            offset += limit
            
            if offset >= total or not items:
                break
                
    return pd.DataFrame(all_items)

# Ejemplo de uso:
# df_viajes = fetch_all_records("/viajes")
# df_clima = fetch_all_records("/clima")
# df_zonas = fetch_all_records("/zonas")
```

---

## 4. Retos y Entregables por Asignatura (Resolubles Vía API)

El estudiante debe resolver los siguientes requerimientos consumiendo únicamente los datos de la API:

### A. Bases de Datos Analíticas & Modelado Dimensional
1. **Modelado en dbt / Data Warehouse:**
   - Consumir los datos vía API y cargar el staging en su almacén local.
   - Construir el *Star Schema*:
     - Tabla de hechos: `fact_viajes` (métricas de tarifas, duración, distancia, comisiones y propinas).
     - Tablas de dimensión: `dim_zona_origen`, `dim_zona_destino`, `dim_usuario`, `dim_conductor`, `dim_tiempo`.
   - Pruebas de calidad de datos en dbt (validar que `multiplicador_dinamico >= 1.00`, tarifas positivas y consistencia de llaves).
2. **Visualización en Metabase / BI:**
   - Tablero con métricas clave: volumen horario de viajes, mapas de calor origen-destino y comportamiento del *surge pricing*.

### B. Shell Scripting & DataOps
1. **Pipeline de Ingesta:** Desarrollar un script en Bash/Python programado para extraer periódicamente los nuevos viajes mediante el endpoint `/movigo/viajes`, exportarlos a formato Parquet y computar sumas de comprobación SHA-256 para auditoría de integridad.
2. **Monitoreo y Alertas:** Script que consulte periódicamente `/movigo/viajes?estado_viaje=cancelado_usuario` y `/movigo/viajes?estado_viaje=cancelado_conductor` y emita una alerta en caso de picos inusuales de cancelación.

### C. Estadística II (Inferencia sobre Datos Extraídos)
1. **Regresión Lineal Simple y Múltiple:**
   - Cruce de `/movigo/clima` y conteo diario de `/movigo/viajes`.
   - Modelar: $\text{ViajesDiarios} = \beta_0 + \beta_1 (\text{Precipitación}_{mm}) + \beta_2 (\text{ÍndiceCongestión}) + \epsilon$.
2. **Tabla ANOVA Completa:** Calcular suma de cuadrados explicada ($SCA$), del error ($SCE$), grados de libertad y significancia del estadístico $F$.
3. **Verificación de Supuestos Gauss-Markov:**
   - Normalidad de los residuos (prueba de Shapiro-Wilk o Jarque-Bera).
   - Homocedasticidad (prueba de Breusch-Pagan / White).
   - Independencia temporal (estadístico Durbin-Watson).
4. **Batería de Pruebas de Hipótesis Formales:**
   - **Prueba $t$-Student / Welch:** Evaluar si el multiplicador dinámico ($> 1.25\times$) eleva significativamente la tarifa final respecto a la tarifa base ($p < 0.05$).
   - **Prueba $z$ de dos proporciones:** Demostrar si la tasa de cancelación en horas pico (07:00-08:59, 17:00-18:59) es significativamente mayor que en horas valle.
   - **ANOVA de un factor:** Determinar si la duración de los viajes difiere significativamente según el estrato socioeconómico de destino (`alto`, `medio`, `popular`, `comercial`).
   - **Prueba de Independencia Chi-Cuadrado ($\chi^2$):** Contrastar la hipótesis de independencia entre el `metodo_pago` y el `estrato_socioeconomico` del origen ($p < 0.01$).

### D. Métodos Numéricos
1. **Búsqueda de Raíces (Equilibrio de Tarifa Dinámica):**
   - A partir de la elasticidad de demanda observada en los datos, formular la función de exceso de demanda $f(m) = \text{Demanda}(m) - \text{Oferta}(m) = 0$.
   - Implementar los métodos de **Bisección** y **Newton-Raphson** para encontrar el multiplicador de equilibrio $m^*$, reportando la convergencia y número de iteraciones.
2. **Diferenciación Numérica:**
   - Aproximar numéricamente la elasticidad-precio de los viajes mediante diferencias finitas centradas de orden $\mathcal{O}(h^2)$ evaluando si la demanda de movilidad en Managua es elástica ($|\varepsilon| > 1$) o inelástica ($|\varepsilon| < 1$).
3. **Integración Numérica:**
   - Ajustar la curva horaria de intensidad de viajes (0 a 24 horas) y aplicar la **Regla de Simpson 1/3** para aproximar el volumen diario acumulado de viajes.

### E. Optimización
1. **Algoritmo Húngaro (Despacho Óptimo):**
   - A partir de una muestra de conductores disponibles (`GET /movigo/conductores?estado=activo` o `/movigo/telemetria`) y solicitudes simultáneas de `/movigo/viajes`, construir la matriz de distancias o tiempos de llegada y resolver la asignación biyectiva que minimice el tiempo total de respuesta.
2. **Ruta Más Corta (Dijkstra):**
   - Representar la red de cuadrantes de Managua como un grafo ponderado por distancia e índice de congestión (obtenido de `/movigo/zonas` y `/movigo/clima`).
   - Comparar el camino óptimo entre dos zonas en condiciones de flujo libre vs. evento de lluvia torrencial.
3. **Problema de la Mochila (Knapsack 0/1):**
   - Consumir `/movigo/campanas`.
   - Formular el problema binario: maximizar las `incremento_horas_conexion` sujeto a una restricción presupuestaria de **C$ 120,000 NIO** en `costo_presupuesto_nio`.
   - Resolver mediante Programación Dinámica o Branch & Bound.

---

## 5. Resumen para el Estudiante

| Componente | Detalle |
| :--- | :--- |
| **Acceso:** | Exclusivo vía API REST (HTTP GET con JSON). No hay conexión directa a PostgreSQL. |
| **Paginación:** | Esquema `PaginatedResponse` con `items`, `total`, `offset`, `limit` (máx 200). |
| **Catálogos Clave:** | `/movigo/zonas`, `/movigo/usuarios`, `/movigo/conductores`, `/movigo/campanas`. |
| **Series y Transacciones:** | `/movigo/clima` (variables meteorológicas), `/movigo/viajes` (viajes y tarifas), `/movigo/telemetria` (GPS y velocidad). |
| **Moneda:** | Córdobas nicaragüenses (NIO, C$). |
