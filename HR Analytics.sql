-- ================================================
-- PROYECTO HR ANALYTICS — Análisis de Rotación
-- Daniel Esquivel — 2026
-- Herramienta: DB Browser for SQLite
-- Dataset: IBM HR Analytics (Kaggle)
-- ================================================

-- PREGUNTA 1: Total empleados y rotación

SELECT COUNT(EmployeeNumber) AS Total_empleados,
       COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) AS Empleados_que_se_fueron,
       ROUND(COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0 / COUNT(EmployeeNumber), 2) AS Porcentaje_rotacion
FROM "WA_Fn-UseC_-HR-Employee-Attrition"

-- Resultado: 1.470 empleados | 237 se fueron | 16.72% rotación
-- Conclusión: rotación por encima del promedio (5-10%)
-- Recomendación: investigar causas raíz de la rotación

-- PREGUNTA 2: Rotación por departamento

SELECT Department, 
       COUNT(EmployeeNumber) AS Total_empleados,
       COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) AS Empleados_que_se_fueron,
       ROUND(COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0 / COUNT(EmployeeNumber), 2) AS Porcentaje_rotacion
FROM "WA_Fn-UseC_-HR-Employee-Attrition"
GROUP BY Department
ORDER BY Porcentaje_rotacion DESC

-- Resultado: Sales lidera en rotación. Research & Development tiene más empleados pero menor tasa de rotación
-- Conclusión: Sales requiere atención prioritaria en retención. R&D tiene mejor cultura de retención, analizar qué hacen diferente

-- PREGUNTA 3: Salario promedio por departamento

SELECT Department,
       ROUND(AVG(MonthlyIncome), 2) AS Salario_promedio_mensual,
	   MAX(MonthlyIncome) AS Salario_Maximo,
	   MIN(MonthlyIncome) AS Salario_Minimo
FROM "WA_Fn-UseC_-HR-Employee-Attrition"
GROUP BY Department
ORDER BY Salario_promedio_mensual DESC

-- Resultado: Sales tiene el salario promedio más alto
-- Insight clave: Sales paga mejor PERO tiene mayor rotación
-- Conclusión: el problema de rotación en Sales no es salarial
-- Recomendación: investigar factores no monetarios como ambiente laboral, carga de trabajo o liderazgo

-- PREGUNTA 4: Comparación salario promedio entre los empleados activos y los retirados

SELECT Attrition,
       ROUND(AVG(MonthlyIncome), 2) AS Salario_promedio_mensual
FROM "WA_Fn-UseC_-HR-Employee-Attrition"
GROUP BY Attrition
ORDER BY Salario_promedio_mensual DESC

-- Resultado: empleados que se fueron ganaban menos
-- Insight: el salario SÍ influye en la rotación general, pero en Sales específicamente el salario no es el factor
-- Conclusión: la rotación tiene causas múltiples según departamento

-- PREGUNTA 5: Satisfacción laboral entre empleados activos y retirados

SELECT Attrition,
       ROUND(AVG(JobSatisfaction), 2) AS Promedio_satisfacción,
	   CASE WHEN AVG(JobSatisfaction) >= 3.5 THEN 'Muy Alto'
	        WHEN AVG(JobSatisfaction) >= 2.5 THEN 'Alto'
			WHEN AVG(JobSatisfaction) >= 1.5 THEN 'Medio' ELSE 'Bajo'
			END AS Nivel_satisfacción
FROM "WA_Fn-UseC_-HR-Employee-Attrition"
GROUP BY Attrition
ORDER BY Promedio_satisfacción DESC

-- Resultado: Se quedaron: 2.78 (Alto) | Se fueron: 2.47 (Medio)
-- Insight: la diferencia es pequeña, la satisfacción laboral no es el único factor determinante de la rotación
-- Conclusión: hay otros factores más influyentes que la satisfacción
-- Recomendación: analizar carga de trabajo, distancia al trabajo y balance vida-trabajo como factores adicionales

-- PREGUNTA 6: Rotación por rango salarial

SELECT CASE WHEN MonthlyIncome < 3000 THEN 'Bajo'
            WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medio'
			ELSE 'Alto'
			END AS Rango_salarial,
		COUNT(EmployeeNumber) AS Total_empleados,
		COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) AS Empleados_retirados,
		ROUND(COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100 / COUNT(EmployeeNumber), 2) AS Porcentaje_de_retiro
FROM "WA_Fn-UseC_-HR-Employee-Attrition" 
GROUP BY Rango_salarial
ORDER BY Porcentaje_de_retiro DESC

-- Resultado: Bajo (<3000) tiene la mayor rotación
-- Insight: rango Bajo tiene el doble de rotación vs Medio y Alto, aunque tiene menos empleados en total
-- Conclusión: salarios bajos = mayor riesgo de rotación
-- Recomendación: revisar política salarial para empleados en el rango bajo como medida prioritaria de retención


-- PREGUNTA 7: Costo salarial por departamento

SELECT Department, SUM(MonthlyIncome) AS Costo_salarial_total,
       ROUND(SUM(MonthlyIncome) * 100 / (SELECT SUM(MonthlyIncome) FROM "WA_Fn-UseC_-HR-Employee-Attrition" ), 2) AS Porcentaje_del_global
FROM "WA_Fn-UseC_-HR-Employee-Attrition" 
GROUP BY Department
ORDER BY Costo_salarial_total DESC

-- Resultado: R&D 63% | Sales 32% | HR 4%
-- Insight: R&D concentra más del 60% del costo salarial y tiene la menor rotación — inversión justificada. Sales tiene 32% del costo pero la mayor rotación
-- Conclusión: el problema de Sales no es salarial
-- Recomendación: auditar factores cualitativos en Sales


-- PREGUNTA 8: Ranking por salario de empleados en cada departamento

WITH Ranking_empleados AS(
                          SELECT Department, EmployeeNumber, MonthlyIncome,
			         RANK() OVER(PARTITION BY Department
					     ORDER BY MonthlyIncome DESC) AS Ranking_salarial
			  FROM "WA_Fn-UseC_-HR-Employee-Attrition"
			  )
SELECT *
FROM Ranking_empleados
WHERE Ranking_salarial <= 3
ORDER BY Department, Ranking_salarial

-- Resultado: HR: empleado 1338 | R&D: empleado 259 | Sales: empleado 1282
-- Conclusión: top 3 de cada departamento identificado
-- Útil para análisis de equidad salarial interna



