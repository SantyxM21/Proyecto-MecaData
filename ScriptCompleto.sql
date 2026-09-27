--Dominios
CREATE DOMAIN TPlaca AS VARCHAR(6)
    CHECK (VALUE ~ '^[A-Z]{3}[0-9]{3}$');

CREATE DOMAIN TCorreo AS VARCHAR(50)
    CHECK (VALUE LIKE ('%@%.%'));

CREATE DOMAIN TTelefono AS VARCHAR(15)
    CHECK (VALUE ~ '^[0-9]{7,15}$');

CREATE DOMAIN TCargo AS CHAR(1)
    CHECK (VALUE IN ('G','I','T','A'));

CREATE DOMAIN TEstadoOrden AS CHAR(1)
    CHECK (VALUE IN ('F','E','C'));

CREATE DOMAIN TEstadoGarantia AS CHAR(1)
    CHECK (VALUE IN ('R','X','A','V'));

CREATE DOMAIN TEstadoMovimiento AS CHAR(1)
    CHECK (VALUE IN ('P', 'X'));

CREATE DOMAIN TMedioPago AS CHAR(1)
    CHECK (VALUE IN ('E','B','C','T'));

CREATE DOMAIN TMoneda AS NUMERIC(20,2)
    CHECK (VALUE >= 0);

CREATE DOMAIN TNumeroOrden AS VARCHAR(13)
    CHECK (VALUE ~ '^OS[0-9]{2}-[0-9]{8}$');

--Tablas
CREATE TABLE Automoviles(
    vehiculo TPlaca NOT NULL, 
    numeroPuertas int NOT NULL
);

CREATE TABLE Vehiculos(
    placa TPlaca NOT NULL,
    kilometraje int NOT NULL,
    marca VARCHAR(30) NOT NULL,
    modelo NUMERIC(4) NOT NULL,
    cilindraje NUMERIC NOT NULL,
    color VARCHAR(20) NOT NULL,
    cliente VARCHAR(15) NOT NULL
);

CREATE TABLE Clientes(
    direccion VARCHAR(100),
    fechaRegistro DATE NOT NULL,
    persona VARCHAR(15) NOT NULL
);

CREATE TABLE Personas(
    cedula VARCHAR(15) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo TCorreo NOT NULL, 
    telefono TTelefono NOT NULL
);

