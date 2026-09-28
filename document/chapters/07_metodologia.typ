#import "../template.typ": callout

= Diseño Metodológico

El diseño metodológico describe la secuencia técnica y computacional concebida para la recolección, ingesta, transformación y estructuración de los datos del servicio MoviGo, así como el marco general para los análisis cuantitativos posteriores orientados a evaluar la tarifa dinámica.

== Enfoque, Tipo y Alcance de la Investigación

La presente investigación se fundamenta en un *enfoque cuantitativo empírico*, sustentado en el procesamiento y modelación de registros transaccionales, telemétricos y meteorológicos generados a partir de un entorno de simulación que abarca un año completo de operaciones del servicio MoviGo en Managua.

De acuerdo con sus objetivos y naturaleza, el estudio se caracteriza por:
- *Diseño No Experimental y Longitudinal:* Se analizan los eventos y registros operativos generados por la simulación a lo largo del tiempo, sin manipular de forma directa el comportamiento de los usuarios o conductores.
- *Alcance Descriptivo y Correlacional:* Busca describir la distribución espacial y temporal del servicio y evaluar las relaciones existentes entre el multiplicador dinámico, los eventos climáticos, las características socioeconómicas de las zonas y los niveles de cancelación observados.
- *Proyección Prescriptiva:* Plantea explorar formulaciones de balance tarifario y modelos de optimización de incentivos para mitigar las fricciones operativas detectadas.

== Arquitectura del Pipeline y Paradigma ELT

La estrategia de ingeniería de datos constituye la base operativa y concreta planificada para el proyecto, adoptando una arquitectura moderna basada en el paradigma *ELT (Extract, Load, Transform)*:

=== 1. Extracción de Datos vía API REST
El acceso a la información se realiza a partir de una base de datos sintética expuesta a través de una *API REST pública en una URL temporal provista para fines académicos* (el repositorio de código fuente del generador de datos será enlazado y documentado en fases posteriores). Dado que como estudiantes no se cuenta con acceso directo al motor de base de datos de producción, se implementa un script en Python modular (`httpx`/`requests`):
- Paginación sistemática mediante parámetros `limit` y `offset` dinámico para recuperar las colecciones completas de viajes, clima, zonas, conductores, usuarios y telemetría.
- Preservación de la coherencia estructural y relaciones foráneas entre las entidades durante la descarga.

=== 2. Persistencia en PostgreSQL como Réplica OLTP
Los conjuntos de datos extraídos en memoria se exportan y cargan directamente hacia un motor relacional dedicado en *PostgreSQL*. Esta instancia actúa como la representación local del entorno transaccional (*OLTP*), manteniendo las tablas crudas (_raw data_) en su esquema de origen y sirviendo como única fuente de verdad para los procesos subsecuentes.

=== 3. Transformación y Modelado Analítico con dbt Core
Una vez consolidados los datos crudos en PostgreSQL, se utiliza *dbt (Data Build Tool)* para orquestar la transformación y estructuración de la base de datos analítica (*OLAP*):
- *Capa de Estandarización (_Staging_):* Vistas SQL que homogenizan la nomenclatura a convenciones consistentes (`snake_case`), tipifican marcas de tiempo en formato estándar y calculan métricas operativas intermedias (tales como tiempos de espera entre solicitud y abordaje).
- *Capa de Entrega Analítica (_Marts_):* Materialización de esquemas optimizados para consulta y agregación multidimensional, facilitando el análisis del comportamiento del viaje junto con su contexto espacial, temporal y meteorológico.
- *Aseguramiento de Calidad de Datos (_dbt Tests_):* Ejecución de pruebas automáticas declaradas en esquemas YAML para auditar unicidad, no nulidad, consistencia referencial y cumplimiento de reglas operativas básicas (tarifas positivas y coherencia de identificadores).

== Marco para los Análisis Cuantitativos Posteriores

A partir de la base de datos analítica consolidada y transformada mediante dbt, el proyecto contempla el desarrollo de tres líneas de trabajo analítico complementarias:

+ *Modelación e Inferencia Estadística:* Orientada a evaluar la sensibilidad de la demanda ante fluctuaciones en la tarifa, examinar la incidencia de choques meteorológicos sobre el volumen de viajes y contrastar si existen variaciones significativas en la propensión a la cancelación según el estrato socioeconómico o la franja horaria.
+ *Métodos Numéricos y Sensibilidad:* Orientada a estudiar el comportamiento de la elasticidad-precio y explorar puntos de equilibrio tarifario que equilibren las solicitudes de pasajeros y la disponibilidad de vehículos.
+ *Optimización Operativa:* Orientada a formular y evaluar esquemas de asignación eficiente de recursos o incentivos presupuestarios dirigidos a socios conductores para fortalecer la oferta vehicular en zonas o periodos con alta demanda.

#v(1em)

#callout(
  title: "Nota Metodológica sobre Fases Posteriores de Investigación",
  color: "amber",
  [
    Las formulaciones matemáticas definitivas, algoritmos numéricos de cálculo, pruebas de hipótesis exactas y modelos de optimización prescriptiva específicos se encuentran actualmente en fase de formulación e investigación exploratoria. Dichos modelos serán definidos, calibrados y documentados en detalle en entregas futuras del proyecto, una vez que la base de datos analítica esté completamente materializada mediante dbt y se disponga de los resultados del análisis exploratorio de datos (EDA).
  ]
)
