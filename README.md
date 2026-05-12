# HR Analytics — Employee Attrition Analysis

## Descripción
Análisis de rotación de empleados sobre dataset de IBM HR Analytics 
con 1.470 registros. Se respondieron 8 preguntas de negocio usando 
SQL y se construyó un dashboard ejecutivo en Power BI.

## Herramientas
- SQL (DB Browser for SQLite)
- Power BI Desktop (visualización y DAX)
- Dataset: IBM HR Analytics Employee Attrition (Kaggle)

## Preguntas de negocio respondidas
1. ¿Cuántos empleados hay y cuál es la tasa de rotación global?
2. ¿Qué departamento tiene mayor rotación?
3. ¿Cuál es el salario promedio por departamento?
4. ¿Los empleados que se fueron tenían menor salario?
5. ¿Qué nivel de satisfacción tienen los empleados que se fueron?
6. Clasificación de empleados por rango salarial y rotación
7. ¿Qué departamento tiene mayor costo salarial?
8. Ranking de empleados por salario dentro de cada departamento

## Principales hallazgos
- **16.12%** de tasa de rotación global — por encima del promedio saludable
- **Sales** tiene la mayor rotación (21%) pero el mejor salario promedio
- El problema de rotación en Sales **no es salarial** — hay factores cualitativos
- **R&D** concentra el 65% de los empleados y tiene la menor rotación
- Empleados que se fueron ganaban **$2.000 menos** en promedio

## Técnicas SQL utilizadas
- COUNT + CASE WHEN
- GROUP BY + HAVING
- Subconsultas
- CTEs (Common Table Expressions)
- Window Functions (RANK, PARTITION BY)

## Dashboard Power BI
- 3 medidas DAX (CALCULATE, DIVIDE, COUNT)
- Filtros interactivos por Department y JobRole
- KPIs ejecutivos de rotación

## Autor
Daniel Esquivel — Ingeniero Industrial | Data Analytics  
Bogotá, Colombia — 2026
