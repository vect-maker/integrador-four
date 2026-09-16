# 6. Marco Teórico

## 6.1 Eficiencia del Servicio y Fundamentos Operacionales

La optimización de un servicio de transporte selectivo requiere comprender que su eficiencia no depende únicamente del número de vehículos disponibles, sino de la capacidad de la empresa para ubicar su flota de acuerdo con el comportamiento territorial y temporal de la demanda, responder oportunamente a los cambios del entorno y establecer tarifas coherentes con las condiciones reales en las que se presta el servicio.

En una organización como Movi Go, cuyo ámbito de análisis se concentra en el municipio de Managua, estas relaciones adquieren especial importancia debido a que las solicitudes de transporte pueden presentar variaciones según la zona geográfica, la hora del día, el día de la semana, la disponibilidad de vehículos, las condiciones climáticas, los tiempos de aproximación y los niveles tarifarios aplicados.

Desde esta perspectiva, la distribución territorial de la flota y la determinación de tarifas constituyen problemas estrechamente vinculados. Una concentración excesiva de vehículos en zonas con baja demanda puede producir tiempos ociosos y desplazamientos improductivos, mientras que una disponibilidad insuficiente en zonas de elevada demanda puede incrementar el tiempo de espera de los usuarios, aumentar las distancias de aproximación y generar solicitudes que no sean atendidas oportunamente.

De manera paralela, una estructura tarifaria que no responda adecuadamente al comportamiento de la oferta, la demanda y las condiciones operativas puede afectar tanto la percepción del usuario como la sostenibilidad económica del servicio. Por ello, la toma de decisiones requiere una base analítica que permita observar estas variables de manera conjunta y no como elementos independientes.

---

## 6.2 Arquitectura de Datos y Paradigma ELT

La construcción de esta base analítica comienza con la adecuada administración de los datos generados por la operación. Cada solicitud, viaje, vehículo disponible, ubicación, tarifa, distancia, duración y condición meteorológica constituye una observación capaz de aportar información sobre el funcionamiento del sistema. Sin embargo, el valor de estos registros depende de la existencia de mecanismos que permitan capturarlos, conservarlos, depurarlos y relacionarlos de manera consistente. En este sentido, la ingeniería de datos constituye el soporte técnico sobre el cual pueden desarrollarse posteriormente los análisis estadísticos y los modelos de optimización.

Dentro de las arquitecturas modernas de datos, el paradigma ELT, correspondiente a extracción, carga y transformación, resulta pertinente cuando se pretende centralizar información procedente de diferentes fuentes y conservar inicialmente los datos con el menor nivel de modificación posible. Google Cloud define este enfoque señalando que "los datos sin procesar se cargan directamente en un almacén de datos de destino", realizándose las transformaciones posteriormente dentro del sistema que los contiene.

Esta lógica permite preservar registros originales, facilitar auditorías y ejecutar nuevas transformaciones cuando cambian las necesidades analíticas, sin depender de una única preparación previa de la información.

Aplicado al contexto de Movi Go, este enfoque permite concebir un flujo en el que la información operacional se extrae desde las fuentes disponibles, se concentra inicialmente en una plataforma de almacenamiento y posteriormente se somete a procesos de limpieza, tipificación, estandarización, integración y generación de variables analíticas.

Entre estas transformaciones podrían encontrarse la homologación de fechas y horas, la identificación de zonas de origen y destino, el cálculo de duraciones, la asociación de cada servicio con las condiciones meteorológicas correspondientes y la construcción de métricas sobre disponibilidad vehicular, demanda y tarifas.

---

## 6.3 Modelado Dimensional y Metodología Kimball

La utilización de herramientas orientadas a la ingeniería analítica, como dbt, complementa este proceso debido a que permite organizar las transformaciones de datos como modelos relacionados entre sí. De esta manera, los registros iniciales pueden pasar progresivamente desde una capa de preparación hasta estructuras intermedias y conjuntos finales diseñados para el análisis. Esta organización también facilita el control del linaje de los datos, debido a que puede identificarse de qué fuente procede una variable y cuáles transformaciones fueron necesarias antes de llegar al modelo de consumo. La documentación y el linaje resultan especialmente relevantes cuando las decisiones posteriores dependen de indicadores operativos que deben ser reproducibles y verificables.

