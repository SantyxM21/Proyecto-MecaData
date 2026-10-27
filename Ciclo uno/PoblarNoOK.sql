-- MecaData PoblarNoOK
-- Tipo: kilometraje es int, no acepta texto
INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('XYZ999', 'mucho', 'Renault', 2019, 1600, 'Azul', '1010101010');

-- Nulidad: toda persona debe tener nombre
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('3030303030', NULL, 'Rojas', 'sin.nombre@mail.com', '3201112233');

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
    ('ORDEN1', '2024-06-01', NULL, 'E', 'ABC123', 'S01');

-- Dominio: estado de orden solo acepta F, E o C
INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('OS24-00000002', '2024-06-01', NULL, 'Z', 'ABC123', 'S01');

-- CHECK de atributo: el inventario no puede ser negativo
INSERT INTO INVENTARIO (cantidad, sede, repuesto) VALUES
    (-5, 'S02', 'R001');

-- Disparador: no se pueden modificar los servicios finalizados
UPDATE SERVICIOS SET sede = 'S02' WHERE numero = 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000002';

-- Disparador: no se pueden eliminar los servicios en proceso
DELETE FROM SERVICIOS WHERE numero = 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000001';
