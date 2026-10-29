// typst/tables/variables_operationalization.typ: Matriz de Operacionalización de Variables
// Especificación metodológica formal para el estudio econométrico y espacial

#let table-variables-operationalization(size: 7.2pt) = {
  set text(size: size)
  table(
    columns: (1.5fr, 1.1fr, 2.3fr, 2fr, 1.2fr, 1.1fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 4pt, y: 4pt),
    align: (col, row) => if row == 0 { center + horizon } else if col == 1 or col == 4 or col == 5 { center + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*Variable*], [*Rol*], [*Definición Conceptual*], [*Definición Operacional*], [*Escala*], [*Entidad*]
    ),
    [Cancelación de Viaje (`is_cancelled`)],
    [Dependiente ($Y$)],
    [Decisión de abandonar o no consumar el servicio de transporte solicitado.],
    [Variable dicotómica booleana ($1 = "cancelado"$, $0 = "completado"$).],
    [Nominal dicotómica],
    [`fct_viajes`],

    [Multiplicador Dinámico (`surge_multiplier`)],
    [Independiente ($X_1$)],
    [Factor de recargo sobre la tarifa base determinado por desbalance oferta/demanda.],
    [Multiplicador continuo en escala $[1.00, 3.20]times$ registrado al solicitar el viaje.],
    [Razón continua],
    [`fct_viajes`],

    [Distancia de Ruta (`distance_km`)],
    [Independiente ($X_2$)],
    [Longitud métrica del desplazamiento planificado entre origen y destino.],
    [Kilómetros de trayecto calculados por ruteo vial con factor de tortuosidad.],
    [Razón continua],
    [`fct_viajes`],

    [Índice de Congestión (`congestion_index`)],
    [Independiente ($X_3$)],
    [Nivel de saturación vehicular exógeno en la trama arterial de la capital.],
    [Escala continua normalizada de $1.00$ (flujo libre) a $3.50$ (colapso vial).],
    [Razón continua],
    [`dim_weather`],

    [Hora Pico (`is_peak_hour`)],
    [Control ($X_4$)],
    [Ventana temporal de máxima demanda laboral y escolar matutina y vespertina.],
    [Indicador booleano ($1$ en 07:00--08:59 y 17:00--18:59, $0$ en hora valle).],
    [Nominal dicotómica],
    [`fct_viajes`],

    [Condición de Lluvia (`has_rain`)],
    [Control ($X_5$)],
    [Ocurrencia de precipitaciones con potencial de anegamiento vial.],
    [Indicador booleano diario ($1$ si $"precipitación" > 0.1 "mm"$, $0$ si seco).],
    [Nominal dicotómica],
    [`dim_weather`],

    [Estrato Socioeconómico (`stratum`)],
    [Segmentación ($Z$)],
    [Nivel socioeconómico territorial del cuadrante donde se genera el viaje.],
    [Clasificación ordinal en 4 niveles (1: Popular, 2: Medio, 3: Comercial, 4: Alto).],
    [Ordinal politómica],
    [`dim_zones`],
  )
}

#let fig-variables-operationalization = figure(
  table-variables-operationalization(),
  caption: [Matriz metodológica de operacionalización de variables de la investigación],
)
