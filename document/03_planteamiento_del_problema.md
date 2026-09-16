# 3. Planteamiento del Problema

## 3.1 La Complejidad de Coordinar Flota y Demanda Dinámica

La operación de un servicio de transporte selectivo exige coordinar la ubicación de los vehículos con una demanda cuya distribución puede variar espacial y temporalmente. La literatura sobre movilidad bajo demanda reconoce que el desbalance entre solicitudes y unidades disponibles condiciona los tiempos de espera, los desplazamientos de aproximación y la utilización de la flota (Alonso-Mora et al., 2017; Jiao et al., 2021). En este marco, el problema de investigación se centra en determinar si la distribución territorial de la flota de Movi Go guarda correspondencia con el comportamiento real de la demanda y si el sistema tarifario mantiene coherencia con las condiciones bajo las cuales se presta el servicio.

Esta problemática es compleja porque la demanda no depende de una sola variable. El número y localización de solicitudes pueden cambiar según horario, día, zona, características de los desplazamientos y condiciones del entorno. Del mismo modo, la capacidad de respuesta de la empresa puede modificarse en función de la disponibilidad de vehículos, su posición inicial, las distancias de aproximación, los tiempos de recorrido y las restricciones operativas existentes. En consecuencia, una distribución que resulte adecuada en determinado momento podría ser poco eficiente en otro, lo que obliga a estudiar el comportamiento del sistema mediante datos históricos y escenarios comparables.

---

## 3.2 Manifestación Territorial: Desbalance Espacial y Recorridos de Aproximación

La dimensión territorial del problema se manifiesta en la posibilidad de que algunos sectores concentren solicitudes mientras otros concentren vehículos, generando desplazamientos adicionales antes del inicio efectivo del servicio. Desde una perspectiva de eficiencia, interesa conocer la relación entre origen de la demanda, ubicación de la flota y tiempos requeridos para atenderla. Si esta relación no se examina, la toma de decisiones puede apoyarse únicamente en apreciaciones operativas o reacciones inmediatas, sin disponer de criterios cuantitativos para anticipar dónde y cuándo conviene posicionar las unidades.

---

## 3.3 El Sistema Tarifario como Decisión Sensible e Interdependiente

A esta situación se añade la necesidad de analizar el sistema tarifario. La tarifa representa una decisión sensible porque se relaciona con las condiciones del viaje y con la sostenibilidad operativa del servicio. Si se estudia de manera aislada, se corre el riesgo de ignorar factores como distancia, tiempo, zona, disponibilidad, recorridos de aproximación o variaciones excepcionales de la operación. Por ello, el problema no consiste solamente en determinar cuánto cobrar, sino en establecer qué variables deben ser consideradas para evaluar la coherencia de las tarifas actuales y qué escenarios alternativos podrían ser razonables bajo diferentes condiciones.

---

## 3.4 Variabilidad Climática como Factor Explicativo Complementario

Los factores climáticos introducen una fuente adicional de variabilidad que debe ser sometida a comprobación empírica. Estudios desarrollados con datos de taxis y plataformas de movilidad han identificado relaciones entre precipitación, demanda, distribución espacial de vehículos, tiempos de búsqueda y patrones de viaje, aunque la dirección y magnitud de esos efectos varían según el periodo, la localización y las características del sistema analizado (Chen et al., 2017; Sun et al., 2020; Liu et al., 2021). Por ello, la investigación no atribuye de antemano a las condiciones climáticas los cambios observados en Movi Go, sino que las incorpora como variables explicativas que serán contrastadas frente a factores operativos y territoriales.

---

## 3.5 La Necesidad de un Análisis Integrado en Ciencia de Datos

La ausencia de un análisis integrado puede limitar la capacidad para reconocer relaciones importantes. Por ejemplo, un incremento en el tiempo de atención podría estar asociado con mayor demanda, mayor distancia entre vehículo y usuario, congestión, precipitación, concentración territorial de solicitudes o una combinación de varias condiciones. De manera similar, una tarifa más elevada puede corresponder a recorridos más largos o complejos y no necesariamente representar una anomalía. La investigación requiere separar, relacionar y comparar estas variables antes de formular conclusiones.

En este marco, la Ciencia de Datos ofrece la posibilidad de estructurar el problema mediante un conjunto de etapas articuladas: integración de registros, depuración de datos, caracterización de variables, análisis de patrones y anomalías, construcción de modelos, simulación de escenarios y formulación de alternativas de optimización. El reto consiste en que estas técnicas no se apliquen de manera fragmentada, sino como parte de una misma lógica investigativa orientada a comprender el sistema de movilidad de Movi Go y sustentar decisiones posteriores.

---

## 3.6 Brechas de Información Iniciales y Definición del Problema Central

La información disponible al inicio del proyecto todavía no permite establecer cuáles zonas presentan mayor demanda, qué franjas horarias concentran solicitudes, cómo se distribuye actualmente la flota, qué variables explican la tarifa aplicada o en qué magnitud las condiciones climáticas afectan el servicio. Precisamente, estas brechas de información justifican el proceso investigativo. El estudio deberá construir evidencia a partir de datos verificables y evitar asumir como hechos aquellos comportamientos que todavía no han sido demostrados.

El problema central se expresa, entonces, en la necesidad de contar con un esquema analítico que relacione demanda, ubicación de la flota, tarifas y factores del entorno para valorar alternativas de distribución territorial y de configuración tarifaria. La optimización esperada no debe entenderse únicamente como la obtención de un resultado matemático, sino como la identificación de escenarios técnicamente sustentados, operativamente factibles y coherentes con las restricciones que sean identificadas durante el estudio.

En consecuencia, la investigación se orienta a determinar de qué manera pueden emplearse los datos disponibles para comprender el comportamiento territorial y operativo del servicio, reconocer patrones, variaciones y anomalías, y evaluar escenarios que contribuyan a una mejor correspondencia entre la ubicación de la flota, la demanda y el sistema tarifario dentro del municipio de Managua.
