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
