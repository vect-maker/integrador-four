= Antecedentes

== Tarificación Dinámica y Modelos de Equilibrio en Mercados Bilaterales de Movilidad

La literatura científica sobre plataformas de movilidad bajo demanda (_ride-hailing_) sitúa a los algoritmos de tarificación dinámica (_surge pricing_) como el mecanismo regulatorio primordial de los mercados bilaterales. En estos mercados, la plataforma debe balancear de forma simultánea la utilidad de los pasajeros y los ingresos de los conductores bajo condiciones de incertidumbre y fricción espacial.

Cachon, Daniels y Lobel @cachon2017 demostraron formalmente que los esquemas de precios dependientes del estado (_state-dependent surge pricing_) son superiores a las tarifas fijas convencionales, dado que permiten maximizar el bienestar social y la tasa de servicio durante periodos de sobrecarga. No obstante, advierten que la efectividad del mecanismo depende críticamente de la elasticidad de respuesta de ambos lados del mercado: un incremento tarifario que no logre movilizar conductores adicionales simplemente actúa como una barrera excluyente de demanda.

En una línea convergente, Zha, Yin y Du @zha2018 formularon modelos de optimización bi-nivel para analizar el equilibrio de precios en redes urbanas congestionadas. Sus hallazgos revelaron que, si bien el multiplicador dinámico atrae vehículos hacia zonas con déficit de oferta, la fijación de precios excesivos induce desequilibrios espaciotemporales secundarios, empujando a los usuarios hacia modos de transporte alternativos o forzando la cancelación de servicios solicitados.

Asimismo, Castillo, Knoepfle y Weyl @castillo2022, en su influyente estudio sobre el colapso del servicio en plataformas de movilidad (_surge pricing and wild goose chases_), demostraron que una tarificación insuficiente durante picos de demanda conduce a una escasez severa de unidades disponibles, provocando que los pocos conductores libres atiendan solicitudes excesivamente lejanas, lo que incrementa los tiempos de espera y eleva las cancelaciones mutuas.

== Elasticidad-Precio, Sensibilidad al Costo y Abandono del Viaje

La respuesta empírica de los pasajeros ante variaciones en el multiplicador dinámico ha sido objeto de exhaustiva investigación microeconométrica. Cohen et al. @cohen2016 estimaron la curva de demanda y el excedente del consumidor en servicios de transporte por app, identificando que la demanda global tiende a ser inelástica en trayectos cortos o rutinarios, pero se vuelve marcadamente elástica ($|epsilon| > 1$) ante multiplicadores superiores a $1.25times$ o en franjas horarias no laborales.

Hall, Kendrick y Nosko @hall2015 aportaron evidencia empírica directa sobre la mecánica del _surge pricing_, demostrando que la pérdida de eficiencia en el servicio no se origina únicamente en la escasez de vehículos, sino en la tasa de abandono de los usuarios cuando la tarifa supera su umbral de tolerancia. Cuando el multiplicador se incrementa drásticamente, la probabilidad de que un usuario acepte la cotización inicial pero cancele el viaje minutos después ante la combinación de alta tarifa y tiempo de espera prolongado crece exponencialmente.

En el contexto de MoviGo, donde el multiplicador oscila de forma continua entre $1.00times$ y $2.80times$ (y hasta $3.20times$), estos antecedentes justifican la necesidad de estimar la elasticidad zonal mediante métodos cuantitativos y aproximar el *multiplicador de equilibrio ($m^*$)* que minimice las cancelaciones sin desabastecer el cuadrante.

== Equidad Socio-Espacial y Heterogeneidad Territorial

La literatura reciente en economía del transporte y ciencias de la computación ha puesto en tela de juicio la neutralidad de los algoritmos de precios dinámicos respecto a la equidad socioeconómica y territorial.

