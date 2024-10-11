## :dart: Introducción

El **objetivo** general del proyecto es realizar un análisis exploratorio de la base de datos de Northwind Traders en SQLite, con el fin de identificar patrones.

Northwind Traders es una organización ficticia creada por Microsoft cuya base de datos relacional simula las operaciones de un comercio electrónico de alimentos, donde se gestionan pedidos, productos, clientes, proveedores, entre otros.

Su alta disponibilidad y estructura sencilla la hacen una base de datos ideal para la exploración y/o desarrollo de habilidades.

## :wrench: Tecnologías utilizadas

Para el desarrollo del proyecto se utilizarón las siguientes herramientas:

- **SQLite:** Sistema de gestión de base de datos (SGBD)
- **DB Browser for SQLite:** Aplicación de escritorio diseñada para interactuar con SQLite. 
- **Excel:** Herramienta para la creación de gráficos y visualización efectiva de los datos.

## :open_file_folder: Estructura de la base de datos

El proceso de reconocimiento y comprensión de la esctructura interna de una base de datos (cuando no somos nosotros quien la creamos) es fundamental para la manipulación de la misma, resulta necesario antes de escudriñar en el mar de datos disponibles, saber como estan estructurados y como se relacionan entre si. Por ende, empezaremos por desmenuzar el diagrama entidad relación de Northwind:

