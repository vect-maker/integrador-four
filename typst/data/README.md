# Analytical Data Catalog (`typst/data/`)

This directory houses the structured JSON datasets that feed the scientific paper (`typst/document/`) and the presentation slides (`typst/slides/`) under the reproducible **_Data-to-Document_** paradigm.

All files are deterministically extracted from the local columnar DuckDB analytical warehouse (`pipeline/data/analytics.duckdb`) using the automation command:

```bash
just hydrate-data
```

---

## Dataset Inventory (JSON)

Every dataset is serialized as structured JSON (`array[dictionary]`), providing native Typst data types (`int`, `float`, `bool`, `str`), semantic dot-notation access (`item.property`), and zero drift against column ordering changes.

| Dataset File | Grain / Description | Records | SQL Source |
| :--- | :--- | :---: | :--- |
| **`general_kpis.json`** | Macro operational and pricing metrics for the 2024 annual cycle ($N = 77,036$). | 1 | `01_general_kpis.sql` |
| **`cancellations_by_hour.json`** | Hourly distribution ($0..23$ hrs), peak vs off-peak indicator, surge multiplier and cancellation rate. | 24 | `02_cancellations_by_hour.sql` |
| **`cancellations_by_stratum.json`** | Price sensitivity and cancellation propensities across socioeconomic strata ($1..4$). | 4 | `03_cancellations_by_stratum.sql` |
| **`cancellations_by_weather.json`** | Contingency analysis linking rainfall severity, traffic congestion index, fares and cancellations. | 4 | `04_cancellations_by_weather.sql` |
| **`campaigns_optimization.json`** | Driver incentive programs and unit connection costs for the 0/1 Knapsack optimization model. | 12 | `05_campaigns_optimization.sql` |
| **`zones.json`** | Geospatial coordinates, coverage radius and base fares for the 12 urban zones in Managua. | 12 | `06_zones_catalog.sql` |

---

## Typst Ingestion Examples

### Semantic Property Access (Single Object)
```typst
#let kpis = json("/data/general_kpis.json").at(0)

El ciclo analítico consolidó un total de #kpis.total_viajes solicitudes, registrando
una tasa global de cancelación del #kpis.tasa_cancelacion_pct% bajo un multiplicador
dinámico promedio de #kpis.surge_promedio x.
```

### Collection Iteration and Mapping (Tables & Cards)
```typst
#let zones = json("/data/zones.json")

#table(
  columns: (1.5fr, 1.2fr, 1fr),
  table.header([*Zona*], [*Estrato*], [*Base*]),
  ..zones.slice(0, 3).map(z => (
    [#z.nombre_zona],
    [#z.estrato_socioeconomico],
    [C\$ #z.tarifa_base_bajada_bandera]
  )).flatten()
)
```
