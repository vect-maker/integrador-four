#import "../../snippets.typ": (
  fig-raw-ddl,
  fig-loader-azure,
  fig-fct-viajes,
  fig-marts-models,
)
#import "../../tables/star_schema.typ": fig-star-schema-table

= Apéndice C: Especificación Técnica de Ingeniería de Datos y Modelos dbt

== Diccionario Arquitectónico del Esquema en Estrella (Kimball Star Schema)

El almacén analítico implementa un modelado dimensional estricto a grano atómico por viaje (@tbl-star-schema), relacionando la tabla de hechos `fct_viajes` con seis dimensiones conformadas mediante llaves subrogadas sintéticas generadas por hash determinístico MD5.

#fig-star-schema-table <tbl-star-schema>

== Definiciones DDL Relacionales y Pipeline de Carga (PostgreSQL en Azure)

A continuación se detallan los artefactos de código fuente correspondientes a la capa cruda (_raw schema_) desplegada en Azure Database for PostgreSQL (@lst-ddl) y el script en Python responsable de la ingesta en bloque y control de dependencias relacionales (@lst-loader).

#fig-raw-ddl <lst-ddl>

#fig-loader-azure <lst-loader>

== Modelos Declarativos y Pruebas de Calidad en dbt Core

La transformación analítica y la materialización dimensional se orquestan mediante dbt Core. Se presentan las sentencias de modelado de la tabla de hechos `fct_viajes` (@lst-fct-viajes) y la suite de pruebas automatizadas de integridad referencial y completitud declarada en YAML (@lst-dbt-marts).

#fig-fct-viajes <lst-fct-viajes>

#fig-marts-models <lst-dbt-marts>
