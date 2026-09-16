# 2. Antecedentes

## 2.1 Asignación Dinámica y Reposicionamiento de Flotas

La literatura científica sobre servicios de movilidad bajo demanda (*ride-hailing*) identifica la asignación dinámica de solicitudes y el posicionamiento de vehículos como problemas centrales para la eficiencia del sistema. Alonso-Mora et al. (2017), mediante un modelo de asignación dinámica viaje-vehículo aplicado a datos reales de taxis de Nueva York, demostraron que la localización de la demanda y la disponibilidad de vehículos deben analizarse de forma conjunta para reducir tiempos de espera y mejorar el aprovechamiento de la flota.

En una línea aplicada al reposicionamiento de vehículos desocupados, Jiao et al. (2021) desarrollaron y evaluaron un enfoque basado en aprendizaje por refuerzo para orientar la redistribución de unidades considerando el estado espaciotemporal del sistema. Estos trabajos constituyen antecedentes metodológicos pertinentes para estudiar la distribución territorial de la flota de Movi Go, porque muestran que la eficiencia operativa depende de la correspondencia dinámica entre demanda, ubicación de vehículos y condiciones de operación.

---

## 2.2 Desequilibrio Espaciotemporal entre Oferta y Demanda

El desequilibrio espaciotemporal entre oferta y demanda representa, por tanto, una de las principales dificultades operativas de los sistemas de transporte bajo solicitud. La demanda puede concentrarse en determinados sectores y periodos mientras las unidades disponibles permanecen en otras zonas, lo que incrementa recorridos de aproximación, tiempos de espera y periodos de circulación sin pasajero.

Por su parte Jiao et al. (2021) señalan que las plataformas digitales pueden aprovechar información global y datos de oferta-demanda para orientar el reposicionamiento de vehículos, mientras que Alonso-Mora et al. (2017) evidencian que la asignación dinámica puede formularse como un problema de optimización sujeto a restricciones de tiempo, capacidad y localización. En consecuencia, el análisis territorial de la flota no debe limitarse a contabilizar vehículos disponibles, sino que requiere estudiar su distribución relativa respecto de los patrones espaciales y temporales de las solicitudes.

---

## 2.3 Modelación del Sistema Tarifario y Tarificación Dinámica

En relación con el componente tarifario, la investigación internacional sobre *ride-hailing* ha mostrado que la fijación de precios puede vincularse con la necesidad de equilibrar oferta y demanda, aunque sus efectos dependen de las condiciones del mercado y de los objetivos de la plataforma. Zha, Yin y Du (2018) analizaron la denominada tarifa dinámica o *surge pricing* mediante modelos de equilibrio y programación bi-nivel, encontrando que los mecanismos de precios pueden modificar tanto la oferta de conductores como el comportamiento de la demanda.

Por su parte, Battifarano y Qian (2019) desarrollaron un marco predictivo para estudiar multiplicadores tarifarios en tiempo real utilizando información de tráfico, entorno urbano y condiciones meteorológicas.

Estos antecedentes no implican que Movi Go utilice un esquema de tarifa dinámica ni que su sistema actual sea inadecuado; su pertinencia radica en demostrar que el análisis tarifario puede enriquecerse cuando se relaciona con variables de demanda, disponibilidad, localización, tráfico y entorno, en lugar de evaluarse únicamente a partir de la distancia recorrida.

---

## 2.4 Incidencia Empírica de las Condiciones Meteorológicas

La incidencia de las condiciones meteorológicas sobre la movilidad también cuenta con respaldo empírico. Chen et al. (2017), mediante datos GPS y de taxímetro, determinaron que la precipitación modifica la distribución temporal y espacial de la demanda de taxis, con efectos diferentes según la intensidad de la lluvia y el periodo del día. Sun et al. (2020) encontraron que la lluvia puede alterar de manera significativa la distribución espacial de pasajeros y taxis, aun cuando el volumen total de oferta y demanda no presente necesariamente variaciones de igual magnitud; además, identificaron cambios en tiempos de búsqueda, velocidad y nivel de servicio.

De forma específica para servicios de *ride-hailing*, Liu, Jiang y Chen (2021) mostraron que la precipitación, el viento y otras variables meteorológicas presentan efectos diferenciados según horario, día de la semana, distancia del viaje y localización. Estos resultados justifican incorporar los factores climáticos como variables explicativas complementarias dentro del estudio de Movi Go, sin asumir de antemano que constituyen la causa principal de las variaciones operativas.

---

## 2.5 Datos Georreferenciados en Movilidad y Ciencia de Datos

Otro antecedente relevante corresponde al uso de datos georreferenciados para estudiar el comportamiento del transporte selectivo. Chen et al. (2017) evidencian que los registros GPS permiten trabajar con variables como fecha y hora, longitud, latitud, velocidad, dirección y estado de ocupación del vehículo, y que su vinculación con datos operativos posibilita reconstruir unidades de viaje y analizar patrones espaciotemporales.

Esta perspectiva resulta directamente vinculable con un proyecto de Ciencia de Datos, porque permite estructurar procesos de limpieza, integración, consulta, análisis estadístico y visualización a partir de registros transaccionales y geográficos. Para Movi Go, la posibilidad real de aplicar estas técnicas dependerá de la existencia, calidad, granularidad y autorización de uso de sus bases de datos; por ello, el estudio deberá distinguir entre variables disponibles y variables deseables antes de construir los modelos.

---

## 2.6 Antecedentes Institucionales en Managua: Plan Maestro JICA (2017)

En el contexto específico de Managua existe, además, un antecedente institucional de planificación de la movilidad urbana. El Proyecto del Plan Maestro para el Desarrollo Urbano del Municipio de Managua, elaborado por la Agencia de Cooperación Internacional del Japón (JICA) y publicado en 2017, incorporó la planificación del transporte como uno de los ejes del desarrollo urbano. En su diagnóstico histórico, la encuesta de hogares utilizada por el proyecto estimó que aproximadamente el 26 % de los viajes se realizaban en taxi, dato que evidencia la importancia que este modo tenía dentro de la movilidad capitalina en el periodo analizado (JICA, 2017).

Este antecedente debe interpretarse con cautela ya que corresponde a información anterior al periodo de la presente investigación y no describe la operación de Movi Go; sin embargo, proporciona un marco territorial que confirma la relevancia del transporte selectivo dentro del sistema de movilidad de Managua.

---

## 2.7 Situación Específica y Diagnóstico en la Empresa Movi Go

En cuanto a antecedentes específicos de la empresa Movi Go, los materiales proporcionados para esta investigación no incluyen estudios previos, diagnósticos históricos, informes de optimización, evaluaciones del sistema tarifario ni análisis consolidados sobre la distribución territorial de su flota. Por esta razón, no resulta metodológicamente correcto afirmar que existen actualmente sobreoferta de vehículos, déficit de cobertura, tarifas desproporcionadas, ineficiencias de asignación o afectaciones climáticas específicas.

Tales situaciones deberán ser formuladas como aspectos susceptibles de comprobación mediante evidencia empírica. El valor de la presente investigación radica precisamente en trasladar los antecedentes teóricos y metodológicos de la literatura al contexto particular de Movi Go, utilizando datos de la empresa para determinar cuáles relaciones, patrones, restricciones y escenarios se verifican realmente en el municipio de Managua.
