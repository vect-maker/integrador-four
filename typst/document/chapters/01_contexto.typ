= Contextualización de la Investigación

== Sistema de Movilidad Urbana y el Rol del Transporte Selectivo por Plataforma

La movilidad urbana constituye un sistema dinámico y multidimensional en el que convergen decisiones de los usuarios, disponibilidad de vehículos, configuración territorial, condiciones de circulación, tiempos de desplazamiento, costos operativos y variaciones del entorno. En el caso del transporte selectivo, estas relaciones adquieren especial relevancia porque la prestación eficaz del servicio depende de la capacidad de ubicar oportunamente las unidades en aquellos sectores donde se concentra o se desplaza la demanda, responder con tiempos razonables de atención y mantener un esquema tarifario que guarde correspondencia con las condiciones reales de operación. Por ello, la distribución espacial de la oferta y la definición de tarifas no pueden analizarse como procesos aislados, sino como componentes interdependientes de un mismo mercado bilateral (@cachon2017).

En este ecosistema, las plataformas tecnológicas bajo demanda (_ride-hailing_) operan como intermediarios algorítmicos. La *tarificación dinámica* (_surge pricing_) se erige como el mecanismo económico rector para balancear oferta y demanda en tiempo real. Cuando la intensidad de solicitudes supera la disponibilidad inmediata de vehículos en un sector, o cuando el entorno vial se deteriora por congestión o fenómenos climáticos, la plataforma eleva temporalmente las tarifas a través de un multiplicador continuo. Teóricamente, este mecanismo cumple un doble propósito equilibrador:

+ *Racionar la demanda:* Desalentar los viajes prescindibles entre usuarios con menor disposición o capacidad de pago.
+ *Estimular la oferta:* Atraer conductores hacia los cuadrantes con déficit de vehículos mediante la expectativa de un mayor ingreso marginal.

Sin embargo, en mercados urbanos caracterizados por marcadas disparidades socioeconómicas y limitaciones de infraestructura, la aplicación descalibrada de la tarifa dinámica introduce fricciones severas: incrementos abruptos en el precio final pueden inducir tasas críticas de cancelación de viajes por parte de pasajeros sensibles al costo, generar exclusión territorial en sectores populares y propiciar que los conductores rechacen o cancelen servicios en zonas congestionadas.

La presente investigación se sitúa en el municipio de *Managua, Nicaragua*, y toma como unidad de análisis el servicio de transporte selectivo de la empresa *MoviGo*. La plataforma atiende la movilidad metropolitana articulando a pasajeros y conductores a través de tres modalidades vehiculares:

- `movigo_estandar`: Unidades sedán convencionales orientadas al traslado urbano cotidiano.
- `movigo_comfort`: Vehículos de gama superior con mayores prestaciones de espacio y comodidad.
- `movigo_moto`: Flota de dos ruedas para traslados individuales ágiles y de menor costo.

El eje central del estudio consiste en *evaluar la eficacia del esquema de tarificación dinámica de MoviGo*, analizando la sensibilidad y elasticidad de la demanda, las tasas de cancelación resultantes, la heterogeneidad territorial de la capital y la viabilidad de esquemas de incentivos económicos como alternativa sostenible al aumento punitivo de tarifas.

== Dimensión Tarifaria Paramétrica y Dinámica del Surge Pricing

El sistema tarifario de MoviGo opera bajo una regla de tarificación compuesta y paramétrica que calcula en primer lugar una tarifa base regular en función de la distancia, el tiempo y el cuadrante de origen, sobre la cual se aplica el multiplicador dinámico:

$ "TarifaBase" = "BajadaBandera"_z + (18.0 dot "distancia_km") + (4.5 dot "duracion_minutos") $

$ "TarifaFinal" = "TarifaBase" dot "multiplicador_dinamico" $

Donde:
- *$"BajadaBandera"_z$:* Costo fijo inicial de arranque del servicio, diferenciado según el cuadrante urbano de partida $z$ (con valores que oscilan entre *C\$ 35.0 y C\$ 80.0 NIO*).
- *Costo por Distancia:* Cargo paramétrico fijo de *C\$ 18.0 NIO* por cada kilómetro recorrido.
- *Costo por Tiempo:* Cargo paramétrico fijo de *C\$ 4.5 NIO* por cada minuto transcurrido de trayecto.
- *Multiplicador Dinámico ($m$):* Factor escalar continuo que oscila regularmente entre *$1.00 times$ (tarifa regular) y $2.80 times$ (alta demanda)*, alcanzando techos extraordinarios de hasta *$3.20 times$* ante perturbaciones meteorológicas severas y colapso vial.

Esta arquitectura tarifaria exige examinar si las reglas de cobro utilizadas mantienen coherencia con las características de los desplazamientos y si el multiplicador converge efectivamente hacia un equilibrio de mercado o si, por el contrario, opera en rangos de sobredimensión que desbordan la disposición de pago del usuario, induciendo cancelaciones masivas de viajes.

== Dimensión Territorial y Heterogeneidad Urbana de Managua

La dimensión territorial agrega un nivel de complejidad determinante. Managua presenta una estructura urbana extensa, dispersa, policéntrica y marcadamente estratificada, con sectores residenciales, comerciales, institucionales, educativos y de servicios que generan patrones de movilidad asimétricos y diferenciados (@jica2017).

