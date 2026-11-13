--Dominios
CREATE DOMAIN T_PLACA AS VARCHAR(6)
    CHECK (VALUE ~ '^[A-Z]{3}[0-9]{3}$');

CREATE DOMAIN T_CORREO AS VARCHAR(50)
    CHECK (VALUE LIKE ('%@%.%'));

CREATE DOMAIN T_TELEFONO AS VARCHAR(15)
    CHECK (VALUE ~ '^[0-9]{7,15}$');

CREATE DOMAIN T_CARGO AS CHAR(1)
    CHECK (VALUE IN ('G','T'));

CREATE DOMAIN T_ESTADO_ORDEN AS CHAR(1)
    CHECK (VALUE IN ('F','E','C'));

CREATE DOMAIN T_ESTADO_GARANTIA AS CHAR(1)
    CHECK (VALUE IN ('R','X','A','V'));

CREATE DOMAIN T_ESTADO_MOVIMIENTO AS CHAR(1)
    CHECK (VALUE IN ('P', 'X'));

CREATE DOMAIN T_MEDIO_PAGO AS CHAR(1)
    CHECK (VALUE IN ('E','B','C','T'));

CREATE DOMAIN T_MONEDA AS NUMERIC(20,2)
    CHECK (VALUE >= 0);

CREATE DOMAIN T_NUMERO_ORDEN AS VARCHAR(13)
    CHECK (VALUE ~ '^OS[0-9]{2}-[0-9]{8}$');


--Tablas
CREATE TABLE AUTOMOVILES(
    vehiculo T_PLACA NOT NULL, 
    numero_puertas INTEGER NOT NULL
);

CREATE TABLE VEHICULOS(
    placa T_PLACA NOT NULL,
    kilometraje INTEGER NOT NULL,
    marca VARCHAR(30) NOT NULL,
    modelo NUMERIC(4) NOT NULL,
    cilindraje NUMERIC NOT NULL,
    color VARCHAR(20) NOT NULL,
    cliente VARCHAR(15) NOT NULL
);

CREATE TABLE CLIENTES(
    fecha_registro DATE NOT NULL,
    persona VARCHAR(15) NOT NULL
);

CREATE TABLE PERSONAS(
    cedula VARCHAR(15) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo T_CORREO NOT NULL, 
    telefono T_TELEFONO NOT NULL
);

