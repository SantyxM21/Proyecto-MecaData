-- MecaData Disparadores
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
