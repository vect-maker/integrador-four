= Contextualización de la Investigación

== El Transporte Selectivo por Aplicación y el Rol Central de la Tarifa Dinámica

La movilidad urbana moderna en capitales y áreas metropolitanas latinoamericanas ha experimentado una transformación profunda con la adopción de plataformas tecnológicas de transporte bajo demanda (_ride-hailing_). A diferencia del servicio de taxi convencional, caracterizado por tarifas fijas o negociadas de forma discrecional, las aplicaciones móviles operan como *mercados bilaterales* (_two-sided markets_) donde convergen usuarios que demandan movilidad inmediata y socios conductores que ofrecen su capacidad vehicular.

En este ecosistema, la *tarificación dinámica* (_surge pricing_) constituye el mecanismo económico y operativo rector. Cuando la demanda de viajes supera la disponibilidad inmediata de vehículos en un sector, o cuando el entorno vial se deteriora por congestión o fenómenos climáticos, la plataforma eleva temporalmente las tarifas a través de un multiplicador continuo. Teóricamente, este mecanismo cumple un doble propósito equilibrador:

+ *Racionar la demanda:* Desalentar los viajes prescindibles entre usuarios con menor disposición o capacidad de pago.
+ *Estimular la oferta:* Atraer conductores hacia los cuadrantes con déficit de vehículos mediante la expectativa de mayores ingresos por servicio.

Sin embargo, en mercados urbanos marcados por disparidades socioeconómicas y limitaciones de infraestructura, la aplicación descalibrada de la tarifa dinámica introduce fricciones severas: incrementos abruptos en el precio final pueden inducir tasas críticas de cancelación de viajes por parte de pasajeros sensibles al costo, generar exclusión territorial en cuadrantes populares y provocar que los conductores rechacen o cancelen servicios en zonas congestionadas.

La presente investigación se sitúa en el municipio de *Managua, Nicaragua*, y toma como unidad de análisis el servicio de transporte selectivo de la plataforma *MoviGo*. La empresa opera en el área metropolitana de la capital conectando a pasajeros con una flota categorizada en tres modalidades:

- `movigo_estandar`: Vehículos sedán convencionales para movilidad diaria.
- `movigo_comfort`: Vehículos de gama superior con mayores prestaciones de comodidad y espacio.
- `movigo_moto`: Unidades de dos ruedas para traslados individuales ágiles y de menor costo.

El foco central del estudio radica en *evaluar la eficacia del esquema de tarificación dinámica de MoviGo*, analizando la sensibilidad y elasticidad de la demanda, las tasas de cancelación resultantes, la equidad socio-espacial entre cuadrantes urbanos y las estrategias de asignación de incentivos económicos como alternativa sostenible al aumento punitivo de tarifas.

== Dimensión Tarifaria Paramétrica y Mecánica del Surge Pricing

MoviGo opera bajo una regla de tarificación compuesta y paramétrica que calcula en primer lugar una tarifa base regular en función del cuadrante de origen, la distancia recorrida y el tiempo transcurrido, sobre la cual se aplica el multiplicador dinámico:

$ "TarifaBase" = "BajadaBandera"_z + (18.0 dot "distancia_km") + (4.5 dot "duracion_minutos") $

$ "TarifaFinal" = "TarifaBase" dot "multiplicador_dinamico" $

Donde:
- *$"BajadaBandera"_z$:* Costo fijo de inicio de servicio asociado al cuadrante urbano de partida $z$, con valores que oscilan entre *C\$ 35.0 y C\$ 80.0 NIO*.
- *Costo por Distancia:* Cargo paramétrico fijo de *C\$ 18.0 NIO* por cada kilómetro recorrido.
- *Costo por Tiempo:* Cargo paramétrico fijo de *C\$ 4.5 NIO* por cada minuto transcurrido de trayecto.
- *Multiplicador Dinámico ($m$):* Factor escalar continuo que oscila regularmente entre *$1.00 times$ (tarifa regular) y $2.80 times$ (alta demanda)*, alcanzando techos extraordinarios de hasta *$3.20 times$* durante episodios de tormenta y colapso circulatorio.

