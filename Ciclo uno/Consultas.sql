-- MecaData Consultas
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
