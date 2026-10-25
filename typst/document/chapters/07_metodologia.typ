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

=== 1. Extracción de Datos vía API REST y Persistencia en Parquet
El acceso a la información se realiza a partir de una base de datos sintética expuesta a través de una *API REST pública en una URL temporal provista para fines académicos* (el repositorio de código fuente del generador de datos será enlazado y documentado en fases posteriores). Dado que como estudiantes no se cuenta con acceso directo al motor de base de datos de producción, se implementa un script en Python modular (`fetcher.py`):
- Paginación sistemática mediante parámetros `limit` y `offset` dinámico para recuperar las colecciones completas de viajes, clima, zonas, conductores, usuarios y telemetría.
- Serialización de los conjuntos de datos en archivos columnares en formato *Apache Parquet* (`.parquet`) en el directorio de almacenamiento crudo local. Esta práctica desacopla el consumo de red de los procesos de carga, garantiza idempotencia, preserva los tipos de datos nativos y asegura la reproducibilidad sin reconsultar recurrentemente la API transaccional.

=== 2. Persistencia en Azure PostgreSQL como Réplica OLTP (Base de Datos `raw`, Esquema `public`)
Una vez generados los archivos Parquet, se realiza la carga hacia un servicio administrado en la nube en *Azure Database for PostgreSQL (Flexible Server)* mediante un módulo cargador en Python (`loader.py`) empleando SQLAlchemy y `psycopg3` bajo conexión segura cifrada (`sslmode=require`):
- *Aprovisionamiento y Definición DDL:* Se establece la base de datos transaccional dedicada `raw`, ejecutando un esquema relacional estricto en el esquema `public` (`raw_schema.sql`). Este define claves primarias, restricciones de validación (`CHECK`), índices analíticos y restricciones de integridad referencial foráneas en las siete entidades principales (`zonas_urbanas`, `usuarios`, `conductores`, `campanas_incentivos`, `clima_cuadrantes`, `viajes`, `telemetria_conductores`) y su tabla de auditoría.
- *Casteo y Carga Topológica por Lotes:* El script procesa explícitamente los formatos de fecha (ISO8601 a tipos nativos SQL `DATE` y `TIMESTAMP`) y gestiona identificadores nulos en claves foráneas. La inserción se ejecuta en lotes de 2,000 registros respetando el orden estricto de dependencias foráneas, consolidando una réplica transaccional (*OLTP*) de alta fidelidad que funge como fuente única de verdad para el almacén de datos.

=== 3. Transformación y Modelado Analítico con dbt Core
Una vez consolidados los datos crudos en la base de datos `raw` de Azure PostgreSQL (esquema `public`), se utiliza *dbt (Data Build Tool)* para orquestar la transformación y estructuración de la base de datos analítica (*OLAP*), declarando la capa transaccional como fuente primaria en `sources.yml`:
- *Capa de Estandarización (_Staging_):* Vistas SQL que homogenizan la nomenclatura a convenciones consistentes (`snake_case`), tipifican marcas de tiempo en formato estándar y calculan métricas operativas intermedias (tales como tiempos de espera entre solicitud y abordaje).
- *Capa de Entrega Analítica (_Marts_):* Materialización de esquemas optimizados para consulta y agregación multidimensional, facilitando el análisis del comportamiento del viaje junto con su contexto espacial, temporal y meteorológico.
- *Aseguramiento de Calidad de Datos (_dbt Tests_):* Ejecución de pruebas automáticas declaradas en esquemas YAML para auditar unicidad, no nulidad, consistencia referencial y cumplimiento de reglas operativas básicas (tarifas positivas y coherencia de identificadores).

== Marco para los Análisis Cuantitativos Posteriores

A partir de la base de datos analítica consolidada y transformada mediante dbt, el proyecto contempla el desarrollo de tres líneas de trabajo analítico complementarias:

+ *Modelación e Inferencia Estadística:* Orientada a evaluar la sensibilidad de la demanda ante fluctuaciones en la tarifa, examinar la incidencia de choques meteorológicos sobre el volumen de viajes y contrastar si existen variaciones significativas en la propensión a la cancelación según el estrato socioeconómico o la franja horaria.
+ *Métodos Numéricos y Sensibilidad:* Orientada a estudiar el comportamiento de la elasticidad-precio y explorar puntos de equilibrio tarifario que equilibren las solicitudes de pasajeros y la disponibilidad de vehículos.
+ *Optimización Operativa:* Orientada a formular y evaluar esquemas de asignación eficiente de recursos o incentivos presupuestarios dirigidos a socios conductores para fortalecer la oferta vehicular en zonas o periodos con alta demanda.