Esta estructura tarifaria vuelve imperativo indagar si los valores del multiplicador efectivamente convergen hacia un *punto de equilibrio de mercado ($m^*$)* o si, por el contrario, operan en rangos de sobredimensión que provocan la pérdida recurrente de usuarios y servicios no concretados.

== Dimensión Climática y Choques Exógenos de Tráfico

En Managua, el clima tropical de sabana impone episodios intensos de lluvias torrenciales y tormentas convectivas. Dada la topografía y el déficit histórico de drenaje pluvial de la capital, las precipitaciones generan inundaciones temporales en cauces viales y rotondas neurálgicas (*Rotonda Centroamérica, Metrocentro, Rotonda Rubén Darío, Pista Juan Pablo II*).

La plataforma MoviGo registra esta dinámica en sus series meteorológicas diarias mediante cuatro variables fundamentales:
- Precipitación acumulada (`precipitacion_mm`).
- Temperatura media ambiental (`temperatura_c`).
- Condición del cielo (`despejado`, `nublado`, `lluvia_ligera`, `tormenta`).
- *Índice de Congestión Vial:* Indicador continuo que escala desde $1.00$ (flujo vehicular libre) hasta $3.50$ (colapso de la red circulatoria).

Los días de tormenta generan un choque simultáneo en el mercado: la demanda de viajes se dispara al buscar los peatones refugio en vehículos selectivos, mientras que la oferta de conductores se contrae o avanza a velocidades drásticamente reducidas. En respuesta, el algoritmo de MoviGo activa multiplicadores extremos ($2.50times - 3.20times$). Evaluar si esta respuesta tarifaria equilibra el sistema o exacerba la insatisfacción y la cancelación constituye una prioridad investigativa.

== Alternativa Operativa: Campañas de Incentivos y Subsidios de Oferta

Frente a la limitación de apoyarse exclusivamente en la tarificación dinámica punitiva para resolver el déficit de vehículos, MoviGo dispone de un portafolio de *campañas de incentivos y bonos para socios conductores* (`/movigo/campanas`). Estos programas buscan inyectar horas activas de conexión en franjas y zonas críticas (`meta_viajes`, `hora_pico_lluvia`, `zona_alta_demanda`) sin traspasar íntegramente el sobrecosto al usuario final.

La optimización de estos programas bajo restricciones de presupuesto operativo (problema de la mochila binaria) emerge como la contraparte prescriptiva natural al análisis tarifario: resolver la escasez de oferta mediante incentivos planificados en lugar de subidas desproporcionadas del multiplicador dinámico.

== Perspectiva de Ciencia de Datos y Acceso Exclusivo vía API REST

Metodológicamente, la investigación se apoya en un entorno de simulación transaccional de alta fidelidad que modela un año completo de operaciones de MoviGo, con *77,386 registros de viajes*, 19,375 pings de telemetría GPS, catálogos georreferenciados de zonas y conductores, y series meteorológicas continuas.

Una condición rectora del proyecto es que *el acceso a los datos no se realiza mediante volcados directos ni sentencias SQL al servidor transaccional, sino única y exclusivamente consumiendo una base de datos sintética expuesta a través de una API REST en una URL pública temporal provista para el curso* (cuyo repositorio de código fuente se referenciará e integrará en etapas posteriores).

En consecuencia, el proceso analítico requiere:
+ Diseñar un pipeline de extracción paginada en Python (`httpx`/`requests`).
+ Consolidar los registros en una base de datos relacional local en *PostgreSQL* que actúe como réplica del entorno OLTP operativo.
+ Desplegar un almacén analítico (*Data Warehouse*) modelado y transformado mediante *dbt (Data Build Tool)*.
+ Aplicar técnicas de inferencia estadística, métodos numéricos y optimización sobre los datos transformados.
