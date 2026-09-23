# 5. Objetivos de la Investigación

## 5.1 Objetivo General

**Optimizar** la distribución operativa de la flota vehicular y el esquema de tarifa dinámica del servicio de transporte selectivo Movi Go en el municipio de Managua mediante la ingesta de datos transaccionales y meteorológicos vía API REST y su modelado y transformación con dbt, evaluando patrones espaciotemporales y estrategias de asignación bajo condiciones variables de demanda y clima urbano.

---

## 5.2 Objetivos Específicos

1. **Estructurar** un pipeline de ingeniería de datos analítico mediante **dbt (Data Build Tool)** sobre PostgreSQL a partir de los registros transaccionales, telemétricos y meteorológicos extraídos de la API REST de Movi Go, garantizando la consolidación, estandarización y auditoría del histórico operativo del servicio.

2. **Analizar** la distribución espaciotemporal de los flujos de demanda, los tiempos de espera y la duración de los trayectos frente a eventos meteorológicos, condiciones de tráfico y disparidades territoriales entre las zonas del municipio de Managua.

3. **Evaluar** la dinámica del esquema de tarificación dinámica (*surge pricing*) y la sensibilidad de la oferta y la demanda vehicular ante variaciones en el multiplicador de precios bajo distintas franjas horarias y condiciones contextuales.

4. **Formular** modelos prescriptivos de optimización operativa para la asignación y el rebalanceo territorial de la flota vehicular, orientados a mitigar los recorridos improductivos en vacío (*deadhead*) y equilibrar los tiempos de servicio entre los cuadrantes urbanos de la capital.
