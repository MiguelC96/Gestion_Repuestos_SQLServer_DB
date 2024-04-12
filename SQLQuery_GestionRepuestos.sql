--CREAR BASE DATOS PARA GESTION DE STOCK--
--https://www.linkedin.com/in/miguel-carmona-362349187/ 
--Reforzando los conocimientos obtenidos en el curso de bases de datos y MYSQL de EducacionIT : https://www.educacionit.com/cursos-de-mysql
-- Y poniendo en practica los conocimientos impartidos en el curso de SQL SERVER de ADEMASS: https://campus-ademass.com/curso/108

--Ejemplo de como usar una base de datos simple, para la gestion de stock y su posterior utilizacion para analizar los datos pertinentes mediante consultas.
-- Asi como su uso para posteriores practicas de analisis de datos en Power BI.
--Todos los registros de clientes,proveedores y autopartes son totalmente ficticios, solo para uso academico y proporcionados por CHATGPT.


-- 
create database gestion_respuestos;

--tabla clientes--

CREATE TABLE Clientes (
    ID INT PRIMARY KEY IDENTITY(1,1),
	DNI INT,
    CUIT VARCHAR(20),
    [Nombre] VARCHAR(255),
    Apellido VARCHAR(255),
    FechaNacimiento DATE,
	Sexo CHAR(1),
    Direccion TEXT,
    Telefono VARCHAR(20),
    Mail VARCHAR(100),
    Pais VARCHAR(100),
    Region VARCHAR(100),
	CuentaCorriente BIT
);

--Definicion de condiciones NOT NULL en las columnas de tabla clientes.

ALTER TABLE Clientes
ALTER COLUMN DNI INT NOT NULL;

ALTER TABLE Clientes
ALTER COLUMN CUIT VARCHAR(20) NOT NULL;

ALTER TABLE Clientes
ALTER COLUMN [Nombre] VARCHAR(255) NOT NULL;

ALTER TABLE Clientes
ALTER COLUMN Apellido VARCHAR(255) NOT NULL;

ALTER TABLE Clientes
ALTER COLUMN FechaNacimiento DATE NOT NULL;

ALTER TABLE Clientes
ALTER COLUMN Telefono VARCHAR(20) NOT NULL;

ALTER TABLE Clientes
ALTER COLUMN Mail VARCHAR(100) NOT NULL;



-- Tabla Familia de Autopartes para establecer jerarquia entre piezas --

CREATE TABLE FamiliasAutopartes (
    FamiliaID INT PRIMARY KEY IDENTITY(1,1),
    NombreFamilia VARCHAR(100) UNIQUE,
    Descripcion VARCHAR(MAX),
    FamiliaPadreID INT,
    FOREIGN KEY (FamiliaPadreID) REFERENCES FamiliasAutopartes(FamiliaID)
);

-- Tabla para el stock de ejemplo de TOYOTA--

CREATE TABLE Stock_Toyota (
    FamiliaID INT,
	NumeroParteT VARCHAR(50) PRIMARY KEY,
    NombreAutoparte VARCHAR(255),
    Marca VARCHAR(100),
	ModeloAuto VARCHAR(50),
	Año INT,
	Fabricante VARCHAR(100),
	ProveedorID INT,
	Cantidad INT,
    Precio DECIMAL(10,2)
);

---Definicion de condiciones NOT NULL en las columnas de tabla Stock_Toyota

ALTER TABLE Stock_Toyota
ALTER COLUMN NombreAutoparte VARCHAR(255) NOT NULL;

ALTER TABLE Stock_Toyota
ALTER COLUMN Marca VARCHAR(100) NOT NULL;

ALTER TABLE Stock_Toyota
ALTER COLUMN ModeloAuto VARCHAR(50) NOT NULL;

ALTER TABLE Stock_Toyota
ALTER COLUMN ProveedorID INT NOT NULL;

ALTER TABLE Stock_Toyota
ALTER COLUMN Cantidad INT NOT NULL;

ALTER TABLE Stock_Toyota
ALTER COLUMN Precio DECIMAL(10,2) NOT NULL;



--Tabla para el stock de ejemplo de HONDA--

CREATE TABLE Stock_Honda (
    FamiliaID INT,
	NumeroParteH VARCHAR(50) PRIMARY KEY,
    NombreAutoparte VARCHAR(255),
    Marca VARCHAR(100),
	ModeloAuto VARCHAR(50),
	Año INT,
	Fabricante VARCHAR(100),
	ProveedorID INT,
	Cantidad INT,
    Precio DECIMAL(10,2)
);

---Definicion de condiciones NOT NULL en las columnas de tabla Stock_Honda

ALTER TABLE Stock_Honda
ALTER COLUMN NombreAutoparte VARCHAR(255) NOT NULL;

ALTER TABLE Stock_Honda
ALTER COLUMN Marca VARCHAR(100) NOT NULL;

ALTER TABLE Stock_Honda
ALTER COLUMN ModeloAuto VARCHAR(50) NOT NULL;

ALTER TABLE Stock_Honda
ALTER COLUMN ProveedorID INT NOT NULL;

ALTER TABLE Stock_Honda
ALTER COLUMN Cantidad INT NOT NULL;

ALTER TABLE Stock_Honda
ALTER COLUMN Precio DECIMAL(10,2) NOT NULL;


--Tabla Proveedores--

CREATE TABLE Proveedores (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(255),
	CUIT VARCHAR(20),
    Mail VARCHAR(100),
    Telefono VARCHAR(20),
    Pais VARCHAR(100),
    Provincia VARCHAR(100),
	PaginaWeb VARCHAR(255)
);

--Definicion de condiciones NOT NULL en las columnas de tabla Proveedores.

ALTER TABLE Proveedores
ALTER COLUMN Nombre VARCHAR(255) NOT NULL;

ALTER TABLE Proveedores
ALTER COLUMN CUIT VARCHAR(20) NOT NULL;

ALTER TABLE Proveedores
ALTER COLUMN Mail VARCHAR(100) NOT NULL;

ALTER TABLE Proveedores
ALTER COLUMN Telefono VARCHAR(20) NOT NULL;


--Relacion FK con tabla Stock Toyota--

-- Para establecer relaciones de clave foranea de proveedor con stock toyota, se debio crear la tabla proveedores para luego usar un alter table.


ALTER TABLE Stock_Toyota
ADD CONSTRAINT FK_Proveedor_Toyota
FOREIGN KEY (ProveedorID)
REFERENCES Proveedores(ID);

--Relacion FK con tabla Stock Honda--

---- Para establecer relaciones de clave foranea de proveedor con stock honda, se debio crear la tabla proveedores para luego usar un alter table.

ALTER TABLE Stock_Honda
ADD CONSTRAINT FK_Proveedor_Honda
FOREIGN KEY (ProveedorID)
REFERENCES Proveedores(ID);

--Tabla de Sucursales--

CREATE TABLE Sucursales (
    ID INT PRIMARY KEY,
    NombreSucursal VARCHAR(50),
    Direccion TEXT,
    Telefono VARCHAR(20),
    Mail VARCHAR(100),
    Encargado VARCHAR(100),
	Pais VARCHAR(100),
    Provincia VARCHAR(100)
);

--Definicion de condiciones NOT NULL en las columnas de tabla Sucursales.

ALTER TABLE Sucursales
ALTER COLUMN NombreSucursal VARCHAR(50) NOT NULL;

ALTER TABLE Sucursales
ALTER COLUMN Direccion TEXT NOT NULL;

ALTER TABLE Sucursales
ALTER COLUMN Telefono VARCHAR(20) NOT NULL;

ALTER TABLE Sucursales
ALTER COLUMN Mail VARCHAR(100) NOT NULL;


--Para asignar la sucursal en donde se encuentra el stock, primero se debio crear la tabla sucursales y luego proceder con alter table a la tabla stock honda y toyota.

--Relacion FK con la tabla Stock_Honda para establecer en que sucursal se encuentra la pieza--

ALTER TABLE Stock_Honda --Se agrega SucursalID a Stock_Honda, para luego poder agregar la FK.
ADD SucursalID INT;

-- se procede a agregar las relaciones de clave foranea entre las tablas Stock_Honda y Sucursales

ALTER TABLE Stock_Honda
ADD CONSTRAINT FK_Sucursal_Honda FOREIGN KEY (SucursalID) REFERENCES Sucursales(ID);  -- FK --


--Relacion FK con la tabla Stock_Toyota para establecer en que sucursal se encuentra la pieza--

ALTER TABLE Stock_Toyota --Se agrega SucursalID a Stock_Toyota, para luego poder agregar la FK.
ADD SucursalID INT;

-- se procede a agregar las relaciones de clave foranea entre las tablas Stock_Toyota y Sucursales

ALTER TABLE Stock_Toyota
ADD CONSTRAINT FK_Sucursal_Toyota FOREIGN KEY (SucursalID) REFERENCES Sucursales(ID);  -- FK --


--Tabla de Ventas--

CREATE TABLE Ventas (
    ID INT PRIMARY KEY IDENTITY(1,1),
    FechaVenta DATE,
    ClienteID INT,
    NumeroParteH VARCHAR(50),
    NumeroParteT VARCHAR(50),
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalVenta DECIMAL(10,2),
    SucursalID INT,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ID), -- FK para referenciar clientes
    FOREIGN KEY (NumeroParteH) REFERENCES Stock_Honda(NumeroParteH), -- FK para referenciar tabla de stock de Honda
    FOREIGN KEY (NumeroParteT) REFERENCES Stock_Toyota(NumeroParteT), -- FK para referenciar tabla de stock de Toyota
    FOREIGN KEY (SucursalID) REFERENCES Sucursales(ID) -- FK para referenciar la sucursal
);

--Definicion de condiciones NOT NULL en las columnas de tabla Ventas.

ALTER TABLE Ventas
ALTER COLUMN Cantidad INT NOT NULL;

ALTER TABLE Ventas
ALTER COLUMN  PrecioUnitario DECIMAL(10,2) NOT NULL;

ALTER TABLE Ventas
ALTER COLUMN  TotalVenta DECIMAL(10,2) NOT NULL;


--Tabla Compras

CREATE TABLE Compras (
    ID INT PRIMARY KEY IDENTITY(1,1),
    FechaCompra DATE,
    ProveedorID INT,
    NumeroParteH VARCHAR(50), 
    NumeroParteT VARCHAR(50),
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalCompra DECIMAL(10,2),
    SucursalID INT,
    FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ID), -- FK para referenciar proveedores
    FOREIGN KEY (NumeroParteH) REFERENCES Stock_Honda(NumeroParteH), -- FK para referenciar tabla de stock de Honda
    FOREIGN KEY (NumeroParteT) REFERENCES Stock_Toyota(NumeroParteT), -- FK para referenciar tabla de stock de Toyota
    FOREIGN KEY (SucursalID) REFERENCES Sucursales(ID) -- FK para referenciar la sucursal
);

--Definicion de condiciones NOT NULL en las columnas de tabla Compras.

ALTER TABLE Compras
ALTER COLUMN Cantidad INT NOT NULL;

ALTER TABLE Compras
ALTER COLUMN  PrecioUnitario DECIMAL(10,2) NOT NULL;

ALTER TABLE Compras
ALTER COLUMN  TotalCompra DECIMAL(10,2) NOT NULL;



--Informacion recopilada de diversas fuentes para realizar esta parte del codigo.

--https://learn.microsoft.com/es-es/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver16
--https://www.ibm.com/docs/es/db2/11.1?topic=statements-create-trigger
--https://codigofacilito.com/articulos/triggers_mysql
--https://www.mssqltips.com/sqlservertip/7429/sql-triggers-for-inserts-updates-and-deletes-on-a-table/
--https://www.youtube.com/watch?v=97V1LqKdMls
--https://stackoverflow.com/questions/35181763/sql-server-select-from-inserted
--https://chancrovsky.blogspot.com/2014/05/tablas-inserted-deleted-en-triggers.html

-- Explicacion breve de la funcionalidad logica--

--La funcionalidad de estos 2 trigger (ActualizarStock_Compras y ActualizarStock_Ventas) es que actualice la cantidad de stock (Aumentar o deducir )cuando se ingresen valores en tabla compras o ventas--
-- Con la cláusula "AFTER INSERT",se activaran inmediatamente después de que se realice una inserción en la tabla (Compra o Ventas)--
-- Se declaran dos variables: @stock_update_quantity y @marca. 
--@stock_update_quantity se utiliza para almacenar la cantidad de stock que se actualizará--
--@marca se utiliza para determinar la marca del producto comprado o vendido (Honda o Toyota).
--Se utiliza la tabla especial inserted para obtener los datos de la compra o venta recién insertada. 
--Se extrae la cantidad comprada o vendida y se determina la marca del producto en función de si NumeroParteH o NumeroParteT tiene la condicion IS NOT NULL--

-- Trigger ActualizarStock_Compras --

