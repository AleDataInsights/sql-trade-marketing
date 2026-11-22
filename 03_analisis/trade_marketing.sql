-- Cuanto vendimos en total? 
SELECT 
	CAST(SUM(p.precio * v.cantidad_vendida) AS DECIMAL(18,2)) as ventas_brutas,
	CAST(SUM(p.precio * v.cantidad_vendida * (1 - v.descuento / 100)) AS DECIMAL(18,2)) as ventas_netas
FROM productos p
INNER JOIN ventas v 
ON p.id_producto = v.id_producto;

-- RESPUESTA: Obtuvimos unas ventas brutas de $315.986.800.00 y unas ventas netas de $305.893.515.00 (haciendo una deduccion del descuento correpondiente a cada venta)

-- Cuantas ventas tuvimos?
SELECT COUNT(*) as ventas_totales FROM ventas;

-- RESPUESTA: Hubo 3.500 ventas en total
