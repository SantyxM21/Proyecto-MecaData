-- Active: 1792113215779@@127.0.0.1@5432@prueba
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
    horas_trabajadas NUMERIC,
    diagnostico JSONB
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

--Estructura del diagnostico: objeto con sintomas (arreglo no vacio), hallazgos (texto)
--y, opcionalmente recomendaciones (arreglo)
ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_DIAGNOSTICO
    CHECK (diagnostico IS NULL OR (
        jsonb_typeof(diagnostico) = 'object'
        AND diagnostico ? 'sintomas'
        AND diagnostico ? 'hallazgos'
        AND CASE WHEN jsonb_typeof(diagnostico -> 'sintomas') = 'array'
                THEN jsonb_array_length(diagnostico -> 'sintomas') > 0
                ELSE FALSE END
        AND jsonb_typeof(diagnostico -> 'hallazgos') = 'string'
        AND (NOT diagnostico ? 'recomendaciones'
            OR jsonb_typeof(diagnostico -> 'recomendaciones') = 'array')
    ));

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
    CHECK (estado = 'E' OR fecha_fin IS NOT NULL);

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
--De un servicio solo se modifica el estado, y solo mientras esta en proceso: se finaliza o se cancela.
--El numero, la fecha de inicio, el vehiculo y la sede no cambian. Un servicio no se finaliza si tiene detalles en proceso.
--Al finalizar o cancelar se puede indicar la fecha de fin si no se indica, es la de hoy.
CREATE OR REPLACE FUNCTION fc_tg_1_SERVICIOS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF OLD.estado = 'F' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios finalizados';
    END IF;

    IF OLD.estado = 'C' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios cancelados';
    END IF;

    IF NEW.numero IS DISTINCT FROM OLD.numero -- Verifica que solo el estado es el que cambie
        OR NEW.fecha_inicio IS DISTINCT FROM OLD.fecha_inicio
        OR NEW.vehiculo IS DISTINCT FROM OLD.vehiculo
        OR NEW.sede IS DISTINCT FROM OLD.sede
        OR (NEW.estado = 'E' AND NEW.fecha_fin IS DISTINCT FROM OLD.fecha_fin) THEN
        RAISE EXCEPTION 'De un servicio solo se puede modificar el estado';
    END IF;

    IF NEW.estado = 'F' -- Si hay detalles en proceso no permite pasar a Finalizado
        AND EXISTS (SELECT 1 FROM DETALLE_ORDENES d WHERE d.servicio = NEW.numero AND d.estado = 'E') THEN
        RAISE EXCEPTION 'No se puede finalizar un servicio con detalles en proceso';
    END IF;

    IF NEW.estado IN ('F', 'C') THEN
        IF NEW.fecha_fin IS NULL THEN
            NEW.fecha_fin := CURRENT_DATE;
        ELSIF NEW.fecha_fin > CURRENT_DATE THEN
            RAISE EXCEPTION 'La fecha de fin del servicio no puede ser futura';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_SERVICIOS_bu
    BEFORE UPDATE ON SERVICIOS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_SERVICIOS_bu();


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
--No se permite eliminar los servicios de la base de datos
CREATE OR REPLACE FUNCTION fc_tg_2_SERVICIOS_bd() RETURNS TRIGGER AS
$$
BEGIN
    RAISE EXCEPTION 'No se permite eliminar los servicios';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_2_SERVICIOS_bd
    BEFORE DELETE ON SERVICIOS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_2_SERVICIOS_bd();


    --DETALLE_ORDENES
--Solo se agregan detalles a servicios en proceso y de servicios del catalogo que la sede tiene habilitados.
--El tecnico del detalle debe trabajar en la sede del servicio.
CREATE OR REPLACE FUNCTION fc_tg_1_DETALLE_ORDENES_bi() RETURNS TRIGGER AS
$$
DECLARE
    estado_servicio VARCHAR;
    sede_servicio VARCHAR;
BEGIN
    SELECT s.estado, s.sede INTO estado_servicio, sede_servicio FROM SERVICIOS s WHERE s.numero = NEW.servicio;

    IF estado_servicio <> 'E' THEN
        RAISE EXCEPTION 'Solo se pueden agregar detalles a los servicios en proceso';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM OFERTAS_SERVICIOS o
                    WHERE o.sede = sede_servicio
                        AND o.catalogo_servicio = NEW.catalogo_servicio
                        AND o.habilitado = TRUE) THEN
        RAISE EXCEPTION 'La sede no tiene habilitado ese servicio del catalogo';
    END IF;

    IF EXISTS (SELECT 1 FROM EMPLEADOS e WHERE e.persona = NEW.tecnico AND e.sede <> sede_servicio) THEN
        RAISE EXCEPTION 'El tecnico no trabaja en la sede del servicio';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_DETALLE_ORDENES_bi
    BEFORE INSERT ON DETALLE_ORDENES
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_DETALLE_ORDENES_bi();


--Los detalles solo se modifican mientras el servicio esta en proceso 
--Del detalle no cambian el servicio, el item, el servicio del catalogo ni el valor cobrado.
--El tecnico del detalle debe trabajar en la sede del servicio.
CREATE OR REPLACE FUNCTION fc_tg_1_DETALLE_ORDENES_bu() RETURNS TRIGGER AS
$$
DECLARE
    estado_servicio VARCHAR;
    sede_servicio VARCHAR;
BEGIN
    SELECT s.estado, s.sede INTO estado_servicio, sede_servicio FROM SERVICIOS s WHERE s.numero = NEW.servicio;

    IF NEW.servicio IS DISTINCT FROM OLD.servicio
        OR NEW.item IS DISTINCT FROM OLD.item
        OR NEW.catalogo_servicio IS DISTINCT FROM OLD.catalogo_servicio
        OR NEW.valor_cobrado IS DISTINCT FROM OLD.valor_cobrado THEN
        RAISE EXCEPTION 'Del detalle no se puede cambiar el servicio, el item, el servicio del catalogo ni el valor cobrado';
    END IF;

    IF estado_servicio <> 'E'
        AND NOT (estado_servicio = 'C' AND OLD.estado = 'E' AND NEW.estado = 'C') THEN
        RAISE EXCEPTION 'Solo se pueden modificar los detalles de los servicios en proceso';
    END IF;

    IF NEW.tecnico IS DISTINCT FROM OLD.tecnico
        AND EXISTS (SELECT 1 FROM EMPLEADOS e WHERE e.persona = NEW.tecnico AND e.sede <> sede_servicio) THEN
        RAISE EXCEPTION 'El tecnico no trabaja en la sede del servicio';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_DETALLE_ORDENES_bu
    BEFORE UPDATE ON DETALLE_ORDENES
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_DETALLE_ORDENES_bu();


--Los detalles no se eliminan
CREATE OR REPLACE FUNCTION fc_tg_1_DETALLE_ORDENES_bd() RETURNS TRIGGER AS
$$
BEGIN
    RAISE EXCEPTION 'No se permite eliminar los detalles';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_DETALLE_ORDENES_bd
    BEFORE DELETE ON DETALLE_ORDENES
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_DETALLE_ORDENES_bd();


--El valor cobrado es el precio local de la sede si no tiene, el precio base del catalogo.
CREATE OR REPLACE FUNCTION fc_tg_2_DETALLE_ORDENES_bi() RETURNS TRIGGER AS
$$
BEGIN
    SELECT COALESCE(o.precio_local, cs.precio_base) INTO NEW.valor_cobrado
    FROM SERVICIOS s
    JOIN OFERTAS_SERVICIOS o ON o.sede = s.sede
    JOIN CATALOGO_SERVICIOS cs ON cs.codigo = o.catalogo_servicio
    WHERE s.numero = NEW.servicio AND o.catalogo_servicio = NEW.catalogo_servicio;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_2_DETALLE_ORDENES_bi
    BEFORE INSERT ON DETALLE_ORDENES
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_2_DETALLE_ORDENES_bi();


    --COMPRAS
    --Valores por omision
ALTER TABLE COMPRAS ALTER COLUMN fecha SET DEFAULT CURRENT_DATE;

--Consecutivo del numero de la compra (C#########) con secuencia.
CREATE SEQUENCE SQ_COMPRAS_numero OWNED BY COMPRAS.numero;
SELECT setval('SQ_COMPRAS_numero',
                (SELECT COALESCE(MAX(SUBSTRING(numero FROM 2)::INTEGER), 0) + 1 FROM COMPRAS), false);
ALTER TABLE COMPRAS ALTER COLUMN numero SET DEFAULT
    'C' || LPAD(nextval('SQ_COMPRAS_numero')::TEXT, 9, '0');

    --Adicionar
--Al registrar una compra, su fecha no puede ser futura
CREATE OR REPLACE FUNCTION fc_tg_1_COMPRAS_bi() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.fecha > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de la compra no puede ser futura';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_COMPRAS_bi
    BEFORE INSERT ON COMPRAS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_COMPRAS_bi();

    --Modificar
--Una compra pagada no se modifica. De una compra solo cambia el proveedor y solo mientras no tenga detalles
--el numero, la fecha y la sede no cambian
CREATE OR REPLACE FUNCTION fc_tg_1_COMPRAS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM PAGOS pg WHERE pg.compra = OLD.numero) THEN
        RAISE EXCEPTION 'La compra ya tiene pago y no se puede modificar';
    END IF;

    IF NEW.numero IS DISTINCT FROM OLD.numero
        OR NEW.fecha IS DISTINCT FROM OLD.fecha
        OR NEW.sede IS DISTINCT FROM OLD.sede THEN
        RAISE EXCEPTION 'De una compra solo se puede modificar el proveedor';
    END IF;

    IF NEW.proveedor IS DISTINCT FROM OLD.proveedor
        AND EXISTS (SELECT 1 FROM DETALLE_COMPRAS dc WHERE dc.compra = OLD.numero) THEN
        RAISE EXCEPTION 'No se puede cambiar el proveedor de una compra que ya tiene detalles';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_COMPRAS_bu
    BEFORE UPDATE ON COMPRAS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_COMPRAS_bu();


    --DETALLE_COMPRAS
--No se agregan detalles a una compra que ya tiene pago.
CREATE OR REPLACE FUNCTION fc_tg_1_DETALLE_COMPRAS_bi() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM PAGOS pg WHERE pg.compra = NEW.compra) THEN
        RAISE EXCEPTION 'La compra ya tiene pago y no se puede modificar';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_DETALLE_COMPRAS_bi
    BEFORE INSERT ON DETALLE_COMPRAS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_DETALLE_COMPRAS_bi();


--No se modifican los detalles de una compra que ya tiene pago
CREATE OR REPLACE FUNCTION fc_tg_1_DETALLE_COMPRAS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM PAGOS pg WHERE pg.compra = OLD.compra OR pg.compra = NEW.compra) THEN
        RAISE EXCEPTION 'La compra ya tiene pago y no se puede modificar';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_DETALLE_COMPRAS_bu
    BEFORE UPDATE ON DETALLE_COMPRAS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_DETALLE_COMPRAS_bu();


--No se eliminan los detalles de una compra que ya tiene pago.
CREATE OR REPLACE FUNCTION fc_tg_1_DETALLE_COMPRAS_bd() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM PAGOS pg WHERE pg.compra = OLD.compra) THEN
        RAISE EXCEPTION 'La compra ya tiene pago y no se puede modificar';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_DETALLE_COMPRAS_bd
    BEFORE DELETE ON DETALLE_COMPRAS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_DETALLE_COMPRAS_bd();


--Si no se indica el precio por unidad se toma el precio de referencia del proveedor de la compra
--si el proveedor no tiene precio de referencia para ese repuesto, el precio se debe indicar.
CREATE OR REPLACE FUNCTION fc_tg_2_DETALLE_COMPRAS_bi() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.precio_unidad IS NULL THEN
        SELECT su.precio_referencia INTO NEW.precio_unidad
        FROM COMPRAS c
        JOIN SUMINISTROS su ON su.proveedor = c.proveedor
        WHERE c.numero = NEW.compra AND su.repuesto = NEW.repuesto;

        IF NEW.precio_unidad IS NULL THEN
            RAISE EXCEPTION 'Se debe indicar el precio por unidad, el proveedor no tiene precio de referencia para ese repuesto';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_2_DETALLE_COMPRAS_bi
    BEFORE INSERT ON DETALLE_COMPRAS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_2_DETALLE_COMPRAS_bi();


    --PAGOS
--Los pagos de las compras no se modifican ni se eliminan
CREATE OR REPLACE FUNCTION fc_tg_1_PAGOS_bu() RETURNS TRIGGER AS
$$
BEGIN
    RAISE EXCEPTION 'Los pagos no se pueden modificar ni eliminar';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_PAGOS_bu
    BEFORE UPDATE ON PAGOS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_PAGOS_bu();


CREATE OR REPLACE FUNCTION fc_tg_1_PAGOS_bd() RETURNS TRIGGER AS
$$
BEGIN
    RAISE EXCEPTION 'Los pagos no se pueden modificar ni eliminar';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_PAGOS_bd
    BEFORE DELETE ON PAGOS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_PAGOS_bd();


    --MOVIMIENTOS