CREATE TRIGGER ActualizarStock_Compras
ON Compras
AFTER INSERT
AS
BEGIN
    DECLARE @stock_update_quantity INT;
    DECLARE @marca CHAR(1);

    -- Se usará la columna NumeroParteH para Honda y NumeroParteT para Toyota

    SELECT @stock_update_quantity = Cantidad,
           @marca = CASE
                       WHEN NumeroParteH IS NOT NULL THEN 'H' -- Si NumeroParteH no es nulo, el producto es de Honda
                       WHEN NumeroParteT IS NOT NULL THEN 'T' -- Si NumeroParteT no es nulo, el producto es de Toyota
                   END
    FROM inserted; -- Se usa la tabla inserted para obtener la información de la compra

    -- Actualizar el stock en la tabla Stock_Honda si la compra es de un producto Honda
    IF @marca = 'H'
    BEGIN
        UPDATE Stock_Honda
        SET Cantidad = Cantidad + @stock_update_quantity
        WHERE NumeroParteH IN (SELECT NumeroParteH FROM inserted);
    END;

    -- Actualizar el stock en la tabla Stock_Toyota si la compra es de un producto Toyota
    IF @marca = 'T'
    BEGIN
        UPDATE Stock_Toyota
        SET Cantidad = Cantidad + @stock_update_quantity
        WHERE NumeroParteT IN (SELECT NumeroParteT FROM inserted);
    END;
END;


-- Trigger ActualizarStock_Ventas --

CREATE TRIGGER ActualizarStock_Ventas
ON Ventas
AFTER INSERT
AS
BEGIN
    DECLARE @stock_update_quantity INT;
    DECLARE @marca VARCHAR(50);

	 -- Se usará la columna NumeroParteH para Honda y NumeroParteT para Toyota

    SELECT @stock_update_quantity = Cantidad,
           @marca = CASE
                       WHEN NumeroParteH IS NOT NULL THEN 'H' -- Si NumeroParteH no es nulo, el producto es de Honda
                       WHEN NumeroParteT IS NOT NULL THEN 'T' -- Si NumeroParteT no es nulo, el producto es de Toyota
                   END
    FROM inserted; -- Se usa la tabla inserted para obtener la información de la venta

    -- Actualizar el stock en la tabla Stock_Honda si la venta es de un producto Honda

    IF @marca = 'H'
    BEGIN
        UPDATE Stock_Honda
        SET Cantidad = Cantidad - @stock_update_quantity
        WHERE NumeroParteH IN (SELECT NumeroParteH FROM inserted);
    END

    -- Actualizar el stock en la tabla Stock_Toyota si la venta es de un producto Toyota

    IF @marca = 'T'
    BEGIN
        UPDATE Stock_Toyota
        SET Cantidad = Cantidad - @stock_update_quantity
        WHERE NumeroParteT IN (SELECT NumeroParteT FROM inserted);
    END
END;


SELECT * FROM sys.triggers;



-- INSERCION DE DATOS DE EJEMPLO OBTENIDOS MEDIANTE CHAT GPT, PROPORCIONANDOLE LA ESTRUCTURA DE LAS TABLAS--

-- CLIENTES

INSERT INTO Clientes (Nombre, Apellido, Direccion, Telefono, Mail, Pais, Region, DNI, CUIT, Sexo, FechaNacimiento, CuentaCorriente)
VALUES 
('Ana', 'Alvarez', 'Calle 789', '456789012', 'ana@example.com', 'Argentina', 'Neuquen', '67890123', '30-67890123-8', 'F', '1993-12-05', 1),
('Pedro', 'Garcia', 'Av. Este', '567890123', 'pedro@example.com', 'Argentina', 'Tucuman', '78901234', '25-78901234-1', 'M', '1989-07-20', 0),
('Carmen', 'Rodriguez', 'Calle Norte', '678901234', 'carmen@example.com', 'Argentina', 'Chaco', '89012345', '20-89012345-4', 'F', '1997-02-15', 1),
('Alejandro', 'Diaz', 'Av. Oeste', '789012345', 'alejandro@example.com', 'Argentina', 'Salta', '90123456', '27-90123456-7', 'M', '1982-09-30', 0),
('Valeria', 'Martinez', 'Calle 123', '890123456', 'valeria@example.com', 'Chile', 'Coquimbo', '01234567', '30-01234567-0', 'F', '1988-11-25', 1),
('Roberto', 'Sanchez', 'Av. Sur', '901234567', 'roberto@example.com', 'Chile', 'Arica y Parinacota', '12345678', '25-12345678-3', 'M', '1994-04-18', 0),
('Florencia', 'Gutierrez', 'Av. Principal', '012345678', 'florencia@example.com', 'Chile', 'Maule', '23456789', '20-23456789-6', 'F', '1985-08-10', 1),
('Jorge', 'Lopez', 'Calle Norte', '123456789', 'jorge@example.com', 'Chile', 'Los Rios', '34567890', '27-34567890-9', 'M', '1990-12-05', 0),
('Sofia', 'Fernandez', 'Av. Central', '234567890', 'sofia@example.com', 'Brasil', 'Minas Gerais', '45678901', '30-45678901-1', 'F', '1987-07-20', 1),
('Ramon', 'Gonzalez', 'Calle Sur', '345678901', 'ramon@example.com', 'Brasil', 'Espirito Santo', '56789012', '25-56789012-4', 'M', '1993-02-15', 0),
('Antonella', 'Perez', 'Av. Este', '456789012', 'antonella@example.com', 'Brasil', 'Rio Grande do Sul', '67890123', '20-67890123-7', 'F', '1989-09-30', 1),
('Matias', 'Sanchez', 'Av. Oeste', '567890123', 'matias@example.com', 'Brasil', 'Bahia', '78901234', '27-78901234-0', 'M', '1982-04-25', 0),
('Agustina', 'Rodriguez', 'Calle 123', '678901234', 'agustina@example.com', 'Uruguay', 'Montevideo', '89012345', '30-89012345-3', 'F', '1988-11-10', 1),
('Carlos', 'Gomez', 'Av. Norte', '789012345', 'carlos@example.com', 'Uruguay', 'Canelones', '90123456', '25-90123456-6', 'M', '1994-06-15', 0),
('Lucia', 'Fernandez', 'Calle Sur', '890123456', 'lucia@example.com', 'Uruguay', 'San Jose', '01234567', '20-01234567-9', 'F', '1985-10-30', 1),
('Maximiliano', 'Lopez', 'Av. Este', '901234567', 'maximiliano@example.com', 'Uruguay', 'Soriano', '12345678', '27-12345678-2', 'M', '1991-03-18', 0),
('Marina', 'Perez', 'Av. Central', '012345678', 'marina@example.com', 'Argentina', 'Chubut', '23456789', '30-23456789-5', 'F', '1986-08-25', 1),
('Joaquin', 'Martinez', 'Calle 123', '123456789', 'joaquin@example.com', 'Argentina', 'Tierra del Fuego', '34567890', '25-34567890-8', 'M', '1992-12-10', 0),
('Romina', 'Sanchez', 'Av. Principal', '234567890', 'romina@example.com', 'Argentina', 'San Luis', '45678901', '20-45678901-1', 'F', '1989-05-15', 1),
('Juan', 'Gutierrez', 'Calle Sur', '345678901', 'juan@example.com', 'Argentina', 'La Pampa', '56789012', '27-56789012-4', 'M', '1995-10-30', 0),
('Maria', 'Lopez', 'Av. Norte', '456789012', 'maria@example.com', 'Chile', 'Antofagasta', '67890123', '30-67890123-7', 'F', '1988-04-25', 1),
('Pablo', 'Martinez', 'Av. Oeste', '567890123', 'pablo@example.com', 'Chile', 'Aysen', '78901234', '25-78901234-0', 'M', '1994-09-18', 0),
('Carolina', 'Fernandez', 'Calle 123', '678901234', 'carolina@example.com', 'Chile', 'Araucania', '89012345', '20-89012345-3', 'F', '1986-03-10', 1),
('Diego', 'Garcia', 'Av. Principal', '789012345', 'diego@example.com', 'Chile', 'Atacama', '90123456', '27-90123456-6', 'M', '1991-06-15', 0),
('Laura', 'Hernandez', 'Av. Norte', '890123456', 'laura@example.com', 'Brasil', 'Sergipe', '01234567', '30-01234567-9', 'F', '1987-11-30', 1),
('Gabriel', 'Martinez', 'Calle Sur', '901234567', 'gabriel@example.com', 'Brasil', 'Rondonia', '12345678', '25-12345678-2', 'M', '1993-04-18', 0),
('Valentina', 'Gonzalez', 'Av. Oeste', '012345678', 'valentina@example.com', 'Brasil', 'Rio Grande do Norte', '23456789', '20-23456789-5', 'F', '1985-09-25', 1),
('Andres', 'Perez', 'Calle 123', '123456789', 'andres@example.com', 'Brasil', 'Parana', '34567890', '27-34567890-8', 'M', '1990-02-10', 0),
('Camila', 'Rodriguez', 'Av. Principal', '234567890', 'camila@example.com', 'Uruguay', 'Artigas', '45678901', '30-45678901-1', 'F', '1988-07-15', 1),
('Javier', 'Lopez', 'Av. Norte', '345678901', 'javier@example.com', 'Uruguay', 'Cerro Largo', '56789012', '25-56789012-4', 'M', '1994-12-10', 0),
('Sofia', 'Gomez', 'Calle Sur', '456789012', 'sofia@example.com', 'Uruguay', 'Durazno', '67890123', '20-67890123-7', 'F', '1987-05-25', 1),
('Mariano', 'Martinez', 'Av. Este', '567890123', 'mariano@example.com', 'Argentina', 'Entre Rios', '78901234', '27-78901234-0', 'M', '1993-10-30', 0),
('Elena', 'Fernandez', 'Calle 123', '678901234', 'elena@example.com', 'Argentina', 'Formosa', '89012345', '30-89012345-3', 'F', '1985-03-15', 1),
('Nicolas', 'Gonzalez', 'Av. Oeste', '789012345', 'nicolas@example.com', 'Chile', 'Biobio', '90123456', '25-90123456-6', 'M', '1991-08-10', 0),
('Paula', 'Lopez', 'Av. Principal', '890123456', 'paula@example.com', 'Chile', 'Los Lagos', '01234567', '20-01234567-9', 'F', '1987-01-25', 1),
('Federico', 'Fernandez', 'Calle Sur', '901234567', 'federico@example.com', 'Brasil', 'Paraiba', '12345678', '27-12345678-2', 'M', '1993-06-10', 0),
('Romina', 'Sanchez', 'Av. Norte', '012345678', 'romina@example.com', 'Brasil', 'Piaui', '23456789', '30-23456789-5', 'F', '1986-09-15', 1),
('Juan', 'Gutierrez', 'Calle 123', '123456789', 'juan@example.com', 'Uruguay', 'Flores', '34567890', '25-34567890-8', 'M', '1992-02-28', 0),
('Maria', 'Lopez', 'Av. Principal', '234567890', 'maria@example.com', 'Uruguay', 'Lavalleja', '45678901', '20-45678901-1', 'F', '1988-07-15', 1),
('Pablo', 'Martinez', 'Calle Sur', '345678901', 'pablo@example.com', 'Argentina', 'San Juan', '56789012', '27-56789012-4', 'M', '1993-10-30', 0),
('Carolina', 'Fernandez', 'Av. Oeste', '456789012', 'carolina@example.com', 'Chile', 'Magallanes', '67890123', '30-67890123-7', 'F', '1987-05-25', 1),
('Diego', 'Garcia', 'Av. Principal', '567890123', 'diego@example.com', 'Brasil', 'Alagoas', '78901234', '25-78901234-0', 'M', '1992-08-10', 0),
('Laura', 'Hernandez', 'Calle 123', '678901234', 'laura@example.com', 'Uruguay', 'Montevideo', '89012345', '20-89012345-3', 'F', '1986-03-15', 1),
('Gabriel', 'Martinez', 'Av. Norte', '789012345', 'gabriel@example.com', 'Argentina', 'Buenos Aires', '90123456', '27-90123456-6', 'M', '1991-08-30', 0);


