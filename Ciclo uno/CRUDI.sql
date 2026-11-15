-- MecaData CRUDI
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