--Un movimiento de caja es un cobro o un pago, nunca los dos a la vez.
CREATE OR REPLACE FUNCTION fc_tg_2_PAGOS_bi() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM COBROS co WHERE co.movimiento = NEW.movimiento) THEN
        RAISE EXCEPTION 'El movimiento ya esta registrado como cobro, no puede ser tambien un pago';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_2_PAGOS_bi
    BEFORE INSERT ON PAGOS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_2_PAGOS_bi();


CREATE OR REPLACE FUNCTION fc_tg_1_COBROS_bi() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM PAGOS pg WHERE pg.movimiento = NEW.movimiento) THEN
        RAISE EXCEPTION 'El movimiento ya esta registrado como pago, no puede ser tambien un cobro';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_COBROS_bi
    BEFORE INSERT ON COBROS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_COBROS_bi();


CREATE OR REPLACE FUNCTION fc_tg_1_COBROS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM PAGOS pg WHERE pg.movimiento = NEW.movimiento) THEN
        RAISE EXCEPTION 'El movimiento ya esta registrado como pago, no puede ser tambien un cobro';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_1_COBROS_bu
    BEFORE UPDATE OF movimiento ON COBROS
    FOR EACH ROW
    EXECUTE FUNCTION fc_tg_1_COBROS_bu();

    --XDisparadores
-- ALTER TABLE SERVICIOS ALTER COLUMN fecha_inicio DROP DEFAULT;
-- ALTER TABLE SERVICIOS ALTER COLUMN estado DROP DEFAULT;
-- ALTER TABLE SERVICIOS ALTER COLUMN numero DROP DEFAULT;
-- DROP SEQUENCE IF EXISTS SQ_SERVICIOS_numero;

-- DROP TRIGGER IF EXISTS tg_1_SERVICIOS_bi ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_1_SERVICIOS_bu ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_1_SERVICIOS_au ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_2_SERVICIOS_bd ON SERVICIOS;

-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bi();
-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bu();
-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_au();
-- DROP FUNCTION IF EXISTS fc_tg_2_SERVICIOS_bd();

-- DROP TRIGGER IF EXISTS tg_2_DETALLE_ORDENES_bi ON DETALLE_ORDENES;
-- DROP TRIGGER IF EXISTS tg_1_DETALLE_ORDENES_bd ON DETALLE_ORDENES;
-- DROP TRIGGER IF EXISTS tg_1_DETALLE_ORDENES_bu ON DETALLE_ORDENES;
-- DROP TRIGGER IF EXISTS tg_1_DETALLE_ORDENES_bi ON DETALLE_ORDENES;
-- DROP FUNCTION IF EXISTS fc_tg_2_DETALLE_ORDENES_bi();
-- DROP FUNCTION IF EXISTS fc_tg_1_DETALLE_ORDENES_bd();
-- DROP FUNCTION IF EXISTS fc_tg_1_DETALLE_ORDENES_bu();
-- DROP FUNCTION IF EXISTS fc_tg_1_DETALLE_ORDENES_bi();

-- DROP TRIGGER IF EXISTS tg_1_COBROS_bu ON COBROS;
-- DROP TRIGGER IF EXISTS tg_1_COBROS_bi ON COBROS;
-- DROP TRIGGER IF EXISTS tg_2_PAGOS_bi ON PAGOS;
-- DROP FUNCTION IF EXISTS fc_tg_1_COBROS_bu();
-- DROP FUNCTION IF EXISTS fc_tg_1_COBROS_bi();
-- DROP FUNCTION IF EXISTS fc_tg_2_PAGOS_bi();

-- DROP TRIGGER IF EXISTS tg_1_PAGOS_bd ON PAGOS;
-- DROP TRIGGER IF EXISTS tg_1_PAGOS_bu ON PAGOS;
-- DROP TRIGGER IF EXISTS tg_2_DETALLE_COMPRAS_bi ON DETALLE_COMPRAS;
-- DROP TRIGGER IF EXISTS tg_1_DETALLE_COMPRAS_bd ON DETALLE_COMPRAS;
-- DROP TRIGGER IF EXISTS tg_1_DETALLE_COMPRAS_bu ON DETALLE_COMPRAS;
-- DROP TRIGGER IF EXISTS tg_1_DETALLE_COMPRAS_bi ON DETALLE_COMPRAS;
-- DROP TRIGGER IF EXISTS tg_1_COMPRAS_bi ON COMPRAS;
-- DROP TRIGGER IF EXISTS tg_1_COMPRAS_bu ON COMPRAS;
-- DROP FUNCTION IF EXISTS fc_tg_1_PAGOS_bd();
-- DROP FUNCTION IF EXISTS fc_tg_1_PAGOS_bu();
-- DROP FUNCTION IF EXISTS fc_tg_2_DETALLE_COMPRAS_bi();
-- DROP FUNCTION IF EXISTS fc_tg_1_DETALLE_COMPRAS_bd();
-- DROP FUNCTION IF EXISTS fc_tg_1_DETALLE_COMPRAS_bu();
-- DROP FUNCTION IF EXISTS fc_tg_1_DETALLE_COMPRAS_bi();
-- DROP FUNCTION IF EXISTS fc_tg_1_COMPRAS_bi();
-- DROP FUNCTION IF EXISTS fc_tg_1_COMPRAS_bu();
-- ALTER TABLE COMPRAS ALTER COLUMN fecha DROP DEFAULT;
-- ALTER TABLE COMPRAS ALTER COLUMN numero DROP DEFAULT;
-- DROP SEQUENCE IF EXISTS SQ_COMPRAS_numero;

--Indices
--CRUD de Servicios: las ordenes se buscan por sede y estado 
CREATE INDEX IX_SERVICIOS_SEDE_ESTADO ON SERVICIOS(sede, estado);

--CRUD de Compras: los detalles de compra se buscan por repuesto
CREATE INDEX IX_DETALLE_COMPRAS_REPUESTO ON DETALLE_COMPRAS(repuesto);

    --XIndices
-- DROP INDEX IF EXISTS IX_SERVICIOS_SEDE_ESTADO;
-- DROP INDEX IF EXISTS IX_DETALLE_COMPRAS_REPUESTO;

--Vistas
--Inventario: unidades disponibles de cada repuesto en cada sede.
--se calcula como = cantidad = compras + traslados que llegan - traslados que salen - consumos
CREATE VIEW INVENTARIO AS
SELECT  m.sede,
        m.repuesto,
        SUM(m.cantidad) AS cantidad
FROM ( -- Devuelve una tabla con la estrcutura -> sede / repuesto / cantidad (- o + dependiendo)
    SELECT c.sede, dc.repuesto, dc.cantidad
    FROM DETALLE_COMPRAS dc                     -- La cantidad que se compra de un repuesto
    JOIN COMPRAS c ON c.numero = dc.compra
    UNION ALL
    SELECT t.sede_llega, t.repuesto, t.cantidad
    FROM TRASLADOS t                            -- Cuando el traslado es hacia la sede
    UNION ALL
    SELECT t.sede_sale, t.repuesto, -t.cantidad
    FROM TRASLADOS t                            -- Cuando el traslado sale de la
    UNION ALL
    SELECT s.sede, co.repuesto, -co.cantidad
    FROM CONSUMOS co                            -- La cantidad de respuestos usados en reparaciones 
    JOIN SERVICIOS s ON s.numero = co.servicio
) m
GROUP BY m.sede, m.repuesto;

--Ganancia de cada sede en cada mes (AAAA-MM) en el que hubo movimientos de caja pagados.
--ganancia = total cobrado - total de compras pagadas - salarios mensuales de los empleados de la sede
CREATE VIEW GANANCIAS_SEDES AS
SELECT  t.sede,
        t.nombre,
        t.mes,
        t.totalCobrado,
        t.totalCompras,
        t.totalSalarios,
        t.totalCobrado - t.totalCompras - t.totalSalarios AS ganancia
FROM (
    SELECT  se.numero AS sede,
            se.nombre,
            me.mes,
            COALESCE((SELECT SUM(m.valor)   -- suma de todos los cobros de servicios
                        FROM COBROS c
                        JOIN MOVIMIENTOS m ON m.numero = c.movimiento
                        JOIN SERVICIOS s ON s.numero = c.orden
                        WHERE s.sede = se.numero AND m.estado = 'P'
                        AND TO_CHAR(m.fecha, 'YYYY-MM') = me.mes), 0) AS totalCobrado,
            COALESCE((SELECT SUM(m.valor)   -- suma de todos los pagos hechos a proveedores (resta)
                        FROM PAGOS pg
                        JOIN MOVIMIENTOS m ON m.numero = pg.movimiento
                        JOIN COMPRAS co ON co.numero = pg.compra
                        WHERE co.sede = se.numero AND m.estado = 'P'
                        AND TO_CHAR(m.fecha, 'YYYY-MM') = me.mes), 0) AS totalCompras,
            COALESCE((SELECT SUM(e.salario) -- la suma de los salarios de los empleados que ya trabajaban ese mes
                        FROM EMPLEADOS e
                        WHERE e.sede = se.numero
                        AND TO_CHAR(e.fecha_ingreso, 'YYYY-MM') <= me.mes), 0) AS totalSalarios
    FROM SEDES se
    -- arma la tabla de combinaciones sede × mes
    CROSS JOIN (SELECT DISTINCT TO_CHAR(m.fecha, 'YYYY-MM') AS mes
                FROM MOVIMIENTOS m
                WHERE m.estado = 'P') me
) t;

--Valor generado por cada tecnico en cada mes (AAAA-MM), con sus detalles de orden finalizados.
CREATE VIEW VALORES_TECNICOS AS
SELECT  p.cedula,
        p.nombre,
        p.apellido,
        e.sede,
        TO_CHAR(d.fecha_fin, 'YYYY-MM') AS mes,
        COUNT(*) AS trabajosFinalizados,
        SUM(d.valor_cobrado) AS valorGenerado,          -- este número no refleja la utilidad
        SUM(d.horas_trabajadas) AS horasTrabajadas,
        SUM(cs.tiempo_medio) AS horasEstimadas,
        SUM(d.horas_trabajadas) - SUM(cs.tiempo_medio) AS diferencia
FROM DETALLE_ORDENES d
JOIN EMPLEADOS e ON e.persona = d.tecnico
JOIN PERSONAS p ON p.cedula = e.persona
JOIN CATALOGO_SERVICIOS cs ON cs.codigo = d.catalogo_servicio
WHERE d.estado = 'F'
GROUP BY p.cedula, p.nombre, p.apellido, e.sede, TO_CHAR(d.fecha_fin, 'YYYY-MM');

--Cobros pagados de cada cliente: una fila por orden cobrada, con el vehiculo y la fecha del cobro.
CREATE VIEW COBROS_CLIENTES AS
SELECT  p.cedula,
        p.nombre,
        p.apellido,
        v.placa,
        s.numero AS orden,
        m.fecha,
        m.valor
FROM COBROS c
JOIN MOVIMIENTOS m ON m.numero = c.movimiento
JOIN SERVICIOS s ON s.numero = c.orden
JOIN VEHICULOS v ON v.placa = s.vehiculo
JOIN PERSONAS p ON p.cedula = v.cliente
WHERE m.estado = 'P';

--Existencias y consumo de cada repuesto en cada sede, para saber cuales estan por agotarse.
CREATE VIEW REPUESTOS_POR_AGOTARSE AS
SELECT  i.sede,
        r.serie,
        r.nombre,
        i.cantidad AS cantidadDisponible,
        COALESCE(u.cantidadUsada, 0) AS cantidadUsada,
        COALESCE(ROUND(u.cantidadUsada / u.meses, 2), 0) AS consumoMensualPromedio
FROM INVENTARIO i       -- inventario trae los respuesto disponibles 
JOIN REPUESTOS r ON r.serie = i.repuesto
LEFT JOIN (             -- este left join trae los consumos
    SELECT  s.sede,
            co.repuesto,
            SUM(co.cantidad) AS cantidadUsada,
            COUNT(DISTINCT TO_CHAR(co.fecha_uso, 'YYYY-MM')) AS meses
    FROM CONSUMOS co
    JOIN SERVICIOS s ON s.numero = co.servicio
    GROUP BY s.sede, co.repuesto
) u ON u.sede = i.sede AND u.repuesto = i.repuesto;

    --XVistas
-- DROP VIEW IF EXISTS REPUESTOS_POR_AGOTARSE;
-- DROP VIEW IF EXISTS COBROS_CLIENTES;
-- DROP VIEW IF EXISTS VALORES_TECNICOS;
-- DROP VIEW IF EXISTS GANANCIAS_SEDES;
-- DROP VIEW IF EXISTS INVENTARIO;