CREATE TABLE Empleados(
    cargo TCargo NOT NULL,
    fechaIngreso DATE NOT NULL,
    salario TMoneda NOT NULL,
    persona VARCHAR(15) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE Tecnicos(
    especialidad VARCHAR(50) NOT NULL,
    empleado VARCHAR(15) NOT NULL
);

CREATE TABLE Trabaja(
    horasTrabajadas NUMERIC NOT NULL,
    tecnico VARCHAR(15) NOT NULL,
    detalleOrden VARCHAR(10) NOT NULL
);

CREATE TABLE DetalleOrdenes(
    id VARCHAR(10) NOT NULL,
    valorCobrado TMoneda,
    estado TEstadoOrden NOT NULL, 
    fechaInicio DATE NOT NULL,
    fechaFin DATE,
    catalogoServicio VARCHAR(10) NOT NULL,
    servicio TNumeroOrden NOT NULL
);

CREATE TABLE Garantias(
    numero VARCHAR(10) NOT NULL,
    fechaInicio DATE NOT NULL,
    condiciones VARCHAR(200) NOT NULL,
    estado TEstadoGarantia NOT NULL, 
    detalleOrden VARCHAR(10) NOT NULL 
);

CREATE TABLE Servicios(
    numero TNumeroOrden NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE,
    estado TEstadoOrden NOT NULL, 
    vehiculo TPlaca NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE CatalogoServicios(
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    precioBase TMoneda NOT NULL,
    tiempoMedio NUMERIC NOT NULL
);

CREATE TABLE Presta(
    disponible boolean NOT NULL, 
    precioLocal TMoneda,
    catalogoServicio VARCHAR(10) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE Sedes(
    numero VARCHAR(5) NOT NULL, 
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono TTelefono NOT NULL
);

CREATE TABLE Inventario(
    cantidad int NOT NULL,
    sede VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE Repuestos(
    serie VARCHAR(20) NOT NULL,
    tipo VARCHAR(30) NOT NULL, 
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Traslados(
    numero VARCHAR(10) NOT NULL,
    cantidad int NOT NULL,
    fecha DATE NOT NULL,
    detalle VARCHAR(200),
    sedeLlega VARCHAR(5) NOT NULL,
    sedeSale VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE ConsumoRepuesto(
    cantidad int NOT NULL,
    fechaUso DATE NOT NULL,
    precio TMoneda NOT NULL,
    repuesto VARCHAR(20) NOT NULL, 
    detalleOrden VARCHAR(10) NOT NULL
);

CREATE TABLE Suministra(
    precioReferencia TMoneda NOT NULL,
    proveedor VARCHAR(15) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE Proveedores(
    nit VARCHAR(15) NOT NULL,
    correo TCorreo NOT NULL,
    numeroContacto TTelefono NOT NULL,
    representante VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100)
);

CREATE TABLE Compras(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    sede VARCHAR(5) NOT NULL,
    proveedor VARCHAR(15) NOT NULL
);

CREATE TABLE DetalleCompras(
    id VARCHAR(10) NOT NULL,
    cantidad int NOT NULL,
    precioUnidad TMoneda NOT NULL,
    compra VARCHAR(10) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE Movimientos(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    valor TMoneda NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    estado TEstadoMovimiento NOT NULL
);

CREATE TABLE Cobros(
    movimiento VARCHAR(10) NOT NULL,
    medioPago TMedioPago NOT NULL,
    fechaExpedido DATE NOT NULL,
    orden TNumeroOrden NOT NULL
);

CREATE TABLE Pagos(
    movimiento VARCHAR(10) NOT NULL,
    fechaPago DATE NOT NULL,
    compra VARCHAR(10) NOT NULL
);

--Atributos
ALTER TABLE Vehiculos ADD CONSTRAINT CK_VEHICULOS_KILOMETRAJE
    CHECK (kilometraje >= 0);

ALTER TABLE Vehiculos ADD CONSTRAINT CK_VEHICULOS_CILINDRAJE
    CHECK (cilindraje > 0);

ALTER TABLE Empleados ADD CONSTRAINT CK_EMPLEADOS_SALARIO
    CHECK (salario > 0);

ALTER TABLE CatalogoServicios ADD CONSTRAINT CK_CATALOGO_SERVICIOS_PRECIO_BASE
    CHECK (precioBase > 0);

ALTER TABLE CatalogoServicios ADD CONSTRAINT CK_CATALOGO_SERVICIOS_TIEMPO_MEDIO
    CHECK (tiempoMedio > 0);

ALTER TABLE Presta ADD CONSTRAINT CK_PRESTA_PRECIO_LOCAL
    CHECK (precioLocal > 0);

ALTER TABLE Trabaja ADD CONSTRAINT CK_TRABAJA_HORAS_TRABAJADAS
    CHECK (horasTrabajadas > 0);

ALTER TABLE Inventario ADD CONSTRAINT CK_INVENTARIO_CANTIDAD
    CHECK (cantidad >= 0);

ALTER TABLE Traslados ADD CONSTRAINT CK_TRASLADOS_CANTIDAD
    CHECK (cantidad > 0);

ALTER TABLE ConsumoRepuesto ADD CONSTRAINT CK_CONSUMO_REPUESTO_CANTIDAD
    CHECK (cantidad > 0);

ALTER TABLE DetalleCompras ADD CONSTRAINT CK_DETALLE_COMPRAS_CANTIDAD
    CHECK (cantidad > 0);

--Primarias
ALTER TABLE Automoviles ADD CONSTRAINT PK_AUTOMOVILES
    PRIMARY KEY (vehiculo);

ALTER TABLE Vehiculos ADD CONSTRAINT PK_VEHICULOS
    PRIMARY KEY (placa);

ALTER TABLE Clientes ADD CONSTRAINT PK_CLIENTES
    PRIMARY KEY (persona);

ALTER TABLE Personas ADD CONSTRAINT PK_PERSONAS
    PRIMARY KEY (cedula);  

ALTER TABLE Empleados ADD CONSTRAINT PK_EMPLEADOS
    PRIMARY KEY (persona);

ALTER TABLE Tecnicos ADD CONSTRAINT PK_TECNICOS
    PRIMARY KEY (empleado);

ALTER TABLE Trabaja ADD CONSTRAINT PK_TRABAJA
    PRIMARY KEY (tecnico, detalleOrden);

ALTER TABLE DetalleOrdenes ADD CONSTRAINT PK_DETALLE_ORDENES
    PRIMARY KEY (id);  

ALTER TABLE Garantias ADD CONSTRAINT PK_GARANTIAS
    PRIMARY KEY (numero);

ALTER TABLE Servicios ADD CONSTRAINT PK_SERVICIOS
    PRIMARY KEY (numero);

ALTER TABLE CatalogoServicios ADD CONSTRAINT PK_CATALOGO_SERVICIOS
    PRIMARY KEY (codigo);

ALTER TABLE Presta ADD CONSTRAINT PK_PRESTA
    PRIMARY KEY (catalogoServicio, sede);

ALTER TABLE Sedes ADD CONSTRAINT PK_SEDES
    PRIMARY KEY (numero);

ALTER TABLE Inventario ADD CONSTRAINT PK_INVENTARIO
    PRIMARY KEY (sede, repuesto);

ALTER TABLE Repuestos ADD CONSTRAINT PK_REPUESTOS
    PRIMARY KEY (serie);

ALTER TABLE Traslados ADD CONSTRAINT PK_TRASLADOS
    PRIMARY KEY (numero);

ALTER TABLE ConsumoRepuesto ADD CONSTRAINT PK_CONSUMO_REPUESTO
    PRIMARY KEY (repuesto, detalleOrden);

ALTER TABLE Suministra ADD CONSTRAINT PK_SUMINISTRA
    PRIMARY KEY (proveedor, repuesto);

ALTER TABLE Proveedores ADD CONSTRAINT PK_PROVEEDORES
    PRIMARY KEY (nit);

ALTER TABLE Compras ADD CONSTRAINT PK_COMPRAS
    PRIMARY KEY (numero);

ALTER TABLE DetalleCompras ADD CONSTRAINT PK_DETALLE_COMPRAS
    PRIMARY KEY (id);

ALTER TABLE Movimientos ADD CONSTRAINT PK_MOVIMIENTOS
    PRIMARY KEY (numero);

ALTER TABLE Cobros ADD CONSTRAINT PK_COBROS
    PRIMARY KEY (movimiento);

ALTER TABLE Pagos ADD CONSTRAINT PK_PAGOS
    PRIMARY KEY (movimiento);


--Unicas
ALTER TABLE Personas ADD CONSTRAINT UK_PERSONAS_CORREO
    UNIQUE (correo);

ALTER TABLE Garantias ADD CONSTRAINT UK_GARANTIAS_DETALLE_ORDEN
    UNIQUE (detalleOrden);

ALTER TABLE Sedes ADD CONSTRAINT UK_SEDES_TELEFONO
    UNIQUE (telefono);

ALTER TABLE Proveedores ADD CONSTRAINT UK_PROVEEDORES_CORREO
    UNIQUE (correo);

ALTER TABLE Proveedores ADD CONSTRAINT UK_PROVEEDORES_NUMERO_CONTACTO
    UNIQUE (numeroContacto);

ALTER TABLE Cobros ADD CONSTRAINT UK_COBROS_ORDEN
    UNIQUE (orden);

ALTER TABLE Pagos ADD CONSTRAINT UK_PAGOS_COMPRA
    UNIQUE (compra);


--Foraneas
ALTER TABLE Automoviles ADD CONSTRAINT FK_AUTOMOVILES_VEHICULO
    FOREIGN KEY (vehiculo) REFERENCES Vehiculos(placa)
    ON DELETE CASCADE;

ALTER TABLE Vehiculos ADD CONSTRAINT FK_VEHICULOS_CLIENTE
    FOREIGN KEY (cliente) REFERENCES Clientes(persona)
    ON DELETE RESTRICT;

ALTER TABLE Clientes ADD CONSTRAINT FK_CLIENTES_PERSONA
    FOREIGN KEY (persona) REFERENCES Personas(cedula)
    ON DELETE CASCADE;

ALTER TABLE Empleados ADD CONSTRAINT FK_EMPLEADOS_PERSONA
    FOREIGN KEY (persona) REFERENCES Personas(cedula)
    ON DELETE CASCADE;

ALTER TABLE Empleados ADD CONSTRAINT FK_EMPLEADOS_SEDE
    FOREIGN KEY (sede) REFERENCES Sedes(numero)
    ON DELETE RESTRICT;

ALTER TABLE Tecnicos ADD CONSTRAINT FK_TECNICOS_EMPLEADO
    FOREIGN KEY (empleado) REFERENCES Empleados(persona)
    ON DELETE CASCADE;

ALTER TABLE Trabaja ADD CONSTRAINT FK_TRABAJA_TECNICO
    FOREIGN KEY (tecnico) REFERENCES Tecnicos(empleado)
    ON DELETE RESTRICT;

ALTER TABLE Trabaja ADD CONSTRAINT FK_TRABAJA_DETALLE_ORDEN
    FOREIGN KEY (detalleOrden) REFERENCES DetalleOrdenes(id)
    ON DELETE CASCADE;

ALTER TABLE DetalleOrdenes ADD CONSTRAINT FK_DETALLE_ORDENES_CATALOGO_SERVICIO
    FOREIGN KEY (catalogoServicio) REFERENCES CatalogoServicios(codigo)
    ON DELETE RESTRICT;

ALTER TABLE DetalleOrdenes ADD CONSTRAINT FK_DETALLE_ORDENES_SERVICIO
    FOREIGN KEY (servicio) REFERENCES Servicios(numero)
    ON DELETE CASCADE;

ALTER TABLE Garantias ADD CONSTRAINT FK_GARANTIAS_DETALLE_ORDEN
    FOREIGN KEY (detalleOrden) REFERENCES DetalleOrdenes(id)
    ON DELETE RESTRICT;

ALTER TABLE Servicios ADD CONSTRAINT FK_SERVICIOS_VEHICULO
    FOREIGN KEY (vehiculo) REFERENCES Vehiculos(placa)
    ON DELETE RESTRICT;

ALTER TABLE Servicios ADD CONSTRAINT FK_SERVICIOS_SEDE
    FOREIGN KEY (sede) REFERENCES Sedes(numero)
    ON DELETE RESTRICT;

ALTER TABLE Presta ADD CONSTRAINT FK_PRESTA_CATALOGO_SERVICIO
    FOREIGN KEY (catalogoServicio) REFERENCES CatalogoServicios(codigo)
    ON DELETE RESTRICT;

ALTER TABLE Presta ADD CONSTRAINT FK_PRESTA_SEDE
    FOREIGN KEY (sede) REFERENCES Sedes(numero)
    ON DELETE RESTRICT;

ALTER TABLE Inventario ADD CONSTRAINT FK_INVENTARIO_SEDE
    FOREIGN KEY (sede) REFERENCES Sedes(numero)
    ON DELETE RESTRICT;

ALTER TABLE Inventario ADD CONSTRAINT FK_INVENTARIO_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES Repuestos(serie)
    ON DELETE RESTRICT;

ALTER TABLE Traslados ADD CONSTRAINT FK_TRASLADOS_SEDE_LLEGA
    FOREIGN KEY (sedeLlega) REFERENCES Sedes(numero)
    ON DELETE RESTRICT;

ALTER TABLE Traslados ADD CONSTRAINT FK_TRASLADOS_SEDE_SALE
    FOREIGN KEY (sedeSale) REFERENCES Sedes(numero)
    ON DELETE RESTRICT;

ALTER TABLE ConsumoRepuesto ADD CONSTRAINT FK_CONSUMO_REPUESTO_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES Repuestos(serie)
    ON DELETE RESTRICT;

ALTER TABLE ConsumoRepuesto ADD CONSTRAINT FK_CONSUMO_REPUESTO_DETALLE_ORDEN
    FOREIGN KEY (detalleOrden) REFERENCES DetalleOrdenes(id)
    ON DELETE CASCADE;

ALTER TABLE Suministra ADD CONSTRAINT FK_SUMINISTRA_PROVEEDOR
    FOREIGN KEY (proveedor) REFERENCES Proveedores(nit)
    ON DELETE RESTRICT;

ALTER TABLE Suministra ADD CONSTRAINT FK_SUMINISTRA_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES Repuestos(serie)
    ON DELETE RESTRICT;

ALTER TABLE Compras ADD CONSTRAINT FK_COMPRAS_SEDE
    FOREIGN KEY (sede) REFERENCES Sedes(numero)
    ON DELETE RESTRICT;

ALTER TABLE Compras ADD CONSTRAINT FK_COMPRAS_PROVEEDOR
    FOREIGN KEY (proveedor) REFERENCES Proveedores(nit)
    ON DELETE RESTRICT;

ALTER TABLE DetalleCompras ADD CONSTRAINT FK_DETALLE_COMPRAS_COMPRA
    FOREIGN KEY (compra) REFERENCES Compras(numero)
    ON DELETE CASCADE;

ALTER TABLE DetalleCompras ADD CONSTRAINT FK_DETALLE_COMPRAS_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES Repuestos(serie)
    ON DELETE RESTRICT;

ALTER TABLE Cobros ADD CONSTRAINT FK_COBROS_MOVIMIENTO
    FOREIGN KEY (movimiento) REFERENCES Movimientos(numero)
    ON DELETE RESTRICT;

ALTER TABLE Cobros ADD CONSTRAINT FK_COBROS_ORDEN
    FOREIGN KEY (orden) REFERENCES Servicios(numero)
    ON DELETE RESTRICT;

ALTER TABLE Pagos ADD CONSTRAINT FK_PAGOS_MOVIMIENTO
    FOREIGN KEY (movimiento) REFERENCES Movimientos(numero)
    ON DELETE RESTRICT;

ALTER TABLE Pagos ADD CONSTRAINT FK_PAGOS_COMPRA
    FOREIGN KEY (compra) REFERENCES Compras(numero)
    ON DELETE RESTRICT;

ALTER TABLE Traslados ADD CONSTRAINT FK_TRASLADOS_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES Repuestos(serie)
    ON DELETE RESTRICT;

--XTablas
/*
DROP TABLE Pagos;
DROP TABLE Cobros;
DROP TABLE Movimientos;
DROP TABLE DetalleCompras;
DROP TABLE Compras;
DROP TABLE Suministra;
DROP TABLE Proveedores;
DROP TABLE ConsumoRepuesto;
DROP TABLE Traslados;
DROP TABLE Inventario;
DROP TABLE Repuestos;
DROP TABLE Garantias;
DROP TABLE Trabaja;
DROP TABLE Tecnicos;
DROP TABLE Empleados;
DROP TABLE DetalleOrdenes;
DROP TABLE Servicios;
DROP TABLE Presta;
DROP TABLE CatalogoServicios;
DROP TABLE Sedes;
DROP TABLE Automoviles;
DROP TABLE Vehiculos;
DROP TABLE Clientes;
DROP TABLE Personas;

DROP DOMAIN TPlaca;
DROP DOMAIN TCorreo;
DROP DOMAIN TTelefono;
DROP DOMAIN TCargo;
DROP DOMAIN TEstadoOrden;
DROP DOMAIN TEstadoGarantia;
DROP DOMAIN TEstadoMovimiento;
DROP DOMAIN TMedioPago;
DROP DOMAIN TMoneda;
DROP DOMAIN TNumeroOrden;
*/

--PoblarOK
INSERT INTO Personas (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543');

INSERT INTO Clientes (direccion, fechaRegistro, persona) VALUES
    ('Calle 10 # 5-20', '2024-01-15', '1010101010');

INSERT INTO Vehiculos (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010');

INSERT INTO Automoviles (vehiculo, numeroPuertas) VALUES
    ('ABC123', 4);

INSERT INTO Sedes (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321');

INSERT INTO Empleados (cargo, fechaIngreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 3500000.00, '2020202020', 'S01');

INSERT INTO Tecnicos (especialidad, empleado) VALUES
    ('Motor', '2020202020');

INSERT INTO CatalogoServicios (codigo, nombre, descripcion, precioBase, tiempoMedio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.5);

INSERT INTO Presta (disponible, precioLocal, catalogoServicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01');

INSERT INTO Servicios (numero, fechaInicio, fechaFin, estado, vehiculo, sede) VALUES
    ('OS24-00000001', '2024-05-10', '2024-05-11', 'F', 'ABC123', 'S01');

INSERT INTO DetalleOrdenes (id, valorCobrado, estado, fechaInicio, fechaFin, catalogoServicio, servicio) VALUES
    ('DO01', 160000.00, 'F', '2024-05-10', '2024-05-11', 'CS01', 'OS24-00000001');

INSERT INTO Trabaja (horasTrabajadas, tecnico, detalleOrden) VALUES
    (1.5, '2020202020', 'DO01');

INSERT INTO Garantias (numero, fechaInicio, condiciones, estado, detalleOrden) VALUES
    ('G01', '2024-05-11', 'Cubre fugas durante 3 meses', 'V', 'DO01');

INSERT INTO Repuestos (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite');

INSERT INTO Inventario (cantidad, sede, repuesto) VALUES
    (20, 'S01', 'R001');

INSERT INTO Traslados (numero, cantidad, fecha, detalle, sedeLlega, sedeSale, repuesto) VALUES
    ('TR01', 5, '2024-04-01', 'Reposicion de filtros', 'S02', 'S01', 'R001');

INSERT INTO ConsumoRepuesto (cantidad, fechaUso, precio, repuesto, detalleOrden) VALUES
    (1, '2024-05-10', 25000.00, 'R001', 'DO01');

INSERT INTO Proveedores (nit, correo, numeroContacto, representante, nombre, direccion) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS', 'Calle 80 # 20-30');

INSERT INTO Suministra (precioReferencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001');

INSERT INTO Compras (numero, fecha, sede, proveedor) VALUES
    ('C01', '2024-03-20', 'S01', '900123456');

INSERT INTO DetalleCompras (id, cantidad, precioUnidad, compra, repuesto) VALUES
    ('DC01', 30, 20000.00, 'C01', 'R001');

INSERT INTO Movimientos (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', '2024-05-11', 185000.00, 'Cobro orden OS24-00000001', 'P'),
    ('M02', '2024-03-25', 600000.00, 'Pago compra C01', 'P');

INSERT INTO Cobros (movimiento, medioPago, fechaExpedido, orden) VALUES
    ('M01', 'T', '2024-05-11', 'OS24-00000001');

INSERT INTO Pagos (movimiento, fechaPago, compra) VALUES
    ('M02', '2024-03-25', 'C01');

--PoblarNoOK
/*
-- Tipo: kilometraje es int, no acepta texto
INSERT INTO Vehiculos (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('XYZ999', 'mucho', 'Renault', 2019, 1600, 'Azul', '1010101010');

-- Nulidad: toda persona debe tener nombre
INSERT INTO Personas (cedula, nombre, apellido, correo, telefono) VALUES
    ('3030303030', NULL, 'Rojas', 'sin.nombre@mail.com', '3201112233');

-- PK: no puede haber dos personas con la misma cedula
INSERT INTO Personas (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Maria', 'Diaz', 'maria.diaz@mail.com', '3154445566');

-- UK: no puede haber dos personas con el mismo correo
INSERT INTO Personas (cedula, nombre, apellido, correo, telefono) VALUES
    ('4040404040', 'Pedro', 'Lopez', 'ana.gomez@mail.com', '3167778899');

-- FK: un vehiculo solo puede pertenecer a un cliente existente
INSERT INTO Vehiculos (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('XYZ999', 30000, 'Renault', 2019, 1600, 'Azul', '9999999999');

-- Dominio: el numero de orden debe tener formato OSAA-########
INSERT INTO Servicios (numero, fechaInicio, fechaFin, estado, vehiculo, sede) VALUES
    ('ORDEN1', '2024-06-01', NULL, 'E', 'ABC123', 'S01');

-- Dominio: estado de orden solo acepta F, E o C
INSERT INTO Servicios (numero, fechaInicio, fechaFin, estado, vehiculo, sede) VALUES
    ('OS24-00000002', '2024-06-01', NULL, 'Z', 'ABC123', 'S01');

-- CHECK de atributo: el inventario no puede ser negativo
INSERT INTO Inventario (cantidad, sede, repuesto) VALUES
    (-5, 'S02', 'R001');
*/

--XPoblar
/*
DELETE FROM Pagos;
DELETE FROM Cobros;
DELETE FROM Movimientos;
DELETE FROM DetalleCompras;
DELETE FROM Compras;
DELETE FROM Suministra;
DELETE FROM Proveedores;
DELETE FROM ConsumoRepuesto;
DELETE FROM Traslados;
DELETE FROM Inventario;
DELETE FROM Repuestos;
DELETE FROM Garantias;
DELETE FROM Trabaja;
DELETE FROM DetalleOrdenes;
DELETE FROM Servicios;
DELETE FROM Presta;
DELETE FROM CatalogoServicios;
DELETE FROM Tecnicos;
DELETE FROM Empleados;
DELETE FROM Sedes;
DELETE FROM Automoviles;
DELETE FROM Vehiculos;
DELETE FROM Clientes;
DELETE FROM Personas;
*/

-- Consultas

-- Consultas gerenciales
    -- Clientes que mas han gastado en el negocio 
SELECT  p.cedula,
        p.nombre,
        p.apellido,
        COUNT(DISTINCT v.placa) AS numeroVehiculos,
        COUNT(DISTINCT s.numero) AS numeroOrdenes,
        SUM(m.valor) AS totalCobrado
FROM Cobros c
JOIN Movimientos m ON m.numero = c.movimiento
JOIN Servicios s ON s.numero = c.orden
JOIN Vehiculos v ON v.placa = s.vehiculo
JOIN Personas p ON p.cedula = v.cliente
WHERE m.estado = 'P' AND m.fecha BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.cedula, p.nombre, p.apellido
ORDER BY totalCobrado DESC;



-- Consultas operativas
    -- Servicios en proceso 
SELECT  s.numero,
        s.vehiculo AS placa,
        p.nombre,
        p.apellido,
        s.fechaInicio
FROM Servicios s
JOIN Vehiculos v ON v.placa = s.vehiculo
JOIN Personas p ON p.cedula = v.cliente
JOIN Empleados e ON e.sede = s.sede
WHERE s.estado = 'E' AND e.cargo = 'G' AND e.persona = '3030303030'
ORDER BY s.fechaInicio ASC;

    -- Saber que servivios presta una sede
SELECT  cs.codigo,
        cs.nombre,
        COALESCE(p.precioLocal, cs.precioBase) AS precio,
        cs.tiempoMedio
FROM Empleados e
JOIN Presta p ON p.sede = e.sede
JOIN CatalogoServicios cs ON cs.codigo = p.catalogoServicio
WHERE e.persona = '2020202020' AND e.cargo = 'A' AND p.disponible = TRUE
ORDER BY cs.nombre;

    -- Consultar cantidad de un repuesto
SELECT  r.serie,
        r.nombre,
        se.numero AS sede,
        se.nombre AS nombreSede,
        i.cantidad
FROM Inventario i
JOIN Repuestos r ON r.serie = i.repuesto
JOIN Sedes se ON se.numero = i.sede
WHERE r.nombre = 'Filtro de aceite'
ORDER BY i.cantidad ASC;

    -- Historial de servicios del técnico
SELECT  s.numero,
        d.fechaFin AS fechaCierre,
        s.vehiculo AS placa,
        cs.nombre AS servicio,
        d.estado
FROM Trabaja t
JOIN DetalleOrdenes d ON d.id = t.detalleOrden
JOIN Servicios s ON s.numero = d.servicio
JOIN CatalogoServicios cs ON cs.codigo = d.catalogoServicio
WHERE t.tecnico = '2020202020' AND d.fechaFin BETWEEN DATE '2024-01-01' AND DATE '2024-12-31'
ORDER BY d.fechaFin DESC;

    -- Tecnicos sin servicio asignado
SELECT  p.cedula AS cedulaTecnico, 
        p.nombre AS nombreTecnico, 
        p.apellido AS apellidoTecnico, 
        t.especialidad AS especialidadTecnico, 
        p.telefono AS telefonoTecnico
FROM Tecnicos t 
JOIN Empleados e ON t.empleado = e.persona
JOIN Personas p ON e.persona = p.cedula
WHERE t.empleado NOT IN (
    SELECT tra.tecnico
    FROM Trabaja tra, DetalleOrdenes det
    WHERE tra.detalleOrden = det.id AND det.estado = 'E'
)
ORDER BY  t.especialidad ASC, p.nombre ASC;

    -- La información de contacto de los gerentes
SELECT  s.numero AS numeroSede,
        s.nombre AS nombreSede, 
        p.nombre AS nombreGerente, 
        p.apellido AS apellidoGerente, 
        p.correo AS correoGerente, 
        p.telefono AS telefonoGerente
FROM Sedes s
JOIN Empleados e ON e.sede = s.numero
JOIN Personas p ON p.cedula = e.persona
WHERE e.cargo = 'G'
ORDER BY s.nombre ASC;

    -- Consultar estado de un ser
SELECT  s.numero AS numeroOrden, 
        s.sede AS sede, 
        det.fechaInicio AS fechaInicio, 
        cat.nombre AS servicioRealizado, 
        det.estado AS estadoServicio
FROM Servicios s
JOIN Vehiculos v ON v.placa = s.vehiculo
JOIN DetalleOrdenes det ON det.servicio = s.numero
JOIN CatalogoServicios cat ON cat.codigo = det.catalogoServicio
WHERE v.cliente = '1010101010' AND v.placa = 'ABC123' AND s.estado = 'E'
ORDER BY det.fechaInicio ASC;

    -- Consultar las garantias vigentes
SELECT  g.numero, 
        v.placa, 
        cat.nombre, 
        g.fechaInicio, 
        g.condiciones
FROM Garantias g, Vehiculos v, CatalogoServicios cat, DetalleOrdenes det, Servicios s
WHERE g.detalleOrden = det.id 
    AND v.placa = s.vehiculo 
    AND det.catalogoServicio = cat.codigo 
    AND det.servicio = s.numero 
    AND v.cliente = '1010101010' 
    AND g.estado = 'V'
ORDER BY g.fechaInicio DESC;