Una vez preparada la información, resulta necesario estructurarla de acuerdo con las necesidades del análisis. El modelado dimensional constituye uno de los enfoques clásicos para organizar información destinada a consultas analíticas. Kimball sostiene que esta técnica busca "present the data in a standard, intuitive framework that allows for high-performance access", enfatizando simultáneamente la facilidad de comprensión y el rendimiento de consulta. Bajo este enfoque, los acontecimientos medibles se separan del contexto descriptivo que permite interpretarlos.

En el caso de Movi Go, un viaje puede representar el acontecimiento central de análisis. Dentro de una tabla de hechos podrían registrarse medidas como distancia recorrida, duración, tiempo de espera, tiempo de aproximación, tarifa aplicada, costo estimado y otros indicadores derivados de la operación.

Alrededor de esta información pueden organizarse dimensiones que describan la fecha, la franja horaria, el vehículo, el conductor cuando corresponda, la zona territorial, las condiciones meteorológicas y demás características necesarias para contextualizar cada observación.

La estructura dimensional permite realizar consultas desde distintas perspectivas. Un mismo conjunto de viajes puede analizarse por zona, horario, vehículo, día, condición climática o nivel tarifario sin modificar la naturaleza fundamental de los registros.

Kimball explica que las tablas de hechos contienen fundamentalmente las mediciones numéricas, mientras que las dimensiones proporcionan el contexto descriptivo necesario para interpretarlas. Esto resulta particularmente útil para Movi Go, debido a que la evaluación de la eficiencia territorial requiere relacionar simultáneamente eventos de movilidad con factores espaciales, temporales y operativos.

---

## 6.4 Llaves Subrogadas y Desacople Analítico

Dentro de esta arquitectura también adquieren importancia las llaves subrogadas, ya que permiten mantener identificadores propios dentro del sistema analítico sin depender completamente de las claves operativas generadas por los sistemas de origen. Esta separación reduce la dependencia ante modificaciones futuras en las fuentes y facilita la integración de información procedente de sistemas distintos. Según Kimball Group, estas claves permiten que el sistema analítico mantenga control sobre la identificación de sus dimensiones y favorecen el seguimiento histórico de cambios.

---

## 6.5 Heterogeneidad Espaciotemporal en Servicios Bajo Demanda

La necesidad de estructurar territorialmente los datos responde a una característica fundamental de los servicios de transporte bajo demanda. Las solicitudes no ocurren de manera uniforme en toda la ciudad ni mantienen la misma intensidad durante el día. Determinadas zonas pueden registrar concentraciones importantes de solicitudes durante ciertos períodos y mostrar una reducción considerable en otros momentos. Del mismo modo, la disponibilidad de vehículos puede presentar una distribución territorial diferente a la de los usuarios, dando lugar a desbalances entre oferta y demanda.

La literatura sobre servicios de transporte bajo demanda demuestra que esta relación debe analizarse simultáneamente desde una perspectiva espacial y temporal. Xu, Alsaleh, Hamzaev y Miller identificaron indicadores como tiempo de espera del pasajero, tiempo de espera del conductor, retraso de recogida, relación entre demanda y oferta, proporción de distancia en vacío y proporción de tiempo de viaje activo. Sus resultados evidencian una "significant temporal and spatial heterogeneity in ride-hailing characteristics", lo que respalda la necesidad de estudiar el comportamiento de la flota diferenciando territorios y períodos de operación.

Esta heterogeneidad permite comprender por qué la cantidad total de vehículos disponibles no constituye por sí sola un indicador suficiente de capacidad operativa. Una empresa podría disponer de un número adecuado de unidades y, sin embargo, experimentar dificultades de atención si estas se encuentran ubicadas lejos de las zonas donde se concentra la demanda. Por consiguiente, la eficiencia está relacionada no solo con la disponibilidad total de la flota, sino con su coincidencia espacial y temporal con las solicitudes.

