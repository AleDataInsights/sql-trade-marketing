USE trade_marketing;
GO

-- ¿Cómo evolucionan las ventas mes a mes y cuánto crecen frente al mes anterior?

WITH VentasMensuales AS (
	SELECT 
	CAST(SUM(p.precio * (1 - v.descuento / 100) * v.cantidad_vendida) AS DECIMAL(18,2)) AS ventas_netas,
	YEAR(v.fecha_venta) AS anio,
	MONTH(v.fecha_venta) AS numero_mes
	FROM ventas AS v 
	JOIN productos AS p ON v.id_producto = p.id_producto
	GROUP BY YEAR(v.fecha_venta), MONTH(v.fecha_venta)
),
VentasMesAnterior AS (
	SELECT 
		anio,
		numero_mes,
		ventas_netas,
		LAG(ventas_netas) OVER(ORDER BY anio ASC, numero_mes ASC) AS ventas_mes_anterior
	FROM VentasMensuales
)

SELECT 
	anio,
	numero_mes,
	ventas_mes_anterior,
	ventas_netas,
	CAST(
		(ventas_netas - ventas_mes_anterior) 
		/ NULLIF(ventas_mes_anterior, 0) * 100 
		AS DECIMAL(10,2) 
	) AS crecimiento_pct
FROM VentasMesAnterior
ORDER BY anio ASC, numero_mes ASC;

-- RESPUESTA: Las ventas netas no crecen de forma constante, sino que suben y bajan mes a mes.
--  * Mayor crecimiento: Marzo de 2026 fue el mes con mayor crecimiento con un (+43,68%) frente a su mes anterior.
--  * Mayor caída: Enero fue el mes que obtuvo la caída más fuerte frente a su mes anterior con un (-44,51%).
--  * Patrón:  Diciembre de 2025 es el pico del año (+36,79%), posiblemente por la temporada de fin de año. Enero cae -44,51% y febrero marca el mínimo ($18.555.535). En marzo hay
--    una recuperación de +43,68% y desde entonces las ventas oscilan entre $22 y $29 millones.
--  * Balance del periodo: Noviembre de 2025 obtuvo ($29.390.615) en ventas netas y finalizó en Octubre de 2026 con ($29.358.760) manteniendo unas ventas adecuadas, no hay tendencia de crecimiento solo estacionalidad.

-- CONCLUSIÓN: Diciembre es el mes con más ventas	, pero Febrero (con $18.555.535) tiene una caída de ventas y tendríamos que aplicar promociones o refuerzo de exhibición en ese mes para estabilizar moderadamente las ventas.