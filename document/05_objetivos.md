# 5. Objetivos de la Investigación

## 5.1 Objetivo General

Optimizar la distribución territorial de la flota vehicular y el sistema de tarifa dinámica (*surge pricing*) del servicio de transporte selectivo de la empresa Movi Go en el municipio de Managua, integrando la extracción de datos vía API REST, un Data Warehouse dimensional en PostgreSQL/dbt, inferencia estadística multivariada, métodos numéricos y modelos de optimización prescriptiva bajo factores operativos, territoriales y climáticos.

---

## 5.2 Objetivos Específicos

1. Construir un pipeline automatizado en Python para extraer los datos transaccionales, telemétricos y meteorológicos desde la API REST de Movi Go, reconstruir sus relaciones en PostgreSQL y estructurar un Data Warehouse dimensional en estrella (*Star Schema*) mediante dbt Core con pruebas de calidad para caracterizar la operación anual de más de 65,000 viajes.
2. Analizar el impacto de las variables meteorológicas, la congestión vial y el estrato socioeconómico sobre la demanda y la operación mediante regresión lineal múltiple (con verificación de supuestos Gauss-Markov) y una batería de pruebas de hipótesis formalizadas (prueba $t$ de Welch para *surge pricing*, prueba $z$ de cancelaciones en horas pico, ANOVA de duración por estrato y prueba $\chi^2$ de independencia para métodos de pago).
3. Implementar métodos numéricos para encontrar el multiplicador tarifario de equilibrio $m^*$ que anula la función de exceso de demanda mediante los algoritmos de Bisección y Newton-Raphson, estimar la elasticidad-precio de los viajes mediante diferenciación numérica centrada de orden $\mathcal{O}(h^2)$ y calcular el volumen acumulado diario de viajes aplicando la Regla de Simpson 1/3.
4. Desarrollar modelos prescriptivos de optimización operativa, incluyendo el Algoritmo Húngaro para la asignación biyectiva óptima de viajes a conductores monitoreados por telemetría GPS, el algoritmo de Dijkstra para determinar rutas mínimas bajo anegamientos por lluvia en la red de Managua, y el Problema de la Mochila 0/1 para maximizar horas de conexión de choferes mediante asignación presupuestaria óptima de campañas de incentivos con un límite de C$ 120,000 NIO.