INSERT INTO Clientes (Nombre, Apellido, Direccion, Telefono, Mail, Pais, Region, DNI, CUIT, Sexo, FechaNacimiento, CuentaCorriente)
VALUES 
('Juan', 'Gutierrez', 'Av. Central', '123456789', 'juan@example.com', 'Argentina', 'Buenos Aires', '09876543', '20-09876543-1', 'M', '1987-04-10', 1),
('Maria', 'Lopez', 'Calle 456', '987654321', 'maria@example.com', 'Argentina', 'Cordoba', '98765432', '27-98765432-4', 'F', '1984-08-25', 0),
('Pablo', 'Martinez', 'Calle Sur', '456789012', 'pablo@example.com', 'Argentina', 'Santa Fe', '87654321', '30-87654321-7', 'M', '1990-12-15', 1),
('Carolina', 'Fernandez', 'Av. Norte', '321098765', 'carolina@example.com', 'Argentina', 'Mendoza', '76543210', '25-76543210-0', 'F', '1988-06-20', 0),
('Diego', 'Garcia', 'Calle Este', '890123456', 'diego@example.com', 'Chile', 'Santiago', '65432109', '27-65432109-3', 'M', '1993-03-12', 1),
('Laura', 'Hernandez', 'Av. Oeste', '012345678', 'laura@example.com', 'Chile', 'Valparaiso', '54321098', '20-54321098-6', 'F', '1982-09-05', 0),
('Gabriel', 'Martinez', 'Calle 123', '901234567', 'gabriel@example.com', 'Chile', 'Concepción', '43210987', '30-43210987-9', 'M', '1985-11-30', 1),
('Valentina', 'Gonzalez', 'Av. Principal', '890123456', 'valentina@example.com', 'Chile', 'Antofagasta', '32109876', '25-32109876-2', 'F', '1997-02-28', 0),
('Andres', 'Perez', 'Av. Norte', '678901234', 'andres@example.com', 'Brasil', 'Rio de Janeiro', '21098765', '20-21098765-5', 'M', '1991-07-15', 1),
('Camila', 'Rodriguez', 'Calle Sur', '345678901', 'camila@example.com', 'Brasil', 'Sao Paulo', '10987654', '27-10987654-8', 'F', '1986-04-22', 0),
('Javier', 'Lopez', 'Calle 456', '012345678', 'javier@example.com', 'Brasil', 'Salvador', '09876543', '30-09876543-1', 'M', '1994-10-18', 1),
('Sofia', 'Gomez', 'Av. Principal', '987654321', 'sofia@example.com', 'Brasil', 'Brasilia', '98765432', '25-98765432-4', 'F', '1983-05-30', 0),
('Mariano', 'Martinez', 'Calle 123', '876543210', 'mariano@example.com', 'Uruguay', 'Montevideo', '76543210', '27-76543210-7', 'M', '1990-09-05', 1),
('Elena', 'Fernandez', 'Av. Norte', '543210987', 'elena@example.com', 'Uruguay', 'Punta del Este', '65432109', '20-65432109-0', 'F', '1987-11-20', 0),
('Nicolas', 'Gonzalez', 'Av. Oeste', '210987654', 'nicolas@example.com', 'Uruguay', 'Colonia', '54321098', '30-54321098-3', 'M', '1995-03-10', 1),
('Paula', 'Lopez', 'Av. Sur', '987654321', 'paula@example.com', 'Uruguay', 'Maldonado', '43210987', '25-43210987-6', 'F', '1984-08-15', 0);

INSERT INTO Clientes (Nombre, Apellido, Direccion, Telefono, Mail, Pais, Region, DNI, CUIT, Sexo, FechaNacimiento, CuentaCorriente)
VALUES 
('Juan', 'Perez', 'Calle 123', '123456789', 'juan@example.com', 'Argentina', 'Buenos Aires', '12345678', '20-12345678-2', 'M', '1990-01-01', 1),
('Maria', 'Gomez', 'Av. Principal', '987654321', 'maria@example.com', 'Argentina', 'Cordoba', '87654321', '27-87654321-1', 'F', '1985-05-15', 0),
('Pedro', 'Lopez', 'Calle 456', '456789123', 'pedro@example.com', 'Argentina', 'Santa Fe', '23456789', '30-23456789-4', 'M', '1988-09-20', 1),
('Ana', 'Martinez', 'Av. Central', '654321987', 'ana@example.com', 'Argentina', 'Mendoza', '34567890', '25-34567890-3', 'F', '1992-11-30', 0),
('Diego', 'Rodriguez', 'Calle Norte', '321987654', 'diego@example.com', 'Chile', 'Santiago', '45678901', '27-45678901-6', 'M', '1995-03-25', 1),
('Carla', 'Gonzalez', 'Calle Sur', '987654321', 'carla@example.com', 'Chile', 'Valparaiso', '56789012', '20-56789012-5', 'F', '1987-07-10', 0),
('José', 'Silva', 'Avenida Este', '456123789', 'jose@example.com', 'Chile', 'Concepción', '67890123', '30-67890123-8', 'M', '1984-12-05', 1),
('Laura', 'Hernandez', 'Calle Oeste', '123789456', 'laura@example.com', 'Chile', 'Antofagasta', '78901234', '25-78901234-7', 'F', '1990-02-15', 0),
('Gabriel', 'Ferreira', 'Rua Principal', '987654321', 'gabriel@example.com', 'Brasil', 'Rio de Janeiro', '89012345', '20-89012345-6', 'M', '1989-08-20', 1),
('Luisa', 'Santos', 'Rua Central', '456321789', 'luisa@example.com', 'Brasil', 'Sao Paulo', '90123456', '27-90123456-9', 'F', '1983-06-18', 0),
('Lucas', 'Oliveira', 'Rua Norte', '123987456', 'lucas@example.com', 'Brasil', 'Salvador', '01234567', '30-01234567-1', 'M', '1994-04-12', 1),
('Fernanda', 'Costa', 'Rua Sul', '789456123', 'fernanda@example.com', 'Brasil', 'Brasilia', '12345678', '25-12345678-4', 'F', '1991-10-08', 0),
('Matias', 'Garcia', 'Calle Este', '654321987', 'matias@example.com', 'Uruguay', 'Montevideo', '23456789', '27-23456789-7', 'M', '1986-07-05', 1),
('Julia', 'Lopez', 'Calle Oeste', '321987654', 'julia@example.com', 'Uruguay', 'Punta del Este', '34567890', '20-34567890-0', 'F', '1981-05-22', 0),
('Martin', 'Rodriguez', 'Avenida Sur', '987654321', 'martin@example.com', 'Uruguay', 'Colonia', '45678901', '30-45678901-3', 'M', '1993-12-17', 1),
('Valentina', 'Gomez', 'Avenida Norte', '654321987', 'valentina@example.com', 'Uruguay', 'Maldonado', '56789012', '25-56789012-6', 'F', '1984-09-14', 0),
('Pedro', 'Sanches', 'Avenida Principal', '987654321', 'pedro@example.com', 'Argentina', 'Buenos Aires', '67890123', '20-67890123-1', 'M', '1997-02-28', 1),
('Laura', 'Fernandez', 'Calle 123', '456123789', 'laura@example.com', 'Argentina', 'Cordoba', '78901234', '27-78901234-4', 'F', '1982-08-16', 0),
('Gonzalo', 'Martinez', 'Avenida Principal', '123789456', 'gonzalo@example.com', 'Argentina', 'Santa Fe', '89012345', '30-89012345-7', 'M', '1989-11-03', 1),
('Ana', 'Gonzalez', 'Calle 456', '789456123', 'ana@example.com', 'Argentina', 'Mendoza', '90123456', '25-90123456-0', 'F', '1996-06-19', 0);

INSERT INTO Clientes (Nombre, Apellido, Direccion, Telefono, Mail, Pais, Region, DNI, CUIT, Sexo, FechaNacimiento, CuentaCorriente) VALUES
('Sofia', 'Perez', 'Avenida 567', '012345678', 'sofia@example.com', 'Argentina', 'Buenos Aires', '34567890', '30-34567890-6', 'F', '1988-10-28', 0),
('Jorge', 'Gonzalez', 'Rua 456', '345678901', 'jorge@example.com', 'Brasil', 'Salvador', '45678901', '30-45678901-7', 'M', '1984-03-12', 0),
('Martina', 'Silva', 'Calle 123', '567890123', 'martina@example.com', 'Uruguay', 'Canelones', '56789012', '30-56789012-5', 'F', '1992-06-07', 0),
('Alejandro', 'Diaz', 'Calle 234', '678901234', 'alejandro@example.com', 'Chile', 'Valparaiso', '67890123', '30-67890123-4', 'M', '1987-01-19', 0),
('Lucia', 'Martinez', 'Rua 345', '789012345', 'lucia@example.com', 'Paraguay', 'Ciudad del Este', '78901234', '30-78901234-3', 'F', '1996-08-04', 0),
('Mateo', 'Lopez', 'Avenida 678', '901234567', 'mateo@example.com', 'Argentina', 'Cordoba', '89012345', '30-89012345-2', 'M', '1994-12-20', 0),
('Valentina', 'Rodriguez', 'Avenida 789', '012345678', 'valentina@example.com', 'Brasil', 'Curitiba', '90123456', '30-90123456-1', 'F', '1990-05-15', 0),
('Facundo', 'Fernandez', 'Rua 678', '123456789', 'facundo@example.com', 'Uruguay', 'Montevideo', '12345678', '30-12345678-9', 'M', '1986-09-30', 0),
('Camila', 'Gomez', 'Calle 789', '234567890', 'camila@example.com', 'Chile', 'Santiago', '23456789', '30-23456789-8', 'F', '1993-02-24', 0),
('Nicolas', 'Hernandez', 'Avenida 123', '345678901', 'nicolas@example.com', 'Paraguay', 'Asuncion', '34567890', '30-34567890-7', 'M', '1989-07-11', 9),
('Agustina', 'Suarez', 'Rua 234', '456789012', 'agustina@example.com', 'Argentina', 'Mendoza', '45678901', '30-45678901-6', 'F', '1983-04-26', 9),
('Diego', 'Perez', 'Calle 345', '567890123', 'diego@example.com', 'Brasil', 'Fortaleza', '56789012', '30-56789012-5', 'M', '1991-10-01', 9),
('Bianca', 'Vazquez', 'Rua 456', '678901234', 'bianca@example.com', 'Uruguay', 'Montevideo', '67890123', '30-67890123-4', 'F', '1984-02-16', 0),
('Maximiliano', 'Molina', 'Calle 567', '789012345', 'maximiliano@example.com', 'Chile', 'Valparaiso', '78901234', '30-78901234-3', 'M', '1995-06-21', 1),
('Florencia', 'Rojas', 'Rua 678', '901234567', 'florencia@example.com', 'Paraguay', 'Ciudad del Este', '89012345', '30-89012345-2', 'F', '1988-11-05', 0),
('Lautaro', 'Gimenez', 'Avenida 789', '012345678', 'lautaro@example.com', 'Argentina', 'Buenos Aires', '90123456', '30-90123456-1', 'M', '1992-03-30', 0),
('Catalina', 'Luna', 'Avenida 123', '123456789', 'catalina@example.com', 'Brasil', 'Sao Paulo', '01234567', '30-01234567-0', 'F', '1987-08-14', 0),
('Simon', 'Aguilar', 'Rua 234', '234567890', 'simon@example.com', 'Uruguay', 'Canelones', '12345678', '30-12345678-9', 'M', '1993-01-19', 0),
('Isabella', 'Rivas', 'Calle 345', '345678901', 'isabella@example.com', 'Chile', 'Santiago', '23456789', '30-23456789-8', 'F', '1985-05-04', 0),
('Thiago', 'Mendez', 'Avenida 456', '456789012', 'thiago@example.com', 'Paraguay', 'Asuncion', '34567890', '30-34567890-7', 'M', '1990-09-29', 0);

INSERT INTO Clientes (Nombre, Apellido, Direccion, Telefono, Mail, Pais, Region, DNI, CUIT, Sexo, FechaNacimiento, CuentaCorriente) VALUES
('Valentino', 'Castro', 'Avenida 567', '012345678', 'valentino@example.com', 'Argentina', 'Cordoba', '45678901', '30-45678901-6', 'M', '1991-12-15', 0),
('Mia', 'Ortega', 'Rua 456', '345678901', 'mia@example.com', 'Brasil', 'Rio de Janeiro', '56789012', '30-56789012-5', 'F', '1988-06-20', 0),
('Benjamin', 'Marti', 'Calle 123', '567890123', 'benjamin@example.com', 'Uruguay', 'Montevideo', '67890123', '30-67890123-4', 'M', '1994-02-10', 0),
('Emilia', 'Flores', 'Avenida 234', '678901234', 'emilia@example.com', 'Chile', 'Valparaiso', '78901234', '30-78901234-3', 'F', '1985-09-25', 0),
('Lucas', 'Vidal', 'Calle 345', '789012345', 'lucas@example.com', 'Paraguay', 'Asuncion', '89012345', '30-89012345-2', 'M', '1990-03-18', 0),
('Juliana', 'Gutierrez', 'Rua 456', '901234567', 'juliana@example.com', 'Argentina', 'Buenos Aires', '90123456', '30-90123456-1', 'F', '1993-07-02', 0),
('Mateo', 'Santos', 'Calle 567', '012345678', 'mateo@example.com', 'Brasil', 'Sao Paulo', '01234567', '30-01234567-0', 'M', '1989-11-27', 0),
('Isabella', 'Rocha', 'Avenida 678', '123456789', 'isabella@example.com', 'Uruguay', 'Canelones', '12345678', '30-12345678-9', 'F', '1992-05-13', 0),
('Juan', 'Lopez', 'Rua 789', '234567890', 'juan@example.com', 'Chile', 'Santiago', '23456789', '30-23456789-8', 'M', '1986-12-08', 0),
('Emma', 'Soto', 'Calle 890', '345678901', 'emma@example.com', 'Paraguay', 'Ciudad del Este', '34567890', '30-34567890-7', 'F', '1991-04-03', 0),
('Thiago', 'Torres', 'Avenida 901', '456789012', 'thiago@example.com', 'Argentina', 'Cordoba', '45678901', '30-45678901-6', 'M', '1983-08-18', 0),
('Valentina', 'Pereyra', 'Rua 012', '567890123', 'valentina@example.com', 'Brasil', 'Salvador', '56789012', '30-56789012-5', 'F', '1990-02-02', 0),
('Luciano', 'Amaral', 'Calle 123', '678901234', 'luciano@example.com', 'Uruguay', 'Montevideo', '67890123', '30-67890123-4', 'M', '1987-06-17', 0),
('Sofia', 'Gonzalez', 'Avenida 234', '789012345', 'sofia@example.com', 'Chile', 'Valparaiso', '78901234', '30-78901234-3', 'F', '1994-09-12', 0),
('Nicolas', 'Castillo', 'Rua 345', '890123456', 'nicolas@example.com', 'Paraguay', 'Asuncion', '89012345', '30-89012345-2', 'M', '1988-01-26', 0),
('Amanda', 'Ferreira', 'Calle 456', '901234567', 'amanda@example.com', 'Argentina', 'Buenos Aires', '90123456', '30-90123456-1', 'F', '1993-05-21', 0),
('Alejandro', 'Moreno', 'Rua 567', '012345678', 'alejandro@example.com', 'Brasil', 'Sao Paulo', '01234567', '30-01234567-0', 'M', '1985-10-15', 0),
('Valeria', 'Mendez', 'Calle 678', '123456789', 'valeria@example.com', 'Uruguay', 'Canelones', '12345678', '30-12345678-9', 'F', '1992-03-30', 0),
('Juan', 'Gomez', 'Avenida 789', '234567890', 'juan@example.com', 'Chile', 'Santiago', '23456789', '30-23456789-8', 'M', '1987-08-14', 0),
('Florencia', 'Rojas', 'Rua 890', '345678901', 'florencia@example.com', 'Paraguay', 'Ciudad del Este', '34567890', '30-34567890-7', 'F', '1990-01-19', 0);