Diversos estudios señalan que los algoritmos de _surge pricing_ tienden a concentrar los incrementos tarifarios en áreas con alta densidad de actividades comerciales y corporativas, pero pueden castigar desproporcionadamente a sectores residenciales periféricos o de estratos económicos bajos, donde la población carece de alternativas eficientes de movilidad masiva y depende del dinero en efectivo como principal medio de pago.

En Managua, donde los cuadrantes urbanos presentan una marcada segregación económica (desde zonas de alto poder adquisitivo como Santo Domingo o Las Colinas hasta sectores populares como el Mercado Oriental o Ciudad Jardín), estudiar la disparidad en las tarifas cobradas, las formas de pago adoptadas y la incidencia de cancelaciones resulta indispensable para evaluar si el algoritmo de MoviGo perpetúa brechas de accesibilidad urbana.

== Perturbaciones Meteorológicas y Choques Exógenos de Demanda

El impacto del clima sobre la movilidad urbana y la demanda de transporte selectivo cuenta con una sólida fundamentación empírica. Chen et al. @chen2017, utilizando registros masivos de viajes y datos meteorológicos, evidenciaron que la precipitación altera de manera radical los patrones de generación y atracción de viajes, incrementando la demanda repentina y reduciendo la velocidad media de circulación.

Liu, Jiang y Chen @liu2021 demostraron que los efectos de la lluvia sobre las plataformas de _ride-hailing_ no son homogéneos: las tormentas intensas inducen picos extraordinarios en los multiplicadores dinámicos que no siempre se traducen en viajes completados, sino en un incremento sustancial de la tasa de cancelación por parte de conductores atrapados en cuellos de botella viales.

Para el caso de MoviGo en Managua, la disponibilidad de series sincronizadas de precipitación (`precipitacion_mm`) y congestión vial (`indice_congestion` de 1.00 a 3.50) permite modelar formalmente la interacción entre choques meteorológicos, alzas tarifarias y fiabilidad del servicio.

== Incentivos a Conductores como Mecanismo Complementario al Surge Pricing

Frente a las externalidades negativas de transferir todo el costo de congestión al pasajero mediante el _surge pricing_, la investigación de operaciones ha propuesto esquemas de subsidios e incentivos directos a los conductores.

En lugar de elevar las tarifas al usuario hasta niveles prohibitivos en momentos de escasez, las plataformas diseñan programas de bonificación garantizada que compensan al conductor por conectarse en franjas horarias o zonas específicas. La formulación matemática de este dilema bajo un presupuesto empresarial finito se traduce en un *Problema de la Mochila Binaria (Knapsack 0/1)*, donde el objetivo es seleccionar la combinación óptima de campañas de bonos que maximice las horas-hombre de conexión activa.

Este enfoque complementa la perspectiva analítica de MoviGo, transformando los datos del catálogo `/movigo/campanas` en una herramienta prescriptiva de optimización.

== Antecedente Institucional en Managua: Plan Maestro JICA (2017)

En el ámbito local, el antecedente institucional de mayor envergadura corresponde al *Proyecto del Plan Maestro para el Desarrollo Urbano del Municipio de Managua*, formulado por la Agencia de Cooperación Internacional del Japón (JICA) y la Alcaldía de Managua en 2017 @jica2017.

El diagnóstico integral de movilidad de JICA reveló que *aproximadamente el 26% de los viajes motorizados diarios en Managua se realizan en transporte selectivo*, evidenciando un peso relativo significativamente mayor al observado en otras capitales de la región. Esta dependencia estructural obedece a la baja frecuencia, saturación y rigidez de rutas del transporte colectivo tradicional.

Dicho antecedente ratifica que en Managua el transporte selectivo no constituye un servicio suntuario, sino una modalidad de movilidad cotidiana prioritaria. Por consiguiente, evaluar y calibrar la tarificación dinámica de MoviGo responde a una necesidad real de garantizar un servicio accesible, justo y sostenible para la capital nicaragüense.
