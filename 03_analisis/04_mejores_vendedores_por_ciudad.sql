USE trade_marketing;
GO

--¿Quiénes son los mejores vendedores de cada ciudad?

-- 1) Ranking completo de vendedores por ciudad (permite ver todos los puestos)

WITH VentasObtenidas AS(
	SELECT 
		vdr.id_vendedor,
		vdr.nombre + ' ' + vdr.apellidos AS nombre_completo,
		vdr.ciudad,
		vdr.estado,
		MAX(v.fecha_venta) AS ultima_venta,
		CAST(SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) AS DECIMAL(18,2)) AS ganancia_total,
		SUM(v.cantidad_vendida) AS total_unidades_vendidas
	FROM ventas AS v
	JOIN productos AS p 
		ON p.id_producto = v.id_producto
	JOIN vendedores AS vdr 
		ON v.id_vendedor = vdr.id_vendedor
	GROUP BY 
		vdr.id_vendedor,
		vdr.nombre,
		vdr.apellidos,
		vdr.estado,
		vdr.ciudad
)

SELECT 
	id_vendedor,
	nombre_completo,
	ciudad,
	estado,
	ganancia_total,
	total_unidades_vendidas,
	DENSE_RANK() OVER(PARTITION BY ciudad ORDER BY ganancia_total DESC, total_unidades_vendidas DESC) AS ranking,
	ultima_venta
FROM VentasObtenidas
ORDER BY ciudad, ranking;

-- 2) Mejor vendedor de cada ciudad (solo el puesto 1)

WITH VentasObtenidas AS(
	SELECT 
		vdr.id_vendedor,
		vdr.nombre + ' ' + vdr.apellidos AS nombre_completo,
		vdr.ciudad,
		vdr.estado,
		MAX(v.fecha_venta) AS ultima_venta,
		CAST(SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) AS DECIMAL(18,2)) AS ganancia_total,
		SUM(v.cantidad_vendida) AS total_unidades_vendidas
	FROM ventas AS v
	JOIN productos AS p 
		ON p.id_producto = v.id_producto
	JOIN vendedores AS vdr 
		ON v.id_vendedor = vdr.id_vendedor
	GROUP BY 
		vdr.id_vendedor,
		vdr.nombre,
		vdr.apellidos,
		vdr.estado,
		vdr.ciudad
),

VendedoresRankeados AS(
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY ciudad ORDER BY ganancia_total DESC, total_unidades_vendidas DESC) AS ranking
	FROM VentasObtenidas
)

SELECT 
	id_vendedor,
	nombre_completo,
	ciudad,
	estado,
	ganancia_total,
	total_unidades_vendidas,
	ranking,
	ultima_venta
FROM VendedoresRankeados
WHERE ranking = 1
ORDER BY ciudad, ranking;

-- RESPUESTA: Los mejores de cada ciudad son: 

--  * Barranquilla:  Luis Fernando Barraza Pérez ($4.579.425)
--  * Bogotá:  Julián David Castro Pardo ($5.507.500)
--  * Bucaramanga:  Oscar Iván Rueda Ardila ($3.639.755)
--  * Cali:  Andrés Felipe Cardona Ríos ($5.677.515)
--  * Medellín:  Mateo Zapata Ospina ($5.579.215)
--  * Yopal:  Yuliana Rincón Amaya ($3.371.795)

-- CONCLUSIÓN: Los tres vendedores inactivos (Bogotá, Cali y Yopal) quedaron en el
-- puesto 4 de su ciudad y vendieron por última vez en marzo de 2026. Como tuvieron
-- unos 7 meses menos para vender, compararlos por utilidad acumulada los penaliza,
-- su puesto refleja menos tiempo activo, no necesariamente peor desempeño. Una
-- comparación más justa mediría la utilidad por mes activo.