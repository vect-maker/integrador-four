# 3. Planteamiento del Problema

## 3.1 La Complejidad de Coordinar Flota y Demanda Dinámica

La operación de un servicio de transporte selectivo por aplicación móvil exige coordinar la ubicación de los vehículos con una demanda cuya distribución varía continua y espacialmente. La literatura sobre movilidad bajo demanda reconoce que el desbalance entre solicitudes y unidades disponibles condiciona los tiempos de espera, los desplazamientos de aproximación y la utilización efectiva de la flota (Alonso-Mora et al., 2017; Jiao et al., 2021). 

En Movi Go, este problema se manifiesta de manera cotidiana en la capital: mientras cuadrantes comerciales y universitarios experimentan picos intensos de demanda en horas pico (07:00–08:59 y 17:00–18:59), las unidades disponibles suelen encontrarse dispersas o atrapadas en cuellos de botella viales (*Metrocentro, Rotonda Centroamérica, Rotonda Rubén Darío*). Esta fricción espacial provoca demoras en la recogida y una elevada tasa de cancelación tanto por parte de usuarios desesperados por la espera como de conductores que rechazan viajes lejanos.

---

## 3.2 Manifestación Territorial: Desbalance Espacial y Recorridos de Aproximación

La dimensión territorial del problema se traduce en recorridos improductivos en vacío (*deadhead miles*). Cuando un conductor debe recorrer varios kilómetros sin pasajero para atender una solicitud, se incrementa el costo operativo por combustible y desgaste vehicular, al tiempo que se reduce la ventana de tiempo productiva de la unidad.

A esto se suma la heterogeneidad de Managua, donde los cuadrantes urbanos poseen características socioeconómicas dispares (`alto`, `medio`, `popular`, `comercial`) que inciden en las tarifas base de bajada de bandera (desde C$ 30 hasta C$ 90 NIO) y en los métodos de pago preferidos. La falta de una asignación inteligente y biyectiva de viajes provoca que la flota no esté posicionada estratégicamente en las zonas de mayor rentabilidad y necesidad social.

---

## 3.3 El Dilema de Calibración de la Tarifa Dinámica (Surge Pricing)

Movi Go aplica una fórmula tarifaria conocida con un multiplicador dinámico continuo ($1.00\times$ a $2.80\times$, y hasta $3.20\times$ en tormentas). Aunque el objetivo teórico del *surge pricing* es atraer conductores desocupados hacia áreas de alta demanda y racionar solicitudes, en la práctica un incremento excesivo del multiplicador puede expulsar a usuarios sensibles al precio, mientras que un multiplicador insuficiente genera escasez crónica de vehículos.

El problema no consiste en desconocer la tarifa, sino en **encontrar el multiplicador de equilibrio $m^*$** que equilibre la función de exceso de demanda:

$$f(m) = \text{Demanda}(m) - \text{Oferta}(m) = 0$$

determinar la elasticidad-precio de los viajes mediante métodos numéricos y verificar estadísticamente si los picos tarifarios realmente justifican el incremento en el valor final del servicio o si disparan la tasa de abandono de la plataforma.

---

## 3.4 Variabilidad Climática y Congestión Vial

Las condiciones meteorológicas añaden una perturbación severa a la operación. Durante episodios de lluvias torrenciales en Managua, el índice de congestión vial reportado en la plataforma escala hasta valores de $3.50$ (colapso de la red), anegando vías críticas y disminuyendo la velocidad instantánea de circulación.

Esta situación genera un desajuste simultáneo:
1. **Pico de Solicitudes:** La demanda se dispara porque los peatones y usuarios de transporte colectivo convencional buscan refugio en vehículos selectivos.
2. **Caída de Oferta Efectiva:** La velocidad de la flota se reduce a la mitad, extendiendo los tiempos de viaje y reteniendo a los vehículos ocupados durante lapsos mucho mayores.
3. **Rutas Interrumpidas:** Los caminos habituales se vuelven intransitables, requiriendo algoritmos de ruta más corta adaptativos (**Dijkstra**) que ponderen tanto la distancia euclidiana como el índice de congestión y lluvia.

---

## 3.5 Necesidad de un Enfoque Integrado en Ciencia de Datos

Los datos generados por Movi Go se encuentran dispersos en endpoints transaccionales independientes dentro de una API REST:
* Solicitudes y viajes en `/movigo/viajes`.
* Posicionamiento telemétrico en `/movigo/telemetria`.
* Condiciones climáticas y congestión en `/movigo/clima`.
* Zonas, usuarios, conductores y campañas en sus respectivos directorios.

Sin un pipeline de ingeniería de datos que integre estos registros en una base de datos relacional y construya un almacén analítico dimensional (*Star Schema* en dbt), la empresa no puede correlacionar eventos ni tomar decisiones basadas en evidencia. El reto radica en articular un flujo ELT reproducible que transforme los datos crudos de la API en información estructurada para el análisis inferencial y la optimización.

---

## 3.6 Formulación del Problema Central

El problema central de investigación se sintetiza en la siguiente interrogante:

> **¿De qué manera pueden emplearse los datos transaccionales, territoriales y climáticos disponibles vía API para caracterizar el comportamiento del servicio de Movi Go en Managua, validar el impacto del clima y las tarifas sobre la operación, y formular modelos cuantitativos de optimización (despacho óptimo, ruteo bajo congestión y asignación de incentivos) que reduzcan los tiempos de espera y los recorridos improductivos de la flota?**
