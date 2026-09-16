# 1. Contextualización de la Investigación

## 1.1 El Transporte Selectivo como Sistema Dinámico Complejo

La movilidad urbana constituye un sistema dinámico en el que convergen decisiones de los usuarios, disponibilidad de vehículos, configuración territorial, condiciones de circulación, tiempos de desplazamiento, costos operativos y variaciones del entorno.

En el caso del transporte selectivo por aplicación móvil (*ride-hailing*), estas relaciones adquieren especial relevancia porque la prestación del servicio depende de la capacidad de ubicar oportunamente las unidades en aquellos sectores donde se concentra o se desplaza la demanda, responder con tiempos razonables de atención y mantener un esquema tarifario que guarde correspondencia con las condiciones reales de operación. Por ello, la distribución territorial de la flota y la definición de tarifas no pueden analizarse como procesos aislados, sino como componentes interdependientes de un mismo sistema de movilidad.

La presente investigación se sitúa en el área metropolitana del municipio de Managua y toma como unidad de análisis el servicio de transporte selectivo de la plataforma **Movi Go**. La empresa opera en la capital ofreciendo tres categorías de servicio diferenciadas:
* **`movigo_estandar`**: Vehículos convencionales para traslados urbanos diarios.
* **`movigo_comfort`**: Vehículos de mayor gama, espacio y confort.
* **`movigo_moto`**: Motocicletas para traslados individuales rápidos y económicos.

El interés central consiste en estudiar la forma en que la flota se distribuye espacialmente y cómo esa distribución se relaciona con la demanda del servicio, las tarifas dinámicas aplicadas, las perturbaciones climáticas y la saturación de los principales corredores viales de Managua (*Metrocentro, Rotonda Centroamérica, Rotonda Rubén Darío, Pista Juan Pablo II*).

La investigación adopta un enfoque integral en el que las condiciones operativas, territoriales y climáticas interactúan entre sí y modifican el comportamiento del servicio en distintos momentos, zonas y escenarios.

---

## 1.2 Dimensión Operativa

Desde la dimensión operativa, el funcionamiento de un servicio de transporte selectivo está condicionado por variables tales como disponibilidad de unidades, tiempo de respuesta, duración de los viajes, distancia recorrida, permanencia sin pasajero, frecuencia de solicitudes, horarios de mayor o menor demanda, asignación de vehículos y utilización efectiva de la flota. Estas variables permiten aproximarse al desempeño del sistema y reconocer si la oferta vehicular guarda correspondencia con la demanda observada.

En consecuencia, su análisis revela concentraciones de unidades en determinados sectores, zonas con baja cobertura relativa, recorridos improductivos (*deadhead miles*) o periodos en los que la distribución existente no responde de manera adecuada a las solicitudes de los usuarios, derivando en cancelaciones tanto por parte de pasajeros frustrados por la espera como por parte de conductores ante trayectos poco convenientes.

---

## 1.3 Dimensión Territorial

La dimensión territorial agrega un nivel de complejidad determinante. Managua presenta una estructura urbana extensa, policéntrica y heterogénea, con sectores residenciales, comerciales, institucionales, educativos, productivos y de servicios que generan patrones de movilidad asimétricos.

En este contexto, la demanda de transporte no se distribuye de manera uniforme en el espacio ni permanece constante durante el día. La localización de puntos de origen y destino, la conectividad vial, las distancias entre zonas, los tiempos de desplazamiento y la accesibilidad a determinados sectores condicionan la conveniencia de mantener o movilizar unidades hacia determinadas áreas.

Asimismo, la segmentación socioeconómica de los cuadrantes urbanos (clasificados en estratos `alto`, `medio`, `popular` y `comercial`) influye directamente en las preferencias de medios de pago (`efectivo`, `tarjeta`, `billetera_digital`), en la tolerancia a la tarifa y en las dinámicas de generación y atracción de viajes.

---

## 1.4 Dimensión Tarifaria y Tarifa Dinámica (Surge Pricing)

