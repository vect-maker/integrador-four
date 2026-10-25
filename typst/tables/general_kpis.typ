// typst/tables/general_kpis.typ: Macro Operational KPIs Summary Table
// Programmatically hydrated from data/general_kpis.json via DuckDB

#import "../data_bindings.typ": general-kpis as kpis

// Reusable table component
#let table-general-kpis(size: 8pt) = {
  set text(size: size)
  table(
    columns: (2.2fr, 1.4fr, 2fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 4.5pt),
    align: (col, row) => if row == 0 { center + horizon } else if col == 1 { right + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*Métrica Operacional*], [*Valor Empírico*], [*Interpretación / Alcance*]
    ),
    [Total de Solicitudes Registradas], [#kpis.total_viajes], [Muestra anual consolidada (ciclo 2024)],
    [Servicios Completados Efectivos], [#kpis.total_completados], [Viajes finalizados satisfactoriamente],
    [Total de Cancelaciones Observadas], [#kpis.total_cancelados], [Cancelaciones de usuario y conductor],
    [Tasa Global de Cancelación], [#kpis.tasa_cancelacion_pct%], [Proporción global de fricción transaccional],
    [Multiplicador Dinámico Promedio], [#kpis.surge_promedio#text(fill: rgb("#64748b"))[x]], [Presión tarifaria media sobre la tarifa base],
    [Tarifa Base Promedio], [C\$ #kpis.tarifa_base_promedio_nio NIO], [Tarifa de referencia según distancia y zona],
    [Tarifa Final Promedio], [C\$ #kpis.tarifa_final_promedio_nio NIO], [Costo total incurrido tras aplicar surge],
    [Sobrecosto Medio por Dinámica], [C\$ #kpis.sobrecosto_promedio_nio NIO], [Diferencial monetario atribuible al surge],
    [Distancia Promedio por Viaje], [#kpis.distancia_promedio_km km], [Recorrido medio de traslado urbano],
    [Tiempo de Espera Promedio], [#kpis.tiempo_espera_promedio_min min], [Tiempo de arribo de la unidad asignada],
  )
}

// Formal enumerated figure with caption for the paper
#let fig-general-kpis = figure(
  table-general-kpis(),
  caption: [Indicadores macroeconómicos y operativos del ciclo anual 2024 (MoviGo)],
)