![DER](https://github.com/Johanna-Rojas/BD_NORTHWIND/blob/main/Northwind_E-R_Diagram.png)

**1.** La base de datos relacional esta compuesta por las siguientes entidades (cada una con más de 3 atributos):
- Customers (Clientes)
- Employees (Empleados)
- Shippers (Transportistas)
- Suppliers (Proveedores)
- Orders (Pedido)
- OrderDetails (Detalles del pedido)
- Products (Productos)
- Categories (Categorias)

**2.** Las claves primarias o atributos que identifican de manera única cada registro de la entidad son sus respectivos ID (ClienteID, EmpleadoID, ProvedorID, etc.) 

**3.** Las claves fóraneas o relacionales se caracterizan pos las siguientes cardinalidades, que aseguran que los datos se almacenan de manera coherente:

* Uno a muchos
   - Customers - Orders: Un cliente puede realizar muchos pedidos.
   - Employees - Orders: Un empleado puede atender muchos pedidos.
   - Shippers - Orders: Un transportista puede llevar varios pedidos.
   - Orders - OrderDetails: Un pedido puede contener muchos productos.

* Muchos a uno
   - OrderDetails - Products: Un producto puede estar en muchos pedidos.
   - Products - Suppliers: Muchos productos son suministrados por un solo proveedor.
   - Products - Categories: Muchos productos pertenecen a una categoría.

**4.** La base de datos parece estar diseñada siguiendo los principios de normalización, garantizando la integridad de los datos y reduciendo la redundancia, es decir, cada campo contiene un solo valor atómico y no hay conjuntos de atributos que dependan de otros más que de su clave primaria.

***En el siguiente enlace pueden encontrar muchos otros detalles de esta base de datos, como los tipos de datos, restricciones, índices, etc:*** [Estructura de la BD Northwind](https://en.wikiversity.org/wiki/Database_Examples/Northwind)

## :interrobang: Objetivos de análisis

El análisis exploratorio se realizó teniendo en cuenta los siguientes objetivos obtenidos a partir de las preguntas de investigación, con el fin de descubrir patrones, tendencias o áreas de oportunidad:

1. Analizar la tendencia de ventas e ingresos a lo largo del tiempo.
2. Segmentar las ventas y/o ingresos por región.
3. Identificar el/los productos estrella(s) de cada categoría.
4. Cuantificar el desempeño en ventas por empleado.
5. Clasificar los mejores clientes

## :bookmark_tabs: Consultas SQLite

A través de consultas SQL, exploramos los patrones y tendencias presentes en los datos de clientes, empleados, productos y pedidos de la base de datos de Northwind Traders. Este análisis nos arrojó valiosos insights, que permitierón obtener respuestas a preguntas claves sobre el negocio, proporcionando una base sólida para la toma de decisiones más informadas.

A continuación se presentan algunas de las consultas realizadas, si deseas visualizar el ***Script completo***, ir al siguiente enlace: [Consultas DB Northwind con SQLite](https://github.com/Johanna-Rojas/BD_NORTHWIND/blob/main/Queries_Norhwind.sql)

~~~
----------------------------------------------------------------------------------------------------
-- Vista de los datos más importantes de 7 de las tablas
----------------------------------------------------------------------------------------------------
CREATE VIEW ImportantDate AS
SELECT od.OrderID, o.OrderDate, 
	   c.CategoryName, 
	   ProductName, 
	   sup.SupplierName, sup.CitySuppl, sup.CountrySuppl,
	   CONCAT(FirstName,' ',LastName) AS EmployeeName,
	   cus.CustomerName, cus.City, cus.Country,
	   od.Quantity, p.Price, od.Quantity * p.Price AS TotalGrossProfit
FROM 
	   OrderDetails od
LEFT JOIN Orders o 
	   ON od.OrderID = o.OrderID
INNER JOIN Employees e 
	   ON o.EmployeeID = e.EmployeeID
INNER JOIN Products p 
	   ON od.ProductID = p.ProductID
INNER JOIN Categories c 
	   ON p.CategoryID = c.CategoryID
INNER JOIN Customers cus 
	   ON o.CustomerID = cus.CustomerID
INNER JOIN Suppliers sup 
	   ON p.SupplierID = sup.SupplierID

----------------------------------------------------------------------------------------------------
-- Consultas individuales
----------------------------------------------------------------------------------------------------
-- Segmentación de Ventas por Categoría
SELECT cs.CategoryID, c.CategoryName,
	   sum(QuantitySold) AS QuantityCategory, 
	   sum(GrossProfit) AS GrossProfitCategory
FROM CommercialStatus cs
INNER JOIN Categories c ON cs.CategoryID = c.CategoryID
GROUP BY cs.CategoryID
ORDER BY GrossProfitCategory DESC

-- Utilidad Mensual
SELECT COUNT(OrderID) AS QuantityOrders, 
	   strftime('%Y-%m', OrderDate) AS YearsMonth,
	   sum(Utility) AS UtilityMonth
FROM UtilityOrders
GROUP BY YearsMonth

-- Top 5 de los mejores clientes por categoría
WITH CustomersCategory AS (
	SELECT 
		p.CategoryID, o.CustomerID, 
	    c.CustomerName,
	    sum(od.Quantity) AS TotalQuantity,
	    sum(od.Quantity * Price) AS GrossProfitCust
	FROM 
		Orders o
	INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
	INNER JOIN Products p 	ON od.ProductID = p.ProductID
	INNER JOIN Customers c ON o.CustomerID = c.CustomerID
	GROUP BY 
		p.CategoryID, o.CustomerID
)
SELECT *,
	(SELECT count(*)
	FROM CustomersCategory cc2
	WHERE cc2.CategoryID = cc.CategoryID
	  and cc2.GrossProfitCust >= cc.GrossProfitCust) AS Ranking
FROM
	CustomersCategory cc
WHERE Ranking <=5
ORDER BY CategoryID, Ranking
~~~

## :bar_chart: Visualización de resultados

Ofreciendo una visión general de los datos más relevantes obtenidos através de las consultas, se desarrolló mediante la herramienta Excel el siguiente Dashboard ([Video](https://vimeo.com/1018783584)) que permite visualizar de forma dinámica los resultados, cumpliendo con los objetivos de análisis propuestos. 

![Dashboard](https://github.com/Johanna-Rojas/BD_NORTHWIND/blob/main/Dashboard_Analisis_Northwind.png)


## :chart_with_upwards_trend: Interpretación de los datos

El Dashboard proporciona una visión general de los datos de ventas y utilidades obtenidos por Northwind Traders durante los años 1996 y 1997. De donde se pueden inferir lo siguiente:

**1.** Tendencia en ventas e ingresos:

- Se observa una tendencia creciente en las ventas totales a lo largo del período, con un crecimiento del 7.37%.
- El descenso significativo en el mes de febrero de 1997, puede ser debido a que no se reportó toda la data de ese mes.
- Se evidencian algunas flutuaciones estacionales, con picos y valles en ciertos meses del año, posiblemente factores como las festividades, estaciones climaticas o campañas de marketing pueden estar influyendo.
- Los ingresos siguen una tendencia similar a las ventas, de Julio a Enero se experimento un aumento del 11.8%.

**2.** Distribución geográfica:

- La mayor parte de los ingresos por ventas se concentran en USA (aprox. 18%), seguido por Austria y Alemania, lo que nos indica la alta presencia en estos mercados y el potencial de crecimiento en otras regiones como Brasil que cuenta con el 10.41% del mercado, Canada y Francia.

**3.** Comportamiento por categoría y producto:

- Se indica una fuerte demanda de los productos de las categorías "Beverages" (17.96%), "Dairy Products" (20.41%), "Confections" (16.56%), respectivamente el aporte en ingresos es del 25.74%, 18.09%, 14.21%. 
- De esas tres categorías, productos específicos como el "Cote de Blaye", "Raclette Courdavault", "Camembert Pierrot", "Tarte au sucre", son los que más destacan por el ingreso generado, con porcentajes mayores al 20% en cada una de sus categorías respectivas.
- Pero definitivamente el producto estrella es "Cote de Blaye" que genera el mayor porcentaje de ingresos (16.30%) de los 77 productos ofrecidos.
- Se debe fijar la atención en productos que tienen un porcentaje de ventas muy por encima de los ingresos generados, ya que esto esta provocando un esfuerzo en ventas con una retribucción baja.
- Cabe mencionar que las categorías Produce, Grains/Cereals que manejan doce de los productos, han tenido un muy bajo rendimiento, estan aportando aproximadamente solo el 6% de los ingresos y ventas, podrían requerir ajustes, campañas promocionales, etc.
- El análisis ABC revela que que 61% de los productos le estan generando a la empresa solo un 20% de ingresos y que el mayor beneficio (80%) lo aportan las ventas solo del 39% de los productos (30/77), lo que sugiere una oportunidad para optimizar el inventario y enfocarse en los productos más rentables.

**4.** Desempeño de empleados:

- "Margaret Peacock" es quien lleva la batuta en ventas, contribuyendo en un 27% a los ingresos totales.
- Se debe evaluar afondo el desempeño de "Andrew Fuller", "Steven Buchanan", "Michael Suyama" y "Anne Dodsworth" que muestran porcentajes de ventas y aportes en ingresos muy por debajo del 10%.

Evaluando las tres categorías más rentables: 

- "Margaret Peacock" es quien sobresale por la cantidad de productos vendidos en las 3 categorías (del 20% al 30%), con un porcentaje muy similar al de los ingresos recibidos.
- En la categoría "Beverages" se distingue "Robert King" por la cantidad de ingresos que logro generar a la empresa (aproximadamente un 29% de la categoría) respecto a las pocos productos vendidos (aprox. 11%). En las otras categorías muestra un bajo desempeño.
- En las categorías "Dairy Products" y "Confections" resalta "Nancy Davolio" por su aporte en ventas e ingresos por encima del 15%.
	   
**5.** Clientes Clave:

- Un pequeño número de clientes, 25 de 74 (34%), generan una proporción significativa de las ventas e ingresos totales (aprox. 80%), esto sugiere una dependencia con muy pocos clientes clave.
- En general, los clientes que le suponen a la empresa un mayor beneficio son: "Ernst Handel", "Mère Paillarde" y "Save-a-lot Markets".
- Y quienes estan apartando menos a los ingresos son: "Franchi S.p.A", "Ana Trujillo Emparedados y helados" y "Centro comercial Moctezuma".

Evaluando las tres categorías más rentables:

- En la categoría "Beverages" sobresalen con un aporte mayor al 20% del total de la categoría, "Mère Paillarde", "Simons bistro" y "Piccolo und mehr".
- Respecto a la categoría "Dairy Products" destacan clientes como "Frankenversand" y "Ernst Handel" con un aporte del 28% y 24% respectivamente.
- Y en la categoría "Confections" resalta "Rattlesnake Canyon Grocery" con un aporte casi del 30% de los ingresos persividos en esa categoría.

## :thought_balloon: Concluciones y recomendaciones

- Fortalecer las categorías de mayor venta: Dado que "Beverages", "Dairy Products" y "Confections" son las categorías más populares, la empresa podría considerar expandir su oferta de productos en estas líneas o lanzar promociones especiales.
- Analizar la estacionalidad: Identificar los factores que influyen en las fluctuaciones estacionales y desarrollar estrategias para aprovechar las temporadas altas y mitigar los efectos de las temporadas bajas.
- Optimizar la fuerza de ventas: Utilizar los datos de ventas por empleado para identificar áreas de mejora y proporcionar capacitación adicional a los empleados que lo necesiten.
- Fomentar la lealtad de los clientes clave: Implementar programas de fidelización para retener a los clientes más importantes y estimular compras repetidas.
- Expansión geográfica: Considerar la posibilidad de expandir las operaciones a nuevas regiones para diversificar los ingresos y reducir la dependencia de un solo mercado.
- Análisis de la competencia: Realizar un análisis comparativo con los competidores para identificar oportunidades y amenazas en el mercado.

## :pencil: Contribuciones

Este proyecto genera un espacio para aprender y crecer. 
Siéntete libre de explorar el código, hacer preguntas y proponer mejoras. 
Tus comentarios son muy valiosos. :sparkles:

***¡Gracias por tu interés en el proyecto!***