El sistema tarifario constituye el mecanismo económico central para equilibrar la oferta y la demanda. Movi Go opera mediante un esquema paramétrico estructurado que calcula una tarifa base y le aplica un factor multiplicador dinámico:

$$\text{TarifaBase} = \text{BajadaBandera} + (18 \times \text{distancia\_km}) + (4.5 \times \text{duracion\_minutos})$$

$$\text{TarifaFinal} = \text{TarifaBase} \times \text{multiplicador\_dinamico}$$

Donde:
* **Bajada de Bandera:** Tarifa inicial fija según el cuadrante urbano de partida, oscilando entre **C$ 30.0 y C$ 90.0 NIO**.
* **Costo por Distancia:** C$ 18.0 NIO por kilómetro recorrido.
* **Costo por Tiempo:** C$ 4.5 NIO por minuto de trayecto.
* **Multiplicador Dinámico (*Surge Pricing*):** Factor continuo que oscila habitualmente entre **$1.00\times$ y $2.80\times$**, pudiendo alcanzar picos de hasta **$3.20\times$** durante episodios de tormenta y colapso vial.

Estudiar este sistema tarifario junto con la distribución territorial permite valorar si las reglas de cobro mantienen coherencia con los costos reales de desplazamiento, evaluar la elasticidad-precio de los usuarios ante aumentos del multiplicador y determinar puntos de equilibrio que eviten expulsar la demanda o provocar desabastecimiento de conductores.

---

## 1.5 Dimensión Climática y Congestión Vial

En Managua, las condiciones meteorológicas constituyen una variable exógena crítica. La capital experimenta lluvias torrenciales estacionales que provocan escorrentías urbanas e inundaciones temporales en cauces y pasos viales, reduciendo drásticamente la velocidad promedio de circulación vehicular.

La plataforma Movi Go registra esta dinámica a través de series diarias donde se asocia la precipitación acumulada (`precipitacion_mm`), la temperatura ambiental (`temperatura_c`), la condición atmosférica (`despejado`, `nublado`, `lluvia_ligera`, `tormenta`) y un **índice de congestión vial** continuo que escala desde $1.00$ (flujo vehicular libre) hasta $3.50$ (colapso de la red vial por tormenta).

Esta articulación permite evaluar objetivamente cómo los episodios de precipitación generan un efecto dual: expanden repentinamente la demanda de viajes al tiempo que reducen la velocidad de la flota y retienen a las unidades ocupadas por más tiempo.

---

## 1.6 Perspectiva de Ciencia de Datos y Acceso a Datos vía API

Desde la perspectiva de Ciencia de Datos, el proyecto se sustenta en un entorno transaccional sintético generado para simular la operación real de Movi Go durante un año completo, abarcando **más de 65,000 registros de viajes**, un directorio de usuarios y socios conductores categorizados, cuadrantes urbanos georreferenciados en coordenadas WGS84, campañas de bonos e incentivos, series climáticas y telemetría GPS continua de los vehículos.

Un elemento metodológico y arquitectónico central de esta investigación es que **el acceso a los datos de origen no se realiza mediante consultas SQL directas a una base de datos relacional, sino única y exclusivamente a través de una API REST (`/movigo`)**. 

Por consiguiente, la estrategia de ingeniería de datos requiere:
1. Desarrollar un **cliente de extracción en Python** (`httpx`/`requests`) que maneje paginación estructurada (`offset`, `limit` hasta 200 registros) y descargue los registros de los 7 endpoints de la plataforma.
2. Cargar los datos extraídos en memoria estructurada con **pandas**, reconstruir y validar las relaciones entre tablas (llaves foráneas, consistencia de IDs de zonas y usuarios).
3. Ingestar estas tablas en una base de datos relacional propia en **PostgreSQL** para consolidar la capa cruda (*raw/staging*).
4. A partir de dicha base de datos, desplegar el pipeline ELT con **dbt** para estructurar el modelo dimensional analítico (*Data Warehouse*) y ejecutar los análisis estadísticos, los métodos numéricos y los modelos de optimización prescriptiva.
