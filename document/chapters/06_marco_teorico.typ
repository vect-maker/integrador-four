= Marco Teórico

== Mercados Bilaterales de Movilidad y Tarificación Dinámica (Surge Pricing)

Las plataformas de transporte selectivo bajo demanda (_ride-hailing_) operan bajo la estructura económica de los *mercados bilaterales* (_two-sided markets_) @cachon2017. En estos entornos, la plataforma actúa como intermediario tecnológico entre dos grupos de agentes interdependientes: los pasajeros que demandan traslados y los socios conductores independientes que suministran capacidad vehicular.

El desafío operativo cardinal de este modelo radica en la volatilidad espaciotemporal de la demanda frente a una oferta vehicular con rigideces de desplazamiento físico. Para coordinar ambos lados del mercado en tiempo real, las plataformas implementan algoritmos de *tarificación dinámica* (_surge pricing_) @zha2018.

Desde la perspectiva teórica, el multiplicador dinámico cumple dos funciones primordiales:
+ *Racionamiento de Demanda:* Eleva el costo del servicio en zonas o momentos saturados, incentivando a los usuarios con viajes postergables o elásticos a desistir de la solicitud.
+ *Incentivo de Oferta:* Incrementa los ingresos esperados de los choferes, atrayendo unidades desocupadas hacia los focos de alta demanda.

No obstante, cuando el multiplicador supera los umbrales de tolerancia económica de los usuarios o cuando la congestión vial impide que los vehículos lleguen a tiempo, el mecanismo puede colapsar, induciendo tasas severas de cancelación mutua y distorsiones territoriales @castillo2022.

== Microeconomía de la Demanda: Elasticidad-Precio y Cancelación de Viajes

El comportamiento del pasajero ante la cotización de un viaje se rige por la *teoría de la demanda y la elasticidad-precio*. La elasticidad-precio de la demanda ($epsilon$) mide la variación porcentual en la cantidad demandada de viajes ($Q$) ante un cambio porcentual en la tarifa ($P$):

$ epsilon = frac(Delta Q \/ Q, Delta P \/ P) = frac(partial Q, partial P) dot frac(P, Q) $ <eq-elasticidad>

En servicios de transporte urbano:
- *Demanda Inelástica ($|epsilon| < 1$):* El usuario requiere movilizarse de forma imperativa (ej. emergencias, compromisos laborales estrictos en horas pico) y tolera incrementos moderados en la tarifa.
- *Demanda Elástica ($|epsilon| > 1$):* El usuario posee alternativas viables o alta sensibilidad presupuestaria, reaccionando al incremento del multiplicador mediante el desistimiento inmediato o la *cancelación del viaje tras haber solicitado el servicio*.

En MoviGo, la tarifa final se define paramétricamente mediante la fórmula:

$ "TarifaBase" = "BajadaBandera"_z + (18.0 dot "distancia_km") + (4.5 dot "duracion_minutos") $

$ "TarifaFinal" = "TarifaBase" dot "multiplicador_dinamico" $

Donde el multiplicador dinámico oscila habitualmente entre $1.00times$ y $2.80times$, con techos extraordinarios de $3.20times$ durante tormentas. Cuando la tarifa final resultante excede el excedente del consumidor, o cuando el tiempo de espera estimado se dilata debido a la congestión, se desencadena la cancelación del viaje (`estado_viaje = 'cancelado_usuario'`), representando una pérdida económica neta tanto para la plataforma como para el conductor.

== Equidad Socio-Espacial y Disparidad Territorial en Managua

La teoría de la justicia espacial y el acceso al transporte urbano postula que las tarifas y la disponibilidad de los servicios de movilidad no deben discriminar ni excluir a las poblaciones de menores recursos.

En el municipio de Managua, la estructura urbana se caracteriza por una marcada heterogeneidad y fragmentación espacial. MoviGo divide la capital en 12 cuadrantes operativos agrupados en cuatro estratos socioeconómicos:
- *Alto:* Villa Fontana, Las Colinas, Santo Domingo (bajada de bandera de C\$ 70 a C\$ 80 NIO).
- *Medio:* Los Robles, Altamira, Bolonia, Bello Horizonte, Linda Vista (bajada de bandera de C\$ 48 a C\$ 55 NIO).
- *Comercial:* Metrocentro / Eje Corporativo UCA (bajada de bandera de C\$ 60 NIO).
- *Popular:* Ciudad Jardín, Mercado Oriental, Mercado Roberto Huembes (bajada de bandera de C\$ 35 a C\$ 40 NIO).