---

## 6.6 Recorridos Improductivos (Deadhead Miles) y Tiempos de Aproximación

Cuando un vehículo debe desplazarse una distancia considerable sin pasajero antes de iniciar un servicio, se genera un recorrido improductivo. Este desplazamiento incrementa el tiempo necesario para atender la solicitud, utiliza combustible, incorpora desgaste vehicular y reduce la cantidad de tiempo disponible para realizar viajes remunerados. Por esta razón, las distancias recorridas sin pasajeros, los tiempos de aproximación y la permanencia ociosa constituyen indicadores relevantes para evaluar la asignación territorial de la flota.

---

## 6.7 Discretización Territorial y Matrices Origen-Destino

La representación espacial de la demanda puede realizarse mediante la división del municipio en zonas operativas, unidades administrativas o celdas geográficas. La finalidad de esta discretización consiste en transformar un espacio urbano continuo en unidades comparables que permitan conocer cuántas solicitudes se originan, cuántos vehículos se encuentran disponibles y cuántos desplazamientos se producen entre distintas zonas. A partir de estas unidades pueden construirse matrices de origen y destino, mapas de densidad y series temporales territoriales capaces de revelar concentraciones y desplazamientos recurrentes de la demanda.

---

## 6.8 Análisis Espacial, Autocorrelación (Índice de Moran) y Anomalías

El análisis de las relaciones entre zonas también puede enriquecerse con herramientas estadísticas espaciales. La autocorrelación espacial permite determinar si valores elevados o reducidos tienden a concentrarse geográficamente, mientras que las técnicas de análisis temporal permiten reconocer horas pico, ciclos diarios, comportamientos semanales y cambios atípicos.

El estudio de Xu y colaboradores, por ejemplo, empleó pruebas estadísticas y el índice de Moran para examinar variaciones temporales y espaciales dentro de servicios de transporte bajo demanda. Para Movi Go, estos enfoques proporcionan una base conceptual para reconocer zonas con insuficiencia recurrente de vehículos, sectores con capacidad ociosa y franjas horarias que requieran una distribución distinta de la flota.

La identificación de anomalías representa otra dimensión importante del análisis. No toda variación constituye necesariamente un problema, pues una demanda elevada durante determinados horarios puede formar parte del comportamiento normal del sistema. Una anomalía se presenta cuando una observación se aparta de manera considerable del patrón esperado. Entre los posibles casos pueden encontrarse aumentos o caídas inusuales en las solicitudes, tiempos de espera excepcionalmente elevados, tarifas significativamente diferentes de las habituales, vehículos con niveles atípicos de inactividad o zonas que experimentan déficits de oferta fuera de sus patrones históricos. La utilización combinada de medidas estadísticas, análisis de dispersión, series temporales y métodos computacionales permite distinguir estos eventos de las fluctuaciones ordinarias de la operación.

---

## 6.9 Incidencia Meteorológica en la Demanda y Operación del Transporte

Este análisis debe considerar además que el comportamiento de la demanda no depende exclusivamente de las características internas del servicio. Las condiciones meteorológicas constituyen una variable exógena capaz de modificar los desplazamientos de las personas, la velocidad de circulación y la disponibilidad de determinados medios alternativos de transporte. En consecuencia, la precipitación y otras condiciones atmosféricas pueden alterar simultáneamente la cantidad de solicitudes y los tiempos necesarios para realizar los viajes.

Liu, Jiang y Chen analizaron este fenómeno y encontraron una relación estadísticamente significativa entre las condiciones meteorológicas y el uso de servicios de transporte bajo demanda. En su estudio, un incremento de un milímetro de precipitación estuvo asociado con un aumento aproximado del 0.39 % en la cantidad de viajes, aunque los efectos variaron según horario, día, distancia y ubicación. De manera similar, Brodeur y Nield observaron que los viajes de Uber y Lyft aumentaban durante episodios de lluvia en Nueva York.

