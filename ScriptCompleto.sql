-- Active: 1794333671248@@granate.is.escuelaing.edu.co@5432@db1000107428
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
--El numero, la fecha de inicio, el vehiculo y la sede no cambian; la fecha de fin se asigna al finalizar o cancelar.
CREATE OR REPLACE FUNCTION fc_tg_1_SERVICIOS_bu() RETURNS TRIGGER AS
$$
BEGIN
    IF OLD.estado = 'F' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios finalizados';
    END IF;

    IF OLD.estado = 'C' THEN
        RAISE EXCEPTION 'No se pueden modificar los servicios cancelados';
    END IF;

    IF NEW.numero IS DISTINCT FROM OLD.numero
        OR NEW.fecha_inicio IS DISTINCT FROM OLD.fecha_inicio
        OR NEW.fecha_fin IS DISTINCT FROM OLD.fecha_fin
        OR NEW.vehiculo IS DISTINCT FROM OLD.vehiculo
        OR NEW.sede IS DISTINCT FROM OLD.sede THEN
        RAISE EXCEPTION 'De un servicio solo se puede modificar el estado';
    END IF;

    IF NEW.estado IN ('F', 'C') THEN
        NEW.fecha_fin := CURRENT_DATE;
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
--No se permite eliminar los servicios de la base de datos: un servicio que no continua se cancela.
CREATE OR REPLACE FUNCTION fc_tg_2_SERVICIOS_bd() RETURNS TRIGGER AS
$$
BEGIN
    RAISE EXCEPTION 'No se permite eliminar los servicios; un servicio que no continua se cancela';
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
-- DROP TRIGGER IF EXISTS tg_1_SERVICIOS_au ON SERVICIOS;
-- DROP TRIGGER IF EXISTS tg_2_SERVICIOS_bd ON SERVICIOS;

-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bi();
-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_bu();
-- DROP FUNCTION IF EXISTS fc_tg_1_SERVICIOS_au();
-- DROP FUNCTION IF EXISTS fc_tg_2_SERVICIOS_bd();

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
            COALESCE((SELECT SUM(e.salario) -- la suma de los salarios de todos lo empleados ese mes
                        FROM EMPLEADOS e
                        WHERE e.sede = se.numero), 0) AS totalSalarios
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
    ('OS26-00000004', '2026-10-20', '2026-10-21', 'C', 'GHI789', 'S02');

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
    estado_servicio VARCHAR;
    sede_servicio VARCHAR;
    precio NUMERIC;
    new_item INTEGER;
BEGIN
    SELECT s.estado, s.sede INTO estado_servicio, sede_servicio
    FROM SERVICIOS s
    JOIN EMPLEADOS e ON e.sede = s.sede
    WHERE s.numero = ad_detalle.servicio
        AND e.persona = ad_detalle.empleado;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio no existe o no pertenece a la sede del empleado';
    END IF;

    IF estado_servicio <> 'E' THEN
        RAISE EXCEPTION 'Solo se pueden agregar detalles a los servicios en proceso';
    END IF;

    SELECT COALESCE(o.precio_local, cs.precio_base) INTO precio
    FROM OFERTAS_SERVICIOS o
    JOIN CATALOGO_SERVICIOS cs ON cs.codigo = o.catalogo_servicio
    WHERE o.sede = sede_servicio
        AND o.catalogo_servicio = ad_detalle.catalogo_servicio
        AND o.habilitado = TRUE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La sede no tiene habilitado ese servicio del catalogo';
    END IF;

    SELECT COALESCE(MAX(d.item), 0) + 1 INTO new_item
    FROM DETALLE_ORDENES d
    WHERE d.servicio = ad_detalle.servicio;

    INSERT INTO DETALLE_ORDENES(item, valor_cobrado, estado, fecha_inicio, catalogo_servicio, servicio, tecnico)
    VALUES(new_item, precio, 'E', CURRENT_DATE, ad_detalle.catalogo_servicio, ad_detalle.servicio, ad_detalle.tecnico);
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


