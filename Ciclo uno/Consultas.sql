-- MecaData Consultas

-- Consultas gerenciales
    -- Clientes que mas han gastado en el negocio 
SELECT  p.cedula,
        p.nombre,
        p.apellido,
        COUNT(DISTINCT v.placa) AS numeroVehiculos,
        COUNT(DISTINCT s.numero) AS numeroOrdenes,
        SUM(m.valor) AS totalCobrado
FROM Cobros c
JOIN Movimientos m ON m.numero = c.movimiento
JOIN Servicios s ON s.numero = c.orden
JOIN Vehiculos v ON v.placa = s.vehiculo
JOIN Personas p ON p.cedula = v.cliente
WHERE m.estado = 'P' AND m.fecha BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.cedula, p.nombre, p.apellido
ORDER BY totalCobrado DESC;



-- Consultas operativas
    -- Servicios en proceso 
SELECT  s.numero,
        s.vehiculo AS placa,
        p.nombre,
        p.apellido,
        s.fechaInicio
FROM Servicios s
JOIN Vehiculos v ON v.placa = s.vehiculo
JOIN Personas p ON p.cedula = v.cliente
JOIN Empleados e ON e.sede = s.sede
WHERE s.estado = 'E' AND e.cargo = 'G' AND e.persona = '3030303030'
ORDER BY s.fechaInicio ASC;

    -- Saber que servivios presta una sede
SELECT  cs.codigo,
        cs.nombre,
        COALESCE(p.precioLocal, cs.precioBase) AS precio,
        cs.tiempoMedio
FROM Empleados e
JOIN Presta p ON p.sede = e.sede
JOIN CatalogoServicios cs ON cs.codigo = p.catalogoServicio
WHERE e.persona = '2020202020' AND e.cargo = 'A' AND p.disponible = TRUE
ORDER BY cs.nombre;

    -- Consultar cantidad de un repuesto
SELECT  r.serie,
        r.nombre,
        se.numero AS sede,
        se.nombre AS nombreSede,
        i.cantidad
FROM Inventario i
JOIN Repuestos r ON r.serie = i.repuesto
JOIN Sedes se ON se.numero = i.sede
WHERE r.nombre = 'Filtro de aceite'
ORDER BY i.cantidad ASC;

    -- Historial de servicios del técnico
SELECT  s.numero,
        d.fechaFin AS fechaCierre,
        s.vehiculo AS placa,
        cs.nombre AS servicio,
        d.estado
FROM Trabaja t
JOIN DetalleOrdenes d ON d.id = t.detalleOrden
JOIN Servicios s ON s.numero = d.servicio
JOIN CatalogoServicios cs ON cs.codigo = d.catalogoServicio
WHERE t.tecnico = '2020202020' AND d.fechaFin BETWEEN DATE '2024-01-01' AND DATE '2024-12-31'
ORDER BY d.fechaFin DESC;

    -- Tecnicos sin servicio asignado
SELECT  p.cedula AS cedulaTecnico, 
        p.nombre AS nombreTecnico, 
        p.apellido AS apellidoTecnico, 
        t.especialidad AS especialidadTecnico, 
        p.telefono AS telefonoTecnico
FROM Tecnicos t 
JOIN Empleados e ON t.empleado = e.persona
JOIN Personas p ON e.persona = p.cedula
WHERE t.empleado NOT IN (
    SELECT tra.tecnico
    FROM Trabaja tra, DetalleOrdenes det
    WHERE tra.detalleOrden = det.id AND det.estado = 'E'
)
ORDER BY  t.especialidad ASC, p.nombre ASC;

    -- La información de contacto de los gerentes
SELECT  s.numero AS numeroSede,
        s.nombre AS nombreSede, 
        p.nombre AS nombreGerente, 
        p.apellido AS apellidoGerente, 
        p.correo AS correoGerente, 
        p.telefono AS telefonoGerente
FROM Sedes s
JOIN Empleados e ON e.sede = s.numero
JOIN Personas p ON p.cedula = e.persona
WHERE e.cargo = 'G'
ORDER BY s.nombre ASC;

    -- Consultar estado de un ser
SELECT  s.numero AS numeroOrden, 
        s.sede AS sede, 
        det.fechaInicio AS fechaInicio, 
        cat.nombre AS servicioRealizado, 
        det.estado AS estadoServicio
FROM Servicios s
JOIN Vehiculos v ON v.placa = s.vehiculo
JOIN DetalleOrdenes det ON det.servicio = s.numero
JOIN CatalogoServicios cat ON cat.codigo = det.catalogoServicio
WHERE v.cliente = '1010101010' AND v.placa = 'ABC123' AND s.estado = 'E'
ORDER BY det.fechaInicio ASC;

    -- Consultar las garantias vigentes
SELECT  g.numero, 
        v.placa, 
        cat.nombre, 
        g.fechaInicio, 
        g.condiciones
FROM Garantias g, Vehiculos v, CatalogoServicios cat, DetalleOrdenes det, Servicios s
WHERE g.detalleOrden = det.id 
    AND v.placa = s.vehiculo 
    AND det.catalogoServicio = cat.codigo 
    AND det.servicio = s.numero 
    AND v.cliente = '1010101010' 
    AND g.estado = 'V'
ORDER BY g.fechaInicio DESC;