CREATE TABLE EMPLEADOS(
    cargo T_CARGO NOT NULL,
    fecha_ingreso DATE NOT NULL,
    salario T_MONEDA NOT NULL,
    persona VARCHAR(15) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE TECNICOS(
    especialidad VARCHAR(50) NOT NULL,
    empleado VARCHAR(15) NOT NULL
);

CREATE TABLE DETALLE_ORDENES(
    item INTEGER NOT NULL,
    valor_cobrado T_MONEDA,
    estado T_ESTADO_ORDEN NOT NULL, 
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    catalogo_servicio VARCHAR(10) NOT NULL,
    servicio T_NUMERO_ORDEN NOT NULL,
    tecnico VARCHAR(15),
    horas_trabajadas NUMERIC
);

CREATE TABLE GARANTIAS(
    numero VARCHAR(10) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    condiciones VARCHAR(200) NOT NULL,
    estado T_ESTADO_GARANTIA NOT NULL, 
    servicio T_NUMERO_ORDEN NOT NULL,
    item INTEGER NOT NULL
);

CREATE TABLE SERVICIOS(
    numero T_NUMERO_ORDEN NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado T_ESTADO_ORDEN NOT NULL, 
    vehiculo T_PLACA NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE CATALOGO_SERVICIOS(
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    precio_base T_MONEDA NOT NULL,
    tiempo_medio NUMERIC NOT NULL
);

CREATE TABLE OFERTAS_SERVICIOS(
    habilitado BOOLEAN NOT NULL, 
    precio_local T_MONEDA,
    catalogo_servicio VARCHAR(10) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE SEDES(
    numero VARCHAR(5) NOT NULL, 
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono T_TELEFONO NOT NULL
);

CREATE TABLE REPUESTOS(
    serie VARCHAR(20) NOT NULL,
    tipo VARCHAR(30) NOT NULL, 
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE TRASLADOS(
    numero VARCHAR(10) NOT NULL,
    cantidad INTEGER NOT NULL,
    fecha DATE NOT NULL,
    detalle VARCHAR(200),
    sede_llega VARCHAR(5) NOT NULL,
    sede_sale VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE CONSUMOS(
    cantidad INTEGER NOT NULL,
    fecha_uso DATE NOT NULL,
    precio T_MONEDA NOT NULL,
    repuesto VARCHAR(20) NOT NULL, 
    servicio T_NUMERO_ORDEN NOT NULL,
    item INTEGER NOT NULL
);

CREATE TABLE SUMINISTROS(
    precio_referencia T_MONEDA NOT NULL,
    proveedor VARCHAR(15) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE PROVEEDORES(
    nit VARCHAR(15) NOT NULL,
    correo T_CORREO NOT NULL,
    numero_contacto T_TELEFONO NOT NULL,
    representante VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE COMPRAS(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    sede VARCHAR(5) NOT NULL,
    proveedor VARCHAR(15) NOT NULL
);

CREATE TABLE DETALLE_COMPRAS(
    cantidad INTEGER NOT NULL,
    precio_unidad T_MONEDA NOT NULL,
    compra VARCHAR(10) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE MOVIMIENTOS(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    valor T_MONEDA NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    estado T_ESTADO_MOVIMIENTO NOT NULL
);

CREATE TABLE COBROS(
    movimiento VARCHAR(10) NOT NULL,
    medio_pago T_MEDIO_PAGO NOT NULL,
    fecha_expedido DATE NOT NULL,
    orden T_NUMERO_ORDEN NOT NULL
);

CREATE TABLE PAGOS(
    movimiento VARCHAR(10) NOT NULL,
    fecha_pago DATE NOT NULL,
    compra VARCHAR(10) NOT NULL
);

--Atributos
ALTER TABLE AUTOMOVILES ADD CONSTRAINT CK_AUTOMOVILES_NUMERO_PUERTAS
    CHECK (numero_puertas > 0);

ALTER TABLE VEHICULOS ADD CONSTRAINT CK_VEHICULOS_KILOMETRAJE
    CHECK (kilometraje >= 0);

ALTER TABLE VEHICULOS ADD CONSTRAINT CK_VEHICULOS_CILINDRAJE
    CHECK (cilindraje > 0);

ALTER TABLE EMPLEADOS ADD CONSTRAINT CK_EMPLEADOS_SALARIO
    CHECK (salario > 0);

ALTER TABLE CATALOGO_SERVICIOS ADD CONSTRAINT CK_CATALOGO_SERVICIOS_PRECIO_BASE
    CHECK (precio_base > 0);

ALTER TABLE CATALOGO_SERVICIOS ADD CONSTRAINT CK_CATALOGO_SERVICIOS_TIEMPO_MEDIO
    CHECK (tiempo_medio > 0);

ALTER TABLE OFERTAS_SERVICIOS ADD CONSTRAINT CK_OFERTAS_SERVICIOS_PRECIO_LOCAL
    CHECK (precio_local > 0);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_ITEM
    CHECK (item > 0);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_HORAS_TRABAJADAS
    CHECK (horas_trabajadas > 0);

ALTER TABLE TRASLADOS ADD CONSTRAINT CK_TRASLADOS_CANTIDAD
    CHECK (cantidad > 0);

ALTER TABLE CONSUMOS ADD CONSTRAINT CK_CONSUMOS_CANTIDAD
    CHECK (cantidad > 0);

ALTER TABLE DETALLE_COMPRAS ADD CONSTRAINT CK_DETALLE_COMPRAS_CANTIDAD
    CHECK (cantidad > 0);

--Primarias
ALTER TABLE AUTOMOVILES ADD CONSTRAINT PK_AUTOMOVILES
    PRIMARY KEY (vehiculo);

ALTER TABLE VEHICULOS ADD CONSTRAINT PK_VEHICULOS
    PRIMARY KEY (placa);

ALTER TABLE CLIENTES ADD CONSTRAINT PK_CLIENTES
    PRIMARY KEY (persona);

ALTER TABLE PERSONAS ADD CONSTRAINT PK_PERSONAS
    PRIMARY KEY (cedula);  

ALTER TABLE EMPLEADOS ADD CONSTRAINT PK_EMPLEADOS
    PRIMARY KEY (persona);

ALTER TABLE TECNICOS ADD CONSTRAINT PK_TECNICOS
    PRIMARY KEY (empleado);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT PK_DETALLE_ORDENES
    PRIMARY KEY (servicio, item);

ALTER TABLE GARANTIAS ADD CONSTRAINT PK_GARANTIAS
    PRIMARY KEY (numero);

ALTER TABLE SERVICIOS ADD CONSTRAINT PK_SERVICIOS
    PRIMARY KEY (numero);

ALTER TABLE CATALOGO_SERVICIOS ADD CONSTRAINT PK_CATALOGO_SERVICIOS
    PRIMARY KEY (codigo);

ALTER TABLE OFERTAS_SERVICIOS ADD CONSTRAINT PK_OFERTAS_SERVICIOS
    PRIMARY KEY (catalogo_servicio, sede);

ALTER TABLE SEDES ADD CONSTRAINT PK_SEDES
    PRIMARY KEY (numero);

ALTER TABLE REPUESTOS ADD CONSTRAINT PK_REPUESTOS
    PRIMARY KEY (serie);

ALTER TABLE TRASLADOS ADD CONSTRAINT PK_TRASLADOS
    PRIMARY KEY (numero);

ALTER TABLE CONSUMOS ADD CONSTRAINT PK_CONSUMOS
    PRIMARY KEY (servicio, item, repuesto);

ALTER TABLE SUMINISTROS ADD CONSTRAINT PK_SUMINISTROS
    PRIMARY KEY (proveedor, repuesto);

ALTER TABLE PROVEEDORES ADD CONSTRAINT PK_PROVEEDORES
    PRIMARY KEY (nit);

ALTER TABLE COMPRAS ADD CONSTRAINT PK_COMPRAS
    PRIMARY KEY (numero);

ALTER TABLE DETALLE_COMPRAS ADD CONSTRAINT PK_DETALLE_COMPRAS
    PRIMARY KEY (compra, repuesto);

ALTER TABLE MOVIMIENTOS ADD CONSTRAINT PK_MOVIMIENTOS
    PRIMARY KEY (numero);

ALTER TABLE COBROS ADD CONSTRAINT PK_COBROS
    PRIMARY KEY (movimiento);

ALTER TABLE PAGOS ADD CONSTRAINT PK_PAGOS
    PRIMARY KEY (movimiento);


--Unicas
ALTER TABLE PERSONAS ADD CONSTRAINT UK_PERSONAS_CORREO
    UNIQUE (correo);

ALTER TABLE GARANTIAS ADD CONSTRAINT UK_GARANTIAS_DETALLE_ORDEN
    UNIQUE (servicio, item);

ALTER TABLE SEDES ADD CONSTRAINT UK_SEDES_TELEFONO
    UNIQUE (telefono);

ALTER TABLE PROVEEDORES ADD CONSTRAINT UK_PROVEEDORES_CORREO
    UNIQUE (correo);

ALTER TABLE PROVEEDORES ADD CONSTRAINT UK_PROVEEDORES_NUMERO_CONTACTO
    UNIQUE (numero_contacto);

ALTER TABLE COBROS ADD CONSTRAINT UK_COBROS_ORDEN
    UNIQUE (orden);

ALTER TABLE PAGOS ADD CONSTRAINT UK_PAGOS_COMPRA
    UNIQUE (compra);


--Foraneas

ALTER TABLE CLIENTES ADD CONSTRAINT FK_CLIENTES_PERSONA
    FOREIGN KEY (persona) REFERENCES PERSONAS(cedula)
    ON DELETE CASCADE;

ALTER TABLE EMPLEADOS ADD CONSTRAINT FK_EMPLEADOS_PERSONA
    FOREIGN KEY (persona) REFERENCES PERSONAS(cedula)
    ON DELETE CASCADE;

ALTER TABLE EMPLEADOS ADD CONSTRAINT FK_EMPLEADOS_SEDE
    FOREIGN KEY (sede) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE TECNICOS ADD CONSTRAINT FK_TECNICOS_EMPLEADO
    FOREIGN KEY (empleado) REFERENCES EMPLEADOS(persona)
    ON DELETE CASCADE;

ALTER TABLE AUTOMOVILES ADD CONSTRAINT FK_AUTOMOVILES_VEHICULO
    FOREIGN KEY (vehiculo) REFERENCES VEHICULOS(placa)
    ON DELETE CASCADE;

ALTER TABLE VEHICULOS ADD CONSTRAINT FK_VEHICULOS_CLIENTE
    FOREIGN KEY (cliente) REFERENCES CLIENTES(persona)
    ON DELETE RESTRICT;

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT FK_DETALLE_ORDENES_CATALOGO_SERVICIO
    FOREIGN KEY (catalogo_servicio) REFERENCES CATALOGO_SERVICIOS(codigo)
    ON DELETE RESTRICT;

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT FK_DETALLE_ORDENES_SERVICIO
    FOREIGN KEY (servicio) REFERENCES SERVICIOS(numero)
    ON DELETE CASCADE;

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT FK_DETALLE_ORDENES_TECNICO
    FOREIGN KEY (tecnico) REFERENCES TECNICOS(empleado)
    ON DELETE RESTRICT;

ALTER TABLE GARANTIAS ADD CONSTRAINT FK_GARANTIAS_DETALLE_ORDEN
    FOREIGN KEY (servicio, item) REFERENCES DETALLE_ORDENES(servicio, item)
    ON DELETE RESTRICT;

ALTER TABLE SERVICIOS ADD CONSTRAINT FK_SERVICIOS_VEHICULO
    FOREIGN KEY (vehiculo) REFERENCES VEHICULOS(placa)
    ON DELETE RESTRICT;

ALTER TABLE SERVICIOS ADD CONSTRAINT FK_SERVICIOS_SEDE
    FOREIGN KEY (sede) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE OFERTAS_SERVICIOS ADD CONSTRAINT FK_OFERTAS_SERVICIOS_CATALOGO_SERVICIO
    FOREIGN KEY (catalogo_servicio) REFERENCES CATALOGO_SERVICIOS(codigo)
    ON DELETE RESTRICT;

ALTER TABLE OFERTAS_SERVICIOS ADD CONSTRAINT FK_OFERTAS_SERVICIOS_SEDE
    FOREIGN KEY (sede) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE TRASLADOS ADD CONSTRAINT FK_TRASLADOS_SEDE_LLEGA
    FOREIGN KEY (sede_llega) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE TRASLADOS ADD CONSTRAINT FK_TRASLADOS_SEDE_SALE
    FOREIGN KEY (sede_sale) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE CONSUMOS ADD CONSTRAINT FK_CONSUMOS_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES REPUESTOS(serie)
    ON DELETE RESTRICT;

ALTER TABLE CONSUMOS ADD CONSTRAINT FK_CONSUMOS_DETALLE_ORDEN
    FOREIGN KEY (servicio, item) REFERENCES DETALLE_ORDENES(servicio, item)
    ON DELETE CASCADE;

ALTER TABLE SUMINISTROS ADD CONSTRAINT FK_SUMINISTROS_PROVEEDOR
    FOREIGN KEY (proveedor) REFERENCES PROVEEDORES(nit)
    ON DELETE RESTRICT;

ALTER TABLE SUMINISTROS ADD CONSTRAINT FK_SUMINISTROS_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES REPUESTOS(serie)
    ON DELETE RESTRICT;

ALTER TABLE COMPRAS ADD CONSTRAINT FK_COMPRAS_SEDE
    FOREIGN KEY (sede) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE COMPRAS ADD CONSTRAINT FK_COMPRAS_PROVEEDOR
    FOREIGN KEY (proveedor) REFERENCES PROVEEDORES(nit)
    ON DELETE RESTRICT;

ALTER TABLE DETALLE_COMPRAS ADD CONSTRAINT FK_DETALLE_COMPRAS_COMPRA
    FOREIGN KEY (compra) REFERENCES COMPRAS(numero)
    ON DELETE CASCADE;

ALTER TABLE DETALLE_COMPRAS ADD CONSTRAINT FK_DETALLE_COMPRAS_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES REPUESTOS(serie)
    ON DELETE RESTRICT;

ALTER TABLE COBROS ADD CONSTRAINT FK_COBROS_MOVIMIENTO
    FOREIGN KEY (movimiento) REFERENCES MOVIMIENTOS(numero)
    ON DELETE RESTRICT;

ALTER TABLE COBROS ADD CONSTRAINT FK_COBROS_ORDEN
    FOREIGN KEY (orden) REFERENCES SERVICIOS(numero)
    ON DELETE RESTRICT;

ALTER TABLE PAGOS ADD CONSTRAINT FK_PAGOS_MOVIMIENTO
    FOREIGN KEY (movimiento) REFERENCES MOVIMIENTOS(numero)
    ON DELETE RESTRICT;

ALTER TABLE PAGOS ADD CONSTRAINT FK_PAGOS_COMPRA
    FOREIGN KEY (compra) REFERENCES COMPRAS(numero)
    ON DELETE RESTRICT;

ALTER TABLE TRASLADOS ADD CONSTRAINT FK_TRASLADOS_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES REPUESTOS(serie)
    ON DELETE RESTRICT;





-- MecaData · Tuplas
ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_FECHAS
    CHECK (fecha_fin >= fecha_inicio);

ALTER TABLE SERVICIOS ADD CONSTRAINT CK_SERVICIOS_FECHAS
    CHECK (fecha_fin >= fecha_inicio);

ALTER TABLE TRASLADOS ADD CONSTRAINT CK_TRASLADOS_SEDES
    CHECK (sede_sale <> sede_llega);

ALTER TABLE SERVICIOS ADD CONSTRAINT CK_SERVICIOS_ESTADO_FECHA_FIN
    CHECK (estado <> 'F' OR fecha_fin IS NOT NULL);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_ESTADO_FECHA_FIN
    CHECK (estado <> 'F' OR fecha_fin IS NOT NULL);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_ESTADO_TECNICO
    CHECK (estado <> 'F' OR (tecnico IS NOT NULL AND horas_trabajadas IS NOT NULL));

ALTER TABLE GARANTIAS ADD CONSTRAINT CK_GARANTIAS_FECHAS
    CHECK (fecha_fin >= fecha_inicio);

--XTablas
/*
DROP TABLE IF EXISTS PAGOS;
DROP TABLE IF EXISTS COBROS;
DROP TABLE IF EXISTS MOVIMIENTOS;
DROP TABLE IF EXISTS DETALLE_COMPRAS;
DROP TABLE IF EXISTS COMPRAS;
DROP TABLE IF EXISTS SUMINISTROS;
DROP TABLE IF EXISTS CONSUMOS;
DROP TABLE IF EXISTS TRASLADOS;
DROP TABLE IF EXISTS GARANTIAS;
DROP TABLE IF EXISTS DETALLE_ORDENES;
DROP TABLE IF EXISTS SERVICIOS;
DROP TABLE IF EXISTS AUTOMOVILES;
DROP TABLE IF EXISTS VEHICULOS;
DROP TABLE IF EXISTS CLIENTES;
DROP TABLE IF EXISTS OFERTAS_SERVICIOS;
DROP TABLE IF EXISTS TECNICOS;
DROP TABLE IF EXISTS EMPLEADOS;
DROP TABLE IF EXISTS PROVEEDORES;
DROP TABLE IF EXISTS REPUESTOS;
DROP TABLE IF EXISTS CATALOGO_SERVICIOS;
DROP TABLE IF EXISTS SEDES;
DROP TABLE IF EXISTS PERSONAS;

DROP DOMAIN IF EXISTS T_PLACA;
DROP DOMAIN IF EXISTS T_CORREO;
DROP DOMAIN IF EXISTS T_TELEFONO;
DROP DOMAIN IF EXISTS T_CARGO;
DROP DOMAIN IF EXISTS T_ESTADO_ORDEN;
DROP DOMAIN IF EXISTS T_ESTADO_GARANTIA;
DROP DOMAIN IF EXISTS T_ESTADO_MOVIMIENTO;
DROP DOMAIN IF EXISTS T_MEDIO_PAGO;
DROP DOMAIN IF EXISTS T_MONEDA;
DROP DOMAIN IF EXISTS T_NUMERO_ORDEN;
*/


--DISPARADOERS

    --Valores por omision
ALTER TABLE SERVICIOS ALTER COLUMN fecha_inicio SET DEFAULT CURRENT_DATE;
ALTER TABLE SERVICIOS ALTER COLUMN estado SET DEFAULT 'E'; --E: En proceso

--Consecutivo del numero de la orden (OSAA-########) con secuencia.
CREATE SEQUENCE SQ_SERVICIOS_numero OWNED BY SERVICIOS.numero;
SELECT setval('SQ_SERVICIOS_numero',
                (SELECT COALESCE(MAX(SPLIT_PART(numero, '-', 2)::INTEGER), 0) + 1 FROM SERVICIOS), false);
ALTER TABLE SERVICIOS ALTER COLUMN numero SET DEFAULT
    'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-' || LPAD(nextval('SQ_SERVICIOS_numero')::TEXT, 8, '0');

    --Adicionar

--Al crear un servicio, su fecha de inicio no puede ser futura.
CREATE OR REPLACE FUNCTION fc_tg_1_SERVICIOS_bi() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.fecha_inicio > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de inicio del servicio no puede ser futura';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_SERVICIOS_bi
    BEFORE INSERT ON SERVICIOS 
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_SERVICIOS_bi();


    --Modificar
--Los datos de los servicios finalizados o cancelados no se pueden modificar y la fecha de inicio no puede quedar en el futuro.
CREATE OR REPLACE FUNCTION fc_tg_1_SERVICIOS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF OLD.estado = 'F' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios finalizados';
    END IF;

    IF OLD.estado = 'C' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios cancelados';
    END IF;

    IF NEW.fecha_inicio > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de inicio del servicio no puede ser futura';
    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_SERVICIOS_bu
    BEFORE UPDATE ON SERVICIOS 
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_SERVICIOS_bu();


--Actualizar el valor de fecha final cuando el servicio se declara finalizado
CREATE OR REPLACE FUNCTION fc_tg_2_SERVICIOS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.estado = 'F' AND OLD.estado <> 'F' THEN 
        NEW.fecha_fin := CAST(NOW() AS DATE);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_2_SERVICIOS_bu 
    BEFORE UPDATE ON SERVICIOS 
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_2_SERVICIOS_bu();


--Al cancelar un servicio, sus detalles de orden en proceso tambien quedan cancelados.
CREATE OR REPLACE FUNCTION fc_tg_1_SERVICIOS_au() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.estado = 'C' AND OLD.estado <> 'C' THEN
        UPDATE DETALLE_ORDENES
        SET estado = 'C'
        WHERE servicio = NEW.numero AND estado = 'E';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_SERVICIOS_au
    AFTER UPDATE ON SERVICIOS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_SERVICIOS_au();


    --Eliminar
--No se permiten eliminar los serivicios realizados de la base de datos pero si los cancelados
CREATE OR REPLACE FUNCTION fc_tg_2_SERVICIOS_bd() RETURNS TRIGGER AS
$$
BEGIN
    IF OLD.estado IN ('F','E') THEN
    RAISE EXCEPTION 'No se permiten eliminar los servicios realizados de la base datos';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_2_SERVICIOS_bd
    BEFORE DELETE ON SERVICIOS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_2_SERVICIOS_bd();


    --XDisparadores
-- ALTER TABLE SERVICIOS ALTER COLUMN fecha_inicio DROP DEFAULT;
-- ALTER TABLE SERVICIOS ALTER COLUMN estado DROP DEFAULT;
-- ALTER TABLE SERVICIOS ALTER COLUMN numero DROP DEFAULT;
-- DROP SEQUENCE IF EXISTS SQ_SERVICIOS_numero;

-- DROP TRIGGER IF EXISTS tg_1_SERVICIOS_bi ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_1_SERVICIOS_bu ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_2_SERVICIOS_bu ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_1_SERVICIOS_au ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_2_SERVICIOS_bd ON SERVICIOS;

-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bi();
-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bu();
-- DROP FUNCTION IF EXISTS fc_tg_2_SERVICIOS_bu();
-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_au();
-- DROP FUNCTION IF EXISTS fc_tg_2_SERVICIOS_bd();

--Vistas
--Inventario: unidades disponibles de cada repuesto en cada sede.
--se calcula como = cantidad = compras + traslados que llegan - traslados que salen - consumos
CREATE VIEW INVENTARIO AS
SELECT  m.sede,
        m.repuesto,
        SUM(m.cantidad) AS cantidad
FROM (
    SELECT c.sede, dc.repuesto, dc.cantidad
    FROM DETALLE_COMPRAS dc
    JOIN COMPRAS c ON c.numero = dc.compra
    UNION ALL
    SELECT t.sede_llega, t.repuesto, t.cantidad
    FROM TRASLADOS t
    UNION ALL
    SELECT t.sede_sale, t.repuesto, -t.cantidad
    FROM TRASLADOS t
    UNION ALL
    SELECT s.sede, co.repuesto, -co.cantidad
    FROM CONSUMOS co
    JOIN SERVICIOS s ON s.numero = co.servicio
) m
GROUP BY m.sede, m.repuesto;

    --XVistas
-- DROP VIEW IF EXISTS INVENTARIO;

-- MecaData PoblarOK
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543'),
    ('3030303030', 'Sofia', 'Martinez', 'sofia.martinez@mail.com', '3112223344'),
    ('5050505050', 'Camila', 'Torres', 'camila.torres@mail.com', '3125556677'),
    ('6060606060', 'Jorge', 'Ramirez', 'jorge.ramirez@mail.com', '3138889900'),
    ('7070707070', 'Pedro', 'Castro', 'pedro.castro@mail.com', '3141112233'),
    ('8080808080', 'Laura', 'Moreno', 'laura.moreno@mail.com', '3154443322');

INSERT INTO CLIENTES (fecha_registro, persona) VALUES
    ('2024-01-15', '1010101010'),
    ('2025-06-10', '7070707070');

INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010'),
    ('DEF456', 82000, 'Chevrolet', 2017, 1400, 'Gris', '1010101010'),
    ('GHI789', 15000, 'Renault', 2023, 1600, 'Blanco', '7070707070');

INSERT INTO AUTOMOVILES (vehiculo, numero_puertas) VALUES
    ('ABC123', 4),
    ('DEF456', 5),
    ('GHI789', 4);

INSERT INTO SEDES (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321');

INSERT INTO EMPLEADOS (cargo, fecha_ingreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 3500000.00, '2020202020', 'S01'),
    ('G', '2021-01-10', 8000000.00, '3030303030', 'S01'),
    ('T', '2022-05-16', 4200000.00, '5050505050', 'S01'),
    ('T', '2024-02-01', 3300000.00, '6060606060', 'S02'),
    ('G', '2020-08-03', 7800000.00, '8080808080', 'S02');

INSERT INTO TECNICOS (especialidad, empleado) VALUES
    ('Motor', '2020202020'),
    ('Alineacion', '5050505050'),
    ('Frenos', '6060606060');

INSERT INTO CATALOGO_SERVICIOS (codigo, nombre, descripcion, precio_base, tiempo_medio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.5),
    ('CS02', 'Revision de frenos', 'Revision y cambio de pastillas de freno', 220000.00, 2),
    ('CS03', 'Alineacion y balanceo', 'Alineacion de direccion y balanceo de llantas', 90000.00, 1);

INSERT INTO OFERTAS_SERVICIOS (habilitado, precio_local, catalogo_servicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01'),
    (TRUE, NULL, 'CS02', 'S01'),
    (FALSE, 95000.00, 'CS03', 'S01'),
    (TRUE, 155000.00, 'CS01', 'S02'),
    (TRUE, 230000.00, 'CS02', 'S02');

INSERT INTO REPUESTOS (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite'),
    ('R002', 'Freno', 'Pastillas de freno');

INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('OS26-00000001', '2026-11-03', NULL, 'E', 'ABC123', 'S01'),
    ('OS26-00000002', '2026-09-14', '2026-09-15', 'F', 'DEF456', 'S01'),
    ('OS26-00000003', '2026-10-05', '2026-10-06', 'F', 'GHI789', 'S02'),
    ('OS26-00000004', '2026-10-20', NULL, 'C', 'GHI789', 'S02');

SELECT setval('SQ_SERVICIOS_numero',
              (SELECT COALESCE(MAX(SPLIT_PART(numero, '-', 2)::INTEGER), 0) + 1 FROM SERVICIOS), false);

INSERT INTO DETALLE_ORDENES (item, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio, tecnico, horas_trabajadas) VALUES
    (1, 160000.00, 'E', '2026-11-03', NULL, 'CS01', 'OS26-00000001', '2020202020', 1.5),
    (1, 220000.00, 'F', '2026-09-14', '2026-09-15', 'CS02', 'OS26-00000002', '2020202020', 2),
    (1, 230000.00, 'F', '2026-10-05', '2026-10-06', 'CS02', 'OS26-00000003', '6060606060', 2.5);

INSERT INTO CONSUMOS (cantidad, fecha_uso, precio, repuesto, servicio, item) VALUES
    (1, '2026-11-03', 25000.00, 'R001', 'OS26-00000001', 1),
    (2, '2026-09-14', 60000.00, 'R002', 'OS26-00000002', 1),
    (2, '2026-10-05', 62000.00, 'R002', 'OS26-00000003', 1);

INSERT INTO GARANTIAS (numero, fecha_inicio, fecha_fin, condiciones, estado, servicio, item) VALUES
    ('G01', '2026-09-15', '2027-03-15', 'Cubre desgaste prematuro de pastillas durante 6 meses', 'V', 'OS26-00000002', 1),
    ('G02', '2026-10-06', '2027-01-06', 'Cubre ruidos en el sistema de frenos durante 3 meses', 'V', 'OS26-00000003', 1);

INSERT INTO TRASLADOS (numero, cantidad, fecha, detalle, sede_llega, sede_sale, repuesto) VALUES
    ('TR01', 5, '2024-04-01', 'Reposicion de filtros', 'S02', 'S01', 'R001');

INSERT INTO PROVEEDORES (nit, correo, numero_contacto, representante, nombre) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS'),
    ('900654321', 'contacto@frenosya.com', '6015551111', 'Marta Diaz', 'Frenos Ya LTDA');

INSERT INTO SUMINISTROS (precio_referencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001'),
    (45000.00, '900654321', 'R002');

INSERT INTO COMPRAS (numero, fecha, sede, proveedor) VALUES
    ('C01', '2024-03-20', 'S01', '900123456'),
    ('C02', '2025-02-11', 'S02', '900654321'),
    ('C03', '2026-08-20', 'S01', '900654321');

INSERT INTO DETALLE_COMPRAS (cantidad, precio_unidad, compra, repuesto) VALUES
    (30, 20000.00, 'C01', 'R001'),
    (10, 45000.00, 'C02', 'R002'),
    (10, 45000.00, 'C03', 'R002');

INSERT INTO MOVIMIENTOS (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', '2026-09-15', 340000.00, 'Cobro orden de servicio DEF456', 'P'),
    ('M02', '2024-03-25', 600000.00, 'Pago compra C01', 'P'),
    ('M03', '2026-10-06', 354000.00, 'Cobro orden de servicio GHI789', 'P'),
    ('M04', '2025-02-15', 450000.00, 'Pago compra C02', 'P'),
    ('M05', '2026-08-25', 450000.00, 'Pago compra C03', 'P');

INSERT INTO COBROS (movimiento, medio_pago, fecha_expedido, orden) VALUES
    ('M01', 'T', '2026-09-15', 'OS26-00000002'),
    ('M03', 'E', '2026-10-06', 'OS26-00000003');

INSERT INTO PAGOS (movimiento, fecha_pago, compra) VALUES
    ('M02', '2024-03-25', 'C01'),
    ('M04', '2025-02-15', 'C02'),
    ('M05', '2026-08-25', 'C03');


--PoblarNoOK
/*
-- Tipo: kilometraje es int, no acepta texto
INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('XYZ999', 'mucho', 'Renault', 2019, 1600, 'Azul', '1010101010');

-- Nulidad: toda persona debe tener nombre
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('4040404040', NULL, 'Rojas', 'sin.nombre@mail.com', '3201112233');

-- PK: no puede haber dos personas con la misma cedula
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Maria', 'Diaz', 'maria.diaz@mail.com', '3154445566');

-- UK: no puede haber dos personas con el mismo correo
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('4040404040', 'Pedro', 'Lopez', 'ana.gomez@mail.com', '3167778899');

-- FK: un vehiculo solo puede pertenecer a un cliente existente
INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('XYZ999', 30000, 'Renault', 2019, 1600, 'Azul', '9999999999');

-- Dominio: el numero de orden debe tener formato OSAA-########
INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('ORDEN1', '2026-06-01', NULL, 'E', 'ABC123', 'S01');

-- Dominio: estado de orden solo acepta F, E o C
INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('OS26-00000099', '2026-06-01', NULL, 'Z', 'ABC123', 'S01');

-- FK: el tecnico de un detalle de orden debe ser un tecnico existente
INSERT INTO DETALLE_ORDENES (item, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio, tecnico, horas_trabajadas) VALUES
    (2, 150000.00, 'E', '2026-11-03', NULL, 'CS01', 'OS26-00000001', '9999999999', NULL);

-- Nulidad: toda garantia debe tener fecha de fin
INSERT INTO GARANTIAS (numero, fecha_inicio, fecha_fin, condiciones, estado, servicio, item) VALUES
    ('G04', '2026-06-01', NULL, 'Sin fecha de fin', 'V', 'OS26-00000001', 1);
*/

--XPoblar
/*
TRUNCATE TABLE PAGOS, COBROS, MOVIMIENTOS, DETALLE_COMPRAS, COMPRAS, SUMINISTROS, PROVEEDORES,
                CONSUMOS, TRASLADOS, REPUESTOS, GARANTIAS, DETALLE_ORDENES, SERVICIOS,
                OFERTAS_SERVICIOS, CATALOGO_SERVICIOS, TECNICOS, EMPLEADOS, SEDES,
                AUTOMOVILES, VEHICULOS, CLIENTES, PERSONAS
    RESTART IDENTITY;
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
FROM COBROS c
JOIN MOVIMIENTOS m ON m.numero = c.movimiento
JOIN SERVICIOS s ON s.numero = c.orden
JOIN VEHICULOS v ON v.placa = s.vehiculo
JOIN PERSONAS p ON p.cedula = v.cliente
WHERE m.estado = 'P' AND m.fecha BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY p.cedula, p.nombre, p.apellido
ORDER BY totalCobrado DESC;



-- Consultas operativas
    -- Servicios en proceso
SELECT  s.numero,
        s.vehiculo AS placa,
        p.nombre,
        p.apellido,
        s.fecha_inicio
FROM SERVICIOS s
JOIN VEHICULOS v ON v.placa = s.vehiculo
JOIN PERSONAS p ON p.cedula = v.cliente
JOIN EMPLEADOS e ON e.sede = s.sede
WHERE s.estado = 'E' AND e.cargo = 'G' AND e.persona = '3030303030'
ORDER BY s.fecha_inicio ASC;

    -- Saber que servivios presta una sede
SELECT  cs.codigo,
        cs.nombre,
        COALESCE(p.precio_local, cs.precio_base) AS precio,
        cs.tiempo_medio
FROM EMPLEADOS e
JOIN OFERTAS_SERVICIOS p ON p.sede = e.sede
JOIN CATALOGO_SERVICIOS cs ON cs.codigo = p.catalogo_servicio
WHERE e.persona = '3030303030' AND e.cargo = 'G' AND p.habilitado = TRUE
ORDER BY cs.nombre;

    -- Consultar cantidad de un repuesto
SELECT  r.serie,
        r.nombre,
        se.numero AS sede,
        se.nombre AS nombreSede,
        i.cantidad
FROM INVENTARIO i
JOIN REPUESTOS r ON r.serie = i.repuesto
JOIN SEDES se ON se.numero = i.sede
WHERE r.nombre = 'Filtro de aceite'
ORDER BY i.cantidad ASC;

    -- Historial de servicios del técnico
SELECT  s.numero,
        d.fecha_fin AS fechaCierre,
        s.vehiculo AS placa,
        cs.nombre AS servicio,
        d.estado
FROM DETALLE_ORDENES d
JOIN SERVICIOS s ON s.numero = d.servicio
JOIN CATALOGO_SERVICIOS cs ON cs.codigo = d.catalogo_servicio
WHERE d.tecnico = '2020202020' AND d.fecha_fin BETWEEN DATE '2026-01-01' AND DATE '2026-12-31'
ORDER BY d.fecha_fin DESC;

    -- Procedimientos previos de un vehiculo
SELECT  d.fecha_inicio AS fecha,
        s.sede,
        s.numero AS numeroOrden,
        cs.nombre AS servicio,
        r.nombre AS repuestoUsado
FROM SERVICIOS s
JOIN DETALLE_ORDENES d ON d.servicio = s.numero
JOIN CATALOGO_SERVICIOS cs ON cs.codigo = d.catalogo_servicio
LEFT JOIN CONSUMOS co ON co.servicio = d.servicio AND co.item = d.item
LEFT JOIN REPUESTOS r ON r.serie = co.repuesto
WHERE s.vehiculo = 'DEF456'
ORDER BY d.fecha_inicio DESC;

    -- Tecnicos sin servicio asignado
SELECT  p.cedula AS cedulaTecnico,
        p.nombre AS nombreTecnico,
        p.apellido AS apellidoTecnico,
        t.especialidad AS especialidadTecnico,
        p.telefono AS telefonoTecnico
FROM TECNICOS t
JOIN EMPLEADOS e ON t.empleado = e.persona
JOIN PERSONAS p ON e.persona = p.cedula
WHERE e.sede = (SELECT g.sede FROM EMPLEADOS g WHERE g.persona = '3030303030' AND g.cargo = 'G')
    AND NOT EXISTS (
        SELECT 1
        FROM DETALLE_ORDENES det
        WHERE det.tecnico = t.empleado AND det.estado = 'E'
    )
ORDER BY  t.especialidad ASC, p.nombre ASC;

    -- La información de contacto de los gerentes
SELECT  s.numero AS numeroSede,
        s.nombre AS nombreSede,
        p.nombre AS nombreGerente,
        p.apellido AS apellidoGerente,
        p.correo AS correoGerente,
        p.telefono AS telefonoGerente
FROM SEDES s
JOIN EMPLEADOS e ON e.sede = s.numero
JOIN PERSONAS p ON p.cedula = e.persona
WHERE e.cargo = 'G'
    AND e.sede <> (SELECT g.sede FROM EMPLEADOS g WHERE g.persona = '3030303030' AND g.cargo = 'G')
ORDER BY s.nombre ASC;

    -- Consultar estado de un ser
SELECT  s.numero AS numeroOrden,
        s.sede AS sede,
        det.fecha_inicio AS fechaInicio,
        cat.nombre AS servicioRealizado,
        det.estado AS estadoServicio
FROM SERVICIOS s
JOIN VEHICULOS v ON v.placa = s.vehiculo
JOIN DETALLE_ORDENES det ON det.servicio = s.numero
JOIN CATALOGO_SERVICIOS cat ON cat.codigo = det.catalogo_servicio
WHERE v.cliente = '1010101010' AND v.placa = 'ABC123' AND s.estado = 'E'
ORDER BY det.fecha_inicio ASC;

    -- Consultar las garantias vigentes
SELECT  g.numero,
        v.placa,
        cat.nombre,
        g.fecha_inicio,
        g.fecha_fin,
        g.condiciones
FROM GARANTIAS g, VEHICULOS v, CATALOGO_SERVICIOS cat, DETALLE_ORDENES det, SERVICIOS s
WHERE g.servicio = det.servicio
    AND g.item = det.item
    AND v.placa = s.vehiculo
    AND det.catalogo_servicio = cat.codigo
    AND det.servicio = s.numero
    AND v.cliente = '1010101010'
    AND g.estado = 'V'
ORDER BY g.fecha_inicio DESC;