INSERT INTO Clientes (Nombre, Apellido, Direccion, Telefono, Mail, Pais, Region, DNI, CUIT, Sexo, FechaNacimiento, CuentaCorriente) VALUES
('Elena', 'Gómez', 'Calle 123', '987654321', 'elena@example.com', 'Brasil', 'Sao Paulo', '09876543', '32-09876543-6', 'F', '1990-08-15', 1),
('Diego', 'Martinez', 'Avenida 456', '123456789', 'diego@example.com', 'Argentina', 'Buenos Aires', '01234567', '30-01234567-4', 'M', '1985-04-25', 0),
('Lucía', 'Fernández', 'Rúa 789', '456123789', 'lucia@example.com', 'Chile', 'Santiago', '78945612', '33-78945612-5', 'F', '1996-11-30', 1),
('Manuel', 'López', 'Carrera 456', '321654987', 'manuel@example.com', 'Uruguay', 'Montevideo', '32198765', '31-32198765-7', 'M', '1998-02-10', 0),
('Carla', 'Sánchez', 'Avenue 789', '654987321', 'carla@example.com', 'Paraguay', 'Asunción', '65432198', '34-65432198-8', 'F', '1994-07-20', 0),
('Gabriel', 'Rodriguez', 'Rua 123', '987654321', 'gabriel@example.com', 'Brasil', 'Rio de Janeiro', '09876543', '32-09876543-6', 'M', '1988-12-03', 0),
('Lorena', 'García', 'Calle 456', '123456789', 'lorena@example.com', 'Argentina', 'Córdoba', '01234567', '30-01234567-4', 'F', '1992-09-05', 0),
('Andrés', 'Fernández', 'Rua 789', '456123789', 'andres@example.com', 'Chile', 'Valparaíso', '78945612', '33-78945612-5', 'M', '1997-04-18', 0),
('María', 'Martinez', 'Avenida 456', '321654987', 'maria@example.com', 'Uruguay', 'Punta del Este', '32198765', '31-32198765-7', 'F', '1995-10-12', 0),
('Pedro', 'Gómez', 'Carrera 789', '654987321', 'pedro@example.com', 'Paraguay', 'Encarnación', '65432198', '34-65432198-8', 'M', '1991-03-28', 0),
('Laura', 'Perez', 'Avenue 123', '987654321', 'laura@example.com', 'Brasil', 'Brasilia', '09876543', '32-09876543-6', 'F', '1987-06-17', 0),
('Martín', 'Rodriguez', 'Rúa 456', '123456789', 'martin@example.com', 'Argentina', 'Rosario', '01234567', '30-01234567-4', 'M', '1984-01-22', 0),
('Sofía', 'Fernández', 'Calle 789', '456123789', 'sofia@example.com', 'Chile', 'Concepción', '78945612', '33-78945612-5', 'F', '1999-08-08', 0),
('Juan', 'López', 'Avenida 456', '321654987', 'juan@example.com', 'Uruguay', 'Colonia', '32198765', '31-32198765-7', 'M', '1989-03-14', 0),
('Carolina', 'Martinez', 'Rua 789', '654987321', 'carolina@example.com', 'Paraguay', 'Ciudad del Este', '65432198', '34-65432198-8', 'F', '1993-12-30', 0),
('David', 'Gómez', 'Calle 123', '987654321', 'david@example.com', 'Brasil', 'Salvador', '09876543', '32-09876543-6', 'M', '1986-11-04', 0),
('Valentina', 'Rodriguez', 'Avenue 456', '123456789', 'valentina@example.com', 'Argentina', 'La Plata', '01234567', '30-01234567-4', 'F', '1991-07-12', 0),
('Javier', 'Fernández', 'Rua 789', '456123789', 'javier@example.com', 'Chile', 'Arica', '78945612', '33-78945612-5', 'M', '1983-05-26', 0),
('Andrea', 'Martinez', 'Carrera 456', '321654987', 'andrea@example.com', 'Uruguay', 'Maldonado', '32198765', '31-32198765-7', 'F', '1980-09-18', 0),
('Nicolás', 'Sánchez', 'Avenue 123', '654987321', 'nicolas@example.com', 'Paraguay', 'Luque', '65432198', '34-65432198-8', 'M', '1998-02-25', 0);

INSERT INTO Clientes (Nombre, Apellido, Direccion, Telefono, Mail, Pais, Region, DNI, CUIT, Sexo, FechaNacimiento, CuentaCorriente) VALUES
('Ana', 'Alvarez', 'Calle 789', '987654321', 'ana@example.com', 'Brasil', 'Sao Paulo', '09876543', '32-09876543-6', 'F', '1993-12-05', 0),
('Diego', 'Martinez', 'Avenida 456', '123456789', 'diego@example.com', 'Argentina', 'Buenos Aires', '01234567', '30-01234567-4', 'M', '1985-04-25', 0),
('Lucía', 'Fernández', 'Rúa 789', '456123789', 'lucia@example.com', 'Chile', 'Santiago', '78945612', '33-78945612-5', 'F', '1996-11-30', 0),
('Manuel', 'López', 'Carrera 456', '321654987', 'manuel@example.com', 'Uruguay', 'Montevideo', '32198765', '31-32198765-7', 'M', '1998-02-10', 0),
('Carla', 'Sánchez', 'Avenue 789', '654987321', 'carla@example.com', 'Paraguay', 'Asunción', '65432198', '34-65432198-8', 'F', '1994-07-20', 0),
('Gabriel', 'Rodriguez', 'Rua 123', '987654321', 'gabriel@example.com', 'Brasil', 'Rio de Janeiro', '09876543', '32-09876543-6', 'M', '1988-12-03', 0),
('Lorena', 'García', 'Calle 456', '123456789', 'lorena@example.com', 'Argentina', 'Córdoba', '01234567', '30-01234567-4', 'F', '1992-09-05', 0),
('Andrés', 'Fernández', 'Rua 789', '456123789', 'andres@example.com', 'Chile', 'Valparaíso', '78945612', '33-78945612-5', 'M', '1997-04-18', 0),
('María', 'Martinez', 'Avenida 456', '321654987', 'maria@example.com', 'Uruguay', 'Punta del Este', '32198765', '31-32198765-7', 'F', '1995-10-12', 0),
('Pedro', 'Gómez', 'Carrera 789', '654987321', 'pedro@example.com', 'Paraguay', 'Encarnación', '65432198', '34-65432198-8', 'M', '1991-03-28', 0),
('Laura', 'Perez', 'Avenue 123', '987654321', 'laura@example.com', 'Brasil', 'Brasilia', '09876543', '32-09876543-6', 'F', '1987-06-17', 0),
('Martín', 'Rodriguez', 'Rúa 456', '123456789', 'martin@example.com', 'Argentina', 'Rosario', '01234567', '30-01234567-4', 'M', '1984-01-22', 0),
('Sofía', 'Fernández', 'Calle 789', '456123789', 'sofia@example.com', 'Chile', 'Concepción', '78945612', '33-78945612-5', 'F', '1999-08-08', 0),
('Juan', 'López', 'Avenida 456', '321654987', 'juan@example.com', 'Uruguay', 'Colonia', '32198765', '31-32198765-7', 'M', '1989-03-14', 0),
('Carolina', 'Martinez', 'Rua 789', '654987321', 'carolina@example.com', 'Paraguay', 'Ciudad del Este', '65432198', '34-65432198-8', 'F', '1993-12-30', 0),
('David', 'Gómez', 'Calle 123', '987654321', 'david@example.com', 'Brasil', 'Salvador', '09876543', '32-09876543-6', 'M', '1986-11-04', 0),
('Valentina', 'Rodriguez', 'Avenue 456', '123456789', 'valentina@example.com', 'Argentina', 'La Plata', '01234567', '30-01234567-4', 'F', '1991-07-12', 0),
('Javier', 'Fernández', 'Rua 789', '456123789', 'javier@example.com', 'Chile', 'Arica', '78945612', '33-78945612-5', 'M', '1983-05-26', 0),
('Andrea', 'Martinez', 'Carrera 456', '321654987', 'andrea@example.com', 'Uruguay', 'Maldonado', '32198765', '31-32198765-7', 'F', '1980-09-18', 0),
('Nicolás', 'Sánchez', 'Avenue 123', '654987321', 'nicolas@example.com', 'Paraguay', 'Luque', '65432198', '34-65432198-8', 'M', '1998-02-25', 0),
('Lucas', 'Fernández', 'Calle 789', '987654321', 'lucas@example.com', 'Brasil', 'Porto Alegre', '09876543', '32-09876543-6', 'M', '1995-10-15', 0),
('Camila', 'López', 'Avenida 456', '123456789', 'camila@example.com', 'Argentina', 'Mar del Plata', '01234567', '30-01234567-4', 'F', '1987-04-03', 0),
('Marcos', 'Rodríguez', 'Rua 789', '456123789', 'marcos@example.com', 'Chile', 'Antofagasta', '78945612', '33-78945612-5', 'M', '1984-08-19', 0),
('Laura', 'Martinez', 'Aenue 456', '321654987', 'laura@example.com', 'Uruguay', 'Piriápolis', '32198765', '31-32198765-7', 'F', '1989-12-25', 0),
('Luciano', 'Gómez', 'Carrera 789', '654987321', 'luciano@example.com', 'Paraguay', 'San Lorenzo', '65432198', '34-65432198-8', 'M', '1992-07-07', 0),
('Sofía', 'Rodríguez', 'Avenue 123', '987654321', 'sofia@example.com', 'Brasil', 'Curitiba', '09876543', '32-09876543-6', 'F', '1997-02-14', 0),
('Matías', 'Martinez', 'Rúa 456', '123456789', 'matias@example.com', 'Argentina', 'Tucumán', '01234567', '30-01234567-4', 'M', '1994-06-21', 0),
('Valentina', 'Fernández', 'Calle 789', '456123789', 'valentina@example.com', 'Chile', 'Valdivia', '78945612', '33-78945612-5', 'F', '1991-11-28', 0),
('Diego', 'López', 'Avenida 456', '321654987', 'diego@example.com', 'Uruguay', 'Canelones', '32198765', '31-32198765-7', 'M', '1998-05-08', 0),
('Agustina', 'Sánchez', 'Rua 789', '654987321', 'agustina@example.com', 'Paraguay', 'Itauguá', '65432198', '34-65432198-8', 'F', '1983-09-11', 0);

SELECT * FROM Clientes;

-- Datos para tabla proveedores 

INSERT INTO Proveedores (ID, Nombre, Mail, Telefono, Pais, Provincia, CUIT, PaginaWeb)
VALUES   
(1, 'HondaARG', 'Honda1@example.com', '123456789', 'Argentina', 'Buenos Aires', '30-12345678-0', 'www.hondaproveedor1.com'),
(2, 'ToyotaCL', 'Toyota2@example.com',  '234567890', 'Chile', 'Santiago', '30-23456789-1', 'www.Toyotaproveedor2.com'),
(3, 'AsianPartsBR', 'AsianParts3@example.com', '345678901', 'Brasil', 'Sao Paulo', '30-34567890-2', 'www.AsianParts3.com'),
(4, 'DistriSurUY', 'DistriSurUY4@example.com', '456789012', 'Uruguay', 'Montevideo', '30-45678901-3', 'www.DistriSurUY4.com');