Estos resultados no deben trasladarse directamente a Managua como si los mismos porcentajes fueran aplicables al comportamiento de Movi Go, debido a que las características urbanas, económicas, climáticas y de movilidad son diferentes.

Su importancia teórica radica en demostrar que el clima puede actuar como variable explicativa dentro de los modelos de demanda y que su efecto puede variar tanto espacial como temporalmente. En consecuencia, la precipitación y otras condiciones disponibles deben incorporarse al análisis como factores del entorno y someterse a evaluación utilizando los propios datos de Movi Go.

Las condiciones climáticas también pueden afectar la duración de los desplazamientos. Una reducción de la velocidad promedio durante períodos de lluvia puede aumentar los tiempos de viaje y de aproximación, lo que modifica indirectamente la disponibilidad efectiva de la flota. Un vehículo que necesita más tiempo para completar cada servicio permanece ocupado durante un período mayor, disminuyendo temporalmente la oferta disponible para atender nuevas solicitudes. Por ello, el clima puede producir un doble efecto al modificar tanto el comportamiento de los usuarios como la capacidad operativa del sistema.

---

## 6.10 Dinámica del Sistema Tarifario y Precios Basados en Evidencia

A medida que se relacionan demanda, ubicación de vehículos, tiempos de servicio, condiciones externas y distancias recorridas, surge otro componente fundamental de la operación, correspondiente al sistema tarifario. La tarifa no representa únicamente el valor monetario cobrado al usuario, sino un mecanismo que puede influir en el comportamiento de la demanda, en los ingresos obtenidos por cada viaje y en los incentivos asociados con la disponibilidad de oferta.

En un esquema de transporte bajo demanda, la estructura tarifaria puede incorporar un valor inicial y componentes asociados con distancia, tiempo o condiciones específicas del servicio. Asimismo, puede contemplar ajustes relacionados con períodos en los que la demanda supera considerablemente la disponibilidad de vehículos. Sin embargo, la aplicación de mecanismos dinámicos debe fundamentarse en evidencia debido a que el incremento de precios no produce necesariamente efectos uniformes entre usuarios, lugares y momentos.

Investigaciones recientes muestran que existe una interacción estrecha entre tarifa, demanda y tiempo de espera. Paithankar, Kockelman y Gurumurthy estudiaron estas relaciones en diferentes zonas y períodos, encontrando que la respuesta de la demanda puede variar sustancialmente entre operadores y que los tiempos de espera también pueden ejercer una influencia importante en la decisión del usuario. Esto significa que la optimización tarifaria no debería centrarse únicamente en maximizar el valor cobrado por viaje, sino considerar simultáneamente la calidad de servicio, disponibilidad de vehículos y reacción probable de la demanda.

La tarificación dinámica suele plantearse como un mecanismo para equilibrar oferta y demanda, dado que un precio mayor puede reducir determinadas solicitudes e incentivar una mayor disponibilidad de conductores. Sin embargo, su comportamiento no está libre de efectos adversos. Un estudio publicado en Nature Communications advierte que "dynamic pricing may induce demand-supply imbalances instead of preventing them". Este resultado es particularmente importante desde el punto de vista teórico porque indica que un sistema tarifario debe ser evaluado mediante escenarios y no asumirse automáticamente como eficiente por el simple hecho de ajustarse dinámicamente.

Una estructura tarifaria adecuada para Movi Go debe analizarse, por tanto, como parte de un sistema integrado en el que tarifa, demanda, disponibilidad territorial de vehículos y tiempos de atención interactúan permanentemente. Una modificación de la tarifa puede alterar la cantidad de solicitudes, pero una modificación de la demanda también puede cambiar la relación entre vehículos disponibles y solicitudes pendientes. A su vez, esta relación puede influir en los tiempos de espera y en la calidad percibida del servicio.

---

## 6.11 Técnicas Estadísticas e Inferencia Cuantitativa

