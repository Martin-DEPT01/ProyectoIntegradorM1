USE sales_company;

-- Crea un trigger que registre en una tabla de monitoreo cada vez que un producto supere las 200.000 unidades vendidas acumuladas.
-- El trigger debe activarse después de insertar una nueva venta y registrar en la tabla el ID del producto, su nombre, 
-- la nueva cantidad total de unidades vendidas, y la fecha en que se superó el umbral.

DROP TABLE IF EXISTS monitoreo;
CREATE TABLE monitoreo (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  ProductID INT,
  ProductName VARCHAR(255),
  total_vendido INT,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER supera_200k_tr
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
	DECLARE CANTIDAD_MINIMA INT;
    DECLARE TOTAL_VENDIDA INT;
    DECLARE PRODUCT_NAME VARCHAR(255);
    SET CANTIDAD_MINIMA = 200000;
    
	SELECT SUM(QUANTITY) 
    INTO TOTAL_VENDIDA 
    FROM SALES
    WHERE PRODUCTID = NEW.PRODUCTID 
    GROUP BY PRODUCTID;
    
    SELECT ProductName INTO PRODUCT_NAME FROM PRODUCTS WHERE PRODUCTID = NEW.PRODUCTID;
    
	IF (TOTAL_VENDIDA >= CANTIDAD_MINIMA) AND 
    NOT EXISTS (SELECT 1 FROM monitoreo WHERE ProductID = NEW.PRODUCTID) THEN
		INSERT INTO monitoreo (ProductID, ProductName, total_vendido, fecha)
        VALUES (NEW.PRODUCTID, PRODUCT_NAME, TOTAL_VENDIDA, NOW());
	END IF;
END; //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------

-- Registra una venta correspondiente al vendedor con ID 9, al cliente con ID 84, del producto con ID 103, por una cantidad de 1.876 unidades y un valor de 1200 unidades.
-- Consulta la tabla de monitoreo, toma captura de los resultados y realiza un análisis breve de lo ocurrido.

SELECT * FROM monitoreo;

SET @NEXT_SALESID = (SELECT MAX(SalesID) +1 FROM SALES); -- 6758126
INSERT INTO sales (
	SalesID,
    SalesPersonID,
    CustomerID,
    ProductID,
    Quantity,
    Discount,
    TotalPrice,
    SalesDate,
    TransactionNumber
) VALUES (
	@NEXT_SALESID,
    9,
    84,
    103,
    1876,
    0,
    1200,
    NOW(),
    concat('TX',@NEXT_SALESID)
);

SELECT * FROM monitoreo;
-- ---------------------------------------------------------------------------------------------------------------------------------------

-- Selecciona dos consultas del avance 1 y crea los índices que consideres más adecuados para optimizar su ejecución.
-- Prueba con índices individuales y compuestos, según la lógica de cada consulta. 
-- Luego, vuelve a ejecutar ambas consultas y compara los tiempos de ejecución antes y después de aplicar los índices. 
-- Finalmente, describe brevemente el impacto que tuvieron los índices en el rendimiento y en qué tipo de columnas resultan más efectivos para este tipo de operaciones.


-- 1. Top 5 productos más vendidos por cantidad y vendedor que mas unidades vendio:
WITH TOP5_PRODUCTOS_MAS_VENDIDOS AS (
SELECT 
	PRODUCTID,
    SUM(QUANTITY) CANTIDAD_TOTAL 
FROM 
	SALES
GROUP BY PRODUCTID
ORDER BY CANTIDAD_TOTAL DESC
LIMIT 5
),
VENTAS_POR_VENDEDOR_Y_PRODUCTO AS (
SELECT 
	PRODUCTID, 
	SALESPERSONID, 
    SUM(QUANTITY) CANTIDAD_VENDIDA 
FROM 
	SALES
GROUP BY PRODUCTID, SALESPERSONID
), 
TOP_VENDEDORES_POR_PRODUCTO AS (
SELECT 
	VVP.PRODUCTID, 
    VVP.SALESPERSONID, 
    VVP.CANTIDAD_VENDIDA
FROM 
	VENTAS_POR_VENDEDOR_Y_PRODUCTO VVP
INNER JOIN
( 	SELECT 
		PRODUCTID, 
		MAX(CANTIDAD_VENDIDA) CANTIDAD_TOTAL_VENDIDA_PRODUCTO
	FROM 
		VENTAS_POR_VENDEDOR_Y_PRODUCTO
	GROUP BY PRODUCTID) AS SUB
ON 
	VVP.PRODUCTID = SUB.PRODUCTID AND VVP.CANTIDAD_VENDIDA = SUB.CANTIDAD_TOTAL_VENDIDA_PRODUCTO
)

SELECT 
	RANK() OVER(ORDER BY T5P.CANTIDAD_TOTAL DESC) RANKING,
	T5P.PRODUCTID, 
    P.PRODUCTNAME, 
    T5P.CANTIDAD_TOTAL AS VENTAS_POR_PRODUCTO, 
    TVP.SALESPERSONID, 
	CONCAT(EM.FIRSTNAME,' ',EM.LASTNAME) AS NOMBRE_EMPLEADO,
	TVP.CANTIDAD_VENDIDA AS VENTAS_POR_VENDEDOR,
	ROUND((TVP.CANTIDAD_VENDIDA / T5P.CANTIDAD_TOTAL * 100),2) AS '%_VENTAS_VENDEDOR/PRODUCTO'
FROM TOP5_PRODUCTOS_MAS_VENDIDOS T5P
INNER JOIN TOP_VENDEDORES_POR_PRODUCTO TVP ON T5P.PRODUCTID = TVP.PRODUCTID
INNER JOIN EMPLOYEES EM ON TVP.SALESPERSONID = EM.EMPLOYEEID
INNER JOIN PRODUCTS P ON T5P.PRODUCTID = P.PRODUCTID
ORDER BY VENTAS_POR_PRODUCTO DESC;
-- 21.750 sec

CREATE INDEX idx_sales_product_salesperson_quantity 
ON SALES(ProductID,SalesPersonID,Quantity);
-- 10.234
DROP INDEX idx_sales_product_salesperson_quantity ON SALES;


-- 2. Top 10 productos con mayor cantidad de unidades vendidas en todo el catálogo y posición dentro de su categoria
WITH VENTAS_POR_PRODUCTO_Y_CATEGORIA AS(
SELECT 
	PR.CATEGORYID,
    C.CATEGORYNAME,
	SL.PRODUCTID,
    PR.PRODUCTNAME,
    SUM(QUANTITY) TOTAL_PRODUCTO 
FROM 
	PRODUCTS PR
INNER JOIN SALES SL ON PR.PRODUCTID = SL.PRODUCTID
INNER JOIN CATEGORIES C ON PR.CATEGORYID = C.CATEGORYID
GROUP BY CATEGORYID, PRODUCTID
)

SELECT 
RANK() OVER (ORDER BY TOTAL_PRODUCTO DESC) RANKING_PRODUCTO,
CATEGORYID,CATEGORYNAME,PRODUCTID,PRODUCTNAME,TOTAL_PRODUCTO,
RANK() OVER (PARTITION BY CATEGORYID ORDER BY TOTAL_PRODUCTO DESC) RANKING_EN_SU_CATEGORIA
FROM VENTAS_POR_PRODUCTO_Y_CATEGORIA
ORDER BY TOTAL_PRODUCTO DESC
LIMIT 10;
-- 38.672 sec

CREATE INDEX idx_sales_productid
ON SALES(ProductID);
-- Error duration > 600 sec
DROP INDEX idx_sales_productid ON SALES;

CREATE INDEX idx_sales_productid_quantity
ON SALES(ProductID,Quantity);
-- 57.000 sec
DROP INDEX idx_sales_productid_quantity ON SALES;