-- MecaData PoblarOK
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543'),
    ('3030303030', 'Sofia', 'Martinez', 'sofia.martinez@mail.com', '3112223344'),
    ('5050505050', 'Camila', 'Torres', 'camila.torres@mail.com', '3125556677'),
    ('6060606060', 'Jorge', 'Ramirez', 'jorge.ramirez@mail.com', '3138889900'),
    ('7070707070', 'Pedro', 'Castro', 'pedro.castro@mail.com', '3141112233'),
    ('8080808080', 'Laura', 'Moreno', 'laura.moreno@mail.com', '3154443322'),
    ('1111111111', 'Andres', 'Lopez', 'andres.lopez@mail.com', '3160001122'),
    ('1212121212', 'Valentina', 'Suarez', 'valentina.suarez@mail.com', '3171112233'),
    ('1313131313', 'Mateo', 'Herrera', 'mateo.herrera@mail.com', '3182223344'),
    ('1414141414', 'Sara', 'Jimenez', 'sara.jimenez@mail.com', '3193334455'),
    ('1515151515', 'Daniela', 'Vargas', 'daniela.vargas@mail.com', '3004445566'),
    ('1616161616', 'Felipe', 'Cardenas', 'felipe.cardenas@mail.com', '3015556677'),
    ('1717171717', 'Natalia', 'Rios', 'natalia.rios@mail.com', '3026667788'),
    ('1818181818', 'Juan', 'Mendez', 'juan.mendez@mail.com', '3037778899'),
    ('1919191919', 'Paula', 'Ortiz', 'paula.ortiz@mail.com', '3048889900'),
    ('2121212121', 'Diego', 'Salazar', 'diego.salazar@mail.com', '3059990011');

INSERT INTO CLIENTES (fecha_registro, persona) VALUES
    ('2024-01-15', '1010101010'),
    ('2025-06-10', '7070707070'),
    ('2026-01-20', '5050505050'),
    ('2025-11-03', '1515151515'),
    ('2026-02-14', '1616161616'),
    ('2026-03-09', '1717171717'),
    ('2026-04-22', '1818181818'),
    ('2026-05-30', '1919191919'),
    ('2026-07-11', '2121212121');

INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010'),
    ('DEF456', 82000, 'Chevrolet', 2017, 1400, 'Gris', '1010101010'),
    ('GHI789', 15000, 'Renault', 2023, 1600, 'Blanco', '7070707070'),
    ('JKL321', 98000, 'Toyota', 2019, 1800, 'Negro', '1515151515'),
    ('MNO654', 37000, 'Kia', 2021, 1600, 'Azul', '1616161616'),
    ('BCD579', 121000, 'Mazda', 2015, 1600, 'Verde', '1616161616'),
    ('PQR987', 143000, 'Ford', 2016, 2500, 'Plata', '1717171717'),
    ('STU246', 22000, 'Nissan', 2022, 1600, 'Blanco', '1818181818'),
    ('VWX135', 76000, 'Volkswagen', 2018, 1400, 'Rojo', '1919191919'),
    ('YZA864', 54000, 'Hyundai', 2020, 2000, 'Gris', '2121212121'),
    ('EFG102', 8000, 'Renault', 2024, 1300, 'Negro', '5050505050');

INSERT INTO AUTOMOVILES (vehiculo, numero_puertas) VALUES
    ('ABC123', 4),
    ('DEF456', 5),
    ('GHI789', 4),
    ('JKL321', 4),
    ('MNO654', 5),
    ('BCD579', 4),
    ('PQR987', 4),
    ('STU246', 5),
    ('VWX135', 3),
    ('YZA864', 4),
    ('EFG102', 5);

