# 2. Antecedentes

## 2.1 Asignación Dinámica y Reposicionamiento de Flotas

La literatura científica sobre servicios de movilidad bajo demanda (*ride-hailing*) identifica la asignación dinámica de solicitudes y el posicionamiento de vehículos como problemas centrales para la eficiencia del sistema. Alonso-Mora et al. (2017), mediante un modelo de asignación dinámica viaje-vehículo aplicado a datos reales de taxis de Nueva York, demostraron que la localización de la demanda y la disponibilidad de vehículos deben analizarse de forma conjunta para reducir tiempos de espera y mejorar el aprovechamiento de la flota.

En una línea aplicada al reposicionamiento de vehículos desocupados, Jiao et al. (2021) desarrollaron y evaluaron un enfoque basado en aprendizaje por refuerzo para orientar la redistribución de unidades considerando el estado espaciotemporal del sistema. Estos trabajos constituyen antecedentes metodológicos fundamentales para Movi Go, permitiendo formular algoritmos de emparejamiento óptimo (como el **Algoritmo Húngaro** para despacho biyectivo) y modelos de flujo en red (como el **Algoritmo de Dijkstra** para rutas mínimas congestionadas).

---

## 2.2 Desequilibrio Espaciotemporal entre Oferta y Demanda

El desequilibrio espaciotemporal entre oferta y demanda representa una de las principales dificultades operativas de los sistemas de transporte bajo solicitud. La demanda tiende a concentrarse en determinados sectores y periodos (ej. zonas comerciales o laborales en horas pico) mientras las unidades disponibles permanecen dispersas en otras zonas, lo que incrementa recorridos de aproximación, tiempos de espera y periodos de circulación sin pasajero (*deadhead miles*).

Jiao et al. (2021) señalan que las plataformas digitales deben aprovechar información global y datos de oferta-demanda para orientar el reposicionamiento de vehículos, mientras que Alonso-Mora et al. (2017) evidencian que la asignación dinámica puede formularse como un problema de optimización sujeto a restricciones de tiempo, capacidad y localización. En el contexto de Movi Go, los pings de telemetría GPS (`/movigo/telemetria`) permiten medir con precisión métrica dónde se encuentran los vehículos desocupados respecto a las solicitudes entrantes.

---

## 2.3 Modelación del Sistema Tarifario y Tarificación Dinámica (Surge Pricing)

En relación con el componente tarifario, la investigación internacional sobre *ride-hailing* ha demostrado que la fijación de precios dinámicos (*surge pricing*) busca equilibrar oferta y demanda modificando incentivos para conductores y usuarios. Zha, Yin y Du (2018) analizaron la tarifa dinámica mediante modelos de equilibrio y programación bi-nivel, encontrando que los precios elevados pueden atraer más conductores a zonas de alta demanda, aunque a riesgo de contraer excesivamente las solicitudes si se sobrepasa la disposición a pagar.

Por su parte, Battifarano y Qian (2019) desarrollaron un marco predictivo para estudiar multiplicadores tarifarios en tiempo real utilizando información de tráfico, entorno urbano y condiciones meteorológicas.

A diferencia de aproximaciones teóricas que desconocen las fórmulas operativas, **Movi Go implementa de forma explícita un multiplicador dinámico continuo ($1.00\times$ a $2.80\times$, con picos de $3.20\times$)** acoplado al tráfico y al clima. La pertinencia de estos antecedentes radica en evaluar empíricamente si este multiplicador cumple su propósito equilibrador o si, por el contrario, induce cancelaciones y distorsiones espaciales en la red urbana de Managua.

---

## 2.4 Incidencia Empírica de las Condiciones Meteorológicas

La incidencia de las condiciones meteorológicas sobre la movilidad urbana cuenta con amplio respaldo empírico. Chen et al. (2017), mediante datos GPS y de taxímetro, determinaron que la precipitación modifica la distribución temporal y espacial de la demanda, con efectos diferentes según la intensidad de la lluvia y el periodo del día. Sun et al. (2020) encontraron que la lluvia puede alterar de manera sustancial la distribución espacial de pasajeros y vehículos, identificando cambios significativos en tiempos de búsqueda, velocidad y nivel de servicio.

De forma específica para plataformas de transporte por aplicación, Liu, Jiang y Chen (2021) demostraron que la precipitación, el viento y la temperatura presentan efectos diferenciados según horario, día de la semana, distancia del viaje y localización. En el caso de Movi Go, la plataforma integra directamente en su API (`/movigo/clima`) series temporales de precipitación diaria en milímetros acopladas a un **índice de congestión vial (1.00 a 3.50)**, permitiendo validar formalmente estas relaciones mediante modelos de regresión lineal múltiple y pruebas de hipótesis.

---

## 2.5 Datos Georreferenciados en Movilidad y Ciencia de Datos

Otro antecedente relevante corresponde al uso de datos georreferenciados para estudiar el comportamiento del transporte selectivo. Chen et al. (2017) evidencian que los registros GPS permiten trabajar con variables como fecha y hora, longitud, latitud, velocidad, dirección y estado de ocupación del vehículo, y que su vinculación con datos operativos posibilita reconstruir unidades de viaje y analizar patrones espaciotemporales.

Para Movi Go, la existencia de los endpoints `/movigo/zonas` (coordenadas WGS84 de centroides y radios de cobertura) y `/movigo/telemetria` (pings con latitud, longitud, velocidad instantánea en km/h y estado: `disponible`, `ocupado`, `en_camino_recogida`) permite estructurar procesos avanzados de análisis espacial, matrices Origen-Destino, detección de cuellos de botella y algoritmos de ruteo óptimo.

---

## 2.6 Antecedentes Institucionales en Managua: Plan Maestro JICA (2017)

En el contexto específico de Managua existe un antecedente institucional clave de planificación de la movilidad urbana. El Proyecto del Plan Maestro para el Desarrollo Urbano del Municipio de Managua, elaborado por la Agencia de Cooperación Internacional del Japón (JICA) y publicado en 2017, incorporó la planificación del transporte como uno de los ejes del desarrollo de la capital.

En su diagnóstico, la encuesta de hogares estimó que **aproximadamente el 26 % de los viajes urbanos se realizaban en transporte selectivo (taxis)** (JICA, 2017). Este antecedente confirma la relevancia estratégica que tiene el transporte selectivo en Managua para la conectividad de la población y fundamenta la necesidad de optimizar su operación y tarificación mediante herramientas avanzadas de Ciencia de Datos.

---

## 2.7 Situación Operativa y Disponibilidad de Datos en Movi Go

Movi Go cuenta con un entorno transaccional sintético rigurosamente modelado que refleja la operación anual de la empresa con **más de 65,000 registros históricos de viajes**, flota clasificada en 3 categorías (`movigo_estandar`, `movigo_comfort`, `movigo_moto`), catálogo de usuarios con hábitos de pago, campañas de bonos para choferes, registros climáticos y telemetría continua.

El reto de la presente investigación radica en transformar esta rica base de datos —expuesta mediante una API REST— en un modelo analítico estructurado en PostgreSQL/dbt y aplicar técnicas de inferencia estadística, métodos numéricos y optimización para resolver los desbalances observados de forma cuantitativa y reproducible.