Select * from Proveedores;

-- Datos para Familias de autopartes

INSERT INTO FamiliasAutopartes (NombreFamilia, Descripcion, FamiliaPadreID)
VALUES 
('Lubricantes', 'Piezas relacionadas con lubricantes y aceites', NULL), -- Familia principal
('Aceites', 'Distintos tipos de aceites para motores', 1), -- Subfamilia de Lubricantes
('Filtros de aceite', 'Filtros para la limpieza del aceite del motor', 1), -- Subfamilia de Lubricantes
('Carrocería', 'Piezas relacionadas con la carrocería del vehículo', NULL), -- Familia principal
('Parachoques', 'Piezas que protegen la parte delantera y trasera del vehículo', 4), -- Subfamilia de Carrocería
('Paneles', 'Paneles que conforman los laterales del vehículo', 4), -- Subfamilia de Carrocería
('Electrónicos', 'Piezas relacionadas con sistemas electrónicos', NULL), -- Familia principal
('Sistemas de audio', 'Componentes de audio para el vehículo', 7), -- Subfamilia de Electrónicos
('Navegación GPS', 'Sistemas de navegación GPS para el vehículo', 7), -- Subfamilia de Electrónicos
('Sensores', 'Sensores del vehículo', 7), -- Subfamilia de Electrónicos
('Suspensión', 'Piezas relacionadas con la suspensión del vehículo', NULL), -- Familia principal
('Amortiguadores', 'Componentes que absorben impactos en la suspensión', 10), -- Subfamilia de Suspensión
('Dirección', 'Piezas relacionadas con el sistema de dirección del vehículo', NULL),-- Familia principal
('Filtros', 'Piezas relacionadas con distintos tipos de filtros', NULL),-- Familia principal
('Motor', 'Piezas relacionadas con el motor del vehículo', NULL),-- Familia principal
('Cristales', 'Piezas de vidrio para vehículos', 2); -- Subfamilia de Carrocería


Select * from FamiliasAutopartes;

--DATOS FICTICIOS PARA EL STOCK TOYOTA

-- Lubricantes
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(1, 'T1LUB001', 'Aceite de motor sintético 5W-30', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 1, 50, 25.99),
(1, 'T1LUB002', 'Filtro de aceite de motor', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 1, 30, 12.50),
(1, 'T1LUB003', 'Aceite de transmisión automática ATF-WS', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 1, 20, 35.75),
(1, 'T1LUB004', 'Filtro de aire de motor', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 1, 40, 8.99),
(1, 'T1LUB005', 'Aceite de dirección asistida', 'Toyota', 'Corolla', 2021, 'Toyota Motor Corporation', 1, 15, 20.25),
(1, 'T1LUB006', 'Aceite de diferencial trasero', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 1, 10, 30.50),
(1, 'T1LUB007', 'Filtro de combustible', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 1, 25, 15.75),
(1, 'T1LUB008', 'Aceite para sistema de frenos', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 1, 12, 18.99),
(1, 'T1LUB009', 'Aceite para sistema de enfriamiento', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 1, 18, 22.50),
(1, 'T1LUB010', 'Lubricante para rodamientos', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 1, 8, 10.99);

-- Carrocería
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(4, 'T1CAR001', 'Parachoques delantero', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 2, 5, 120.99),
(4, 'T1CAR002', 'Parachoques trasero', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 2, 7, 135.50),
(4, 'T1CAR003', 'Panel lateral izquierdo', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 2, 4, 85.75),
(4, 'T1CAR004', 'Panel lateral derecho', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 2, 6, 90.99),
(4, 'T1CAR005', 'Cofre delantero', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 2, 3, 180.25),
(4, 'T1CAR006', 'Portón trasero', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 2, 2, 220.50),
(4, 'T1CAR007', 'Espejo lateral izquierdo', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 2, 5, 95.75),
(4, 'T1CAR008', 'Espejo lateral derecho', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 2, 4, 90.99),
(4, 'T1CAR009', 'Defensa delantera', 'Toyota', 'Corolla', 2021, 'Toyota Motor Corporation', 2, 8, 110.99),
(4, 'T1CAR010', 'Defensa trasera', 'Toyota', 'RAV4', 2022, 'Toyota Motor Corporation', 2, 6, 125.50);

-- Electrónicos
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(7, 'T1ELE001', 'Sistema de audio premium', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 3, 3, 450.99),
(7, 'T1ELE002', 'Sistema de navegación GPS', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 3, 5, 550.50),
(7, 'T1ELE003', 'Sensor de estacionamiento', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 3, 4, 75.75),
(7, 'T1ELE004', 'Cámara de retroceso', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 3, 6, 100.99),
(7, 'T1ELE005', 'Sistema de seguridad avanzado', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 3, 7, 320.50),
(7, 'T1ELE006', 'Sistema de entretenimiento para asientos traseros', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 3, 2, 400.75),
(7, 'T1ELE007', 'Computadora de a bordo', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 3, 5, 150.99),
(7, 'T1ELE008', 'Luces LED para faros', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 3, 6, 90.50),
(7, 'T1ELE009', 'Sistema de arranque remoto', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 3, 4, 200.75),
(7, 'T1ELE010', 'Sistema de monitoreo de presión de neumáticos', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 3, 8, 80.99);

-- Suspensión
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(11, 'T1SUS001', 'Amortiguador delantero', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 4, 8, 150.99),
(11, 'T1SUS002', 'Amortiguador trasero', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 4, 6, 140.50),
(11, 'T1SUS003', 'Resorte helicoidal', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 4, 10, 75.75),
(11, 'T1SUS004', 'Barra estabilizadora', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 4, 5, 90.99),
(11, 'T1SUS005', 'Brazo de suspensión delantero', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 4, 7, 120.25),
(11, 'T1SUS006', 'Brazo de suspensión trasero', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 4, 6, 110.50),
(11, 'T1SUS007', 'Buje de suspensión', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 4, 12, 40.75),
(11, 'T1SUS008', 'Varilla de dirección', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 4, 9, 55.99),
(11, 'T1SUS009', 'Kit de elevación de suspensión', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 4, 3, 320.50),
(11, 'T1SUS010', 'Barra de torsión', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 4, 4, 80.99);

-- Dirección
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(13, 'T1DIR001', 'Bomba de dirección asistida', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 3, 6, 250.99),
(13, 'T1DIR002', 'Caja de dirección', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 3, 4, 300.50),
(13, 'T1DIR003', 'Manguera de dirección', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 3, 8, 85.75),
(13, 'T1DIR004', 'Columna de dirección', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 3, 5, 200.99),
(13, 'T1DIR005', 'Piñón de dirección', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 3, 7, 150.50),
(13, 'T1DIR006', 'Cremallera de dirección', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 3, 3, 180.25),
(13, 'T1DIR007', 'Amortiguador de dirección', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 3, 2, 95.99),
(13, 'T1DIR008', 'Buje de dirección', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 3, 4, 40.50),
(13, 'T1DIR009', 'Juego de rótulas de dirección', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 3, 6, 120.75),
(13, 'T1DIR010', 'Eje de dirección', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 3, 5, 160.99);

-- Filtros
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(14, 'T1FIL001', 'Filtro de aire de cabina', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 4, 10, 30.99),
(14, 'T1FIL002', 'Filtro de combustible', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 4, 8, 20.50),
(14, 'T1FIL003', 'Filtro de aire de motor', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 4, 12, 15.75),
(14, 'T1FIL004', 'Filtro de aceite', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 4, 6, 10.99),
(14, 'T1FIL005', 'Filtro de aire de admisión', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 4, 10, 25.50),
(14, 'T1FIL006', 'Filtro de transmisión', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 4, 4, 35.25),
(14, 'T1FIL007', 'Filtro de partículas', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 4, 8, 40.99),
(14, 'T1FIL008', 'Filtro de aire del turbo', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 4, 6, 55.50),
(14, 'T1FIL009', 'Filtro de aceite del turbo', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 4, 7, 50.75),
(14, 'T1FIL010', 'Filtro de aire de alto flujo', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 4, 9, 70.99);

-- Motor
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(15, 'T1MOT001', 'Bomba de agua', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 2, 5, 120.99),
(15, 'T1MOT002', 'Árbol de levas', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 2, 3, 350.50),
(15, 'T1MOT003', 'Junta de culata', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 2, 4, 75.75),
(15, 'T1MOT004', 'Pistón', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 2, 6, 90.99),
(15, 'T1MOT005', 'Juego de juntas', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 2, 8, 110.50),
(15, 'T1MOT006', 'Cigüeñal', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 2, 4, 280.25),
(15, 'T1MOT007', 'Cojinete de biela', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 2, 5, 65.99),
(15, 'T1MOT008', 'Tensor de la correa de distribución', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 2, 3, 80.50),
(15, 'T1MOT009', 'Bujía', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 2, 10, 7.75),
(15, 'T1MOT010', 'Termostato', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 2, 6, 30.99);

-- Cristales
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(16, 'T1CRI001', 'Parabrisas delantero', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 1, 5, 300.99),
(16, 'T1CRI002', 'Luna trasera', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 1, 3, 250.50),
(16, 'T1CRI003', 'Cristal de puerta delantera', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 1, 4, 150.75),
(16, 'T1CRI004', 'Cristal de puerta trasera', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 1, 6, 200.99),
(16, 'T1CRI005', 'Cristal lateral izquierdo', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 1, 8, 180.50),
(16, 'T1CRI006', 'Cristal lateral derecho', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 1, 4, 160.25),
(16, 'T1CRI007', 'Cristal de techo solar', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 1, 5, 400.99),
(16, 'T1CRI008', 'Luna de espejo retrovisor', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 1, 3, 120.50),
(16, 'T1CRI009', 'Luna de ventanilla lateral', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 1, 10, 100.75),
(16, 'T1CRI010', 'Luna de espejo lateral', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 1, 6, 150.99);

-- Suspensión
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(11, 'T2SUS001', 'Amortiguador delantero', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 4, 5, 150.99),
(11, 'T2SUS002', 'Muelle de suspensión', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 4, 3, 80.50),
(11, 'T2SUS003', 'Brazo de suspensión', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 4, 4, 120.75),
(11, 'T2SUS004', 'Barra estabilizadora', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 4, 6, 100.99),
(11, 'T2SUS005', 'Cojinete de rueda', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 4, 8, 45.50),
(11, 'T2SUS006', 'Bieleta de suspensión', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 4, 4, 30.25),
(11, 'T2SUS007', 'Silentblock', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 4, 5, 20.99),
(11, 'T2SUS008', 'Horquilla de suspensión', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 4, 3, 60.50),
(11, 'T2SUS009', 'Amortiguador trasero', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 4, 10, 120.75),
(11, 'T2SUS010', 'Soporte de amortiguador', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 4, 6, 35.99);

-- Dirección
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(13, 'T2DIR001', 'Brazo de dirección', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 3, 5, 80.99),
(13, 'T2DIR002', 'Cremallera de dirección', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 3, 3, 280.50),
(13, 'T2DIR003', 'Mangueta de dirección', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 3, 4, 150.75),
(13, 'T2DIR004', 'Amortiguador de dirección', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 3, 6, 100.99),
(13, 'T2DIR005', 'Bieleta de dirección', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 3, 8, 55.50),
(13, 'T2DIR006', 'Barra de dirección', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 3, 4, 130.25),
(13, 'T2DIR007', 'Punta de dirección', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 3, 5, 40.99),
(13, 'T2DIR008', 'Columna de dirección', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 3, 3, 180.50),
(13, 'T2DIR009', 'Rótula de dirección', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 3, 10, 90.75),
(13, 'T2DIR010', 'Caja de dirección', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 3, 6, 350.99);

