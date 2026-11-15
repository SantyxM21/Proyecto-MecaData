-- MecaData Vistas
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
