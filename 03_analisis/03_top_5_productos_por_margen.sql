-- ¿Cuáles son los 5 productos con mayor margen?
-- Elegí el (Margen Porcentual) porque nos da mayor eficiencia por cada peso vendido del producto

-- Top 5 por margen porcentual (eficiencia)
SELECT 
	TOP 5
	p.id_producto,
	p.nombre,
	CAST(SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) AS DECIMAL(18,2)) as utilidad_total,
	CAST(100 * SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) / SUM(p.precio * (1 - v.descuento / 100) * v.cantidad_vendida) AS DECIMAL(18, 2)) as margen_porcentual
FROM productos p
INNER JOIN ventas v ON v.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY margen_porcentual DESC;

-- Top 5 por utilidad total (aporte en pesos)
SELECT 
	TOP 5
	p.id_producto,
	p.nombre,
	CAST(SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) AS DECIMAL(18,2)) as utilidad_total,
	CAST(100 * SUM((p.precio * (1 - v.descuento / 100) - p.costo) * v.cantidad_vendida) / SUM(p.precio * (1 - v.descuento / 100) * v.cantidad_vendida) AS DECIMAL(18, 2)) as margen_porcentual
FROM productos p
INNER JOIN ventas v ON v.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY utilidad_total DESC;

-- RESPUESTA (Eficiencia): Los 5 productos con mayor margen son 'Agua sin gas 600ml (38,83%), Té frío limón 400ml (34,36%), Chicharrón de cerdo 80g (32,08%), Bebida energizante 250ml (31,82%), Papas fritas pollo 150g (30,91%)'

-- RESPUESTA (Aporte en Pesos): Los 5 productos con mayor utilidad son 'Café molido 250g ($6.980.125 COP), Aceite vegetal 1L ($6.366.190 COP), Bebida energizante 250ml ($4.790.225 COP), Leche en polvo 380g ($4.222.900 COP), Shampoo 400ml ($4.155.450 COP)'

-- CONCLUSIÓN: Bebida energizante 250ml es el único producto que aparece en ambos rankings (margen del 31,82% y utilidad total de $4.790.225 COP), por lo que es la mejor candidata para impulsar con marketing