En este contexto, la demanda de transporte no se distribuye de manera uniforme en el espacio ni permanece constante durante la jornada: la localización de los puntos de atracción laboral y comercial, la conectividad de la red vial, las distancias entre sectores y los niveles diferenciados de accesibilidad condicionan tanto la disponibilidad física de vehículos como las decisiones de los pasajeros:

+ *Asimetría en la Elasticidad-Precio:* Los usuarios de cuadrantes populares presentan una sensibilidad al precio sustancialmente más elástica frente a alzas tarifarias que aquellos en cuadrantes corporativos o de estrato socioeconómico alto.
+ *Sensibilidad a Medios de Pago y Liquidez:* La heterogeneidad territorial se traduce en una desigual bancarización. El predominio de pagos en efectivo en sectores populares frente al uso de tarjeta o billetera digital en cuadrantes comerciales provoca que aumentos imprevistos en el multiplicador superen el circulante disponible del pasajero, motivando la cancelación inmediata de la solicitud.

== Dimensión Climática y Choques Exógenos en la Red Vial

Las condiciones climáticas se incorporan como una dimensión complementaria y no como el único eje explicativo del estudio. En el municipio de Managua, la variabilidad de la precipitación y la temperatura forma parte intrínseca del contexto operativo del transporte. De acuerdo con las normas climatológicas históricas de la estación del Aeropuerto Internacional Augusto C. Sandino —reportadas por el Instituto Nicaragüense de Estudios Territoriales (@ineter2021)—, Managua registra una precipitación media anual aproximada de *1,119.8 mm*, caracterizada por una marcada estacionalidad con mayores acumulados durante la época lluviosa, y una temperatura media anual de *26.9 °C*.

La topografía de la capital, sumada a la vulnerabilidad y déficit histórico del drenaje pluvial urbano, ocasiona que eventos de precipitación torrencial y tormentas convectivas deriven en anegamientos temporales de cauces viales y nudos circulatorios neurálgicos (*Rotonda Centroamérica, Metrocentro, Rotonda Rubén Darío, Pista Juan Pablo II*).

Estas condiciones meteorológicas modifican severamente la dinámica del servicio:
- Se reduce la velocidad media de circulación y se prolongan los tiempos de viaje.
- La demanda de viajes se dispara abruptamente al buscar los peatones refugio en vehículos selectivos.
- La disponibilidad efectiva de unidades se contrae o experimenta demoras críticas para alcanzar los puntos de recogida.

Frente a este desbalance simultáneo de oferta y demanda, el algoritmo de la plataforma responde activando multiplicadores extremos ($2.50 times - 3.20 times$). Evaluar si esta respuesta tarifaria equilibra el sistema o exacerba la insatisfacción y la tasa de cancelación constituye un eje investigativo prioritario.

== Alternativa Operativa: Campañas de Incentivos y Subsidios de Oferta

Frente a la limitación de apoyarse exclusivamente en la tarificación dinámica punitiva para resolver el déficit de vehículos, MoviGo dispone de un portafolio de *campañas de incentivos y bonos para socios conductores* (`meta_viajes`, `hora_pico_lluvia`, `zona_alta_demanda`).

Estos programas buscan inyectar horas activas de conexión en franjas y zonas críticas mediante incentivos económicos directos, sin traspasar íntegramente el sobrecosto al usuario final. La optimización de estos programas bajo restricciones de presupuesto operativo (problema de optimización de la mochila) emerge como la contraparte analítica y prescriptiva al análisis tarifario: resolver la escasez de oferta mediante incentivos planificados en lugar de subidas desproporcionadas del multiplicador.

== Perspectiva de Ciencia de Datos y Acceso Exclusivo vía API REST

Desde la perspectiva de la Ciencia de Datos, el problema ofrece condiciones propicias para articular procesos de recolección, depuración, almacenamiento relacional, modelación analítica y evaluación estadística.

Para la contextualización del estudio es fundamental diferenciar entre las condiciones generales del sistema de movilidad y los registros específicos de la empresa:
1. En esta fase de propuesta, las magnitudes exactas de viajes, patrones de asignación, telemetría y tarifas efectivas no se asumen de manera apriorística ni arbitraria.
2. Los datos operacionales corresponden a un entorno transaccional sintético de alta fidelidad (que modela un año completo de operaciones con 77,386 registros de viajes, 19,375 pings de telemetría GPS, catálogos de zonas y conductores, y series meteorológicas continuas), al cual los investigadores acceden *exclusivamente consumiendo una API REST en una URL pública temporal provista para el curso* (cuyo repositorio de código fuente se referenciará e integrará en etapas posteriores).

En concordancia, el flujo de trabajo computacional se estructura en las siguientes fases:
+ *Ingesta:* Construcción de un pipeline automatizado en Python (`httpx` / `requests`) con control de paginación y manejo de errores para extraer los endpoints de la API.
+ *Almacenamiento Transaccional:* Carga de los datos brutos en una base de datos relacional local en *PostgreSQL*, representando el entorno OLTP de la plataforma.
+ *Transformación y Modelado Analítico:* Despliegue de un almacén analítico estructurado en estrella mediante *dbt (Data Build Tool)*, garantizando trazabilidad y calidad de datos.
+ *Inferencia y Evaluación:* Aplicación de análisis estadístico, estimación de elasticidades de demanda y modelación matemática sobre el repositorio analítico resultante.