-- Dirección
INSERT INTO Stock_Toyota (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(13, 'T2DIR011', 'Bomba de dirección eléctrica', 'Toyota', 'Corolla', 2023, 'Toyota Motor Corporation', 4, 3, 280.99),
(13, 'T2DIR012', 'Barra de dirección', 'Toyota', 'RAV4', 2022, 'Toyota Motor Corporation', 4, 4, 150.50),
(13, 'T2DIR013', 'Piñón y cremallera de dirección', 'Toyota', 'Camry', 2021, 'Toyota Motor Corporation', 4, 5, 200.75),
(13, 'T2DIR014', 'Mangueta de dirección', 'Toyota', 'Highlander', 2022, 'Toyota Motor Corporation', 4, 6, 180.99),
(13, 'T2DIR015', 'Rótula de dirección', 'Toyota', 'Sienna', 2023, 'Toyota Motor Corporation', 4, 2, 90.50),
(13, 'T2DIR016', 'Amortiguador de dirección asistida', 'Toyota', 'Tacoma', 2020, 'Toyota Motor Corporation', 4, 3, 110.25),
(13, 'T2DIR017', 'Eje de dirección hidráulica', 'Toyota', 'Avalon', 2020, 'Toyota Motor Corporation', 4, 4, 220.99),
(13, 'T2DIR018', 'Buje de dirección asistida', 'Toyota', 'Prius', 2021, 'Toyota Motor Corporation', 4, 5, 60.50),
(13, 'T2DIR019', 'Varilla de dirección', 'Toyota', 'Corolla', 2022, 'Toyota Motor Corporation', 4, 6, 130.75),
(13, 'T2DIR020', 'Brazo de dirección', 'Toyota', 'RAV4', 2023, 'Toyota Motor Corporation', 4, 3, 175.99);


select * from Stock_Toyota;

-- Dirección
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(13, 'H1DIR001', 'Bomba de dirección asistida', 'Honda', 'Accord', 2021, 'Honda Motor Co., Ltd.', 1, 6, 260.99),
(13, 'H1DIR002', 'Caja de dirección', 'Honda', 'Civic', 2022, 'Honda Motor Co., Ltd.', 1, 4, 310.50),
(13, 'H1DIR003', 'Manguera de dirección', 'Honda', 'CR-V', 2023, 'Honda Motor Co., Ltd.', 1, 8, 90.75),
(13, 'H1DIR004', 'Columna de dirección', 'Honda', 'Pilot', 2023, 'Honda Motor Co., Ltd.', 1, 5, 220.99),
(13, 'H1DIR005', 'Piñón de dirección', 'Honda', 'HR-V', 2022, 'Honda Motor Co., Ltd.', 1, 7, 160.50),
(13, 'H1DIR006', 'Cremallera de dirección', 'Honda', 'Odyssey', 2020, 'Honda Motor Co., Ltd.', 1, 3, 190.25),
(13, 'H1DIR007', 'Amortiguador de dirección', 'Honda', 'Fit', 2020, 'Honda Motor Co., Ltd.', 1, 2, 105.99),
(13, 'H1DIR008', 'Buje de dirección', 'Honda', 'Insight', 2021, 'Honda Motor Co., Ltd.', 1, 4, 45.50),
(13, 'H1DIR009', 'Juego de rótulas de dirección', 'Honda', 'CR-Z', 2022, 'Honda Motor Co., Ltd.', 1, 6, 125.75),
(13, 'H1DIR010', 'Eje de dirección', 'Honda', 'Ridgeline', 2023, 'Honda Motor Co., Ltd.', 1, 5, 170.99);

--Carroceria
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(5, 'H1CAR001', 'Parachoques delantero', 'Honda', 'Accord', 2021, 'Honda Motor Co., Ltd.', 1, 6, 180.99),
(5, 'H1CAR002', 'Parachoques trasero', 'Honda', 'Civic', 2022, 'Honda Motor Co., Ltd.', 1, 4, 220.50),
(5, 'H1CAR003', 'Panel lateral izquierdo', 'Honda', 'CR-V', 2023, 'Honda Motor Co., Ltd.', 1, 8, 100.75),
(5, 'H1CAR004', 'Panel lateral derecho', 'Honda', 'Pilot', 2023, 'Honda Motor Co., Ltd.', 1, 5, 240.99),
(5, 'H1CAR005', 'Faro delantero', 'Honda', 'HR-V', 2022, 'Honda Motor Co., Ltd.', 1, 7, 140.50),
(5, 'H1CAR006', 'Faro trasero', 'Honda', 'Odyssey', 2020, 'Honda Motor Co., Ltd.', 1, 3, 170.25),
(5, 'H1CAR007', 'Espejo retrovisor', 'Honda', 'Fit', 2020, 'Honda Motor Co., Ltd.', 1, 2, 85.99),
(5, 'H1CAR008', 'Manija de puerta', 'Honda', 'Insight', 2021, 'Honda Motor Co., Ltd.', 1, 4, 35.50),
(5, 'H1CAR009', 'Alerón trasero', 'Honda', 'CR-Z', 2022, 'Honda Motor Co., Ltd.', 1, 6, 95.75),
(5, 'H1CAR010', 'Deflector de viento', 'Honda', 'Ridgeline', 2023, 'Honda Motor Co., Ltd.', 1, 5, 120.99);

--Filtros
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(6, 'H1FIL001', 'Filtro de aire', 'Honda', 'Accord', 2021, 'Honda Motor Co., Ltd.', 4,6, 25.99),
(6, 'H1FIL002', 'Filtro de aceite', 'Honda', 'Civic', 2022, 'Honda Motor Co., Ltd.', 4, 4, 30.50),
(6, 'H1FIL003', 'Filtro de combustible', 'Honda', 'CR-V', 2023, 'Honda Motor Co., Ltd.', 4, 8, 15.75),
(6, 'H1FIL004', 'Filtro de habitáculo', 'Honda', 'Pilot', 2023, 'Honda Motor Co., Ltd.', 4, 5, 20.99),
(6, 'H1FIL005', 'Filtro de transmisión', 'Honda', 'HR-V', 2022, 'Honda Motor Co., Ltd.', 4, 7, 35.50),
(7, 'H1ELE001', 'Radio / Reproductor de CD', 'Honda', 'Odyssey', 2020, 'Honda Motor Co., Ltd.', 4, 3, 180.25),
(7, 'H1ELE002', 'Sistema de navegación GPS', 'Honda', 'Fit', 2020, 'Honda Motor Co., Ltd.', 4, 2, 295.99),
(7, 'H1ELE003', 'Unidad de control del motor', 'Honda', 'Insight', 2021, 'Honda Motor Co., Ltd.', 4, 4, 550.50),
(7, 'H1ELE004', 'Sensor de oxígeno', 'Honda', 'CR-Z', 2022, 'Honda Motor Co., Ltd.', 4, 6, 95.75),
(7, 'H1ELE005', 'Módulo de encendido', 'Honda', 'Ridgeline', 2023, 'Honda Motor Co., Ltd.', 4, 5, 120.99);

--Suspencion
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(8, 'H1SUS001', 'Amortiguador', 'Honda', 'Accord', 2021, 'Honda Motor Co., Ltd.', 3, 6, 150.99),
(8, 'H1SUS002', 'Muelle de suspensión', 'Honda', 'Civic', 2022, 'Honda Motor Co., Ltd.', 3, 4, 120.50),
(8, 'H1SUS003', 'Brazo de control', 'Honda', 'CR-V', 2023, 'Honda Motor Co., Ltd.', 3, 8, 85.75),
(9, 'H2DIR001', 'Bomba de dirección asistida', 'Honda', 'Pilot', 2023, 'Honda Motor Co., Ltd.', 3, 5, 200.99),
(9, 'H2DIR002', 'Caja de dirección', 'Honda', 'HR-V', 2022, 'Honda Motor Co., Ltd.', 3, 7, 150.50),
(9, 'H2DIR003', 'Manguera de dirección', 'Honda', 'Odyssey', 2020, 'Honda Motor Co., Ltd.', 3, 3, 180.25),
(10, 'H1FIL006', 'Filtro de aire acondicionado', 'Honda', 'Insight', 2021, 'Honda Motor Co., Ltd.', 3, 4, 40.50),
(10, 'H1FIL007', 'Filtro de gasolina', 'Honda', 'Ridgeline', 2023, 'Honda Motor Co., Ltd.', 3, 6, 55.75),
(10, 'H1FIL008', 'Filtro de transmisión automática', 'Honda', 'Fit', 2020, 'Honda Motor Co., Ltd.', 3, 5, 60.99),
(11, 'H1MOT001', 'Cárter de aceite', 'Honda', 'Accord', 2021, 'Honda Motor Co., Ltd.', 3, 8, 75.50);

--Varios
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(12, 'H1SUS004', 'Barra estabilizadora', 'Honda', 'Civic', 2022, 'Honda Motor Co., Ltd.', 1, 6, 90.99),
(12, 'H1SUS005', 'Resorte de suspensión', 'Honda', 'CR-V', 2023, 'Honda Motor Co., Ltd.', 1, 4, 110.50),
(12, 'H1SUS006', 'Horquilla de suspensión', 'Honda', 'Pilot', 2023, 'Honda Motor Co., Ltd.', 1, 8, 75.75),
(13, 'H2DIR004', 'Columna de dirección', 'Honda', 'Accord', 2021, 'Honda Motor Co., Ltd.', 1, 5, 190.99),
(13, 'H2DIR005', 'Piñón de dirección', 'Honda', 'Civic', 2022, 'Honda Motor Co., Ltd.', 1, 7, 130.50),
(13, 'H2DIR006', 'Cremallera de dirección', 'Honda', 'CR-V', 2023, 'Honda Motor Co., Ltd.', 1, 3, 170.25),
(14, 'H1FIL009', 'Filtro de aceite', 'Honda', 'Pilot', 2023, 'Honda Motor Co., Ltd.', 1, 4, 30.50),
(14, 'H1FIL010', 'Filtro de aire', 'Honda', 'Accord', 2021, 'Honda Motor Co., Ltd.', 1, 6, 45.75),
(14, 'H1FIL011', 'Filtro de combustible', 'Honda', 'Civic', 2022, 'Honda Motor Co., Ltd.', 1, 5, 50.99),
(15, 'H1MOT002', 'Bujía de encendido', 'Honda', 'CR-V', 2023, 'Honda Motor Co., Ltd.', 1, 8, 8.50);

--Cristales
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(16, 'H1CRI011', 'Parabrisas delantero', 'Honda', 'Civic', 2022, 'Honda Glass Co., Ltd.', 4, 10, 270.99),
(16, 'H1CRI012', 'Ventana lateral derecha', 'Honda', 'Accord', 2023, 'Honda Glass Co., Ltd.', 4, 8, 190.50),
(16, 'H1CRI013', 'Ventana lateral izquierda', 'Honda', 'CR-V', 2021, 'Honda Glass Co., Ltd.', 4, 7, 180.75),
(16, 'H1CRI014', 'Luna trasera', 'Honda', 'Pilot', 2022, 'Honda Glass Co., Ltd.', 4, 9, 320.99),
(16, 'H1CRI015', 'Espejo retrovisor', 'Honda', 'HR-V', 2023, 'Honda Glass Co., Ltd.', 4, 6, 110.50),
(16, 'H1CRI016', 'Cristal de faro delantero', 'Honda', 'Odyssey', 2020, 'Honda Glass Co., Ltd.', 4, 5, 90.25),
(16, 'H1CRI017', 'Cristal de faro trasero', 'Honda', 'Civic', 2020, 'Honda Glass Co., Ltd.', 4, 4, 80.99),
(16, 'H1CRI018', 'Cristal de espejo lateral', 'Honda', 'Accord', 2021, 'Honda Glass Co., Ltd.', 4, 7, 60.50),
(16, 'H1CRI019', 'Luna de techo', 'Honda', 'CR-V', 2023, 'Honda Glass Co., Ltd.', 4, 6, 230.75),
(16, 'H1CRI020', 'Cristal de faro antiniebla', 'Honda', 'Pilot', 2022, 'Honda Glass Co., Ltd.', 4, 8, 140.99);

--GPS
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(9, 'H1GPS011', 'Sistema de navegación GPS 7 pulgadas', 'Honda', 'Civic', 2022, 'Honda Electronics Co., Ltd.', 1, 10, 520.99),
(9, 'H1GPS012', 'Sistema de navegación GPS 9 pulgadas', 'Honda', 'Accord', 2023, 'Honda Electronics Co., Ltd.', 1, 8, 620.50),
(9, 'H1GPS013', 'Sistema de navegación GPS 10 pulgadas', 'Honda', 'CR-V', 2021, 'Honda Electronics Co., Ltd.', 1, 7, 720.75),
(9, 'H1GPS014', 'Sistema de navegación GPS 8 pulgadas', 'Honda', 'Pilot', 2022, 'Honda Electronics Co., Ltd.', 1, 9, 570.99),
(9, 'H1GPS015', 'Sistema de navegación GPS 6.5 pulgadas', 'Honda', 'HR-V', 2023, 'Honda Electronics Co., Ltd.', 1, 6, 470.50),
(9, 'H1GPS016', 'Sistema de navegación GPS 12 pulgadas', 'Honda', 'Odyssey', 2020, 'Honda Electronics Co., Ltd.', 1, 5, 840.25),
(9, 'H1GPS017', 'Sistema de navegación GPS 8.5 pulgadas', 'Honda', 'Civic', 2020, 'Honda Electronics Co., Ltd.', 1, 4, 720.99),
(9, 'H1GPS018', 'Sistema de navegación GPS 11 pulgadas', 'Honda', 'Accord', 2021, 'Honda Electronics Co., Ltd.', 1, 7, 780.50),
(9, 'H1GPS019', 'Sistema de navegación GPS 9.5 pulgadas', 'Honda', 'CR-V', 2023, 'Honda Electronics Co., Ltd.', 1, 6, 690.75),
(9, 'H1GPS020', 'Sistema de navegación GPS 7.5 pulgadas', 'Honda', 'Pilot', 2022, 'Honda Electronics Co., Ltd.', 1, 8, 560.99);

--Carroceria
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(4, 'H1CAR011', 'Defensa delantera', 'Honda', 'Civic', 2022, 'Honda Body Co., Ltd.', 1, 10, 430.99),
(4, 'H1CAR012', 'Puerta delantera izquierda', 'Honda', 'Accord', 2023, 'Honda Body Co., Ltd.', 1, 8, 320.50),
(4, 'H1CAR013', 'Puerta delantera derecha', 'Honda', 'CR-V', 2021, 'Honda Body Co., Ltd.', 1, 7, 310.75),
(4, 'H1CAR014', 'Maletero', 'Honda', 'Pilot', 2022, 'Honda Body Co., Ltd.', 1, 9, 450.99),
(4, 'H1CAR015', 'Parachoques trasero', 'Honda', 'HR-V', 2023, 'Honda Body Co., Ltd.', 1, 6, 230.50),
(4, 'H1CAR016', 'Capó', 'Honda', 'Odyssey', 2020, 'Honda Body Co., Ltd.', 1, 5, 360.25),
(4, 'H1CAR017', 'Techo solar', 'Honda', 'Civic', 2020, 'Honda Body Co., Ltd.', 1, 4, 290.99),
(4, 'H1CAR018', 'Parachoques delantero', 'Honda', 'Accord', 2021, 'Honda Body Co., Ltd.', 1, 7, 420.50),
(4, 'H1CAR019', 'Faldones laterales', 'Honda', 'CR-V', 2023, 'Honda Body Co., Ltd.', 1, 6, 380.75),
(4, 'H1CAR020', 'Puerta trasera', 'Honda', 'Pilot', 2022, 'Honda Body Co., Ltd.', 1, 8, 330.99);

--Motor
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(15, 'H1MOT011', 'Bujía de encendido', 'Honda', 'Civic', 2022, 'Honda Engine Co., Ltd.', 4, 10, 15.99),
(15, 'H1MOT012', 'Filtro de aire', 'Honda', 'Accord', 2023, 'Honda Engine Co., Ltd.', 4, 8, 20.50),
(15, 'H1MOT013', 'Correa de distribución', 'Honda', 'CR-V', 2021, 'Honda Engine Co., Ltd.', 4, 7, 35.75),
(15, 'H1MOT014', 'Bomba de agua', 'Honda', 'Pilot', 2022, 'Honda Engine Co., Ltd.', 4, 9, 50.99),
(15, 'H1MOT015', 'Radiador', 'Honda', 'HR-V', 2023, 'Honda Engine Co., Ltd.', 4, 6, 120.50),
(15, 'H1MOT016', 'Motor de arranque', 'Honda', 'Odyssey', 2020, 'Honda Engine Co., Ltd.', 4, 5, 180.25),
(15, 'H1MOT017', 'Alternador', 'Honda', 'Civic', 2020, 'Honda Engine Co., Ltd.', 4, 4, 220.99),
(15, 'H1MOT018', 'Junta de culata', 'Honda', 'Accord', 2021, 'Honda Engine Co., Ltd.', 4, 7, 80.50),
(15, 'H1MOT019', 'Inyector de combustible', 'Honda', 'CR-V', 2023, 'Honda Engine Co., Ltd.', 4, 6, 70.75),
(15, 'H1MOT020', 'Termostato', 'Honda', 'Pilot', 2022, 'Honda Engine Co., Ltd.', 4, 8, 25.99);

--Cristales
INSERT INTO Stock_Honda (FamiliaID, NumeroParte, NombreAutoparte, Marca, ModeloAuto, Año, Fabricante, ProveedorID, Cantidad, Precio)
VALUES 
(16, 'H1CRI021', 'Luna lateral trasera', 'Honda', 'Civic', 2022, 'Honda Glass Co., Ltd.', 4, 10, 300.99),
(16, 'H1CRI022', 'Luna lateral delantera', 'Honda', 'Accord', 2023, 'Honda Glass Co., Ltd.', 4, 8, 220.50),
(16, 'H1CRI023', 'Espejo retrovisor lateral', 'Honda', 'CR-V', 2021, 'Honda Glass Co., Ltd.', 3, 7, 180.75),
(16, 'H1CRI024', 'Cristal de faro trasero', 'Honda', 'Pilot', 2022, 'Honda Glass Co., Ltd.', 3, 9, 320.99),
(16, 'H1CRI025', 'Cristal de espejo retrovisor', 'Honda', 'HR-V', 2023, 'Honda Glass Co., Ltd.', 3, 6, 120.50),
(16, 'H1CRI026', 'Cristal de faro delantero', 'Honda', 'Odyssey', 2020, 'Honda Glass Co., Ltd.', 3, 5, 90.25),
(16, 'H1CRI027', 'Luna panorámica', 'Honda', 'Civic', 2020, 'Honda Glass Co., Ltd.', 3, 4, 270.99),
(16, 'H1CRI028', 'Cristal de retrovisor exterior', 'Honda', 'Accord', 2021, 'Honda Glass Co., Ltd.', 3, 7, 160.50),
(16, 'H1CRI029', 'Cristal de faro antiniebla', 'Honda', 'CR-V', 2023, 'Honda Glass Co., Ltd.', 3, 6, 140.75),
(16, 'H1CRI030', 'Cristal de puerta trasera', 'Honda', 'Pilot', 2022, 'Honda Glass Co., Ltd.', 3, 8, 280.99);

select * from Stock_Honda;


INSERT INTO Sucursales (ID, NombreSucursal, Direccion, Telefono, Mail, Encargado, Pais, Provincia)
VALUES 
-- Argentina
(1, 'Sucursal Honda Argentina', 'Av. Argentina 123', '011-1234567', 'hondaarg@example.com', 'Juan Pérez', 'Argentina', 'Buenos Aires'),
(2, 'Sucursal Toyota Argentina', 'Av. Brasil 456', '011-9876543', 'toyotaarg@example.com', 'María García', 'Argentina', 'Córdoba'),
-- Brasil
(3, 'Sucursal Honda Brasil', 'Rua Brasil 123', '(11) 1234-5678', 'hondabrasil@example.com', 'Carlos Silva', 'Brasil', 'Sao Paulo'),
(4, 'Sucursal Toyota Brasil', 'Rua Uruguay 456', '(11) 8765-4321', 'toyotabrasil@example.com', 'Ana Santos', 'Brasil', 'Rio de Janeiro'),
-- Uruguay
(5, 'Sucursal Honda Uruguay', 'Av. Uruguay 123', '2901-2345', 'hondauruguay@example.com', 'Diego Fernández', 'Uruguay', 'Montevideo'),
(6, 'Sucursal Toyota Uruguay', 'Av. Chile 456', '2901-5432', 'toyotauruguay@example.com', 'Laura Martínez', 'Uruguay', 'Canelones'),
-- Chile
(7, 'Sucursal Honda Chile', 'Calle Chile 123', '(2) 1234-5678', 'hondachile@example.com', 'Roberto González', 'Chile', 'Santiago'),
(8, 'Sucursal Toyota Chile', 'Calle Argentina 456', '(2) 9876-5432', 'toyotachile@example.com', 'Andrea López', 'Chile', 'Valparaíso');



--EMJEMPLOS PRACTICOS DE DIFERENTES CONSULTAS, MODIFICACIONES Y MANEJO DE DATOS--


--1)Agregar registros a compras, para corroborar que funciona el trigger ActualizarStock_Compras --


