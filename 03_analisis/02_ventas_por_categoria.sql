-- Se usan ventas netas (con descuento aplicado) porque reflejan lo que realmente se cobró.
-- ¿Qué categoría deja más ingresos y cuál más margen?

SELECT 
	p.categoria, 
	-- CAST(SUM(p.precio * v.cantidad_vendida) AS DECIMAL(18,2)) as ventas_brutas,
	CAST(SUM(p.precio * v.cantidad_vendida * (1 - v.descuento / 100)) AS DECIMAL(18,2)) as ventas_netas
FROM ventas v
INNER JOIN productos p on p.id_producto = v.id_producto
GROUP BY p.categoria
ORDER BY ventas_netas DESC;

-- RESPUESTA 1: La categoría que deja mas ingresos netos es 'Despensa' con $85.160.065 COP

SELECT 
	p.categoria,
	CAST(SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) AS DECIMAL(18,2)) as utilidad_total,
	CAST(100 * SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) / SUM(p.precio * (1 - v.descuento / 100) * v.cantidad_vendida) AS DECIMAL(18,2)) AS margen_porcentual
FROM productos p
INNER JOIN ventas v ON v.id_producto = p.id_producto
GROUP BY p.categoria
ORDER BY margen_porcentual DESC;

-- RESPUESTA 2: La categoría con más margen (porcentual) es 'Bebidas' con el 31,1% y una utilidad total de $17.667.670 COP