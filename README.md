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

## :interrobang: Objectivos de análisis



## :bookmark_tabs: Consultas SQLite

~~~
----------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------
-- 
~~~

## :bar_chart: Visualización de resultados

## :chart_with_upwards_trend: Interpretación de los datos



## :pencil: Contribuciones

Este proyecto genera un espacio para aprender y crecer. 
Siéntete libre de explorar el código, hacer preguntas y proponer mejoras. 
Tus comentarios son muy valiosos. :sparkles:

***¡Gracias por tu interés en el proyecto!***