INSERT INTO Compras (FechaCompra, ProveedorID, NumeroParteH, Cantidad, PrecioUnitario, TotalCompras, SucursalID)
VALUES ('2024-04-08', 1, 'H1CAR001', 5, 180.99, 180.99 * 5, 1);


INSERT INTO Compras (FechaCompra, ProveedorID, NumeroParteT, Cantidad, PrecioUnitario, TotalCompras, SucursalID)
VALUES ('2024-04-08', 2, 'T1CAR001', 3, 120.99, 120.99 * 3, 2);

INSERT INTO Compras (FechaCompra, ProveedorID, NumeroParteH, Cantidad, PrecioUnitario,PrecioU_30Pct, SucursalID)
VALUES
('2022-05-10', 1, 'H1CAR007', 1, 85.99, 85.99 * 0.7, 1);

select * from compras;
DELETE FROM compras; --Borra los registros que se usaron en forma de prueba


--2)Generar registros en compras que coincidan con stock de honda y toyota.

-- Se apaga el trigger para que no afecte al stock que ya esta agregado--

DISABLE TRIGGER ActualizarStock_Compras ON Compras;

--(Se usa el 30% a modo de ejemplo, para que exista una diferencia entre los precios de compra y los de venta)
--Se multiplica el Precio por 0.7,para calcular el total de la compra, esta contendrá el 70% del valor original del producto en la tabla compras.

-- Se insertan todos los registros de STOCK_HONDA A COMPRAS, CON EL -30% 
--Se usa getdate para usar la fecha actual como fecha de ingreso.

INSERT INTO Compras (FechaCompra, ProveedorID, NumeroParteH, Cantidad, PrecioUnitario, TotalCompra, SucursalID)
SELECT GETDATE(), ProveedorID, NumeroParteH, Cantidad, Precio, Precio * 0.7, SucursalID
FROM Stock_Honda;

-- Se insertan todos los registros de STOCK_TOYOTA A COMPRAS, CON EL -30%
--Se usa getdate para usar la fecha actual como fecha de ingreso.

INSERT INTO Compras (FechaCompra, ProveedorID, NumeroParteT, Cantidad, PrecioUnitario, TotalCompra, SucursalID)
SELECT GETDATE(), ProveedorID, NumeroParteT, Cantidad, Precio, Precio * 0.7, SucursalID
FROM Stock_Toyota;

select * from compras;

-- Se enciende el trigger. 

ENABLE TRIGGER ActualizarStock_Compras ON Compras;


--3)Agregar registros a ventas, para corroborar que funciona el trigger ActualizarStock_Ventas --


INSERT INTO Ventas (FechaVenta, ClienteID, NumeroParteT, Cantidad, PrecioUnitario, TotalVenta, SucursalID)
VALUES (GETDATE(), 5, 'T1CAR001', 1, 120.99, 120.99, 1);

INSERT INTO Ventas (FechaVenta, ClienteID, NumeroParteH, NumeroParteT, Cantidad, PrecioUnitario, TotalVenta, SucursalID)
VALUES ('2024-04-12', 5, 'H1CAR001', NULL, 1, 180.99, 180.99, 1);


--4)Modificacion de la tabla compras, para que refleje el precio con el -30 y tambien el total de la orden, considerando las cantidades compradas.
--Se renombra la columna TotalCompra por PrecioU_30Pct--

ALTER TABLE Compras
ADD PrecioU_30Pct DECIMAL(10, 2);

UPDATE Compras
SET PrecioU_30Pct = TotalCompra;

ALTER TABLE compras
DROP COLUMN TotalCompra;

ALTER TABLE compras
ADD TotalCompras AS (PrecioU_30Pct * Cantidad);

select * from compras;


--5)Asignar valores a SucursalID en la tabla compras, para que los datos coincidan con los registros de las tablas STOCK_TOYOTA Y STOCK_HONDA
--Honda= SucursalID=1   Toyota= SucursalID=2
--Se utiliza LEFT para que use como referencia el primer valor en NumeroParteH y NumeroParteH--

UPDATE compras
SET sucursalID = 
CASE 
    WHEN LEFT(NumeroParteH, 1) = 'H' THEN 1
    WHEN LEFT(NumeroParteT, 1) = 'T' THEN 2
END;


--6) Consulta para visualizar las ventas por mes, segun la marca.

SELECT 
    MONTH(FechaCompra) AS Mes,
    YEAR(FechaCompra) AS Año,
    SUM(Cantidad) AS CantidadTotalArticulos,-- Calcula y muestra la suma total de la cantidad de artículos comprados.
   
   CASE 
        WHEN SucursalID = 1 THEN 'HONDA' -- Si el ID de sucursal es 1, muestra 'HONDA'.
        WHEN SucursalID = 2 THEN 'TOYOTA'-- Si el ID de sucursal es 2, muestra 'TOYOTA'
    END AS Sucursal,
    ProveedorID,

    COUNT(*) AS Total_Compras,-- Cuenta el número total de compras realizadas.
	 SUM(TotalCompras) AS TotalValorCompras -- Calcula y muestra el total de valor de todas las compras.

FROM Compras
GROUP BY MONTH(FechaCompra),ProveedorID,SucursalID, YEAR(FechaCompra);-- Agrupa los resultados por mes, proveedor, sucursal y año.


--7) -- Se corrige el ProveedorID en la tabla Compras que fue asignado erróneamente a productos Toyota.

UPDATE Compras

SET ProveedorID = 2 -- Se establece el ProveedorID correcto
WHERE ProveedorID = 1 -- Filtrar las compras que tienen el ProveedorID incorrecto

AND LEFT(NumeroParteT, 1) = 'T'; -- Asegurarse de que sean productos Toyota

SELECT * FROM Compras
WHERE ProveedorID = 2; -- Filtrar las compras actualizadas



--8)Consulta para mostrar el importe total de cada compra de Honda, clasificados por el importe total de cada compra utilizando la función RANK().
--Se agrupa mostrando NumeroParteH,NombreParte,PrecioU_30pct (precio unitario * 0.7)
--Se ordena de forma descendente basandose en el importe total de cada compra.


