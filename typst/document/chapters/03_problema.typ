#show bibliography: none
#bibliography("../../references.bib")

= Planteamiento del Problema

== El Dilema de Calibración de la Tarifa Dinámica en Mercados de Movilidad

En los servicios de transporte selectivo por aplicación móvil (_ride-hailing_), la fijación de precios dinámicos (_surge pricing_) opera como el mecanismo regulador fundamental para coordinar la oferta vehicular dispersa con una demanda volátil en tiempo real. La teoría económica postula que el multiplicador tarifario debe actuar como una señal de mercado que racione las solicitudes no urgentes y atraiga conductores hacia los sectores con escasez de unidades disponibles @cachon2017; @zha2018.

Sin embargo, en la práctica operacional de la plataforma *MoviGo* en el municipio de Managua, este mecanismo enfrenta un dilema crítico de calibración:

+ *Sobredimensión del Multiplicador:* Si el algoritmo eleva la tarifa de forma desproporcionada ante un pico de demanda o una lluvia repentina, se sobrepasa la elasticidad-precio y la disposición a pagar de los usuarios, disparando la *tasa de cancelación por parte del usuario* y generando abandono de la plataforma @hall2015.
+ *Subestimación del Multiplicador:* Por el contrario, si la tarifa se mantiene baja o estática durante periodos de alta saturación vial, los conductores desocupados no encuentran incentivo económico suficiente para desplazarse hacia los puntos críticos. Esto genera una escasez prolongada de vehículos, tiempos excesivos de espera y una elevada *tasa de cancelación por parte del conductor*, quien rechaza atender traslados lejanos o poco remunerativos @castillo2017.

El problema central no radica en la existencia de la tarifa dinámica, sino en la *ausencia de una calibración cuantitativa del multiplicador de equilibrio ($m^*$)* que iguale la oferta y la demanda sin generar externalidades operativas destructivas:

$ f(m) = "Demanda"(m) - "Oferta"(m) = 0 $ <eq-exceso-demanda>

== Manifestación Territorial y Fricción Socioeconómica en Managua

La complejidad del esquema tarifario se intensifica debido a la estructura urbana fragmentada y heterogénea de Managua. La plataforma opera sobre cuadrantes urbanos con marcadas asimetrías socioeconómicas:

- *Zonas de estrato alto* (Villa Fontana, Santo Domingo, Las Colinas): con tarifas base de bajada de bandera elevadas (C\$ 70 a C\$ 80 NIO) y usuarios con predominio de pagos digitales y menor sensibilidad al precio.
- *Zonas comerciales e institucionales* (Metrocentro, Plaza España, Eje Corporativo): que concentran flujos masivos de salida en horas pico vespertinas (17:00 a 18:59).
- *Zonas populares y de comercio informal* (Mercado Oriental, Mercado Roberto Huembes, Ciudad Jardín): con tarifas base menores (C\$ 35 a C\$ 40 NIO), donde los usuarios dependen predominantemente del dinero en efectivo y exhiben una elasticidad-precio significativamente más alta.

Cuando el algoritmo de MoviGo aplica multiplicadores dinámicos agresivos ($1.80times$ a $2.80times$) sobre cuadrantes populares, el costo total del traslado se duplica o triplica súbitamente. Dado que muchos pasajeros en estas zonas disponen de un presupuesto estricto en efectivo al momento de la solicitud, el alza tarifaria desencadena cancelaciones inmediatas y exclusión socio-espacial, comprometiendo el rol social del transporte en la capital.

== Perturbaciones Climáticas y Vulnerabilidad de la Operación

Las condiciones meteorológicas añaden una perturbación exógena severa a la dinámica tarifaria. Durante los frecuentes episodios de lluvias torrenciales en Managua, el índice de congestión vial escala hasta valores críticos ($3.50$ sobre una escala de $1.00$ a $3.50$), anegando cauces y reduciendo a la mitad la velocidad de circulación de la flota telemétrica.

Esta situación produce un doble desajuste:
- *Explosión de Demanda:* Los peatones y usuarios del transporte colectivo colapsado buscan refugio en vehículos de MoviGo, provocando que el algoritmo responda aplicando los techos máximos de tarifa dinámica ($2.50times$ a $3.20times$).
- *Contracción de Velocidad:* Las unidades activas quedan atrapadas en cuellos de botella, prolongando la duración de los viajes en curso y reduciendo drásticamente la tasa de retorno de los vehículos a estado disponible.

La combinación de tarifas en su punto máximo y tiempos de llegada prolongados genera un colapso en la tasa de finalización de viajes. El servicio experimenta un incremento pronunciado de cancelaciones tanto de usuarios frustrados por la espera como de choferes que se rehúsan a transitar por vías anegadas.

== Estrangulamiento de la Red Vial y Demoras Críticas en Tiempos de Llegada

Actualmente, el incremento de la tarifa dinámica trasladada al usuario no resuelve la rigidez espacial de la red vial urbana de Managua. Durante eventos de congestión o lluvia torrencial, los corredores arteriales sufren anegamientos e interrupciones que duplican los tiempos de traslado vehicular. 

El problema radica en que el sistema de asignación de viajes no anticipa los cuellos de botella ni optimiza las rutas mediante algoritmos de grafos, provocando que los vehículos queden varados en tramos críticos. La dilatación resultante en los tiempos de espera hasta la recogida desborda la paciencia de los pasajeros, detonando cancelaciones masivas que inutilizan el incentivo tarifario.

== Dispersión Transaccional y Necesidad de un Enfoque de Ciencia de Datos

Los datos que reflejan este fenómeno se encuentran fragmentados en endpoints de una *API REST pública*:
- Transacciones históricas y motivos de cancelación en `/movigo/viajes` (> 77,000 registros).
- Pings de velocidad y estado operativo en `/movigo/telemetria` (> 19,000 pings).
- Factores exógenos diarios de lluvia y tráfico en `/movigo/clima`.
- Zonas, usuarios, conductores y campañas en sus respectivos directorios.

Sin un pipeline automatizado de ingeniería de datos (ingesta en Python, almacenamiento en Azure PostgreSQL y transformación dimensional auditable con *dbt Core* y *DuckDB*), resulta inviable cuantificar con precisión la tasa de cancelación, modelar el comportamiento del usuario, estimar numéricamente el multiplicador de equilibrio ni optimizar las rutas de desplazamiento sobre la red urbana.

== Formulación del Problema Central de Investigación

A partir de las problemáticas descritas, el problema central de investigación se sintetiza en la siguiente interrogante formulada:

¿Cuál es el impacto del esquema de tarificación dinámica (*surge pricing*) sobre la tasa de cancelación de viajes en el servicio MoviGo en el municipio de Managua durante 2024, y de qué manera pueden determinarse umbrales tarifarios de equilibrio mediante métodos numéricos y optimizarse las rutas de desplazamiento en la red vial urbana mediante teoría de grafos para mitigar el abandono del servicio bajo perturbaciones climáticas y asimetrías territoriales?
