= Antecedentes de la Investigación

== Asignación Dinámica, Reposicionamiento y Distribución Espaciotemporal de la Flota

La literatura científica sobre servicios de movilidad bajo demanda (_ride-hailing_) identifica la asignación dinámica de solicitudes y el posicionamiento territorial de vehículos como problemas nodales para la eficiencia del sistema. Alonso-Mora et al. (@alonsomora2017), mediante un modelo de asignación dinámica viaje-vehículo aplicado a datos masivos de movilidad en Nueva York, demostraron que la localización de la demanda y la disponibilidad espacial de vehículos deben analizarse de manera conjunta para reducir los tiempos de espera y maximizar el aprovechamiento de la flota.

En una línea aplicada al reposicionamiento de unidades desocupadas, Jiao et al. (@jiao2021) desarrollaron y evaluaron un marco basado en aprendizaje por refuerzo para orientar la redistribución proactiva de vehículos considerando el estado espaciotemporal global del sistema. Estos trabajos constituyen antecedentes metodológicos pertinentes para estudiar la operación de MoviGo, pues evidencian que la eficiencia operativa depende de la correspondencia continua entre la demanda observada, la ubicación de las unidades y las condiciones circulatorias.

El desequilibrio espaciotemporal entre oferta y demanda representa, por tanto, una de las mayores dificultades operativas en el transporte bajo solicitud. La demanda tiende a concentrarse en sectores y franjas horarias específicas mientras los vehículos disponibles permanecen dispersos en otras zonas, lo que incrementa los recorridos de aproximación en vacío (_deadhead_), los tiempos de espera del usuario y los períodos improductivos sin pasajero. Como demuestran Alonso-Mora et al. (@alonsomora2017) y Jiao et al. (@jiao2021), el análisis territorial de la flota no debe limitarse a contabilizar vehículos agregados, sino que exige modelar su distribución relativa respecto a los patrones espaciales y temporales de las solicitudes.

== Modelos de Tarificación Dinámica y Equilibrio en Mercados de Movilidad

En relación con el componente tarifario, la investigación internacional ha demostrado que la fijación dinámica de precios interactúa directamente con la necesidad de equilibrar oferta y demanda, aunque sus impactos reales dependen de la estructura del mercado y de los objetivos algorítmicos de la plataforma.

Zha, Yin y Du (@zha2018) analizaron la tarificación dinámica (_surge pricing_) mediante modelos de equilibrio y programación bi-nivel, encontrando que los mecanismos de precios modifican tanto la disponibilidad de conductores como el comportamiento de los usuarios en la red. Por su parte, Battifarano y Qian (@battifarano2019) desarrollaron un marco predictivo para modelar multiplicadores tarifarios en tiempo real incorporando información de tráfico, entorno urbano y condiciones meteorológicas.

A nivel microeconómico, Cachon, Daniels y Lobel (@cachon2017) probaron que los esquemas de precios dependientes del estado del sistema superan a las tarifas fijas convencionales, maximizando el bienestar social solo cuando existe elasticidad efectiva en ambos lados del mercado. En contraposición, Castillo, Knoepfle y Weyl (@castillo2022) alertaron sobre el riesgo del colapso operativo (_wild goose chase_) cuando la tarifa está descalibrada: una tarificación deficiente o desproporcionada genera dispersión de vehículos y tiempos de espera excesivos que desembocan en cancelaciones mutuas.

Estos antecedentes no implican asumir a priori que el sistema actual de MoviGo sea defectuoso; su pertinencia radica en demostrar que la evaluación tarifaria se enriquece sustancialmente cuando se relaciona con variables de demanda, disponibilidad zonal, congestión vial y factores de entorno, en lugar de reducirse únicamente a la distancia recorrida.

== Elasticidad-Precio, Sensibilidad al Costo y Cancelación de Viajes

La respuesta empírica de los pasajeros ante variaciones del multiplicador tarifario ha sido examinada cuantitativamente en diversos mercados. Cohen et al. (@cohen2016) estimaron la curva de demanda y el excedente del consumidor en servicios por app, identificando que la demanda suele ser inelástica en trayectos habituales, pero se vuelve marcadamente elástica ($|epsilon| > 1$) ante incrementos pronunciados del precio o en franjas no laborales.

Asimismo, Hall, Kendrick y Nosko (@hall2015) aportaron evidencia empírica directa sobre la tasa de abandono de los usuarios: cuando el multiplicador dinámico sobrepasa el umbral de tolerancia del consumidor, la probabilidad de que el viaje sea cancelado tras la cotización inicial se eleva de forma exponencial, desvirtuando el propósito del algoritmo regulador.