--Con el select se obtienen los valores de la tabla compras  C.PrecioU_30pct,  SH.NombreAutoparte, SH.NumeroParteH y se establecela marca como Honda.
SELECT
    'Honda' AS Marca,
    SH.NumeroParteH AS ID_Producto, 
    SH.NombreAutoparte AS Nombre_Producto, 
    C.PrecioU_30pct AS Precio_Unitario, 

 -- Calcula la suma total de la cantidad de cada producto de Honda comprado.
    SUM(C.Cantidad) AS Total_Compras,

 -- Calcula el importe total de cada compra para el producto.
    SUM(C.TotalCompras) AS Total_Importe,

-- Asigna un rango a cada producto de Honda basado en el importe total de cada compra.
    RANK() OVER (ORDER BY SUM(C.TotalCompras) DESC) AS Ranking
FROM
    Compras C

-- Realiza un JOIN con la tabla de Stock de Honda para obtener información adicional sobre la pieza.
JOIN
    Stock_Honda SH ON C.NumeroParteH = SH.NumeroParteH 
WHERE
    LEFT(C.NumeroParteH, 1) = 'H' -- Filtra solo los productos de Honda.

-- Agrupa los resultados por el ID del producto, el nombre del producto y el precio unitario con el descuento del 30%.
GROUP BY
    SH.NumeroParteH, SH.NombreAutoparte, C.PrecioU_30pct 

 -- Ordena los resultados en orden descendente por el importe total de cada compra.
 ORDER BY
    Total_Importe DESC; 




--9)Consulta para mostrar el importe total de cada compra de Toyota, clasificados por el importe total de cada compra utilizando la función RANK().
--Se agrupa mostrando NumeroParteT,NombreParte,PrecioU_30pct (precio unitario * 0.7)
--Se ordena de forma descendente basandose en el importe total de cada compra.


--Con el select se obtienen los valores de la tabla compras C.PrecioU_30pct,  ST.NombreAutoparte, ST.NumeroParteT y se establece la marca como Toyota.
SELECT
    'Toyota' AS Marca,
    ST.NumeroParteT AS ID_Producto, 
    ST.NombreAutoparte AS Nombre_Producto, 
    C.PrecioU_30pct AS Precio_Unitario, 

 -- Calcula la suma total de la cantidad de cada repuesto Toyota comprado.
    SUM(C.Cantidad) AS Total_Compras,

 -- Calcula el importe total de cada compra para el repuesto.
    SUM(C.TotalCompras) AS Total_Importe,

-- Asigna un rango a cada repuesto Toyota basado en el importe total de cada compra.
    RANK() OVER (ORDER BY SUM(C.TotalCompras) DESC) AS Ranking
FROM
    Compras C

-- Realiza un JOIN con la tabla de Stock Toyota para obtener información adicional sobre la pieza.
JOIN
    Stock_Toyota ST ON C.NumeroParteT = ST.NumeroParteT 
WHERE
    LEFT(C.NumeroParteT, 1) = 'T' -- Filtra solo los productos de Honda.

-- Agrupa los resultados por el ID del producto, el nombre del producto y el precio unitario con el descuento del 30%.
GROUP BY
    ST.NumeroParteT, ST.NombreAutoparte, C.PrecioU_30pct 

 -- Ordena los resultados en orden descendente por el importe total de cada compra.
  ORDER BY
    Total_Importe DESC; 


--10)Agregar registros consistentes a la tabla ventas

DELETE FROM Ventas;-- Borramos los registros de prueba.

INSERT INTO Ventas (FechaVenta, ClienteID, NumeroParteH, NumeroParteT, Cantidad, PrecioUnitario, TotalVenta, SucursalID)
VALUES 
('2022-04-10', 5, 'H1CAR001', NULL, 4, 180.99, 4 * 180.99, 1),
('2022-04-15', 6, 'H1CAR002', NULL, 3, 220.50, 3 * 220.50, 1),
('2022-04-20', 7, 'H1CAR003', NULL, 5, 100.75, 5 * 100.75, 1),
('2022-04-25', 8, 'H1CAR004', NULL, 2, 240.99, 2 * 240.99, 1),
('2022-04-30', 9, 'H1CAR005', NULL, 6, 140.50, 6 * 140.50, 1),
('2022-05-05', 10, 'H1CAR006', NULL, 4, 170.25, 4 * 170.25, 1),
('2022-05-10', 11, 'H1CAR007', NULL, 3, 85.99, 3 * 85.99, 1),
('2022-05-15', 12, 'H1CAR008', NULL, 5, 35.50, 5 * 35.50, 1),
('2022-05-20', 13, 'H1CAR009', NULL, 2, 95.75, 2 * 95.75, 1),
('2022-05-25', 14, 'H1CAR010', NULL, 3, 120.99, 3 * 120.99, 1),
('2022-06-04', 16, 'H1CAR012', NULL, 4, 320.50, 4 * 320.50, 1),
('2022-06-09', 17, 'H1CAR013', NULL, 5, 310.75, 5 * 310.75, 1),
('2022-07-19', 25, 'H1CRI011', NULL, 2, 270.99, 2 * 270.99, 1),
('2022-07-24', 26, 'H1CRI012', NULL, 3, 190.50, 3 * 190.50, 1),
('2022-08-13', 30, 'H1CRI016', NULL, 4, 90.25, 4 * 90.25, 1),
('2022-08-18', 31, 'H1CRI017', NULL, 3, 80.99, 3 * 80.99, 1),
('2022-09-07', 35, 'H1CRI021', NULL, 2, 300.99, 2 * 300.99, 1),
('2022-09-12', 36, 'H1CRI022', NULL, 3, 220.50, 3 * 220.50, 1),
('2022-10-02', 40, 'H1CRI026', NULL, 4, 90.25, 4 * 90.25, 1),
('2022-10-07', 41, 'H1CRI027', NULL, 3, 270.99, 3 * 270.99, 1),
('2022-10-12', 42, 'H1CRI028', NULL, 2, 160.50, 2 * 160.50, 1);


INSERT INTO Ventas (FechaVenta, ClienteID, NumeroParteT, Cantidad, PrecioUnitario, TotalVenta, SucursalID)
VALUES 

('2022-04-11', 5, 'T1CAR009', 8, 110.99, 8 * 110.99, 2),
('2022-05-12', 6, 'T1CAR010', 6, 125.50, 6 * 125.50, 2),
('2022-05-13', 7, 'T1CRI001', 5, 300.99, 5 * 300.99, 2),
('2022-05-14', 8, 'T1CRI002', 3, 250.50, 3 * 250.50, 2),
('2022-06-15', 9, 'T1CRI003', 4, 150.75, 4 * 150.75, 2),
('2023-01-16', 10, 'T1CRI004', 6, 200.99, 6 * 200.99, 2),
('2023-07-17', 11, 'T1CRI005', 8, 180.50, 8 * 180.50, 2),
('2023-07-18', 12, 'T1CRI006', 4, 160.25, 4 * 160.25, 2),
('2023-08-19', 13, 'T1CRI007', 5, 400.99, 5 * 400.99, 2),
('2023-09-10', 14, 'T1CRI008', 3, 120.50, 3 * 120.50, 2),
('2023-09-10', 15, 'T1CRI009', 10, 100.75, 10 * 100.75, 2),
('2023-05-10', 16, 'T1DIR001', 6, 250.99, 6 * 250.99, 2),
('2023-12-10', 17, 'T1DIR002', 4, 300.50, 4 * 300.50, 2),
('2024-01-11', 25, 'T1ELE001', 3, 450.99, 3 * 450.99, 2),
('2024-01-11', 26, 'T1ELE002', 5, 550.50, 5 * 550.50, 2),
('2024-02-16', 35, 'T1LUB001', 50, 25.99, 50 * 25.99, 2),
('2024-02-15', 36, 'T1LUB002', 30, 12.50, 30 * 12.50, 2),
('2024-03-12', 42, 'T1SUS010', 4, 80.99, 4 * 80.99, 2),
('2024-04-10', 43, 'T2DIR001', 5, 80.99, 5 * 80.99, 2),
('2024-04-10', 44, 'T2DIR002', 3, 280.50, 3 * 280.50, 2),
('2024-04-10', 55, 'T2DIR014', 6, 180.99, 6 * 180.99, 2),
('2024-04-10', 56, 'T2DIR015', 2, 90.50, 2 * 90.50, 2);




--11)Consulta para mostrar el importe total de cada venta de Toyota y honda por separado, clasificados por el importe total de cada venta utilizando la función RANK().
--Se agrupa mostrando NumeroParteT,NombreParte,PrecioUnitario
--Se ordena de forma descendente basandose en el importe total de cada Venta.


--PARA TOYOTA--
SELECT
    'Toyota' AS Marca,
    ST.NumeroParteT AS ID_Producto, 
    ST.NombreAutoparte AS Nombre_Producto, 
    V.PrecioUnitario AS Precio_Unitario, 

 -- Calcula la suma total de la cantidad de cada repuesto Toyota vendido.
    SUM(V.Cantidad) AS Total_Ventas,

 -- Calcula el importe total de cada venta.
    SUM(V.TotalVenta) AS Total_Vendido,

-- Asigna un rango a cada repuesto Toyota basado en el importe total de cada venta.
    RANK() OVER (ORDER BY SUM(V.TotalVenta) DESC) AS Ranking
FROM
    Ventas V

-- Realiza un JOIN con la tabla de Stock Toyota para obtener información adicional sobre la pieza.
JOIN
    Stock_Toyota ST ON V.NumeroParteT = ST.NumeroParteT 
WHERE
    LEFT(V.NumeroParteT, 1) = 'T' -- Filtra solo los productos de Toyota.

-- Agrupa los resultados por el ID del producto, el nombre del producto y el precio unitario.
GROUP BY
    ST.NumeroParteT, ST.NombreAutoparte, V.PrecioUnitario

 -- Ordena los resultados en orden descendente por el importe total de cada venta.
  ORDER BY
   Total_Vendido DESC; 


   --PARA HONDA--
   SELECT
    'Honda' AS Marca,
    SH.NumeroParteH AS ID_Producto, 
    SH.NombreAutoparte AS Nombre_Producto, 
    V.PrecioUnitario AS Precio_Unitario, 

 -- Calcula la suma total de la cantidad de cada repuesto Honda vendido.
    SUM(V.Cantidad) AS Total_Ventas,

 -- Calcula el importe total de cada venta.
    SUM(V.TotalVenta) AS Total_Vendido,

-- Asigna un rango a cada repuesto Honda basado en el importe total de cada venta.
    RANK() OVER (ORDER BY SUM(V.TotalVenta) DESC) AS Ranking
FROM
    Ventas V

-- Realiza un JOIN con la tabla de Stock Honda para obtener información adicional sobre la pieza.
JOIN
    Stock_Honda SH ON V.NumeroParteH = SH.NumeroParteH
WHERE
    LEFT(V.NumeroParteH, 1) = 'H' -- Filtra solo los productos de Honda.

-- Agrupa los resultados por el ID del producto, el nombre del producto y el precio unitario.
GROUP BY
    SH.NumeroParteH, SH.NombreAutoparte, V.PrecioUnitario

 -- Ordena los resultados en orden descendente por el importe total de cada venta.
  ORDER BY
   Total_Vendido DESC; 

--12) Consultas varias con la tabla venta, usando los registros previamente cargados.


--Consulta simple que muestra la cantidad de compras (veces)que ha hecho un cliente.
SELECT ClienteID, SUM(Cantidad) AS TotalCompras
FROM Ventas
GROUP BY ClienteID;

-- Cantidad de ventas hechas, agrupadas por mes y año.
SELECT YEAR(FechaVenta) AS Año, MONTH(FechaVenta) AS Mes, SUM(Cantidad) AS TotalVentas
FROM Ventas
GROUP BY YEAR(FechaVenta), MONTH(FechaVenta);

--Total de ventas hechas por sucursal.
SELECT SucursalID, SUM(Cantidad) AS TotalVentas
FROM Ventas
GROUP BY SucursalID;

--Venta mas alta y Venta mas baja.
SELECT MAX(TotalVenta) AS VentaMasAlta, MIN(TotalVenta) AS VentaMasBaja
FROM Ventas;

-- Se muestra el importe total comprado por cliente. Mostrando los datos basicos de cliente mas la fecha de compra.
-- Se utiliza un JOIN entre la tabla cliente y la tabla ventas(CLIENTEID), y luego se agrupa con los datos basicos (NOMBRE, APELLIDO, DNI, FECHAVENTA)
SELECT 
    V.ClienteID,
    C.Nombre,
    C.Apellido,
    C.DNI,
    V.FechaVenta AS FechaCompra,
    SUM(V.TotalVenta) AS ImporteTotalComprado
FROM 
    Ventas V
JOIN 
    Clientes C ON V.ClienteID = C.ID
GROUP BY 
    V.ClienteID, C.Nombre, C.Apellido, C.DNI, V.FechaVenta;



--select * from Stock_Honda;
--select * from Stock_Toyota;
--select * from ventas;
--select * from compras;
--select * from Sucursales
--select * from Proveedores;
--select * from clientes;


