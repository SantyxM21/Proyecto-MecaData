--Dominios
CREATE DOMAIN T_PLACA AS VARCHAR(6)
    CHECK (VALUE ~ '^[A-Z]{3}[0-9]{3}$');

CREATE DOMAIN T_CORREO AS VARCHAR(50)
    CHECK (VALUE LIKE ('%@%.%'));

CREATE DOMAIN T_TELEFONO AS VARCHAR(15)
    CHECK (VALUE ~ '^[0-9]{7,15}$');

CREATE DOMAIN T_CARGO AS CHAR(1)
    CHECK (VALUE IN ('G','I','T','A'));

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

CREATE TABLE TRABAJA(
    horas_trabajadas NUMERIC NOT NULL,
    tecnico VARCHAR(15) NOT NULL,
    detalle_orden VARCHAR(10) NOT NULL
);

CREATE TABLE DETALLE_ORDENES(
    id VARCHAR(10) NOT NULL,
    valor_cobrado T_MONEDA,
    estado T_ESTADO_ORDEN NOT NULL, 
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    catalogo_servicio VARCHAR(10) NOT NULL,
    servicio T_NUMERO_ORDEN NOT NULL
);

CREATE TABLE GARANTIAS(
    numero VARCHAR(10) NOT NULL,
    fecha_inicio DATE NOT NULL,
    condiciones VARCHAR(200) NOT NULL,
    estado T_ESTADO_GARANTIA NOT NULL, 
    detalle_orden VARCHAR(10) NOT NULL 
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

CREATE TABLE PRESTA(
    disponible BOOLEAN NOT NULL, 
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

CREATE TABLE INVENTARIO(
    cantidad INTEGER NOT NULL,
    sede VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
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

CREATE TABLE CONSUMO_REPUESTO(
    cantidad INTEGER NOT NULL,
    fecha_uso DATE NOT NULL,
    precio T_MONEDA NOT NULL,
    repuesto VARCHAR(20) NOT NULL, 
    detalle_orden VARCHAR(10) NOT NULL
);

CREATE TABLE SUMINISTRA(
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
    id VARCHAR(10) NOT NULL,
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

ALTER TABLE PRESTA ADD CONSTRAINT CK_PRESTA_PRECIO_LOCAL
    CHECK (precio_local > 0);

ALTER TABLE TRABAJA ADD CONSTRAINT CK_TRABAJA_HORAS_TRABAJADAS
    CHECK (horas_trabajadas > 0);

ALTER TABLE INVENTARIO ADD CONSTRAINT CK_INVENTARIO_CANTIDAD
    CHECK (cantidad >= 0);

ALTER TABLE TRASLADOS ADD CONSTRAINT CK_TRASLADOS_CANTIDAD
    CHECK (cantidad > 0);

ALTER TABLE CONSUMO_REPUESTO ADD CONSTRAINT CK_CONSUMO_REPUESTO_CANTIDAD
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

ALTER TABLE TRABAJA ADD CONSTRAINT PK_TRABAJA
    PRIMARY KEY (tecnico, detalle_orden);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT PK_DETALLE_ORDENES
    PRIMARY KEY (id);  

ALTER TABLE GARANTIAS ADD CONSTRAINT PK_GARANTIAS
    PRIMARY KEY (numero);

ALTER TABLE SERVICIOS ADD CONSTRAINT PK_SERVICIOS
    PRIMARY KEY (numero);

ALTER TABLE CATALOGO_SERVICIOS ADD CONSTRAINT PK_CATALOGO_SERVICIOS
    PRIMARY KEY (codigo);

ALTER TABLE PRESTA ADD CONSTRAINT PK_PRESTA
    PRIMARY KEY (catalogo_servicio, sede);

ALTER TABLE SEDES ADD CONSTRAINT PK_SEDES
    PRIMARY KEY (numero);

ALTER TABLE INVENTARIO ADD CONSTRAINT PK_INVENTARIO
    PRIMARY KEY (sede, repuesto);

ALTER TABLE REPUESTOS ADD CONSTRAINT PK_REPUESTOS
    PRIMARY KEY (serie);

ALTER TABLE TRASLADOS ADD CONSTRAINT PK_TRASLADOS
    PRIMARY KEY (numero);

ALTER TABLE CONSUMO_REPUESTO ADD CONSTRAINT PK_CONSUMO_REPUESTO
    PRIMARY KEY (repuesto, detalle_orden);

ALTER TABLE SUMINISTRA ADD CONSTRAINT PK_SUMINISTRA
    PRIMARY KEY (proveedor, repuesto);

ALTER TABLE PROVEEDORES ADD CONSTRAINT PK_PROVEEDORES
    PRIMARY KEY (nit);

ALTER TABLE COMPRAS ADD CONSTRAINT PK_COMPRAS
    PRIMARY KEY (numero);

ALTER TABLE DETALLE_COMPRAS ADD CONSTRAINT PK_DETALLE_COMPRAS
    PRIMARY KEY (id);

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
    UNIQUE (detalle_orden);

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

ALTER TABLE TRABAJA ADD CONSTRAINT FK_TRABAJA_TECNICO
    FOREIGN KEY (tecnico) REFERENCES TECNICOS(empleado)
    ON DELETE RESTRICT;

ALTER TABLE TRABAJA ADD CONSTRAINT FK_TRABAJA_DETALLE_ORDEN
    FOREIGN KEY (detalle_orden) REFERENCES DETALLE_ORDENES(id)
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

ALTER TABLE GARANTIAS ADD CONSTRAINT FK_GARANTIAS_DETALLE_ORDEN
    FOREIGN KEY (detalle_orden) REFERENCES DETALLE_ORDENES(id)
    ON DELETE RESTRICT;

ALTER TABLE SERVICIOS ADD CONSTRAINT FK_SERVICIOS_VEHICULO
    FOREIGN KEY (vehiculo) REFERENCES VEHICULOS(placa)
    ON DELETE RESTRICT;

ALTER TABLE SERVICIOS ADD CONSTRAINT FK_SERVICIOS_SEDE
    FOREIGN KEY (sede) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE PRESTA ADD CONSTRAINT FK_PRESTA_CATALOGO_SERVICIO
    FOREIGN KEY (catalogo_servicio) REFERENCES CATALOGO_SERVICIOS(codigo)
    ON DELETE RESTRICT;

ALTER TABLE PRESTA ADD CONSTRAINT FK_PRESTA_SEDE
    FOREIGN KEY (sede) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE INVENTARIO ADD CONSTRAINT FK_INVENTARIO_SEDE
    FOREIGN KEY (sede) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE INVENTARIO ADD CONSTRAINT FK_INVENTARIO_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES REPUESTOS(serie)
    ON DELETE RESTRICT;

ALTER TABLE TRASLADOS ADD CONSTRAINT FK_TRASLADOS_SEDE_LLEGA
    FOREIGN KEY (sede_llega) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE TRASLADOS ADD CONSTRAINT FK_TRASLADOS_SEDE_SALE
    FOREIGN KEY (sede_sale) REFERENCES SEDES(numero)
    ON DELETE RESTRICT;

ALTER TABLE CONSUMO_REPUESTO ADD CONSTRAINT FK_CONSUMO_REPUESTO_REPUESTO
    FOREIGN KEY (repuesto) REFERENCES REPUESTOS(serie)
    ON DELETE RESTRICT;

ALTER TABLE CONSUMO_REPUESTO ADD CONSTRAINT FK_CONSUMO_REPUESTO_DETALLE_ORDEN
    FOREIGN KEY (detalle_orden) REFERENCES DETALLE_ORDENES(id)
    ON DELETE CASCADE;

ALTER TABLE SUMINISTRA ADD CONSTRAINT FK_SUMINISTRA_PROVEEDOR
    FOREIGN KEY (proveedor) REFERENCES PROVEEDORES(nit)
    ON DELETE RESTRICT;

ALTER TABLE SUMINISTRA ADD CONSTRAINT FK_SUMINISTRA_REPUESTO
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

--XTablas
/*
DROP TABLE IF EXISTS PAGOS;
DROP TABLE IF EXISTS COBROS;
DROP TABLE IF EXISTS MOVIMIENTOS;
DROP TABLE IF EXISTS DETALLE_COMPRAS;
DROP TABLE IF EXISTS COMPRAS;
DROP TABLE IF EXISTS SUMINISTRA;
DROP TABLE IF EXISTS CONSUMO_REPUESTO;
DROP TABLE IF EXISTS TRASLADOS;
DROP TABLE IF EXISTS INVENTARIO;
DROP TABLE IF EXISTS GARANTIAS;
DROP TABLE IF EXISTS TRABAJA;
DROP TABLE IF EXISTS DETALLE_ORDENES;
DROP TABLE IF EXISTS SERVICIOS;
DROP TABLE IF EXISTS AUTOMOVILES;
DROP TABLE IF EXISTS VEHICULOS;
DROP TABLE IF EXISTS CLIENTES;
DROP TABLE IF EXISTS PRESTA;
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

    --Adicionar

--Al crear un servicio, se coloca automáticamente su numero, fecha de inicio y estado (En proceso).
CREATE OR REPLACE FUNCTION fc_tg_1_SERVICIOS_bi() RETURNS TRIGGER AS
$$
DECLARE
    consecutivo_id INTEGER;
    anno_actual CHAR(2);
BEGIN
    --Consecutivo
    SELECT COALESCE(MAX(SPLIT_PART(numero, '-', 2)::INTEGER), 0) + 1 INTO consecutivo_id FROM SERVICIOS;
    SELECT TO_CHAR(NOW(), 'YY') INTO anno_actual;
    NEW.numero := 'OS' || anno_actual || '-' || LPAD(consecutivo_id::TEXT, 8, '0');

    --fecha actual
    NEW.fecha_inicio := CAST(NOW() AS DATE);

    --estado inicial 
    NEW.estado := 'E';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_SERVICIOS_bi
    BEFORE INSERT ON SERVICIOS 
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_SERVICIOS_bi();


    --Modificar
--Los datos de los servicios finalizados o cancelados no se pueden modificar. 
CREATE OR REPLACE FUNCTION fc_tg_1_SERVICIOS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF OLD.estado = 'F' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios finalizados';
    END IF;

    IF OLD.estado = 'C' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios cancelados';
    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_SERVICIOS_bu
    BEFORE UPDATE ON SERVICIOS 
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_SERVICIOS_bu();


--La cantidad en el inventario de los repuestos gastados disminuye automaticamente.
CREATE OR REPLACE FUNCTION fc_tg_1_CONSUMO_REPUESTO_ai() RETURNS TRIGGER AS
$$
DECLARE
    sede_repuesto VARCHAR(5);
BEGIN
    SELECT s.sede INTO sede_repuesto
    FROM DETALLE_ORDENES d, SERVICIOS s
    WHERE s.numero = d.servicio AND d.id = NEW.detalle_orden;

    UPDATE INVENTARIO 
        SET cantidad = cantidad - NEW.cantidad
        WHERE sede = sede_repuesto AND repuesto = NEW.repuesto;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_CONSUMO_REPUESTO_ai
    AFTER INSERT ON CONSUMO_REPUESTO
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_CONSUMO_REPUESTO_ai();



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
DROP TRIGGER IF EXISTS tg_1_SERVICIOS_bi ON SERVICIOS;
DROP TRIGGER IF EXISTS tg_1_SERVICIOS_bu ON SERVICIOS;
DROP TRIGGER IF EXISTS tg_1_CONSUMO_REPUESTO_ai ON CONSUMO_REPUESTO;
DROP TRIGGER IF EXISTS tg_2_SERVICIOS_bu ON SERVICIOS;
DROP TRIGGER IF EXISTS tg_2_SERVICIOS_bd ON SERVICIOS;

DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bi();
DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bu();
DROP FUNCTION IF EXISTS fc_tg_1_CONSUMO_REPUESTO_ai();
DROP FUNCTION IF EXISTS fc_tg_2_SERVICIOS_bu();
DROP FUNCTION IF EXISTS fc_tg_2_SERVICIOS_bd();

--PoblarOK
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543');

INSERT INTO CLIENTES (fecha_registro, persona) VALUES
    ('2024-01-15', '1010101010');

INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010');

INSERT INTO AUTOMOVILES (vehiculo, numero_puertas) VALUES
    ('ABC123', 4);

INSERT INTO SEDES (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321');

INSERT INTO EMPLEADOS (cargo, fecha_ingreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 3500000.00, '2020202020', 'S01');

INSERT INTO TECNICOS (especialidad, empleado) VALUES
    ('Motor', '2020202020');

INSERT INTO CATALOGO_SERVICIOS (codigo, nombre, descripcion, precio_base, tiempo_medio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.5);

INSERT INTO PRESTA (disponible, precio_local, catalogo_servicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01');
INSERT INTO SERVICIOS (vehiculo, sede) VALUES
    ('ABC123', 'S01');

INSERT INTO DETALLE_ORDENES (id, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio) VALUES
    ('DO01', 160000.00, 'E', CURRENT_DATE, NULL, 'CS01', 'OS26-00000001');

INSERT INTO TRABAJA (horas_trabajadas, tecnico, detalle_orden) VALUES
    (1.5, '2020202020', 'DO01');

INSERT INTO GARANTIAS (numero, fecha_inicio, condiciones, estado, detalle_orden) VALUES
    ('G01', CURRENT_DATE, 'Cubre fugas durante 3 meses', 'V', 'DO01');

INSERT INTO REPUESTOS (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite');

INSERT INTO INVENTARIO (cantidad, sede, repuesto) VALUES
    (20, 'S01', 'R001');

INSERT INTO TRASLADOS (numero, cantidad, fecha, detalle, sede_llega, sede_sale, repuesto) VALUES
    ('TR01', 5, '2024-04-01', 'Reposicion de filtros', 'S02', 'S01', 'R001');

INSERT INTO CONSUMO_REPUESTO (cantidad, fecha_uso, precio, repuesto, detalle_orden) VALUES
    (1, CURRENT_DATE, 25000.00, 'R001', 'DO01');

INSERT INTO PROVEEDORES (nit, correo, numero_contacto, representante, nombre) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS');

INSERT INTO SUMINISTRA (precio_referencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001');

INSERT INTO COMPRAS (numero, fecha, sede, proveedor) VALUES
    ('C01', '2024-03-20', 'S01', '900123456');

INSERT INTO DETALLE_COMPRAS (id, cantidad, precio_unidad, compra, repuesto) VALUES
    ('DC01', 30, 20000.00, 'C01', 'R001');

INSERT INTO MOVIMIENTOS (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', CURRENT_DATE, 185000.00, 'Cobro orden OS26-00000001', 'P'),
    ('M02', '2024-03-25', 600000.00, 'Pago compra C01', 'P');

INSERT INTO COBROS (movimiento, medio_pago, fecha_expedido, orden) VALUES
    ('M01', 'T', CURRENT_DATE, 'OS26-00000001');

INSERT INTO PAGOS (movimiento, fecha_pago, compra) VALUES
    ('M02', '2024-03-25', 'C01');

--PoblarNoOK
/*
-- Tipo: kilometraje es int, no acepta texto
INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('XYZ999', 'mucho', 'Renault', 2019, 1600, 'Azul', '1010101010');

-- Nulidad: toda persona debe tener nombre
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('3030303030', NULL, 'Rojas', 'sin.nombre@mail.com', '3201112233');

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
    ('ORDEN1', '2024-06-01', NULL, 'E', 'ABC123', 'S01');

-- Dominio: estado de orden solo acepta F, E o C
INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('OS24-00000002', '2024-06-01', NULL, 'Z', 'ABC123', 'S01');

-- CHECK de atributo: el inventario no puede ser negativo
INSERT INTO INVENTARIO (cantidad, sede, repuesto) VALUES
    (-5, 'S02', 'R001');
*/

--XPoblar
/*
DELETE FROM PAGOS;
DELETE FROM COBROS;
DELETE FROM MOVIMIENTOS;
DELETE FROM DETALLE_COMPRAS;
DELETE FROM COMPRAS;
DELETE FROM SUMINISTRA;
DELETE FROM PROVEEDORES;
DELETE FROM CONSUMO_REPUESTO;
DELETE FROM TRASLADOS;
DELETE FROM INVENTARIO;
DELETE FROM REPUESTOS;
DELETE FROM GARANTIAS;
DELETE FROM TRABAJA;
DELETE FROM DETALLE_ORDENES;
DELETE FROM SERVICIOS;
DELETE FROM PRESTA;
DELETE FROM CATALOGO_SERVICIOS;
DELETE FROM TECNICOS;
DELETE FROM EMPLEADOS;
DELETE FROM SEDES;
DELETE FROM AUTOMOVILES;
DELETE FROM VEHICULOS;
DELETE FROM CLIENTES;
DELETE FROM PERSONAS;
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
WHERE m.estado = 'P' AND m.fecha BETWEEN '2024-01-01' AND '2024-12-31'
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
JOIN PRESTA p ON p.sede = e.sede
JOIN CATALOGO_SERVICIOS cs ON cs.codigo = p.catalogo_servicio
WHERE e.persona = '2020202020' AND e.cargo = 'A' AND p.disponible = TRUE
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
FROM TRABAJA t
JOIN DETALLE_ORDENES d ON d.id = t.detalle_orden
JOIN SERVICIOS s ON s.numero = d.servicio
JOIN CATALOGO_SERVICIOS cs ON cs.codigo = d.catalogo_servicio
WHERE t.tecnico = '2020202020' AND d.fecha_fin BETWEEN DATE '2024-01-01' AND DATE '2024-12-31'
ORDER BY d.fecha_fin DESC;

    -- Tecnicos sin servicio asignado
SELECT  p.cedula AS cedulaTecnico, 
        p.nombre AS nombreTecnico, 
        p.apellido AS apellidoTecnico, 
        t.especialidad AS especialidadTecnico, 
        p.telefono AS telefonoTecnico
FROM TECNICOS t 
JOIN EMPLEADOS e ON t.empleado = e.persona
JOIN PERSONAS p ON e.persona = p.cedula
WHERE t.empleado NOT IN (
    SELECT tra.tecnico
    FROM TRABAJA tra, DETALLE_ORDENES det
    WHERE tra.detalle_orden = det.id AND det.estado = 'E'
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
        g.condiciones
FROM GARANTIAS g, VEHICULOS v, CATALOGO_SERVICIOS cat, DETALLE_ORDENES det, SERVICIOS s
WHERE g.detalle_orden = det.id 
    AND v.placa = s.vehiculo 
    AND det.catalogo_servicio = cat.codigo 
    AND det.servicio = s.numero 
    AND v.cliente = '1010101010' 
    AND g.estado = 'V'
ORDER BY g.fecha_inicio DESC;