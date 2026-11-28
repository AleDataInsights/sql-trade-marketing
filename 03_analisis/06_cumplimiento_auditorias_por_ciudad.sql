USE trade_marketing;
GO

-- ¿Qué ciudad tiene mejor cumplimiento en las auditorías?

-- Se ordena por "Cumplen los 3" (producto_exhibido, precio_correcto, material_publicitario) para una mayor eficiencia al revisar cuáles ciudades están cumpliendo estos tres criterios mencionados.

SELECT
	ciudad,
	COUNT(*) AS total_visitas,
	CAST(AVG(CAST(puntaje AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS puntaje_promedio,
	CAST(100.0 * SUM(CASE WHEN producto_exhibido = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(10,1)) AS pct_exhibicion,
	CAST(100.0 * SUM(CASE WHEN precio_correcto = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(10,1)) AS pct_precio_correcto,
	CAST(100.0 * SUM(CASE WHEN material_publicitario = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(10,1)) AS pct_material_publicitario,
	CAST(100.0 * 
	SUM(CASE 
			WHEN producto_exhibido = 1
			AND precio_correcto = 1
			AND material_publicitario = 1
			THEN 1
			ELSE 0
			END) / COUNT(*) AS DECIMAL(10,1)
	) AS pct_3_juntos
FROM auditoria_pdv
GROUP BY ciudad
ORDER BY pct_3_juntos DESC;

-- RESPUESTA: Bogotá con un 42,7% en los 3 criterios de cumplimiento y un Puntaje promedio de 7,78. Esto nos hace reconocer que Bogotá es la mejor ciudad en cumplimiento de las auditorías y Yopal con 16,6% en los 3 criterios
-- y 5,89 de Puntaje promedio siendo esta la que peor rendimiento de auditorías tiene en su totalidad.

-- CONCLUSIÓN: Analizando los resultados nos damos cuenta que el criterio de "Material Publicitario" de 4 ciudades estan por debajo del 50% (Cali, Bucaramanga, Barranquilla y Yopal). 
-- Debemos asistirlos para mejorar este criterio de la mejor manera posible ya que es el punto más débil de todas las ciudades. Yopal debe recibir asistencia inmediata en los tres criterios.