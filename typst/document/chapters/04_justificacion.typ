#show bibliography: none
#bibliography("../../references.bib")

= Justificación

== Justificación Práctica: Sostenibilidad Económica y Retención de Clientes para MoviGo

La presente investigación se fundamenta en la necesidad operativa de sustituir la calibración empírica y reactiva de tarifas en la plataforma *MoviGo* por un modelo de tarificación y gestión de oferta sustentado en evidencia matemática y econométrica. En el modelo de negocio de las aplicaciones de transporte selectivo, el esquema tarifario dinámico representa tanto la principal fuente de ingresos como el factor determinante de la experiencia del usuario y del conductor @cachon2017.

A partir del análisis de los *77,487 registros históricos de viajes* y las series meteorológicas expuestas a través de la API REST, este proyecto aporta beneficios concretos a la gestión empresarial de MoviGo:
- *Mitigación de Ingresos Perdidos por Cancelación:* Identifica los umbrales críticos del multiplicador dinámico a partir de los cuales la probabilidad de cancelación por parte del usuario se dispara, cuantificando el costo de las cotizaciones perdidas.
- *Reducción del Desabastecimiento en Horas Pico:* Diagnostica las brechas de oferta en los corredores más saturados de Managua, determinando cuándo la tarifa regular resulta insuficiente para activar la conexión de conductores.
- *Optimización de Presupuestos Operativos:* Provee un marco riguroso para asignar los fondos destinados a programas de incentivos para socios conductores, sustituyendo el aumento ciego de tarifas por subsidios orientados a objetivos medibles de conexión.

== Relevancia Científica y Metodológica: Optimización Espacial y Modelado en Grafos

Desde el punto de vista científico y metodológico, la investigación trasciende la analítica descriptiva tradicional para articular herramientas formales de *teoría de grafos, análisis de redes espaciales e investigación de operaciones*:

+ *Modelado Topológico y Cuellos de Botella Sistémicos:* Modela el territorio metropolitano como una red celular ponderada $G = (V, E)$ de 298 cuadrantes y 1,072 conexiones contiguas en las 24 zonas urbanas de Managua, aplicando métricas de *Centralidad de Intermediación (_Betweenness Centrality_)* para diagnosticar objetivamente los nudos espaciales con mayor vulnerabilidad estructural.
+ *Optimización de Trayectorias y Auditoría de Ruteo de Caja Negra:* Aplica el *Algoritmo de Dijkstra* para calcular caminos mínimos prescriptivos y contrastarlos con las trayectorias reales observadas de MoviGo, demostrando cómo circunnavegar activamente los cauces desbordados ahorra hasta 82 minutos de retraso e impide el colapso operativo por cancelaciones masivas.

== Relevancia Tecnológica y Arquitectura de Ingeniería de Datos (ELT con dbt)

En el ámbito tecnológico, el proyecto resuelve un desafío propio de los entornos de datos contemporáneos: *la inexistencia de acceso directo a la base de datos transaccional y la obligatoriedad de consumir los datos exclusivamente mediante una API REST paginada*.

El pipeline tecnológico implementado demuestra un diseño DataOps escalable y profesional:
+ *Extracción Modular y Paginación Robusta:* Cliente en Python (`httpx`/`requests`) diseñado para consumir colecciones paginadas (`limit=200`, `offset` dinámico), validando esquemas y computando sumas criptográficas *SHA-256* para auditoría y trazabilidad de los datos brutos.
+ *Capa Cruda en Azure PostgreSQL:* Ingesta, normalización relacional y persistencia de los 7 endpoints de la plataforma MoviGo en el esquema `raw` alojado en la base de datos `postgres` de *Azure Database for PostgreSQL*.
+ *Modelado Dimensional y Transformación con dbt Core:* Construcción de un Data Warehouse bajo metodología Kimball mediante *dbt (Data Build Tool)*, desacoplando staging y marts analíticos, con llaves subrogadas hash (MD5) y una batería exhaustiva de pruebas automáticas de calidad (_dbt tests_) que validan reglas de negocio (`multiplicador_dinamico >= 1.00`, tarifas positivas y unicidad referencial) @kimball2013.

== Relevancia Social y Equidad Territorial en el Municipio de Managua

En términos de impacto social, la investigación incide directamente en la equidad urbana y la justicia algorítmica. De acuerdo con el Plan Maestro de Movilidad Urbana de Managua @jica2017, más de una cuarta parte (26%) de los viajes diarios en la capital se realizan en transporte selectivo, constituyendo un modo de transporte vital para la clase trabajadora, estudiantes y comerciantes que conectan periferias con centros neurálgicos como el Mercado Oriental o Metrocentro.

Un algoritmo de tarifa dinámica descalibrado actúa como una barrera económica excluyente que expulsa a las familias de menores ingresos en momentos de vulnerabilidad (lluvias torrenciales o emergencias). Calibrar la tarifa con consideraciones de equidad socio-espacial y evaluar la correlación entre el estrato económico, el medio de pago preferido (`efectivo`, `tarjeta`, `billetera_digital`) y la propensión a la cancelación garantiza un servicio más accesible e inclusivo para la ciudadanía de Managua.

== Articulación Interdisciplinaria en Ciencia de Datos

La presente investigación demuestra la sinergia práctica de la ciencia de datos aplicada a la movilidad metropolitana, articulando armónicamente diferentes frentes técnicos y analíticos en torno a un hilo conductor común:

- *Ingeniería y Almacenamiento Analítico:* Arquitectura ELT, diseño dimensional en estrella bajo metodología Kimball (`fct_viajes` atómica y dimensiones conformadas), transformaciones con *dbt Core* y motor OLAP columnar en proceso con *DuckDB*.
- *Automatización y Reproducibilidad Computacional:* Automatización de ingesta desde API REST paginada, scripts Bash estructurados (`set -euo pipefail`), orquestación mediante `justfile`, entorno reproducible con `uv` y verificación estática con `basedpyright`.
- *Investigación de Operaciones y Redes:* Teoría de grafos, modelado de red vial urbana y algoritmo de Dijkstra para cuantificar retrasos y desvíos forzados ante contingencias pluviales.
- *Persistencia Transaccional Relacional:* Diseño relacional normalizado (3NF) y almacenamiento estructurado en la nube sobre Azure Database for PostgreSQL.
