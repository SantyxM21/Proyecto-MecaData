-- MecaData PoblarNoOK
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