Esta interacción justifica el empleo de técnicas estadísticas y computacionales orientadas inicialmente a caracterizar los datos y posteriormente a estudiar asociaciones entre variables. El análisis descriptivo permite reconocer distribución, tendencia central, dispersión, frecuencias y comportamientos temporales.

Posteriormente pueden utilizarse análisis de correlación, pruebas inferenciales, regresiones y otros procedimientos adecuados a la naturaleza de cada variable con el propósito de establecer cuáles factores presentan relaciones relevantes con la demanda, los tiempos, la disponibilidad y las tarifas.

La interpretación de estas asociaciones debe realizarse con cautela, ya que una correlación no implica necesariamente causalidad. Sin embargo, constituye una herramienta importante para determinar qué variables deben recibir mayor atención durante la construcción de escenarios. Cuando las relaciones encontradas se combinan con evidencia espacial, temporal y operativa, es posible desarrollar una representación más completa del funcionamiento del servicio.

---

## 6.12 Optimización Multiobjetivo y Evaluación de Escenarios

El propósito final de esta integración analítica consiste en proporcionar sustento para la evaluación de escenarios de optimización. Optimizar la distribución territorial de una flota significa determinar cómo deberían ubicarse o redistribuirse los vehículos para responder de forma más eficiente a las necesidades esperadas, considerando restricciones reales de capacidad y operación. No implica necesariamente incrementar el número de vehículos, sino utilizar de manera más eficiente los existentes.

Un escenario de optimización puede comparar diferentes distribuciones territoriales de la flota y estimar sus efectos sobre tiempos de aproximación, solicitudes atendidas, recorridos improductivos, nivel de utilización y capacidad disponible. De igual manera, pueden evaluarse distintas estructuras tarifarias observando su posible efecto sobre ingresos, demanda, tiempos de atención y equilibrio territorial. La finalidad consiste en identificar soluciones que representen una mejora respecto del funcionamiento observado sin ignorar las restricciones propias del sistema.

En este sentido, la optimización puede entenderse como un problema de múltiples objetivos. La alternativa con mayor ingreso no necesariamente será la que produzca menor tiempo de espera, del mismo modo que una distribución que minimice los kilómetros recorridos en vacío puede generar efectos diferentes sobre la cobertura territorial. La decisión requiere encontrar combinaciones razonables entre eficiencia operativa, nivel de servicio y sostenibilidad económica.

La investigación de operaciones y la modelación computacional permiten comparar estas alternativas sin modificar previamente la operación real. Mediante la simulación de escenarios pueden evaluarse los posibles resultados de diferentes decisiones antes de considerar su implementación. Esta característica resulta especialmente pertinente para Movi Go, ya que posibilita examinar propuestas de redistribución y ajustes tarifarios utilizando información histórica y condiciones identificadas en los datos.

---

## 6.13 Articulación Teórica e Integración Analítica

De esta manera, la ingeniería de datos, el modelado dimensional, el análisis estadístico, el componente territorial y la optimización no constituyen áreas independientes dentro de la investigación. La ingeniería de datos proporciona registros estructurados y confiables; el modelo dimensional permite relacionar los eventos operativos con su contexto; el análisis espaciotemporal revela dónde y cuándo ocurren los principales desbalances; la incorporación de variables meteorológicas amplía la comprensión del entorno; el análisis tarifario permite estudiar la interacción económica entre oferta y demanda; y la modelación de escenarios transforma estos hallazgos en alternativas concretas de decisión.

En conjunto, estos fundamentos proporcionan una base teórica coherente con el propósito de optimizar la distribución territorial de la flota vehicular y el sistema tarifario de Movi Go en el municipio de Managua.

El enfoque permite pasar de una observación general del funcionamiento del servicio hacia una comprensión sustentada en datos acerca de dónde se concentra la demanda, cómo se distribuyen los vehículos, qué factores modifican los patrones habituales y qué combinaciones de decisiones podrían favorecer una mayor eficiencia. Así, la información deja de utilizarse únicamente como registro histórico y se convierte en un recurso para respaldar decisiones operativas y tarifarias con criterios cuantitativos, territoriales y contextuales.