En el caso de MoviGo, estos antecedentes justifican la necesidad de estimar empíricamente la elasticidad-precio zonal y aproximar el multiplicador de equilibrio que prevenga la pérdida de servicios sin desincentivar la oferta de conductores.

== Incidencia de Condiciones Meteorológicas sobre la Demanda y Operación de Movilidad

La incidencia de las condiciones atmosféricas sobre los sistemas de transporte selectivo cuenta con amplio respaldo empírico en la literatura contemporánea.

Chen et al. (@chen2017), mediante el análisis de datos de taxímetros y trayectorias GPS, determinaron que la precipitación modifica significativamente la distribución temporal y espacial de la demanda, con efectos asimétricos según la intensidad de la lluvia y la hora del día. Sun et al. (@sun2020) constataron que las precipitaciones alteran la distribución espacial de pasajeros y unidades aun cuando el volumen agregado total no varíe en igual magnitud, generando incrementos críticos en los tiempos de búsqueda, caídas en la velocidad de circulación y deterioro del nivel de servicio.

De forma específica para aplicaciones de _ride-hailing_, Liu, Jiang y Chen (@liu2021) comprobaron que la lluvia, la velocidad del viento y las condiciones de tormenta ejercen efectos heterogéneos según la franja horaria, el día de la semana y la distancia del trayecto. Estos hallazgos fundamentan la incorporación de los factores climáticos como variables explicativas complementarias en la investigación de MoviGo, sin considerarlos como el único factor explicativo, sino como inductores de perturbaciones que tensionan el esquema tarifario.

== Uso de Telemetría GPS y Datos Georreferenciados en Ciencia de Datos

Otro antecedente metodológico primordial reside en el empleo de telemetría georreferenciada masiva para comprender la dinámica del transporte bajo demanda. Chen et al. (@chen2017) evidenciaron que los registros de posicionamiento satelital permiten reconstruir unidades de viaje y trayectorias continuas a partir de atributos clave: marca temporal, latitud, longitud, velocidad instantánea, rumbo y estado de ocupación de la unidad.

Esta perspectiva se vincula directamente con la Ciencia de Datos y la ingeniería analítica, al demandar la estructuración de procesos formales de extracción, depuración, integración multidimensional y modelado espacial. Para el caso de MoviGo, la viabilidad de implementar estas técnicas exige diferenciar rigurosamente entre los atributos disponibles en los esquemas transaccionales y aquellos deseables, garantizando coherencia en la granularidad de los datos antes de formular modelos prescriptivos.

== Antecedente Institucional en Managua: Plan Maestro JICA (2017)

En el contexto específico del municipio de Managua existe un antecedente institucional de alta relevancia para la planificación de la movilidad urbana: el *Proyecto del Plan Maestro para el Desarrollo Urbano del Municipio de Managua*, elaborado por la Agencia de Cooperación Internacional del Japón (@jica2017) en coordinación con la Alcaldía de Managua.

En su diagnóstico integral de transporte, la encuesta de hogares del Plan Maestro estimó que *aproximadamente el 26% de los viajes motorizados cotidianos en Managua se realizaban en modalidad de taxi*, revelando un protagonismo inusualmente alto del transporte selectivo frente a otras urbes de Centroamérica, motivado por las limitaciones de frecuencia y cobertura del transporte colectivo de autobuses.

Si bien este antecedente data de un período anterior a la consolidación de aplicaciones móviles y no describe la operación interna de MoviGo, proporciona un marco referencial sólido que ratifica que el transporte selectivo en Managua constituye un componente esencial de la estructura de movilidad metropolitana y no un servicio de lujo.

== Antecedentes Operativos y Situación Específica de MoviGo

En lo que concierne a la empresa MoviGo, la literatura y los materiales institucionales disponibles no reportan estudios analíticos previos, diagnósticos históricos de rendimiento, evaluaciones formales del sistema tarifario ni auditorías sobre la distribución de su flota en Managua.

Por consiguiente, desde el punto de vista metodológico no resulta admisible calificar apriorísticamente el servicio como ineficiente ni asumir la existencia de sobreoferta, déficit de cobertura o tarifas desproporcionadas. Dichas hipótesis operativas deben formularse como interrogantes sujetas a contrastación empírica. El valor singular de esta investigación radica precisamente en tender un puente entre los marcos teóricos y metodológicos desarrollados internacionalmente y la realidad operacional de MoviGo, empleando la base de datos sintética del entorno transaccional para descubrir qué patrones, restricciones y equilibrios se verifican efectivamente en el municipio de Managua.
