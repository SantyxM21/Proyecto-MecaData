-- MecaData Disparadores
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