El estrato del cuadrante no solo condiciona la tarifa inicial, sino también los métodos de pago dominantes: en cuadrantes populares predomina el uso de *efectivo*, mientras que en estratos altos predomina la *tarjeta de crédito/débito* y las *billeteras digitales*. Un aumento abrupto en el multiplicador dinámico tiene un impacto asimétrico: mientras un usuario con tarjeta puede absorber el cargo marginal, un usuario con efectivo en un mercado popular que dispone de un monto exacto se ve obligado a cancelar el viaje al verse sobrepasado su presupuesto líquido.

== Arquitectura de Datos y Paradigma ELT vía API REST

Para investigar empíricamente este fenómeno, se requiere una arquitectura analítica moderna capaz de transformar registros transaccionales dispersos en un repositorio estructurado para la toma de decisiones. 

Dado que MoviGo expone sus datos a través de una API REST pública (proporcionada en una URL temporal para fines académicos), la solución tecnológica se estructura bajo el paradigma *ELT (Extract, Load, Transform)*:

+ *Ingesta y Carga Cruda (Python $arrow.r$ PostgreSQL):* Un script modular en Python (`httpx`/`requests`) consume los endpoints transaccionales y de catálogo, gestionando paginación sistemática y asegurando la integridad referencial antes de persistir los datos crudos en PostgreSQL. Esta capa opera como réplica local del entorno transaccional (OLTP).
+ *Transformación Analítica con dbt Core:* La orquestación del almacén de datos se delega en *dbt (Data Build Tool)*, permitiendo versionar las transformaciones en SQL modular, materializar tablas intermedias y desacoplar la capa de staging de la capa analítica de consulta (OLAP) @kimball2013.

== Modelado Dimensional Kimball para Análisis del Viaje

El diseño dimensional sigue los principios de Ralph Kimball, definiendo el ciclo de vida del viaje como el proceso de negocio central a través de un *Esquema en Estrella* (_Star Schema_):

- *Tabla de Hechos Atómica (`fact_viajes`):* Grano de una fila por cada intento o viaje registrado (> 77,000 registros). Centraliza métricas monetarias (tarifas base y finales, multiplicadores aplicados), operativas (distancias, duraciones, tiempos de espera) y de calidad (estados de servicio y calificaciones).
- *Dimensiones Conformadas:* Cuadrantes urbanos de origen y destino, marcas temporales y franjas horarias, registros meteorológicos diarios, perfiles de usuarios y flota vehicular registrada.
- *Llaves Subrogadas Hash (MD5):* Desacoplan la identidad analítica de los identificadores operativos de origen, preservando la inmutabilidad y trazabilidad del modelo ante posibles cambios de esquema.

== Fundamentos Teóricos para el Análisis Cuantitativo

A partir de la base de datos analítica estructurada mediante dbt, la investigación contempla el abordaje de tres pilares cuantitativos complementarios, cuyos modelos y algoritmos específicos se encuentran en fase de estudio y definición:

=== 1. Fundamentos de Inferencia y Econometría en Transporte
La literatura en economía del transporte sustenta que la demanda de movilidad y las decisiones de cancelación no responden de forma aislada a las tarifas, sino que están condicionadas por perturbaciones exógenas como la congestión vial y las precipitaciones meteorológicas. Los modelos econométricos permiten aislar el efecto marginal de cada factor contextual, verificar supuestos de estabilidad de varianza e independencia residual, y contrastar hipótesis estadísticas sobre la existencia de disparidades en el servicio según el cuadrante urbano o la franja horaria.

=== 2. Fundamentos de Equilibrio de Mercado y Análisis Numérico
En los sistemas de transporte bajo demanda, la condición teórica de equilibrio se define a través de la función de exceso de demanda, la cual busca identificar el multiplicador tarifario que balancee las solicitudes entrantes con la disponibilidad efectiva de unidades. Dado que las funciones reales de oferta y demanda suelen carecer de soluciones analíticas cerradas debido a la no linealidad del tráfico y la dispersión geográfica, el análisis numérico proporciona herramientas iterativas para aproximar raíces de equilibrio y estimar coeficientes de sensibilidad marginal (elasticidad) a partir de observaciones discretas.

=== 3. Fundamentos de Optimización y Asignación de Recursos
Como alternativa a trasladar todo el costo de congestión al usuario mediante incrementos tarifarios continuos, la investigación de operaciones provee marcos de optimización de recursos limitados. Estos modelos permiten formular problemas de asignación presupuestaria orientados a maximizar el impacto de programas de incentivos o bonificaciones para conductores, buscando fortalecer la oferta en zonas y periodos críticos sin comprometer la accesibilidad económica de los pasajeros.
