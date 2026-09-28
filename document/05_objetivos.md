# 5. Objetivos de la Investigación

## 5.1 Objetivo General

**Evaluar** la eficacia del esquema de tarificación dinámica (*surge pricing*) de la plataforma MoviGo en el municipio de Managua y su impacto sobre la tasa de cancelación y la equidad socio-espacial, determinando puntos de equilibrio tarifario mediante métodos numéricos y formulando estrategias óptimas de asignación de incentivos a la flota bajo condiciones variables de demanda y clima urbano.

---

## 5.2 Objetivos Específicos

1. **Consolidar** un repositorio analítico multidimensional en PostgreSQL y dbt a partir de los registros transaccionales, telemétricos y meteorológicos extraídos de la API REST, garantizando la trazabilidad, estandarización y auditoría del histórico de viajes y tarifas de MoviGo.

2. **Determinar** la sensibilidad de la demanda, la variación de las tarifas y la probabilidad de cancelación de viajes frente a fluctuaciones en el multiplicador dinámico, el estrato socioeconómico de origen y perturbaciones meteorológicas y de congestión vial en Managua.

3. **Modelar** numéricamente el equilibrio de mercado entre oferta y demanda vehicular y la elasticidad-precio del servicio mediante algoritmos de búsqueda de raíces (Bisección y Newton-Raphson) y esquemas de diferenciación finita.

4. **Diseñar** un modelo prescriptivo de asignación presupuestaria de campañas de incentivos a conductores (problema de la mochila 0/1) que maximice las horas de conexión de la flota en periodos críticos como mecanismo complementario y no excluyente al incremento de tarifas dinámicas.
