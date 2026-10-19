-- MecaData Consultas
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