INSERT INTO SEDES (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321'),
    ('S03', 'Sede Centro', 'Calle 26 # 13-40', '6013339988');

INSERT INTO EMPLEADOS (cargo, fecha_ingreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 2100000.00, '2020202020', 'S01'),
    ('G', '2021-01-10', 4500000.00, '3030303030', 'S01'),
    ('T', '2022-05-16', 2400000.00, '5050505050', 'S01'),
    ('T', '2024-02-01', 1900000.00, '6060606060', 'S02'),
    ('G', '2020-08-03', 4300000.00, '8080808080', 'S02'),
    ('T', '2025-09-15', 2000000.00, '1111111111', 'S02'),
    ('G', '2026-08-01', 4200000.00, '1212121212', 'S03'),
    ('T', '2026-08-01', 2200000.00, '1313131313', 'S03'),
    ('T', '2026-08-01', 1800000.00, '1414141414', 'S03');

INSERT INTO TECNICOS (especialidad, empleado) VALUES
    ('Motor', '2020202020'),
    ('Alineacion', '5050505050'),
    ('Frenos', '6060606060'),
    ('Motor', '1111111111'),
    ('Transmision', '1313131313'),
    ('Frenos', '1414141414');

INSERT INTO CATALOGO_SERVICIOS (codigo, nombre, descripcion, precio_base, tiempo_medio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.50),
    ('CS02', 'Revision de frenos', 'Revision y cambio de pastillas de freno', 220000.00, 2),
    ('CS03', 'Alineacion y balanceo', 'Alineacion de direccion y balanceo de llantas', 90000.00, 1),
    ('CS04', 'Reparacion de motor', 'Ajuste de motor y cambio de empaques', 3800000.00, 16),
    ('CS05', 'Cambio de embrague', 'Cambio del kit de embrague', 1900000.00, 6),
    ('CS06', 'Mantenimiento general', 'Revision de 40 puntos y cambio de fluidos', 750000.00, 4);

INSERT INTO OFERTAS_SERVICIOS (habilitado, precio_local, catalogo_servicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01'),
    (TRUE, NULL, 'CS02', 'S01'),
    (FALSE, 95000.00, 'CS03', 'S01'),
    (TRUE, NULL, 'CS04', 'S01'),
    (TRUE, 1950000.00, 'CS05', 'S01'),
    (TRUE, NULL, 'CS06', 'S01'),
    (TRUE, 155000.00, 'CS01', 'S02'),
    (TRUE, 230000.00, 'CS02', 'S02'),
    (TRUE, 3600000.00, 'CS04', 'S02'),
    (TRUE, 720000.00, 'CS06', 'S02'),
    (TRUE, NULL, 'CS01', 'S03'),
    (TRUE, NULL, 'CS02', 'S03'),
    (TRUE, 85000.00, 'CS03', 'S03'),
    (TRUE, NULL, 'CS05', 'S03'),
    (TRUE, NULL, 'CS06', 'S03');

INSERT INTO REPUESTOS (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite'),
    ('R002', 'Freno', 'Pastillas de freno'),
    ('R003', 'Motor', 'Kit de empaques de motor'),
    ('R004', 'Transmision', 'Kit de embrague'),
    ('R005', 'Lubricante', 'Aceite 5W30 (galon)'),
    ('R006', 'Freno', 'Liquido de frenos');

INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('OS26-00000001', '2026-11-03', NULL, 'E', 'ABC123', 'S01'),
    ('OS26-00000002', '2026-09-14', NULL, 'E', 'DEF456', 'S01'),
    ('OS26-00000003', '2026-10-05', NULL, 'E', 'GHI789', 'S02'),
    ('OS26-00000004', '2026-10-20', '2026-10-21', 'C', 'GHI789', 'S02'),
    ('OS26-00000005', '2026-09-03', NULL, 'E', 'JKL321', 'S01'),
    ('OS26-00000006', '2026-09-22', NULL, 'E', 'MNO654', 'S01'),
    ('OS26-00000007', '2026-10-02', NULL, 'E', 'PQR987', 'S01'),
    ('OS26-00000008', '2026-10-14', NULL, 'E', 'BCD579', 'S01'),
    ('OS26-00000009', '2026-10-20', NULL, 'E', 'STU246', 'S01'),
    ('OS26-00000010', '2026-10-27', NULL, 'E', 'EFG102', 'S01'),
    ('OS26-00000011', '2026-11-05', NULL, 'E', 'VWX135', 'S01'),
    ('OS26-00000012', '2026-11-10', NULL, 'E', 'YZA864', 'S01'),
    ('OS26-00000013', '2026-09-08', NULL, 'E', 'GHI789', 'S02'),
    ('OS26-00000014', '2026-09-25', NULL, 'E', 'YZA864', 'S02'),
    ('OS26-00000015', '2026-10-09', NULL, 'E', 'JKL321', 'S02'),
    ('OS26-00000016', '2026-10-22', NULL, 'E', 'STU246', 'S02'),
    ('OS26-00000017', '2026-10-28', NULL, 'E', 'MNO654', 'S02'),
    ('OS26-00000018', '2026-11-11', NULL, 'E', 'PQR987', 'S02'),
    ('OS26-00000019', '2026-09-15', NULL, 'E', 'VWX135', 'S03'),
    ('OS26-00000020', '2026-10-06', NULL, 'E', 'BCD579', 'S03'),
    ('OS26-00000021', '2026-10-19', NULL, 'E', 'EFG102', 'S03'),
    ('OS26-00000022', '2026-11-04', NULL, 'E', 'YZA864', 'S03');

SELECT setval('SQ_SERVICIOS_numero',
                (SELECT COALESCE(MAX(SPLIT_PART(numero, '-', 2)::INTEGER), 0) + 1 FROM SERVICIOS), false);

INSERT INTO DETALLE_ORDENES (item, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio, tecnico, horas_trabajadas, diagnostico) VALUES
    (1, 160000.00, 'E', '2026-11-03', NULL, 'CS01', 'OS26-00000001', '2020202020', 1.50, NULL),
    (1, 220000.00, 'F', '2026-09-14', '2026-09-15', 'CS02', 'OS26-00000002', '2020202020', 2, '{"sintomas": ["ruido al frenar", "pedal esponjoso"], "hallazgos": "Pastillas delanteras al 10% de vida util", "recomendaciones": ["cambiar discos en 5000 km"]}'),
    (1, 230000.00, 'F', '2026-10-05', '2026-10-06', 'CS02', 'OS26-00000003', '6060606060', 2.50, '{"sintomas": ["vibracion al frenar"], "hallazgos": "Pastillas cristalizadas"}'),
    (1, 3800000.00, 'F', '2026-09-03', '2026-09-08', 'CS04', 'OS26-00000005', '2020202020', 18, '{"sintomas": ["perdida de potencia", "humo azul en el escape"], "hallazgos": "Empaque de culata y anillos desgastados", "recomendaciones": ["cambio de aceite a los 1000 km"]}'),
    (2, 750000.00, 'F', '2026-09-03', '2026-09-04', 'CS06', 'OS26-00000005', '5050505050', 4.50, NULL),
    (1, 1950000.00, 'F', '2026-09-22', '2026-09-24', 'CS05', 'OS26-00000006', '2020202020', 6.50, '{"sintomas": ["el embrague patina"], "hallazgos": "Disco de embrague al limite de desgaste"}'),
    (2, 160000.00, 'F', '2026-09-22', '2026-09-22', 'CS01', 'OS26-00000006', '5050505050', 1, NULL),
    (1, 3800000.00, 'F', '2026-10-02', '2026-10-07', 'CS04', 'OS26-00000007', '2020202020', 15, NULL),
    (2, 220000.00, 'F', '2026-10-02', '2026-10-03', 'CS02', 'OS26-00000007', '5050505050', 2, NULL),
    (1, 750000.00, 'F', '2026-10-14', '2026-10-14', 'CS06', 'OS26-00000008', '5050505050', 3.50, NULL),
    (2, 160000.00, 'F', '2026-10-14', '2026-10-14', 'CS01', 'OS26-00000008', '5050505050', 1.50, NULL),
    (1, 3800000.00, 'F', '2026-10-20', '2026-10-24', 'CS04', 'OS26-00000009', '2020202020', 17, '{"sintomas": ["perdida de potencia", "humo azul en el escape"], "hallazgos": "Empaque de culata y anillos desgastados", "recomendaciones": ["cambio de aceite a los 1000 km"]}'),
    (1, 1950000.00, 'F', '2026-10-27', '2026-10-29', 'CS05', 'OS26-00000010', '2020202020', 7, NULL),
    (1, 220000.00, 'F', '2026-11-05', '2026-11-05', 'CS02', 'OS26-00000011', '5050505050', 2.50, NULL),
    (2, 750000.00, 'F', '2026-11-05', '2026-11-06', 'CS06', 'OS26-00000011', '5050505050', 4, NULL),
    (1, 160000.00, 'E', '2026-11-10', NULL, 'CS01', 'OS26-00000012', '5050505050', NULL, NULL),
    (1, 3600000.00, 'F', '2026-09-08', '2026-09-12', 'CS04', 'OS26-00000013', '1111111111', 17, '{"sintomas": ["perdida de potencia", "humo azul en el escape"], "hallazgos": "Empaque de culata y anillos desgastados", "recomendaciones": ["cambio de aceite a los 1000 km"]}'),
    (2, 230000.00, 'F', '2026-09-08', '2026-09-09', 'CS02', 'OS26-00000013', '6060606060', 2, NULL),
    (1, 720000.00, 'F', '2026-09-25', '2026-09-25', 'CS06', 'OS26-00000014', '1111111111', 4, NULL),
    (2, 155000.00, 'F', '2026-09-25', '2026-09-25', 'CS01', 'OS26-00000014', '6060606060', 1, NULL),
    (1, 3600000.00, 'F', '2026-10-09', '2026-10-15', 'CS04', 'OS26-00000015', '1111111111', 14, NULL),
    (1, 230000.00, 'F', '2026-10-22', '2026-10-22', 'CS02', 'OS26-00000016', '6060606060', 3, NULL),
    (2, 720000.00, 'F', '2026-10-22', '2026-10-23', 'CS06', 'OS26-00000016', '1111111111', 4.50, NULL),
    (1, 3600000.00, 'F', '2026-10-28', '2026-10-31', 'CS04', 'OS26-00000017', '1111111111', 16, NULL),
    (1, 230000.00, 'E', '2026-11-11', NULL, 'CS02', 'OS26-00000018', '6060606060', NULL, NULL),
    (1, 1900000.00, 'F', '2026-09-15', '2026-09-17', 'CS05', 'OS26-00000019', '1313131313', 5.50, '{"sintomas": ["el embrague patina"], "hallazgos": "Disco de embrague al limite de desgaste"}'),
    (2, 85000.00, 'F', '2026-09-15', '2026-09-15', 'CS03', 'OS26-00000019', '1414141414', 1, NULL),
    (1, 750000.00, 'F', '2026-10-06', '2026-10-07', 'CS06', 'OS26-00000020', '1414141414', 4, NULL),
    (2, 220000.00, 'F', '2026-10-06', '2026-10-07', 'CS02', 'OS26-00000020', '1414141414', 2, NULL),
    (3, 150000.00, 'F', '2026-10-06', '2026-10-06', 'CS01', 'OS26-00000020', '1313131313', 1.50, NULL),
    (1, 1900000.00, 'F', '2026-10-19', '2026-10-21', 'CS05', 'OS26-00000021', '1313131313', 6, NULL),
    (1, 750000.00, 'E', '2026-11-04', NULL, 'CS06', 'OS26-00000022', '1414141414', NULL, NULL);

-- Las ordenes se cierran despues de tener sus detalles (para saltar las restricciones)
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-15' WHERE numero = 'OS26-00000002';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-06' WHERE numero = 'OS26-00000003';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-08' WHERE numero = 'OS26-00000005';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-24' WHERE numero = 'OS26-00000006';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-07' WHERE numero = 'OS26-00000007';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-14' WHERE numero = 'OS26-00000008';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-24' WHERE numero = 'OS26-00000009';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-29' WHERE numero = 'OS26-00000010';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-11-06' WHERE numero = 'OS26-00000011';
UPDATE SERVICIOS SET estado = 'C', fecha_fin = '2026-11-10' WHERE numero = 'OS26-00000012';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-12' WHERE numero = 'OS26-00000013';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-25' WHERE numero = 'OS26-00000014';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-15' WHERE numero = 'OS26-00000015';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-23' WHERE numero = 'OS26-00000016';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-31' WHERE numero = 'OS26-00000017';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-17' WHERE numero = 'OS26-00000019';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-07' WHERE numero = 'OS26-00000020';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-21' WHERE numero = 'OS26-00000021';

INSERT INTO CONSUMOS (cantidad, fecha_uso, precio, repuesto, servicio, item) VALUES
    (1, '2026-11-03', 25000.00, 'R001', 'OS26-00000001', 1),
    (2, '2026-09-14', 60000.00, 'R002', 'OS26-00000002', 1),
    (2, '2026-10-05', 62000.00, 'R002', 'OS26-00000003', 1),
    (1, '2026-09-04', 780000.00, 'R003', 'OS26-00000005', 1),
    (2, '2026-09-04', 75000.00, 'R005', 'OS26-00000005', 2),
    (1, '2026-09-23', 640000.00, 'R004', 'OS26-00000006', 1),
    (1, '2026-09-22', 25000.00, 'R001', 'OS26-00000006', 2),
    (1, '2026-09-22', 75000.00, 'R005', 'OS26-00000006', 2),
    (1, '2026-10-03', 780000.00, 'R003', 'OS26-00000007', 1),
    (2, '2026-10-03', 60000.00, 'R002', 'OS26-00000007', 2),
    (1, '2026-10-03', 32000.00, 'R006', 'OS26-00000007', 2),
    (2, '2026-10-14', 75000.00, 'R005', 'OS26-00000008', 1),
    (1, '2026-10-14', 25000.00, 'R001', 'OS26-00000008', 2),
    (1, '2026-10-21', 780000.00, 'R003', 'OS26-00000009', 1),
    (1, '2026-10-28', 640000.00, 'R004', 'OS26-00000010', 1),
    (2, '2026-11-05', 60000.00, 'R002', 'OS26-00000011', 1),
    (2, '2026-11-06', 75000.00, 'R005', 'OS26-00000011', 2),
    (1, '2026-09-09', 790000.00, 'R003', 'OS26-00000013', 1),
    (2, '2026-09-08', 62000.00, 'R002', 'OS26-00000013', 2),
    (2, '2026-09-25', 76000.00, 'R005', 'OS26-00000014', 1),
    (1, '2026-09-25', 26000.00, 'R001', 'OS26-00000014', 2),
    (1, '2026-10-10', 790000.00, 'R003', 'OS26-00000015', 1),
    (2, '2026-10-10', 76000.00, 'R005', 'OS26-00000015', 1),
    (2, '2026-10-22', 62000.00, 'R002', 'OS26-00000016', 1),
    (1, '2026-10-22', 33000.00, 'R006', 'OS26-00000016', 1),
    (1, '2026-10-29', 790000.00, 'R003', 'OS26-00000017', 1),
    (1, '2026-09-16', 630000.00, 'R004', 'OS26-00000019', 1),
    (2, '2026-10-06', 74000.00, 'R005', 'OS26-00000020', 1),
    (2, '2026-10-07', 61000.00, 'R002', 'OS26-00000020', 2),
    (1, '2026-10-06', 24000.00, 'R001', 'OS26-00000020', 3),
    (1, '2026-10-20', 630000.00, 'R004', 'OS26-00000021', 1);

INSERT INTO GARANTIAS (numero, fecha_inicio, fecha_fin, condiciones, estado, servicio, item) VALUES
    ('G01', '2026-09-15', '2027-03-15', 'Cubre desgaste prematuro de pastillas durante 6 meses', 'V', 'OS26-00000002', 1),
    ('G02', '2026-10-06', '2027-01-06', 'Cubre ruidos en el sistema de frenos durante 3 meses', 'V', 'OS26-00000003', 1),
    ('G03', '2026-09-08', '2027-09-08', 'Cubre fallas del ajuste de motor durante 12 meses o 20000 km', 'V', 'OS26-00000005', 1),
    ('G05', '2026-09-24', '2027-03-24', 'Cubre el kit de embrague instalado durante 6 meses', 'R', 'OS26-00000006', 1),
    ('G06', '2026-09-12', '2027-09-12', 'Cubre fallas del ajuste de motor durante 12 meses', 'V', 'OS26-00000013', 1),
    ('G07', '2026-09-25', '2026-10-25', 'Cubre fugas del filtro de aceite durante 1 mes', 'X', 'OS26-00000014', 2),
    ('G08', '2026-09-17', '2027-03-17', 'Cubre el kit de embrague instalado durante 6 meses', 'A', 'OS26-00000019', 1);

INSERT INTO TRASLADOS (numero, cantidad, fecha, detalle, sede_llega, sede_sale, repuesto) VALUES
    ('TR01', 5, '2026-09-03', 'Reposicion de filtros', 'S02', 'S01', 'R001'),
    ('TR02', 2, '2026-10-25', 'Pastillas para la Sede Norte', 'S01', 'S02', 'R002'),
    ('TR03', 3, '2026-10-01', 'Filtros para la nueva sede', 'S03', 'S01', 'R001'),
    ('TR04', 3, '2026-10-10', 'Aceite para la nueva sede', 'S03', 'S01', 'R005'),
    ('TR05', 1, '2026-10-25', NULL, 'S02', 'S03', 'R004');

INSERT INTO PROVEEDORES (nit, correo, numero_contacto, representante, nombre) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS'),
    ('900654321', 'contacto@frenosya.com', '6015551111', 'Marta Diaz', 'Frenos Ya LTDA'),
    ('900777888', 'ventas@motorpartes.com', '6015552222', 'Jose Ortiz', 'Motor Partes SAS');

INSERT INTO SUMINISTROS (precio_referencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001'),
    (60000.00, '900123456', 'R005'),
    (25000.00, '900123456', 'R006'),
    (45000.00, '900654321', 'R002'),
    (23000.00, '900654321', 'R006'),
    (650000.00, '900777888', 'R003'),
    (520000.00, '900777888', 'R004'),
    (58000.00, '900777888', 'R005');

INSERT INTO COMPRAS (numero, fecha, sede, proveedor) VALUES
    ('C01', '2026-08-25', 'S01', '900123456'),
    ('C02', '2026-08-26', 'S02', '900654321'),
    ('C03', '2026-08-27', 'S01', '900654321'),
    ('C04', '2026-08-28', 'S01', '900777888'),
    ('C05', '2026-08-29', 'S02', '900777888'),
    ('C06', '2026-09-01', 'S03', '900777888'),
    ('C07', '2026-09-02', 'S03', '900654321'),
    ('C08', '2026-10-01', 'S01', '900123456'),
    ('C09', '2026-10-15', 'S02', '900123456');

SELECT setval('SQ_COMPRAS_numero',
                (SELECT COALESCE(MAX(SUBSTRING(numero FROM 2)::INTEGER), 0) + 1 FROM COMPRAS), false);

INSERT INTO DETALLE_COMPRAS (cantidad, precio_unidad, compra, repuesto) VALUES
    (30, 20000.00, 'C01', 'R001'),
    (10, 45000.00, 'C02', 'R002'),
    (10, 45000.00, 'C03', 'R002'),
    (3, 650000.00, 'C04', 'R003'),
    (3, 520000.00, 'C04', 'R004'),
    (10, 58000.00, 'C04', 'R005'),
    (3, 650000.00, 'C05', 'R003'),
    (8, 58000.00, 'C05', 'R005'),
    (3, 520000.00, 'C06', 'R004'),
    (6, 58000.00, 'C06', 'R005'),
    (6, 45000.00, 'C07', 'R002'),
    (4, 23000.00, 'C07', 'R006'),
    (10, 60000.00, 'C08', 'R005'),
    (5, 25000.00, 'C08', 'R006'),
    (4, 25000.00, 'C09', 'R006'),
    (10, 20000.00, 'C09', 'R001');

INSERT INTO MOVIMIENTOS (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', '2026-09-15', 340000.00, 'Cobro orden de servicio DEF456', 'P'),
    ('M02', '2026-09-01', 600000.00, 'Pago compra C01', 'P'),
    ('M03', '2026-10-06', 354000.00, 'Cobro orden de servicio GHI789', 'P'),
    ('M04', '2026-09-02', 450000.00, 'Pago compra C02', 'P'),
    ('M05', '2026-09-02', 450000.00, 'Pago compra C03', 'P'),
    ('M06', '2026-09-05', 4090000.00, 'Pago compra C04', 'P'),
    ('M07', '2026-09-06', 2414000.00, 'Pago compra C05', 'P'),
    ('M08', '2026-09-07', 1908000.00, 'Pago compra C06', 'P'),
    ('M09', '2026-09-08', 5480000.00, 'Cobro orden de servicio JKL321', 'P'),
    ('M10', '2026-09-08', 362000.00, 'Pago compra C07', 'P'),
    ('M11', '2026-09-12', 4744000.00, 'Cobro orden de servicio GHI789', 'P'),
    ('M12', '2026-09-17', 2615000.00, 'Cobro orden de servicio VWX135', 'P'),
    ('M13', '2026-09-24', 2850000.00, 'Cobro orden de servicio MNO654', 'P'),
    ('M14', '2026-09-25', 1053000.00, 'Cobro orden de servicio YZA864', 'P'),
    ('M15', '2026-10-03', 725000.00, 'Pago compra C08', 'P'),
    ('M16', '2026-10-07', 4952000.00, 'Cobro orden de servicio PQR987', 'P'),
    ('M17', '2026-10-07', 1414000.00, 'Cobro orden de servicio BCD579', 'P'),
    ('M18', '2026-10-14', 1085000.00, 'Cobro orden de servicio BCD579', 'P'),
    ('M19', '2026-10-15', 4542000.00, 'Cobro orden de servicio JKL321', 'P'),
    ('M20', '2026-10-21', 2530000.00, 'Cobro orden de servicio EFG102', 'X'),
    ('M21', '2026-10-23', 1107000.00, 'Cobro orden de servicio STU246', 'P'),
    ('M22', '2026-10-24', 4580000.00, 'Cobro orden de servicio STU246', 'P'),
    ('M23', '2026-10-29', 2590000.00, 'Cobro orden de servicio EFG102', 'P'),
    ('M24', '2026-10-31', 4390000.00, 'Cobro orden de servicio MNO654', 'P'),
    ('M25', '2026-11-06', 1240000.00, 'Cobro orden de servicio VWX135', 'P');

INSERT INTO COBROS (movimiento, medio_pago, fecha_expedido, orden) VALUES
    ('M01', 'T', '2026-09-15', 'OS26-00000002'),
    ('M03', 'E', '2026-10-06', 'OS26-00000003'),
    ('M09', 'T', '2026-09-08', 'OS26-00000005'),
    ('M11', 'E', '2026-09-12', 'OS26-00000013'),
    ('M12', 'B', '2026-09-17', 'OS26-00000019'),
    ('M13', 'T', '2026-09-24', 'OS26-00000006'),
    ('M14', 'C', '2026-09-25', 'OS26-00000014'),
    ('M16', 'E', '2026-10-07', 'OS26-00000007'),
    ('M17', 'B', '2026-10-07', 'OS26-00000020'),
    ('M18', 'T', '2026-10-14', 'OS26-00000008'),
    ('M19', 'T', '2026-10-15', 'OS26-00000015'),
    ('M20', 'E', '2026-10-21', 'OS26-00000021'),
    ('M21', 'B', '2026-10-23', 'OS26-00000016'),
    ('M22', 'T', '2026-10-24', 'OS26-00000009'),
    ('M23', 'C', '2026-10-29', 'OS26-00000010'),
    ('M24', 'E', '2026-10-31', 'OS26-00000017'),
    ('M25', 'B', '2026-11-06', 'OS26-00000011');

INSERT INTO PAGOS (movimiento, fecha_pago, compra) VALUES
    ('M02', '2026-09-01', 'C01'),
    ('M04', '2026-09-02', 'C02'),
    ('M05', '2026-09-02', 'C03'),
    ('M06', '2026-09-05', 'C04'),
    ('M07', '2026-09-06', 'C05'),
    ('M08', '2026-09-07', 'C06'),
    ('M10', '2026-09-08', 'C07'),
    ('M15', '2026-10-03', 'C08');


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

-- Estructura JSON: el diagnostico debe traer los sintomas
INSERT INTO DETALLE_ORDENES (item, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio, tecnico, horas_trabajadas, diagnostico) VALUES
    (2, 150000.00, 'E', '2026-11-03', NULL, 'CS01', 'OS26-00000001', NULL, NULL, '{"hallazgos": "Fuga en el carter"}');
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
    -- Ganancia por sede en un mes
SELECT  g.sede,
        g.nombre,
        g.totalCobrado,
        g.totalCompras,
        g.totalSalarios,
        g.ganancia
FROM GANANCIAS_SEDES g
WHERE g.mes = '2026-09'
ORDER BY g.ganancia DESC;

    -- Valor generado por los tecnicos de una sede en un mes
SELECT  vt.nombre,
        vt.apellido,
        vt.sede,
        vt.trabajosFinalizados,
        vt.valorGenerado,
        vt.horasTrabajadas,
        vt.horasEstimadas,
        vt.diferencia
FROM VALORES_TECNICOS vt
WHERE vt.sede = 'S01' AND vt.mes = '2026-09'
ORDER BY vt.valorGenerado DESC;

    -- Clientes que mas han gastado en el negocio
SELECT  cc.cedula,
        cc.nombre,
        cc.apellido,
        COUNT(DISTINCT cc.placa) AS numeroVehiculos,
        COUNT(DISTINCT cc.orden) AS numeroOrdenes,
        SUM(cc.valor) AS totalCobrado
FROM COBROS_CLIENTES cc
WHERE cc.fecha BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY cc.cedula, cc.nombre, cc.apellido
ORDER BY totalCobrado DESC;

    -- Repuestos por agotarse en una sede
SELECT  ra.serie,
        ra.nombre,
        ra.cantidadDisponible,
        ra.cantidadUsada,
        ra.consumoMensualPromedio
FROM REPUESTOS_POR_AGOTARSE ra
JOIN EMPLEADOS e ON e.sede = ra.sede
WHERE e.persona = '3030303030' AND e.cargo = 'G'
ORDER BY ra.cantidadDisponible ASC;



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

    -- Consultar estado de un servicio
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







--Componentes
CREATE SCHEMA SV_SERVICIOS;

CREATE OR REPLACE FUNCTION SV_SERVICIOS.ad(empleado VARCHAR, vehiculo VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    sede_empleado VARCHAR;
    new_servicio VARCHAR;
BEGIN
    SELECT e.sede INTO sede_empleado
    FROM EMPLEADOS e
    WHERE e.persona = ad.empleado;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La persona no es empleado de ninguna sede';
    END IF;

    INSERT INTO SERVICIOS(vehiculo, sede)
    VALUES(ad.vehiculo, sede_empleado)
    RETURNING numero INTO new_servicio;
    RETURN new_servicio;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_SERVICIOS.up(empleado VARCHAR, numero VARCHAR, estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SERVICIOS s
                    JOIN EMPLEADOS e ON e.sede = s.sede
                    WHERE s.numero = up.numero
                        AND e.persona = up.empleado) THEN
        RAISE EXCEPTION 'El servicio no existe o no pertenece a la sede del empleado';
    END IF;

    UPDATE SERVICIOS s
    SET estado = up.estado
    WHERE s.numero = up.numero;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_SERVICIOS.ad_detalle(empleado VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    new_item INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SERVICIOS s
                    JOIN EMPLEADOS e ON e.sede = s.sede
                    WHERE s.numero = ad_detalle.servicio
                        AND e.persona = ad_detalle.empleado) THEN
        RAISE EXCEPTION 'El servicio no existe o no pertenece a la sede del empleado';
    END IF;

    SELECT COALESCE(MAX(d.item), 0) + 1 INTO new_item
    FROM DETALLE_ORDENES d
    WHERE d.servicio = ad_detalle.servicio;

    INSERT INTO DETALLE_ORDENES(item, estado, fecha_inicio, catalogo_servicio, servicio, tecnico)
    VALUES(new_item, 'E', CURRENT_DATE, ad_detalle.catalogo_servicio, ad_detalle.servicio, ad_detalle.tecnico);
    RETURN new_item;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_SERVICIOS.up_detalle(tecnico VARCHAR, servicio VARCHAR, item INTEGER, estado VARCHAR, horas_trabajadas NUMERIC)
RETURNS VOID AS $$
BEGIN
    UPDATE DETALLE_ORDENES d
    SET estado = COALESCE(up_detalle.estado, d.estado),
        horas_trabajadas = COALESCE(up_detalle.horas_trabajadas, d.horas_trabajadas),
        fecha_fin = CASE WHEN up_detalle.estado = 'F' THEN CURRENT_DATE ELSE d.fecha_fin END
    WHERE d.servicio = up_detalle.servicio
        AND d.item = up_detalle.item
        AND d.tecnico = up_detalle.tecnico;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El detalle no existe o no esta asignado al tecnico';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_SERVICIOS.up_diagnostico(tecnico VARCHAR, servicio VARCHAR, item INTEGER, diagnostico JSONB)
RETURNS VOID AS $$
BEGIN
    UPDATE DETALLE_ORDENES d
    SET diagnostico = up_diagnostico.diagnostico
    WHERE d.servicio = up_diagnostico.servicio
        AND d.item = up_diagnostico.item
        AND d.tecnico = up_diagnostico.tecnico;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El detalle no existe o no esta asignado al tecnico';
    END IF;
END;
$$ LANGUAGE plpgsql;


--Los servicios no se eliminan
CREATE OR REPLACE FUNCTION SV_SERVICIOS.de(empleado VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    RAISE EXCEPTION 'No se permite eliminar los servicios';
END;
$$ LANGUAGE plpgsql;


/* Valor total de un servicio (atributo derivado /valorTotal):
la suma de los valores cobrados en sus detalles mas la suma de (cantidad x precio)
de los repuestos consumidos en ellos. No se cuentan los detalles cancelados. */
CREATE OR REPLACE FUNCTION SV_SERVICIOS.co_valorTotal(empleado VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    total_detalles NUMERIC;
    total_repuestos NUMERIC;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SERVICIOS s
                    JOIN EMPLEADOS e ON e.sede = s.sede
                    WHERE s.numero = co_valorTotal.numero
                        AND e.persona = co_valorTotal.empleado) THEN
        RAISE EXCEPTION 'El servicio no existe o no pertenece a la sede del empleado';
    END IF;

    SELECT COALESCE(SUM(d.valor_cobrado), 0) INTO total_detalles
    FROM DETALLE_ORDENES d
    WHERE d.servicio = co_valorTotal.numero AND d.estado <> 'C';

    SELECT COALESCE(SUM(co.cantidad * co.precio), 0) INTO total_repuestos
    FROM CONSUMOS co
    JOIN DETALLE_ORDENES d ON d.servicio = co.servicio AND d.item = co.item
    WHERE co.servicio = co_valorTotal.numero AND d.estado <> 'C';

    RETURN total_detalles + total_repuestos;
END;
$$ LANGUAGE plpgsql;


/* COMO gerente
QUIERO saber que ordenes de servicio de mi sede se encuentran en proceso
PARA PODER mantener un control oportuno de los trabajos que estan siendo realizados
-
Detalle
C: Numero de orden, placa, nombre y apellido del cliente y fecha de inicio.
F: Ordenes en estado E de la sede del empleado que consulta.
O: De la mas antigua a la mas reciente.
 */
CREATE OR REPLACE FUNCTION SV_SERVICIOS.co_enProceso(empleado VARCHAR)
RETURNS REFCURSOR AS $$
DECLARE
    cur REFCURSOR := 'co_enProceso';
BEGIN
    OPEN cur FOR
        SELECT  s.numero,
                s.vehiculo AS placa,
                p.nombre,
                p.apellido,
                s.fecha_inicio
        FROM SERVICIOS s
        JOIN VEHICULOS v ON v.placa = s.vehiculo
        JOIN PERSONAS p ON p.cedula = v.cliente
        JOIN EMPLEADOS e ON e.sede = s.sede
        WHERE s.estado = 'E' AND e.persona = co_enProceso.empleado
        ORDER BY s.fecha_inicio ASC;
    RETURN cur;
END;
$$ LANGUAGE plpgsql;


/* COMO gerente
QUIERO saber como va la reparacion del vehiculo de un cliente
PARA PODER informarle al cliente el avance de su servicio
-
Detalle
C: Numero de orden, sede, fecha de inicio, servicio del catalogo y estado de cada detalle.
F: Placa del vehiculo y ordenes en estado E.
O: Por fecha de inicio.
 */
CREATE OR REPLACE FUNCTION SV_SERVICIOS.co_estado(placa VARCHAR)
RETURNS REFCURSOR AS $$
DECLARE
    cur REFCURSOR := 'co_estado';
BEGIN
    OPEN cur FOR
        SELECT  s.numero AS numeroOrden,
                s.sede AS sede,
                det.fecha_inicio AS fechaInicio,
                cat.nombre AS servicioRealizado,
                det.estado AS estadoServicio
        FROM SERVICIOS s
        JOIN DETALLE_ORDENES det ON det.servicio = s.numero
        JOIN CATALOGO_SERVICIOS cat ON cat.codigo = det.catalogo_servicio
        WHERE s.vehiculo = co_estado.placa AND s.estado = 'E'
        ORDER BY det.fecha_inicio ASC, det.item ASC;
    RETURN cur;
END;
$$ LANGUAGE plpgsql;




CREATE SCHEMA SV_COMPRAS;

CREATE OR REPLACE FUNCTION SV_COMPRAS.ad(gerente VARCHAR, proveedor VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    sede_gerente VARCHAR;
    new_compra VARCHAR;
BEGIN
    SELECT e.sede INTO sede_gerente
    FROM EMPLEADOS e
    WHERE e.persona = ad.gerente AND e.cargo = 'G';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El empleado no es gerente de ninguna sede';
    END IF;

    INSERT INTO COMPRAS(sede, proveedor)
    VALUES(sede_gerente, ad.proveedor)
    RETURNING numero INTO new_compra;
    RETURN new_compra;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_COMPRAS.up(gerente VARCHAR, numero VARCHAR, proveedor VARCHAR)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM COMPRAS c
                    JOIN EMPLEADOS e ON e.sede = c.sede
                    WHERE c.numero = up.numero
                        AND e.persona = up.gerente AND e.cargo = 'G') THEN
        RAISE EXCEPTION 'La compra no existe o no pertenece a la sede del gerente';
    END IF;

    UPDATE COMPRAS c
    SET proveedor = COALESCE(up.proveedor, c.proveedor)
    WHERE c.numero = up.numero;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_COMPRAS.de(gerente VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM COMPRAS c
                    JOIN EMPLEADOS e ON e.sede = c.sede
                    WHERE c.numero = de.numero
                        AND e.persona = de.gerente AND e.cargo = 'G') THEN
        RAISE EXCEPTION 'La compra no existe o no pertenece a la sede del gerente';
    END IF;

    IF EXISTS (SELECT 1 FROM PAGOS pg WHERE pg.compra = de.numero) THEN
        RAISE EXCEPTION 'La compra ya tiene pago y no se puede eliminar';
    END IF;

    DELETE FROM COMPRAS c WHERE c.numero = de.numero;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_COMPRAS.ad_detalle(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM COMPRAS c
                    JOIN EMPLEADOS e ON e.sede = c.sede
                    WHERE c.numero = ad_detalle.compra
                        AND e.persona = ad_detalle.gerente AND e.cargo = 'G') THEN
        RAISE EXCEPTION 'La compra no existe o no pertenece a la sede del gerente';
    END IF;

    INSERT INTO DETALLE_COMPRAS(cantidad, precio_unidad, compra, repuesto)
    VALUES(ad_detalle.cantidad, ad_detalle.precio_unidad, ad_detalle.compra, ad_detalle.repuesto);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_COMPRAS.up_detalle(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM COMPRAS c
                    JOIN EMPLEADOS e ON e.sede = c.sede
                    WHERE c.numero = up_detalle.compra
                        AND e.persona = up_detalle.gerente AND e.cargo = 'G') THEN
        RAISE EXCEPTION 'La compra no existe o no pertenece a la sede del gerente';
    END IF;

    UPDATE DETALLE_COMPRAS dc
    SET cantidad = COALESCE(up_detalle.cantidad, dc.cantidad),
        precio_unidad = COALESCE(up_detalle.precio_unidad, dc.precio_unidad)
    WHERE dc.compra = up_detalle.compra AND dc.repuesto = up_detalle.repuesto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El detalle no pertenece a la compra';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION SV_COMPRAS.de_detalle(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM COMPRAS c
                    JOIN EMPLEADOS e ON e.sede = c.sede
                    WHERE c.numero = de_detalle.compra
                        AND e.persona = de_detalle.gerente AND e.cargo = 'G') THEN
        RAISE EXCEPTION 'La compra no existe o no pertenece a la sede del gerente';
    END IF;

    DELETE FROM DETALLE_COMPRAS dc
    WHERE dc.compra = de_detalle.compra AND dc.repuesto = de_detalle.repuesto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El detalle no pertenece a la compra';
    END IF;
END;
$$ LANGUAGE plpgsql;


/* Valor total de una compra (atributo derivado /valorTotal):
la suma de (cantidad x precio por unidad) de sus detalles. */
CREATE OR REPLACE FUNCTION SV_COMPRAS.co_valorTotal(empleado VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM COMPRAS c
                    JOIN EMPLEADOS e ON e.sede = c.sede
                    WHERE c.numero = co_valorTotal.numero
                        AND e.persona = co_valorTotal.empleado) THEN
        RAISE EXCEPTION 'La compra no existe o no pertenece a la sede del empleado';
    END IF;

    SELECT COALESCE(SUM(dc.cantidad * dc.precio_unidad), 0) INTO total
    FROM DETALLE_COMPRAS dc
    WHERE dc.compra = co_valorTotal.numero;

    RETURN total;
END;
$$ LANGUAGE plpgsql;


/* COMO empleado
QUIERO conocer los repuestos cuyas existencias en mi sede estan por agotarse
PARA PODER avisar u ordenar un traslado o una compra antes de quedarnos sin ese repuesto
-
Detalle
C: Numero de serie y nombre del repuesto, cantidad disponible
(compras + traslados que llegan - traslados que salen - consumos),
cantidad usada y consumo mensual promedio.
F: Sede del empleado que consulta.
O: De menor a mayor por cantidad disponible.
 */
CREATE OR REPLACE FUNCTION SV_COMPRAS.co_porAgotarse(empleado VARCHAR)
RETURNS REFCURSOR AS $$
DECLARE
    cur REFCURSOR := 'co_porAgotarse';
BEGIN
    OPEN cur FOR
        SELECT  ra.serie,
                ra.nombre,
                ra.cantidadDisponible,
                ra.cantidadUsada,
                ra.consumoMensualPromedio
        FROM REPUESTOS_POR_AGOTARSE ra
        JOIN EMPLEADOS e ON e.sede = ra.sede
        WHERE e.persona = co_porAgotarse.empleado
        ORDER BY ra.cantidadDisponible ASC;
    RETURN cur;
END;
$$ LANGUAGE plpgsql;


--XComponentes
/*
DROP FUNCTION IF EXISTS SV_SERVICIOS.ad(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.up(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.ad_detalle(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.de(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.up_detalle(VARCHAR, VARCHAR, INTEGER, VARCHAR, NUMERIC);
DROP FUNCTION IF EXISTS SV_SERVICIOS.up_diagnostico(VARCHAR, VARCHAR, INTEGER, JSONB);
DROP FUNCTION IF EXISTS SV_SERVICIOS.co_valorTotal(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.co_enProceso(VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.co_estado(VARCHAR);
DROP SCHEMA IF EXISTS SV_SERVICIOS;

DROP FUNCTION IF EXISTS SV_COMPRAS.ad(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_COMPRAS.up(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_COMPRAS.de(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_COMPRAS.ad_detalle(VARCHAR, VARCHAR, VARCHAR, INTEGER, NUMERIC);
DROP FUNCTION IF EXISTS SV_COMPRAS.up_detalle(VARCHAR, VARCHAR, VARCHAR, INTEGER, NUMERIC);
DROP FUNCTION IF EXISTS SV_COMPRAS.de_detalle(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_COMPRAS.co_valorTotal(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_COMPRAS.co_porAgotarse(VARCHAR);
DROP SCHEMA IF EXISTS SV_COMPRAS;
*/


--ComponentesOK

-- Caso 1: La gerente de S02 (8080808080) abre un servicio para el vehiculo GHI789.
-- Queda en la sede de la gerente, con el numero consecutivo, la fecha de hoy y el estado E
SELECT SV_SERVICIOS.ad('8080808080', 'GHI789');
SELECT * FROM SERVICIOS WHERE numero = (SELECT MAX(numero) FROM SERVICIOS);

-- Caso 2: Se le agrega un cambio de aceite a ese servicio.
-- Queda como item 1, en estado E y con el precio local de S02 (155000)
SELECT SV_SERVICIOS.ad_detalle('8080808080', (SELECT MAX(numero) FROM SERVICIOS), 'CS01', '6060606060');

-- Caso 3: A la orden OS26-00000001 (S01) se le agrega una revision de frenos.
-- Queda como item 2 y con el precio base (220000) porque S01 no tiene precio local
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS02', '5050505050');

-- Caso 4: El tecnico 2020202020 finaliza el item 1 de la orden OS26-00000001. Queda en F y con fecha de fin de hoy
SELECT SV_SERVICIOS.up_detalle('2020202020', 'OS26-00000001', 1, 'F', NULL);
SELECT item, estado, fecha_fin, valor_cobrado, tecnico, horas_trabajadas
FROM DETALLE_ORDENES WHERE servicio = 'OS26-00000001' ORDER BY item;

-- Caso 5: Valor total de la orden OS26-00000001: 160000 + 220000 + (1 x 25000) = 405000
SELECT SV_SERVICIOS.co_valorTotal('3030303030', 'OS26-00000001');

-- Caso 6: Estado del servicio del vehiculo ABC123: item 1 en F e item 2 en E
BEGIN;
SELECT SV_SERVICIOS.co_estado('ABC123');
FETCH ALL IN "co_estado";
COMMIT;

-- Caso 7: Se cancela el servicio abierto en el caso 1. Su detalle en proceso queda cancelado
SELECT SV_SERVICIOS.up('8080808080', (SELECT MAX(numero) FROM SERVICIOS), 'C');
SELECT servicio, item, estado FROM DETALLE_ORDENES WHERE servicio = (SELECT MAX(numero) FROM SERVICIOS);

-- Caso 8: Ordenes en proceso de la sede de la gerente 3030303030 (S01): OS26-00000001
BEGIN;
SELECT SV_SERVICIOS.co_enProceso('3030303030');
FETCH ALL IN "co_enProceso";
COMMIT;

-- Caso 9: La gerente de S01 (3030303030) abre una compra al proveedor 900123456.
-- Queda en la sede de la gerente, con el numero consecutivo C000000010 y la fecha de hoy
SELECT SV_COMPRAS.ad('3030303030', '900123456');
SELECT * FROM COMPRAS WHERE numero = 'C000000010';

-- Caso 10: Se agregan 20 filtros de aceite (R001) sin indicar precio.
-- Se toma el precio de referencia del proveedor (20000)
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C000000010', 'R001', 20, NULL);

-- Caso 11: Se corrige el detalle: son 25 unidades a 19000
SELECT SV_COMPRAS.up_detalle('3030303030', 'C000000010', 'R001', 25, 19000);
SELECT * FROM DETALLE_COMPRAS WHERE compra = 'C000000010';

-- Caso 12: El tecnico 2020202020 (S01) consulta el valor total de la compra: 25 x 19000 = 475000
SELECT SV_COMPRAS.co_valorTotal('2020202020', 'C000000010');

-- Caso 13: La gerente de S02 abre la compra C000000011 por error, le agrega un detalle,
-- quita el detalle y elimina la compra
SELECT SV_COMPRAS.ad('8080808080', '900654321');
SELECT SV_COMPRAS.ad_detalle('8080808080', 'C000000011', 'R002', 5, 44000);
SELECT SV_COMPRAS.de_detalle('8080808080', 'C000000011', 'R002');
SELECT SV_COMPRAS.de('8080808080', 'C000000011');
SELECT COUNT(*) AS comprasC5 FROM COMPRAS WHERE numero = 'C000000011';

-- Caso 14: Repuestos por agotarse en la sede de la gerente 3030303030 (S01).
-- Los filtros de aceite ya incluyen las 25 unidades de la compra C000000010
BEGIN;
SELECT SV_COMPRAS.co_porAgotarse('3030303030');
FETCH ALL IN "co_porAgotarse";
COMMIT;


--ComponentesNoOK
/*
-- Caso 1: El vehiculo ZZZ999 no esta registrado
-- FK_SERVICIOS_VEHICULO rechaza el insert
SELECT SV_SERVICIOS.ad('3030303030', 'ZZZ999');

-- Caso 2: Un servicio finalizado (OS26-00000002) no se puede modificar
-- tg_1_SERVICIOS_bu lanza 'No se pueden modificar los servicios finalizados'
SELECT SV_SERVICIOS.up('3030303030', 'OS26-00000002', 'C');

-- Caso 3: Los servicios no se pueden eliminar, ni siquiera los cancelados (OS26-00000004)
-- de lanza 'No se permite eliminar los servicios'
SELECT SV_SERVICIOS.de('8080808080', 'OS26-00000004');

-- Caso 4: La sede S01 no tiene habilitado el servicio CS03
-- tg_1_DETALLE_ORDENES_bi lanza 'La sede no tiene habilitado ese servicio del catalogo'
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS03', NULL);

-- Caso 5: No se agregan detalles a un servicio finalizado (OS26-00000002)
-- tg_1_DETALLE_ORDENES_bi lanza 'Solo se pueden agregar detalles a los servicios en proceso'
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000002', 'CS01', NULL);

-- Caso 6: El item 2 de OS26-00000001 no tiene horas trabajadas, no se puede finalizar
-- CK_DETALLE_ORDENES_ESTADO_TECNICO rechaza el update
SELECT SV_SERVICIOS.up_detalle('5050505050', 'OS26-00000001', 2, 'F', NULL);

-- Caso 7: El item 9 no existe en la orden OS26-00000001
-- up_detalle lanza 'El detalle no existe o no esta asignado al tecnico'
SELECT SV_SERVICIOS.up_detalle('5050505050', 'OS26-00000001', 9, 'F', 2);

-- Caso 8: Quien ejecuta el detalle debe ser un tecnico (3030303030 es gerente)
-- FK_DETALLE_ORDENES_TECNICO rechaza el insert
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS01', '3030303030');

-- Caso 9: Ana (1010101010) es cliente, no empleada: no puede abrir servicios
-- ad lanza 'La persona no es empleado de ninguna sede'
SELECT SV_SERVICIOS.ad('1010101010', 'ABC123');

-- Caso 10: La gerente de S02 no puede agregar detalles a una orden de S01 (OS26-00000001)
-- ad_detalle lanza 'El servicio no existe o no pertenece a la sede del empleado'
SELECT SV_SERVICIOS.ad_detalle('8080808080', 'OS26-00000001', 'CS01', NULL);

-- Caso 11: El item 1 de OS26-00000001 es de 2020202020 otro tecnico no lo puede modificar
-- up_detalle lanza 'El detalle no existe o no esta asignado al tecnico'
SELECT SV_SERVICIOS.up_detalle('5050505050', 'OS26-00000001', 1, 'F', 1);

-- Caso 12: La orden OS26-00000001 tiene detalles en proceso, no se puede finalizar
-- tg_1_SERVICIOS_bu lanza 'No se puede finalizar un servicio con detalles en proceso'
SELECT SV_SERVICIOS.up('3030303030', 'OS26-00000001', 'F');

-- Caso 13: El tecnico 6060606060 trabaja en S02, no se le puede asignar un detalle de una orden de S01
-- tg_1_DETALLE_ORDENES_bi lanza 'El tecnico no trabaja en la sede del servicio'
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS01', '6060606060');

-- Caso 14: El tecnico 2020202020 no registra compras
-- ad lanza 'El empleado no es gerente de ninguna sede'
SELECT SV_COMPRAS.ad('2020202020', '900123456');

-- Caso 15: El proveedor 900123456 no tiene precio de referencia para las pastillas (R002) y no se indica precio
-- tg_2_DETALLE_COMPRAS_bi lanza 'Se debe indicar el precio por unidad, el proveedor no tiene precio de referencia para ese repuesto'
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C000000010', 'R002', 1, NULL);

-- Caso 16: La compra C01 ya tiene pago
-- tg_1_DETALLE_COMPRAS_bi lanza 'La compra ya tiene pago y no se puede modificar'
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C01', 'R001', 5, NULL);

-- Caso 17: El repuesto R001 ya esta en la compra C000000010
-- PK_DETALLE_COMPRAS rechaza el insert
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C000000010', 'R001', 5, NULL);

-- Caso 18: La cantidad comprada debe ser mayor a cero
-- CK_DETALLE_COMPRAS_CANTIDAD rechaza el update
SELECT SV_COMPRAS.up_detalle('3030303030', 'C000000010', 'R001', 0, NULL);

-- Caso 19: La compra C01 ya tiene pago, no se puede eliminar
-- de lanza 'La compra ya tiene pago y no se puede eliminar' y la FK_PAGOS_COMPRA rechaza el DELETE directo
SELECT SV_COMPRAS.de('3030303030', 'C01');

-- Caso 20: La compra C000000010 ya tiene detalles, no se le puede cambiar el proveedor
-- tg_1_COMPRAS_bu lanza 'No se puede cambiar el proveedor de una compra que ya tiene detalles'
SELECT SV_COMPRAS.up('3030303030', 'C000000010', '900654321');

-- Caso 21: Un tecnico no modifica compras, aunque sean de su sede
-- up_detalle lanza 'La compra no existe o no pertenece a la sede del gerente'
SELECT SV_COMPRAS.up_detalle('2020202020', 'C000000010', 'R001', 1, NULL);

-- Caso 22: La gerente de S02 no puede eliminar una compra de S01
-- de lanza 'La compra no existe o no pertenece a la sede del gerente'
SELECT SV_COMPRAS.de('8080808080', 'C000000010');
*/




--Actores
CREATE SCHEMA SV_GERENTE;

CREATE OR REPLACE FUNCTION SV_GERENTE.ad_servicio(gerente VARCHAR, vehiculo VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_SERVICIOS.ad(ad_servicio.gerente, ad_servicio.vehiculo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.up_servicio(gerente VARCHAR, numero VARCHAR, estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up(up_servicio.gerente, up_servicio.numero, up_servicio.estado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.de_servicio(gerente VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.de(de_servicio.gerente, de_servicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.ad_detalle_servicio(gerente VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico VARCHAR)
RETURNS INTEGER AS $$
BEGIN
    RETURN SV_SERVICIOS.ad_detalle(ad_detalle_servicio.gerente, ad_detalle_servicio.servicio, ad_detalle_servicio.catalogo_servicio, ad_detalle_servicio.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_valorTotalServicio(gerente VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_SERVICIOS.co_valorTotal(co_valorTotalServicio.gerente, co_valorTotalServicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_serviciosEnProcesoSede(gerente VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_enProceso(co_serviciosEnProcesoSede.gerente);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_estadoServicioVehiculo(placa VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_estado(co_estadoServicioVehiculo.placa);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;






CREATE OR REPLACE FUNCTION SV_GERENTE.ad_compra(gerente VARCHAR, proveedor VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_COMPRAS.ad(ad_compra.gerente, ad_compra.proveedor);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.up_compra(gerente VARCHAR, numero VARCHAR, proveedor VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.up(up_compra.gerente, up_compra.numero, up_compra.proveedor);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.de_compra(gerente VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.de(de_compra.gerente, de_compra.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.ad_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.ad_detalle(ad_detalle_compra.gerente, ad_detalle_compra.compra, ad_detalle_compra.repuesto, ad_detalle_compra.cantidad, ad_detalle_compra.precio_unidad);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.up_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.up_detalle(up_detalle_compra.gerente, up_detalle_compra.compra, up_detalle_compra.repuesto, up_detalle_compra.cantidad, up_detalle_compra.precio_unidad);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.de_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.de_detalle(de_detalle_compra.gerente, de_detalle_compra.compra, de_detalle_compra.repuesto);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_valorTotalCompra(gerente VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_COMPRAS.co_valorTotal(co_valorTotalCompra.gerente, co_valorTotalCompra.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_repuestosPorAgotarseSede(gerente VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_COMPRAS.co_porAgotarse(co_repuestosPorAgotarseSede.gerente);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



CREATE SCHEMA SV_TECNICO;

CREATE OR REPLACE FUNCTION SV_TECNICO.ad_servicio(tecnico VARCHAR, vehiculo VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_SERVICIOS.ad(ad_servicio.tecnico, ad_servicio.vehiculo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_servicio(tecnico VARCHAR, numero VARCHAR, estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up(up_servicio.tecnico, up_servicio.numero, up_servicio.estado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.de_servicio(tecnico VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.de(de_servicio.tecnico, de_servicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.ad_detalle_servicio(tecnico VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico_asignado VARCHAR)
RETURNS INTEGER AS $$
BEGIN
    RETURN SV_SERVICIOS.ad_detalle(ad_detalle_servicio.tecnico, ad_detalle_servicio.servicio, ad_detalle_servicio.catalogo_servicio, ad_detalle_servicio.tecnico_asignado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_valorTotalServicio(tecnico VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_SERVICIOS.co_valorTotal(co_valorTotalServicio.tecnico, co_valorTotalServicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_serviciosEnProcesoSede(tecnico VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_enProceso(co_serviciosEnProcesoSede.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_estadoServicioVehiculo(placa VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_estado(co_estadoServicioVehiculo.placa);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_detalle_servicio(tecnico VARCHAR, servicio VARCHAR, item INTEGER, estado VARCHAR, horas_trabajadas NUMERIC)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up_detalle(up_detalle_servicio.tecnico, up_detalle_servicio.servicio, up_detalle_servicio.item, up_detalle_servicio.estado, up_detalle_servicio.horas_trabajadas);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_diagnostico_servicio(tecnico VARCHAR, servicio VARCHAR, item INTEGER, diagnostico JSONB)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up_diagnostico(up_diagnostico_servicio.tecnico, up_diagnostico_servicio.servicio, up_diagnostico_servicio.item, up_diagnostico_servicio.diagnostico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



CREATE OR REPLACE FUNCTION SV_TECNICO.co_valorTotalCompra(tecnico VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_COMPRAS.co_valorTotal(co_valorTotalCompra.tecnico, co_valorTotalCompra.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_repuestosPorAgotarseSede(tecnico VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_COMPRAS.co_porAgotarse(co_repuestosPorAgotarseSede.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



--Seguridad
-- Las funciones de rol no funcionan el la DB de la Universidad
CREATE ROLE mecadata_gerente;
CREATE ROLE mecadata_tecnico;

GRANT USAGE ON SCHEMA SV_GERENTE TO mecadata_gerente;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA SV_GERENTE TO mecadata_gerente;

GRANT USAGE ON SCHEMA SV_TECNICO TO mecadata_tecnico;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA SV_TECNICO TO mecadata_tecnico;


--XSeguridad
/*
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA SV_GERENTE FROM mecadata_gerente;
REVOKE USAGE ON SCHEMA SV_GERENTE FROM mecadata_gerente;
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA SV_TECNICO FROM mecadata_tecnico;
REVOKE USAGE ON SCHEMA SV_TECNICO FROM mecadata_tecnico;

DROP FUNCTION IF EXISTS SV_GERENTE.ad_servicio(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.up_servicio(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.de_servicio(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.ad_detalle_servicio(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.co_valorTotalServicio(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.co_serviciosEnProcesoSede(VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.co_estadoServicioVehiculo(VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.ad_servicio(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.up_servicio(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.de_servicio(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.ad_detalle_servicio(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.co_serviciosEnProcesoSede(VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.co_estadoServicioVehiculo(VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.co_valorTotalServicio(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.up_detalle_servicio(VARCHAR, VARCHAR, INTEGER, VARCHAR, NUMERIC);
DROP FUNCTION IF EXISTS SV_TECNICO.up_diagnostico_servicio(VARCHAR, VARCHAR, INTEGER, JSONB);
DROP FUNCTION IF EXISTS SV_GERENTE.ad_compra(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.up_compra(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.de_compra(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.ad_detalle_compra(VARCHAR, VARCHAR, VARCHAR, INTEGER, NUMERIC);
DROP FUNCTION IF EXISTS SV_GERENTE.up_detalle_compra(VARCHAR, VARCHAR, VARCHAR, INTEGER, NUMERIC);
DROP FUNCTION IF EXISTS SV_GERENTE.de_detalle_compra(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.co_valorTotalCompra(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_GERENTE.co_repuestosPorAgotarseSede(VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.co_valorTotalCompra(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_TECNICO.co_repuestosPorAgotarseSede(VARCHAR);

DROP SCHEMA IF EXISTS SV_GERENTE;
DROP SCHEMA IF EXISTS SV_TECNICO;

DROP ROLE IF EXISTS mecadata_gerente;
DROP ROLE IF EXISTS mecadata_tecnico;
*/


--SeguridadOK

-- Cuenta: Gerente

-- Caso 1: La gerente de S01 consulta las ordenes en proceso de su sede: OS26-00000001
BEGIN;
SELECT SV_GERENTE.co_serviciosEnProcesoSede('3030303030');
FETCH ALL IN "co_enProceso";
COMMIT;

-- Caso 2: Agrega un cambio de aceite a la orden OS26-00000001. Queda como item 3
SELECT SV_GERENTE.ad_detalle_servicio('3030303030', 'OS26-00000001', 'CS01', '2020202020');

-- Caso 3: Consulta el valor total de la orden: 405000 + 160000 = 565000
SELECT SV_GERENTE.co_valorTotalServicio('3030303030', 'OS26-00000001');

-- Caso 4: La gerente de S02 abre una orden para el vehiculo DEF456. La sede se toma de la gerente
SELECT SV_GERENTE.ad_servicio('8080808080', 'DEF456');


-- Cuenta: Tecnico

-- Caso 5: La tecnica 5050505050 registra 2 horas y finaliza su trabajo (item 2 de OS26-00000001)
SELECT SV_TECNICO.up_detalle_servicio('5050505050', 'OS26-00000001', 2, 'F', 2);

-- Caso 6: El tecnico 6060606060 recibe el vehiculo GHI789 y abre la orden. La sede se toma del tecnico (S02)
SELECT SV_TECNICO.ad_servicio('6060606060', 'GHI789');


-- Cuenta: Gerente

-- Caso 7: Confirma el avance del vehiculo ABC123: items 1 y 2 en F, item 3 en E
BEGIN;
SELECT SV_GERENTE.co_estadoServicioVehiculo('ABC123');
FETCH ALL IN "co_estado";
COMMIT;


-- Cuenta: Gerente

-- Caso 8: La gerente de S02 abre una compra al proveedor 900654321.
-- La sede se toma de la gerente y se asigna el numero C000000012
SELECT SV_GERENTE.ad_compra('8080808080', '900654321');

-- Caso 9: Le agrega 8 pastillas de freno (R002) al precio de referencia (45000)
SELECT SV_GERENTE.ad_detalle_compra('8080808080', 'C000000012', 'R002', 8, NULL);

-- Caso 10: Consulta el valor total de la compra: 8 x 45000 = 360000
SELECT SV_GERENTE.co_valorTotalCompra('8080808080', 'C000000012');

-- Caso 11: La gerente de S01 sube a 30 las unidades de su compra C000000010
SELECT SV_GERENTE.up_detalle_compra('3030303030', 'C000000010', 'R001', 30, NULL);
SELECT SV_GERENTE.co_valorTotalCompra('3030303030', 'C000000010');


-- Cuenta: Tecnico

-- Caso 12: El tecnico 6060606060 consulta los repuestos por agotarse en su sede (S02)
BEGIN;
SELECT SV_TECNICO.co_repuestosPorAgotarseSede('6060606060');
FETCH ALL IN "co_porAgotarse";
COMMIT;

-- Caso 13: Consulta el valor total de la compra C000000012 de su sede: 360000
SELECT SV_TECNICO.co_valorTotalCompra('6060606060', 'C000000012');



--SeguridadNoOK
/*
-- Cuenta: Gerente

-- Caso 1: No puede usar los servicios del tecnico
SELECT SV_TECNICO.up_detalle_servicio('2020202020', 'OS26-00000001', 3, 'F', 1);

-- Caso 2: No puede saltarse los servicios y leer la tabla directamente
SELECT * FROM SERVICIOS;

-- Caso 3: No puede usar el componente directamente
SELECT SV_SERVICIOS.de('3030303030', 'OS26-00000001');

-- Caso 4: La gerente de S02 no puede cancelar una orden de S01
SELECT SV_GERENTE.up_servicio('8080808080', 'OS26-00000001', 'C');


-- Cuenta: Tecnico

-- Caso 5: No puede usar los servicios del gerente
SELECT SV_GERENTE.ad_servicio('3030303030', 'ABC123');

-- Caso 6: No puede registrar trabajo en un detalle asignado a otro tecnico
SELECT SV_TECNICO.up_detalle_servicio('5050505050', 'OS26-00000001', 3, 'F', 1);

-- Cuenta: Gerente

-- Caso 7: No puede saltarse los servicios y leer la tabla directamente
SELECT * FROM COMPRAS;

-- Caso 8: No puede usar el componente directamente
SELECT SV_COMPRAS.de('3030303030', 'C000000010');

-- Caso 9: La gerente de S02 no puede modificar una compra de S01
SELECT SV_GERENTE.up_detalle_compra('8080808080', 'C000000010', 'R001', 1, NULL);

-- Caso 10: La gerente de S02 no puede eliminar una compra de S01
SELECT SV_GERENTE.de_compra('8080808080', 'C000000010');


-- Cuenta: Tecnico

-- Caso 11: El tecnico no registra compras: no puede usar los servicios del gerente
SELECT SV_GERENTE.ad_compra('3030303030', '900123456');

-- Caso 12: No puede consultar compras de otra sede (6060606060 es de S02, C000000010 de S01)
SELECT SV_TECNICO.co_valorTotalCompra('6060606060', 'C000000010');


*/






/* CRUD de COMPRAS

COMO gerente
QUIERO mantener las compras de repuestos de mi sede
PARA PODER abastecer el inventario y saber cuanto se le debe a cada proveedor
-
Adicion
------------
Se debe asignar automaticamente el numero (C#########) y la fecha (hoy)
SQ_COMPRAS_numero y valores por omision de numero y fecha
La fecha de la compra no puede ser futura.
tg_1_COMPRAS_bi (tg.restringe)
Solo el gerente registra compras, y siempre para su propia sede.
SV_COMPRAS.ad (componente)
La compra la hace una sede existente a un proveedor registrado.
FK_COMPRAS_SEDE, FK_COMPRAS_PROVEEDOR
Cada detalle se identifica por el repuesto dentro de la compra: un repuesto aparece una sola vez por compra.
PK_DETALLE_COMPRAS, FK_DETALLE_COMPRAS_REPUESTO
La cantidad comprada debe ser mayor a cero.
CK_DETALLE_COMPRAS_CANTIDAD
Si no se indica el precio por unidad se toma el precio de referencia del proveedor
si el proveedor no tiene precio de referencia para ese repuesto, el precio se debe indicar.
tg_2_DETALLE_COMPRAS_bi (tg.automatiza)
-
Modificacion
---------------------
Solo el gerente de la sede de la compra la modifica.
SV_COMPRAS.up, SV_COMPRAS.ad_detalle, SV_COMPRAS.up_detalle, SV_COMPRAS.de_detalle (componente)
Una compra que ya tiene pago no se puede modificar. De una compra solo cambia el proveedor,
y solo mientras no tenga detalles; el numero, la fecha y la sede no cambian.
tg_1_COMPRAS_bu (tg.restringe)
Los detalles de una compra que ya tiene pago no se agregan, no se modifican y no se eliminan.
tg_1_DETALLE_COMPRAS_bi, tg_1_DETALLE_COMPRAS_bu, tg_1_DETALLE_COMPRAS_bd (tg.restringe)
Los pagos de las compras no se modifican ni se eliminan.
tg_1_PAGOS_bu, tg_1_PAGOS_bd (tg.restringe)
-
Eliminacion
-------------------
Solo el gerente de la sede de la compra la elimina.
SV_COMPRAS.de (componente)
Una compra que ya tiene pago no se puede eliminar.
SV_COMPRAS.de (componente), FK_PAGOS_COMPRA
Con la compra se eliminan sus detalles.
FK_DETALLE_COMPRAS_COMPRA (ON DELETE CASCADE) */



--Pruebas
/*
Laura Moreno, la gerente de la Sede Sur, revisa los repuestos por agotarse y ve que le quedan
pocas pastillas de freno. Decide hacerle un pedido a Frenos Ya LTDA. Mientras arma la compra
intenta incluir filtros de aceite sin decir el precio, pero no hay un precio de referencia de
Frenos Ya para ese repuesto. Luego corrige la
cantidad de pastillas y el precio que le dieron por telefono. Jorge, un tecnico de la sede,
intenta cambiar la cantidad de la compra y el sistema no lo deja, solo la gerente la modifica.
*/
BEGIN;

-- Paso 1 : Laura consulta los repuestos por agotarse de su sede y abre una compra
--      a "Frenos Ya LTDA". Queda con el numero consecutivo, la fecha de hoy y en la sede de Laura (S02).
SELECT SV_GERENTE.co_repuestosPorAgotarseSede('8080808080');
FETCH ALL IN "co_porAgotarse";
CLOSE "co_porAgotarse";
SELECT SV_GERENTE.ad_compra('8080808080', '900654321');
SELECT * FROM COMPRAS WHERE numero = 'C000000013';

-- Paso 2 : Laura agrega 12 pastillas de freno (R002) sin indicar precio
--      y se toma el precio de referencia del proveedor (45000). Luego intenta agregar filtros
--      de aceite (R001) sin precio. "Frenos Ya" no tiene precio de referencia para ese repuesto
--      y el sistema le pide indicarlo.
SELECT SV_GERENTE.ad_detalle_compra('8080808080', 'C000000013', 'R002', 12, NULL);
DO $$
BEGIN
    PERFORM SV_GERENTE.ad_detalle_compra('8080808080', 'C000000013', 'R001', 5, NULL);
    RAISE NOTICE 'FALLA LA PRUEBA: se agrego un detalle sin precio';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 3 : Laura se equivoca y deja la cantidad en cero el sistema
--      lo rechaza. Luego la corrige a 10 unidades a 44000 cada una.
DO $$
BEGIN
    PERFORM SV_GERENTE.up_detalle_compra('8080808080', 'C000000013', 'R002', 0, NULL);
    RAISE NOTICE 'FALLA LA PRUEBA: se acepto una cantidad de cero';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;
SELECT SV_GERENTE.up_detalle_compra('8080808080', 'C000000013', 'R002', 10, 44000);

-- Paso 4 : Jorge, tecnico de la Sede Sur, intenta subir la cantidad de la compra
--      y el sistema lo rechaza: las compras solo las modifica la gerente.
DO $$
BEGIN
    PERFORM SV_COMPRAS.up_detalle('6060606060', 'C000000013', 'R002', 50, NULL);
    RAISE NOTICE 'FALLA LA PRUEBA: un tecnico modifico una compra';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 5 : Laura verifica que la compra quedo bien: un solo detalle de 10 pastillas
--      a 44000, valor total de 440000, y las pastillas disponibles en su sede aumentaron en 10.
SELECT  c.numero, c.fecha, c.sede, c.proveedor,
        dc.repuesto, dc.cantidad, dc.precio_unidad
FROM COMPRAS c
JOIN DETALLE_COMPRAS dc ON dc.compra = c.numero
WHERE c.numero = 'C000000013';
SELECT SV_GERENTE.co_valorTotalCompra('8080808080', 'C000000013');
SELECT SV_GERENTE.co_repuestosPorAgotarseSede('8080808080');
FETCH ALL IN "co_porAgotarse";

ROLLBACK;














/* CRUD de SERVICIOS

COMO gerente
QUIERO mantener las ordenes de servicio de mi sede
PARA PODER llevar el control de los trabajos que se le hacen a cada vehiculo
-
Adicion
------------
Se debe asignar automaticamente el numero (OSAA-########), la fecha de inicio (hoy) y el estado (en proceso)
SQ_SERVICIOS_numero y valores por omision de numero, fecha_inicio y estado
La fecha de inicio no puede ser futura.
tg_1_SERVICIOS_bi (tg.restringe)
El servicio se realiza sobre un vehiculo registrado y en una sede existente.
FK_SERVICIOS_VEHICULO, FK_SERVICIOS_SEDE
Cada detalle se identifica por su item dentro del servicio y aplica un servicio del catalogo.
PK_DETALLE_ORDENES, CK_DETALLE_ORDENES_ITEM, FK_DETALLE_ORDENES_CATALOGO_SERVICIO
Solo se agregan detalles a servicios en proceso y de servicios del catalogo que la sede tiene habilitados.
El valor cobrado es el precio local de la sede; si no tiene, el precio base del catalogo.
SV_SERVICIOS.ad_detalle (componente)
Quien ejecuta el detalle debe ser un tecnico.
FK_DETALLE_ORDENES_TECNICO
-
Modificacion
---------------------
Los servicios finalizados o cancelados no se pueden modificar y la fecha de inicio no puede quedar en el futuro.
tg_1_SERVICIOS_bu (tg.restringe)
Al finalizar un servicio la fecha de fin se asigna automaticamente.
tg_2_SERVICIOS_bu (tg.automatiza), CK_SERVICIOS_ESTADO_FECHA_FIN, CK_SERVICIOS_FECHAS
Al cancelar un servicio sus detalles en proceso quedan cancelados automaticamente.
tg_1_SERVICIOS_au (tg.automatiza)
Un detalle solo se puede finalizar si tiene tecnico, horas trabajadas y fecha de fin.
CK_DETALLE_ORDENES_ESTADO_TECNICO, CK_DETALLE_ORDENES_ESTADO_FECHA_FIN, CK_DETALLE_ORDENES_FECHAS
Las horas trabajadas deben ser mayores a cero.
CK_DETALLE_ORDENES_HORAS_TRABAJADAS
-
Eliminacion
-------------------
No esta permitido eliminar un servicio; un servicio que no continua se cancela.
tg_2_SERVICIOS_bd (tg.restringe) */




--Pruebas
/*
Ana Gomez lleva su Chevrolet DEF-456 a la Sede Norte porque le toca el cambio de aceite.
La recibe Luis Perez, tecnico de la sede, que abre la orden de servicio y se asigna el
trabajo. Ana pregunta si de una vez le pueden hacer la alineacion, pero la Sede Norte no
tiene habilitado ese servicio. Luis tambien quiere pasarle la revision de frenos a Jorge,
pero Jorge trabaja en la Sede Sur. Camila, la otra tecnica de la sede, intenta registrar
horas en el trabajo de Luis y el sistema no la deja. Luis hace el cambio de aceite,
registra su diagnostico y sus horas, y cierra la orden para cobrarla.
*/
BEGIN;

-- Paso 1 : Luis abre la orden para el vehiculo DEF456.
--      Queda con el numero consecutivo, la fecha de hoy, en estado E y en la sede de Luis (S01).
SELECT SV_TECNICO.ad_servicio('2020202020', 'DEF456');
SELECT * FROM SERVICIOS WHERE numero = 'OS26-00000026';

-- Paso 2 : Luis agrega el cambio de aceite (CS01) y se lo asigna a si mismo.
--      Queda como item 1, en estado E y con el precio local de S01 (160000).
--      Luego intenta agregar la alineacion (CS03), que S01 no tiene habilitada, y el sistema lo rechaza.
SELECT SV_TECNICO.ad_detalle_servicio('2020202020', 'OS26-00000026', 'CS01', '2020202020');
DO $$
BEGIN
    PERFORM SV_TECNICO.ad_detalle_servicio('2020202020', 'OS26-00000026', 'CS03', '2020202020');
    RAISE NOTICE 'FALLA LA PRUEBA: se agrego un servicio que la sede no tiene habilitado';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 3 : Luis intenta agregar la revision de frenos (CS02) asignada a Jorge,
--      que trabaja en la Sede Sur, y el sistema lo rechaza.
DO $$
BEGIN
    PERFORM SV_TECNICO.ad_detalle_servicio('2020202020', 'OS26-00000026', 'CS02', '6060606060');
    RAISE NOTICE 'FALLA LA PRUEBA: se asigno un trabajo a un tecnico de otra sede';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 4 : Camila intenta registrar horas en el trabajo de Luis y el sistema lo rechaza.
--      Luis intenta cerrar la orden con el cambio de aceite aun en proceso y el sistema lo rechaza.
DO $$
BEGIN
    PERFORM SV_TECNICO.up_detalle_servicio('5050505050', 'OS26-00000026', 1, 'F', 2);
    RAISE NOTICE 'FALLA LA PRUEBA: una tecnica registro trabajo en un detalle que no es suyo';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;
DO $$
BEGIN
    PERFORM SV_TECNICO.up_servicio('2020202020', 'OS26-00000026', 'F');
    RAISE NOTICE 'FALLA LA PRUEBA: se finalizo una orden con detalles en proceso';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 5 : Luis registra el diagnostico y 1.5 horas, finaliza su trabajo y cierra la orden.
--      La fecha de fin se asigna automaticamente y el valor total a cobrar es 160000.
--      Se verifica que la orden y su detalle quedaron en F, con fecha de fin, tecnico, horas,
--      valor y diagnostico.
SELECT SV_TECNICO.up_diagnostico_servicio('2020202020', 'OS26-00000026', 1,
    '{"sintomas": ["testigo de cambio de aceite encendido"], "hallazgos": "Aceite degradado y filtro saturado", "recomendaciones": ["proximo cambio en 5000 km"]}');
SELECT SV_TECNICO.up_detalle_servicio('2020202020', 'OS26-00000026', 1, 'F', 1.5);
SELECT SV_TECNICO.up_servicio('2020202020', 'OS26-00000026', 'F');
SELECT SV_TECNICO.co_valorTotalServicio('2020202020', 'OS26-00000026');
SELECT  s.numero, s.estado AS estadoOrden, s.fecha_fin AS finOrden,
        d.item, d.estado AS estadoDetalle, d.fecha_fin AS finDetalle,
        d.tecnico, d.horas_trabajadas, d.valor_cobrado,
        d.diagnostico ->> 'hallazgos' AS hallazgos
FROM SERVICIOS s
JOIN DETALLE_ORDENES d ON d.servicio = s.numero
WHERE s.numero = 'OS26-00000026';

ROLLBACK;
