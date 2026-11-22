/* =====================================================================
   PROYECTO: Análisis de Trade Marketing (SQL Server)
   SCRIPT 01: Crear la base de datos y las 4 tablas
   ---------------------------------------------------------------------
   Orden de ejecución del proyecto:
     01_crear_tablas.sql  ->  02_insertar_datos.sql  ->  03_analisis/
   Es seguro volver a ejecutarlo: borra las tablas si ya existen y las
   crea de nuevo (vacías). Después hay que correr el script 02.
   ===================================================================== */

IF DB_ID('trade_marketing') IS NULL
    CREATE DATABASE trade_marketing;
GO

USE trade_marketing;
GO

/* ---------------------------------------------------------------------
   Borrar tablas existentes.
   El orden importa: primero las que tienen llaves foráneas
   (auditoria_pdv y ventas) y al final las tablas a las que apuntan.
--------------------------------------------------------------------- */
IF OBJECT_ID('auditoria_pdv', 'U') IS NOT NULL DROP TABLE auditoria_pdv;
IF OBJECT_ID('ventas',        'U') IS NOT NULL DROP TABLE ventas;
IF OBJECT_ID('productos',     'U') IS NOT NULL DROP TABLE productos;
IF OBJECT_ID('vendedores',    'U') IS NOT NULL DROP TABLE vendedores;
GO


/* ---------------------------------------------------------------------
   1. VENDEDORES: las personas que venden y visitan los puntos de venta
--------------------------------------------------------------------- */
CREATE TABLE vendedores (
	id_vendedor      INT PRIMARY KEY IDENTITY(1,1),
	nombre           VARCHAR(50),
	apellidos        VARCHAR(50),
	correo           VARCHAR(50),
	identificacion   VARCHAR(15),     -- texto: es un código, no una cantidad
	estado           VARCHAR(10),     -- 'Activo' o 'Inactivo'
	ciudad           VARCHAR(50),
	fecha_ingreso    DATE,
	fecha_nacimiento DATE
);
GO


/* ---------------------------------------------------------------------
   2. PRODUCTOS: catálogo con precio y costo (permite calcular el margen)
--------------------------------------------------------------------- */
CREATE TABLE productos (
	id_producto INT PRIMARY KEY IDENTITY(1,1),
	nombre      VARCHAR(100),
	stock       INT,
	categoria   VARCHAR(50),
	precio      DECIMAL(10,2),        -- precio de venta en COP
	costo       DECIMAL(10,2)         -- costo para la empresa en COP
);
GO


/* ---------------------------------------------------------------------
   3. VENTAS: cada fila es una venta de un vendedor sobre un producto
   `descuento` se guarda como PORCENTAJE (0, 5, 10 o 15)
--------------------------------------------------------------------- */
CREATE TABLE ventas (
	id_venta         INT PRIMARY KEY IDENTITY(1,1),
	id_vendedor      INT,
	id_producto      INT,
	cantidad_vendida INT,
	medio_pago       VARCHAR(50),
	descuento        DECIMAL(10,2),
	fecha_venta      DATE,
	FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
	FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
GO


/* ---------------------------------------------------------------------
   4. AUDITORIA_PDV: cada fila es una visita a un punto de venta (PDV)
   Las columnas BIT guardan 1 (sí) o 0 (no).
--------------------------------------------------------------------- */
CREATE TABLE auditoria_pdv (
	id_auditoria          INT PRIMARY KEY IDENTITY(1,1),
	id_vendedor           INT,
	id_producto           INT,
	nombre_pdv            VARCHAR(100),
	ciudad                VARCHAR(50),
	fecha_auditoria       DATE,
	producto_exhibido     BIT,
	precio_correcto       BIT,
	material_publicitario BIT,
	puntaje               INT,        -- calificación de la visita (1 a 10)
	observaciones         VARCHAR(200),
	FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
	FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
GO