--Los servicios no se eliminan: un servicio que no continua se cancela.
CREATE OR REPLACE FUNCTION SV_SERVICIOS.de(empleado VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    RAISE EXCEPTION 'No se permite eliminar los servicios; un servicio que no continua se cancela';
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


--XComponentes
/*
DROP FUNCTION IF EXISTS SV_SERVICIOS.ad(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.up(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.ad_detalle(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.de(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.up_detalle(VARCHAR, VARCHAR, INTEGER, VARCHAR, NUMERIC);
DROP FUNCTION IF EXISTS SV_SERVICIOS.co_valorTotal(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.co_enProceso(VARCHAR);
DROP FUNCTION IF EXISTS SV_SERVICIOS.co_estado(VARCHAR);
DROP SCHEMA IF EXISTS SV_SERVICIOS;
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


--ComponentesNoOK
/*
-- Caso 1: El vehiculo ZZZ999 no esta registrado
-- FK_SERVICIOS_VEHICULO rechaza el insert
SELECT SV_SERVICIOS.ad('3030303030', 'ZZZ999');

-- Caso 2: Un servicio finalizado (OS26-00000002) no se puede modificar
-- tg_1_SERVICIOS_bu lanza 'No se pueden modificar los servicios finalizados'
SELECT SV_SERVICIOS.up('3030303030', 'OS26-00000002', 'C');

-- Caso 3: Los servicios no se pueden eliminar, ni siquiera los cancelados (OS26-00000004)
-- de lanza 'No se permite eliminar los servicios; un servicio que no continua se cancela'
SELECT SV_SERVICIOS.de('8080808080', 'OS26-00000004');

-- Caso 4: La sede S01 no tiene habilitado el servicio CS03
-- ad_detalle lanza 'La sede no tiene habilitado ese servicio del catalogo'
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS03', NULL);

-- Caso 5: No se agregan detalles a un servicio finalizado (OS26-00000002)
-- ad_detalle lanza 'Solo se pueden agregar detalles a los servicios en proceso'
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

-- Caso 11: El item 1 de OS26-00000001 es de 2020202020; otro tecnico no lo puede modificar
-- up_detalle lanza 'El detalle no existe o no esta asignado al tecnico'
SELECT SV_SERVICIOS.up_detalle('5050505050', 'OS26-00000001', 1, 'F', 1);
*/




--Actores
CREATE SCHEMA SV_GERENTE;

CREATE OR REPLACE FUNCTION SV_GERENTE.ad_s(gerente VARCHAR, vehiculo VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_SERVICIOS.ad(ad_s.gerente, ad_s.vehiculo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.up_s(gerente VARCHAR, numero VARCHAR, estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up(up_s.gerente, up_s.numero, up_s.estado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.de_s(gerente VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.de(de_s.gerente, de_s.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.ad_d(gerente VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico VARCHAR)
RETURNS INTEGER AS $$
BEGIN
    RETURN SV_SERVICIOS.ad_detalle(ad_d.gerente, ad_d.servicio, ad_d.catalogo_servicio, ad_d.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_vt(gerente VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_SERVICIOS.co_valorTotal(co_vt.gerente, co_vt.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_ep(gerente VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_enProceso(co_ep.gerente);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_es(placa VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_estado(co_es.placa);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;






CREATE SCHEMA SV_TECNICO;

CREATE OR REPLACE FUNCTION SV_TECNICO.ad_s(tecnico VARCHAR, vehiculo VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_SERVICIOS.ad(ad_s.tecnico, ad_s.vehiculo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_s(tecnico VARCHAR, numero VARCHAR, estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up(up_s.tecnico, up_s.numero, up_s.estado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.de_s(tecnico VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.de(de_s.tecnico, de_s.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.ad_d(tecnico VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico_asignado VARCHAR)
RETURNS INTEGER AS $$
BEGIN
    RETURN SV_SERVICIOS.ad_detalle(ad_d.tecnico, ad_d.servicio, ad_d.catalogo_servicio, ad_d.tecnico_asignado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_vt(tecnico VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_SERVICIOS.co_valorTotal(co_vt.tecnico, co_vt.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_ep(tecnico VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_enProceso(co_ep.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_es(placa VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_estado(co_es.placa);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_t(tecnico VARCHAR, servicio VARCHAR, item INTEGER, estado VARCHAR, horas_trabajadas NUMERIC)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up_detalle(up_t.tecnico, up_t.servicio, up_t.item, up_t.estado, up_t.horas_trabajadas);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



