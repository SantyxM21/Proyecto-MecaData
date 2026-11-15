-- MecaData PoblarOK
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543'),
    ('3030303030', 'Sofia', 'Martinez', 'sofia.martinez@mail.com', '3112223344'),
    ('5050505050', 'Camila', 'Torres', 'camila.torres@mail.com', '3125556677'),
    ('6060606060', 'Jorge', 'Ramirez', 'jorge.ramirez@mail.com', '3138889900'),
    ('7070707070', 'Pedro', 'Castro', 'pedro.castro@mail.com', '3141112233'),
    ('8080808080', 'Laura', 'Moreno', 'laura.moreno@mail.com', '3154443322'),
    ('1111111111', 'Andres', 'Lopez', 'andres.lopez@mail.com', '3160001122'),
    ('1212121212', 'Valentina', 'Suarez', 'valentina.suarez@mail.com', '3171112233'),
    ('1313131313', 'Mateo', 'Herrera', 'mateo.herrera@mail.com', '3182223344'),
    ('1414141414', 'Sara', 'Jimenez', 'sara.jimenez@mail.com', '3193334455'),
    ('1515151515', 'Daniela', 'Vargas', 'daniela.vargas@mail.com', '3004445566'),
    ('1616161616', 'Felipe', 'Cardenas', 'felipe.cardenas@mail.com', '3015556677'),
    ('1717171717', 'Natalia', 'Rios', 'natalia.rios@mail.com', '3026667788'),
    ('1818181818', 'Juan', 'Mendez', 'juan.mendez@mail.com', '3037778899'),
    ('1919191919', 'Paula', 'Ortiz', 'paula.ortiz@mail.com', '3048889900'),
    ('2121212121', 'Diego', 'Salazar', 'diego.salazar@mail.com', '3059990011');

INSERT INTO CLIENTES (fecha_registro, persona) VALUES
    ('2024-01-15', '1010101010'),
    ('2025-06-10', '7070707070'),
    ('2026-01-20', '5050505050'),
    ('2025-11-03', '1515151515'),
    ('2026-02-14', '1616161616'),
    ('2026-03-09', '1717171717'),
    ('2026-04-22', '1818181818'),
    ('2026-05-30', '1919191919'),
    ('2026-07-11', '2121212121');

INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010'),
    ('DEF456', 82000, 'Chevrolet', 2017, 1400, 'Gris', '1010101010'),
    ('GHI789', 15000, 'Renault', 2023, 1600, 'Blanco', '7070707070'),
    ('JKL321', 98000, 'Toyota', 2019, 1800, 'Negro', '1515151515'),
    ('MNO654', 37000, 'Kia', 2021, 1600, 'Azul', '1616161616'),
    ('BCD579', 121000, 'Mazda', 2015, 1600, 'Verde', '1616161616'),
    ('PQR987', 143000, 'Ford', 2016, 2500, 'Plata', '1717171717'),
    ('STU246', 22000, 'Nissan', 2022, 1600, 'Blanco', '1818181818'),
    ('VWX135', 76000, 'Volkswagen', 2018, 1400, 'Rojo', '1919191919'),
    ('YZA864', 54000, 'Hyundai', 2020, 2000, 'Gris', '2121212121'),
    ('EFG102', 8000, 'Renault', 2024, 1300, 'Negro', '5050505050');

INSERT INTO AUTOMOVILES (vehiculo, numero_puertas) VALUES
    ('ABC123', 4),
    ('DEF456', 5),
    ('GHI789', 4),
    ('JKL321', 4),
    ('MNO654', 5),
    ('BCD579', 4),
    ('PQR987', 4),
    ('STU246', 5),
    ('VWX135', 3),
    ('YZA864', 4),
    ('EFG102', 5);

INSERT INTO SEDES (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321'),
    ('S03', 'Sede Centro', 'Calle 26 # 13-40', '6013339988');

INSERT INTO EMPLEADOS (cargo, fecha_ingreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 2100000.00, '2020202020', 'S01'),
    ('G', '2021-01-10', 4500000.00, '3030303030', 'S01'),
    ('T', '2022-05-16', 2400000.00, '5050505050', 'S01'),
    ('T', '2024-02-01', 1900000.00, '6060606060', 'S02'),
    ('G', '2020-08-03', 4300000.00, '8080808080', 'S02'),
    ('T', '2025-09-15', 2000000.00, '1111111111', 'S02'),
    ('G', '2026-08-01', 4200000.00, '1212121212', 'S03'),
    ('T', '2026-08-01', 2200000.00, '1313131313', 'S03'),
    ('T', '2026-08-01', 1800000.00, '1414141414', 'S03');

INSERT INTO TECNICOS (especialidad, empleado) VALUES
    ('Motor', '2020202020'),
    ('Alineacion', '5050505050'),
    ('Frenos', '6060606060'),
    ('Motor', '1111111111'),
    ('Transmision', '1313131313'),
    ('Frenos', '1414141414');

INSERT INTO CATALOGO_SERVICIOS (codigo, nombre, descripcion, precio_base, tiempo_medio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.50),
    ('CS02', 'Revision de frenos', 'Revision y cambio de pastillas de freno', 220000.00, 2),
    ('CS03', 'Alineacion y balanceo', 'Alineacion de direccion y balanceo de llantas', 90000.00, 1),
    ('CS04', 'Reparacion de motor', 'Ajuste de motor y cambio de empaques', 3800000.00, 16),
    ('CS05', 'Cambio de embrague', 'Cambio del kit de embrague', 1900000.00, 6),
    ('CS06', 'Mantenimiento general', 'Revision de 40 puntos y cambio de fluidos', 750000.00, 4);

INSERT INTO OFERTAS_SERVICIOS (habilitado, precio_local, catalogo_servicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01'),
    (TRUE, NULL, 'CS02', 'S01'),
    (FALSE, 95000.00, 'CS03', 'S01'),
    (TRUE, NULL, 'CS04', 'S01'),
    (TRUE, 1950000.00, 'CS05', 'S01'),
    (TRUE, NULL, 'CS06', 'S01'),
    (TRUE, 155000.00, 'CS01', 'S02'),
    (TRUE, 230000.00, 'CS02', 'S02'),
    (TRUE, 3600000.00, 'CS04', 'S02'),
    (TRUE, 720000.00, 'CS06', 'S02'),
    (TRUE, NULL, 'CS01', 'S03'),
    (TRUE, NULL, 'CS02', 'S03'),
    (TRUE, 85000.00, 'CS03', 'S03'),
    (TRUE, NULL, 'CS05', 'S03'),
    (TRUE, NULL, 'CS06', 'S03');

INSERT INTO REPUESTOS (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite'),
    ('R002', 'Freno', 'Pastillas de freno'),
    ('R003', 'Motor', 'Kit de empaques de motor'),
    ('R004', 'Transmision', 'Kit de embrague'),
    ('R005', 'Lubricante', 'Aceite 5W30 (galon)'),
    ('R006', 'Freno', 'Liquido de frenos');

INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('OS26-00000001', '2026-11-03', NULL, 'E', 'ABC123', 'S01'),
    ('OS26-00000002', '2026-09-14', NULL, 'E', 'DEF456', 'S01'),
    ('OS26-00000003', '2026-10-05', NULL, 'E', 'GHI789', 'S02'),
    ('OS26-00000004', '2026-10-20', '2026-10-21', 'C', 'GHI789', 'S02'),
    ('OS26-00000005', '2026-09-03', NULL, 'E', 'JKL321', 'S01'),
    ('OS26-00000006', '2026-09-22', NULL, 'E', 'MNO654', 'S01'),
    ('OS26-00000007', '2026-10-02', NULL, 'E', 'PQR987', 'S01'),
    ('OS26-00000008', '2026-10-14', NULL, 'E', 'BCD579', 'S01'),
    ('OS26-00000009', '2026-10-20', NULL, 'E', 'STU246', 'S01'),
    ('OS26-00000010', '2026-10-27', NULL, 'E', 'EFG102', 'S01'),
    ('OS26-00000011', '2026-11-05', NULL, 'E', 'VWX135', 'S01'),
    ('OS26-00000012', '2026-11-10', NULL, 'E', 'YZA864', 'S01'),
    ('OS26-00000013', '2026-09-08', NULL, 'E', 'GHI789', 'S02'),
    ('OS26-00000014', '2026-09-25', NULL, 'E', 'YZA864', 'S02'),
    ('OS26-00000015', '2026-10-09', NULL, 'E', 'JKL321', 'S02'),
    ('OS26-00000016', '2026-10-22', NULL, 'E', 'STU246', 'S02'),
    ('OS26-00000017', '2026-10-28', NULL, 'E', 'MNO654', 'S02'),
    ('OS26-00000018', '2026-11-11', NULL, 'E', 'PQR987', 'S02'),
    ('OS26-00000019', '2026-09-15', NULL, 'E', 'VWX135', 'S03'),
    ('OS26-00000020', '2026-10-06', NULL, 'E', 'BCD579', 'S03'),
    ('OS26-00000021', '2026-10-19', NULL, 'E', 'EFG102', 'S03'),
    ('OS26-00000022', '2026-11-04', NULL, 'E', 'YZA864', 'S03');

SELECT setval('SQ_SERVICIOS_numero',
                (SELECT COALESCE(MAX(SPLIT_PART(numero, '-', 2)::INTEGER), 0) + 1 FROM SERVICIOS), false);

INSERT INTO DETALLE_ORDENES (item, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio, tecnico, horas_trabajadas, diagnostico) VALUES
    (1, 160000.00, 'E', '2026-11-03', NULL, 'CS01', 'OS26-00000001', '2020202020', 1.50, NULL),
    (1, 220000.00, 'F', '2026-09-14', '2026-09-15', 'CS02', 'OS26-00000002', '2020202020', 2, '{"sintomas": ["ruido al frenar", "pedal esponjoso"], "hallazgos": "Pastillas delanteras al 10% de vida util", "recomendaciones": ["cambiar discos en 5000 km"]}'),
    (1, 230000.00, 'F', '2026-10-05', '2026-10-06', 'CS02', 'OS26-00000003', '6060606060', 2.50, '{"sintomas": ["vibracion al frenar"], "hallazgos": "Pastillas cristalizadas"}'),
    (1, 3800000.00, 'F', '2026-09-03', '2026-09-08', 'CS04', 'OS26-00000005', '2020202020', 18, '{"sintomas": ["perdida de potencia", "humo azul en el escape"], "hallazgos": "Empaque de culata y anillos desgastados", "recomendaciones": ["cambio de aceite a los 1000 km"]}'),
    (2, 750000.00, 'F', '2026-09-03', '2026-09-04', 'CS06', 'OS26-00000005', '5050505050', 4.50, NULL),
    (1, 1950000.00, 'F', '2026-09-22', '2026-09-24', 'CS05', 'OS26-00000006', '2020202020', 6.50, '{"sintomas": ["el embrague patina"], "hallazgos": "Disco de embrague al limite de desgaste"}'),
    (2, 160000.00, 'F', '2026-09-22', '2026-09-22', 'CS01', 'OS26-00000006', '5050505050', 1, NULL),
    (1, 3800000.00, 'F', '2026-10-02', '2026-10-07', 'CS04', 'OS26-00000007', '2020202020', 15, NULL),
    (2, 220000.00, 'F', '2026-10-02', '2026-10-03', 'CS02', 'OS26-00000007', '5050505050', 2, NULL),
    (1, 750000.00, 'F', '2026-10-14', '2026-10-14', 'CS06', 'OS26-00000008', '5050505050', 3.50, NULL),
    (2, 160000.00, 'F', '2026-10-14', '2026-10-14', 'CS01', 'OS26-00000008', '5050505050', 1.50, NULL),
    (1, 3800000.00, 'F', '2026-10-20', '2026-10-24', 'CS04', 'OS26-00000009', '2020202020', 17, '{"sintomas": ["perdida de potencia", "humo azul en el escape"], "hallazgos": "Empaque de culata y anillos desgastados", "recomendaciones": ["cambio de aceite a los 1000 km"]}'),
    (1, 1950000.00, 'F', '2026-10-27', '2026-10-29', 'CS05', 'OS26-00000010', '2020202020', 7, NULL),
    (1, 220000.00, 'F', '2026-11-05', '2026-11-05', 'CS02', 'OS26-00000011', '5050505050', 2.50, NULL),
    (2, 750000.00, 'F', '2026-11-05', '2026-11-06', 'CS06', 'OS26-00000011', '5050505050', 4, NULL),
    (1, 160000.00, 'E', '2026-11-10', NULL, 'CS01', 'OS26-00000012', '5050505050', NULL, NULL),
    (1, 3600000.00, 'F', '2026-09-08', '2026-09-12', 'CS04', 'OS26-00000013', '1111111111', 17, '{"sintomas": ["perdida de potencia", "humo azul en el escape"], "hallazgos": "Empaque de culata y anillos desgastados", "recomendaciones": ["cambio de aceite a los 1000 km"]}'),
    (2, 230000.00, 'F', '2026-09-08', '2026-09-09', 'CS02', 'OS26-00000013', '6060606060', 2, NULL),
    (1, 720000.00, 'F', '2026-09-25', '2026-09-25', 'CS06', 'OS26-00000014', '1111111111', 4, NULL),
    (2, 155000.00, 'F', '2026-09-25', '2026-09-25', 'CS01', 'OS26-00000014', '6060606060', 1, NULL),
    (1, 3600000.00, 'F', '2026-10-09', '2026-10-15', 'CS04', 'OS26-00000015', '1111111111', 14, NULL),
    (1, 230000.00, 'F', '2026-10-22', '2026-10-22', 'CS02', 'OS26-00000016', '6060606060', 3, NULL),
    (2, 720000.00, 'F', '2026-10-22', '2026-10-23', 'CS06', 'OS26-00000016', '1111111111', 4.50, NULL),
    (1, 3600000.00, 'F', '2026-10-28', '2026-10-31', 'CS04', 'OS26-00000017', '1111111111', 16, NULL),
    (1, 230000.00, 'E', '2026-11-11', NULL, 'CS02', 'OS26-00000018', '6060606060', NULL, NULL),
    (1, 1900000.00, 'F', '2026-09-15', '2026-09-17', 'CS05', 'OS26-00000019', '1313131313', 5.50, '{"sintomas": ["el embrague patina"], "hallazgos": "Disco de embrague al limite de desgaste"}'),
    (2, 85000.00, 'F', '2026-09-15', '2026-09-15', 'CS03', 'OS26-00000019', '1414141414', 1, NULL),
    (1, 750000.00, 'F', '2026-10-06', '2026-10-07', 'CS06', 'OS26-00000020', '1414141414', 4, NULL),
    (2, 220000.00, 'F', '2026-10-06', '2026-10-07', 'CS02', 'OS26-00000020', '1414141414', 2, NULL),
    (3, 150000.00, 'F', '2026-10-06', '2026-10-06', 'CS01', 'OS26-00000020', '1313131313', 1.50, NULL),
    (1, 1900000.00, 'F', '2026-10-19', '2026-10-21', 'CS05', 'OS26-00000021', '1313131313', 6, NULL),
    (1, 750000.00, 'E', '2026-11-04', NULL, 'CS06', 'OS26-00000022', '1414141414', NULL, NULL);

-- Las ordenes se cierran despues de tener sus detalles (para saltar las restricciones)
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-15' WHERE numero = 'OS26-00000002';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-06' WHERE numero = 'OS26-00000003';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-08' WHERE numero = 'OS26-00000005';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-24' WHERE numero = 'OS26-00000006';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-07' WHERE numero = 'OS26-00000007';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-14' WHERE numero = 'OS26-00000008';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-24' WHERE numero = 'OS26-00000009';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-29' WHERE numero = 'OS26-00000010';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-11-06' WHERE numero = 'OS26-00000011';
UPDATE SERVICIOS SET estado = 'C', fecha_fin = '2026-11-10' WHERE numero = 'OS26-00000012';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-12' WHERE numero = 'OS26-00000013';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-25' WHERE numero = 'OS26-00000014';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-15' WHERE numero = 'OS26-00000015';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-23' WHERE numero = 'OS26-00000016';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-31' WHERE numero = 'OS26-00000017';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-09-17' WHERE numero = 'OS26-00000019';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-07' WHERE numero = 'OS26-00000020';
UPDATE SERVICIOS SET estado = 'F', fecha_fin = '2026-10-21' WHERE numero = 'OS26-00000021';

INSERT INTO CONSUMOS (cantidad, fecha_uso, precio, repuesto, servicio, item) VALUES
    (1, '2026-11-03', 25000.00, 'R001', 'OS26-00000001', 1),
    (2, '2026-09-14', 60000.00, 'R002', 'OS26-00000002', 1),
    (2, '2026-10-05', 62000.00, 'R002', 'OS26-00000003', 1),
    (1, '2026-09-04', 780000.00, 'R003', 'OS26-00000005', 1),
    (2, '2026-09-04', 75000.00, 'R005', 'OS26-00000005', 2),
    (1, '2026-09-23', 640000.00, 'R004', 'OS26-00000006', 1),
    (1, '2026-09-22', 25000.00, 'R001', 'OS26-00000006', 2),
    (1, '2026-09-22', 75000.00, 'R005', 'OS26-00000006', 2),
    (1, '2026-10-03', 780000.00, 'R003', 'OS26-00000007', 1),
    (2, '2026-10-03', 60000.00, 'R002', 'OS26-00000007', 2),
    (1, '2026-10-03', 32000.00, 'R006', 'OS26-00000007', 2),
    (2, '2026-10-14', 75000.00, 'R005', 'OS26-00000008', 1),
    (1, '2026-10-14', 25000.00, 'R001', 'OS26-00000008', 2),
    (1, '2026-10-21', 780000.00, 'R003', 'OS26-00000009', 1),
    (1, '2026-10-28', 640000.00, 'R004', 'OS26-00000010', 1),
    (2, '2026-11-05', 60000.00, 'R002', 'OS26-00000011', 1),
    (2, '2026-11-06', 75000.00, 'R005', 'OS26-00000011', 2),
    (1, '2026-09-09', 790000.00, 'R003', 'OS26-00000013', 1),
    (2, '2026-09-08', 62000.00, 'R002', 'OS26-00000013', 2),
    (2, '2026-09-25', 76000.00, 'R005', 'OS26-00000014', 1),
    (1, '2026-09-25', 26000.00, 'R001', 'OS26-00000014', 2),
    (1, '2026-10-10', 790000.00, 'R003', 'OS26-00000015', 1),
    (2, '2026-10-10', 76000.00, 'R005', 'OS26-00000015', 1),
    (2, '2026-10-22', 62000.00, 'R002', 'OS26-00000016', 1),
    (1, '2026-10-22', 33000.00, 'R006', 'OS26-00000016', 1),
    (1, '2026-10-29', 790000.00, 'R003', 'OS26-00000017', 1),
    (1, '2026-09-16', 630000.00, 'R004', 'OS26-00000019', 1),
    (2, '2026-10-06', 74000.00, 'R005', 'OS26-00000020', 1),
    (2, '2026-10-07', 61000.00, 'R002', 'OS26-00000020', 2),
    (1, '2026-10-06', 24000.00, 'R001', 'OS26-00000020', 3),
    (1, '2026-10-20', 630000.00, 'R004', 'OS26-00000021', 1);

INSERT INTO GARANTIAS (numero, fecha_inicio, fecha_fin, condiciones, estado, servicio, item) VALUES
    ('G01', '2026-09-15', '2027-03-15', 'Cubre desgaste prematuro de pastillas durante 6 meses', 'V', 'OS26-00000002', 1),
    ('G02', '2026-10-06', '2027-01-06', 'Cubre ruidos en el sistema de frenos durante 3 meses', 'V', 'OS26-00000003', 1),
    ('G03', '2026-09-08', '2027-09-08', 'Cubre fallas del ajuste de motor durante 12 meses o 20000 km', 'V', 'OS26-00000005', 1),
    ('G05', '2026-09-24', '2027-03-24', 'Cubre el kit de embrague instalado durante 6 meses', 'R', 'OS26-00000006', 1),
    ('G06', '2026-09-12', '2027-09-12', 'Cubre fallas del ajuste de motor durante 12 meses', 'V', 'OS26-00000013', 1),
    ('G07', '2026-09-25', '2026-10-25', 'Cubre fugas del filtro de aceite durante 1 mes', 'X', 'OS26-00000014', 2),
    ('G08', '2026-09-17', '2027-03-17', 'Cubre el kit de embrague instalado durante 6 meses', 'A', 'OS26-00000019', 1);

INSERT INTO TRASLADOS (numero, cantidad, fecha, detalle, sede_llega, sede_sale, repuesto) VALUES
    ('TR01', 5, '2026-09-03', 'Reposicion de filtros', 'S02', 'S01', 'R001'),
    ('TR02', 2, '2026-10-25', 'Pastillas para la Sede Norte', 'S01', 'S02', 'R002'),
    ('TR03', 3, '2026-10-01', 'Filtros para la nueva sede', 'S03', 'S01', 'R001'),
    ('TR04', 3, '2026-10-10', 'Aceite para la nueva sede', 'S03', 'S01', 'R005'),
    ('TR05', 1, '2026-10-25', NULL, 'S02', 'S03', 'R004');

INSERT INTO PROVEEDORES (nit, correo, numero_contacto, representante, nombre) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS'),
    ('900654321', 'contacto@frenosya.com', '6015551111', 'Marta Diaz', 'Frenos Ya LTDA'),
    ('900777888', 'ventas@motorpartes.com', '6015552222', 'Jose Ortiz', 'Motor Partes SAS');

INSERT INTO SUMINISTROS (precio_referencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001'),
    (60000.00, '900123456', 'R005'),
    (25000.00, '900123456', 'R006'),
    (45000.00, '900654321', 'R002'),
    (23000.00, '900654321', 'R006'),
    (650000.00, '900777888', 'R003'),
    (520000.00, '900777888', 'R004'),
    (58000.00, '900777888', 'R005');

INSERT INTO COMPRAS (numero, fecha, sede, proveedor) VALUES
    ('C01', '2026-08-25', 'S01', '900123456'),
    ('C02', '2026-08-26', 'S02', '900654321'),
    ('C03', '2026-08-27', 'S01', '900654321'),
    ('C04', '2026-08-28', 'S01', '900777888'),
    ('C05', '2026-08-29', 'S02', '900777888'),
    ('C06', '2026-09-01', 'S03', '900777888'),
    ('C07', '2026-09-02', 'S03', '900654321'),
    ('C08', '2026-10-01', 'S01', '900123456'),
    ('C09', '2026-10-15', 'S02', '900123456');

SELECT setval('SQ_COMPRAS_numero',
                (SELECT COALESCE(MAX(SUBSTRING(numero FROM 2)::INTEGER), 0) + 1 FROM COMPRAS), false);

INSERT INTO DETALLE_COMPRAS (cantidad, precio_unidad, compra, repuesto) VALUES
    (30, 20000.00, 'C01', 'R001'),
    (10, 45000.00, 'C02', 'R002'),
    (10, 45000.00, 'C03', 'R002'),
    (3, 650000.00, 'C04', 'R003'),
    (3, 520000.00, 'C04', 'R004'),
    (10, 58000.00, 'C04', 'R005'),
    (3, 650000.00, 'C05', 'R003'),
    (8, 58000.00, 'C05', 'R005'),
    (3, 520000.00, 'C06', 'R004'),
    (6, 58000.00, 'C06', 'R005'),
    (6, 45000.00, 'C07', 'R002'),
    (4, 23000.00, 'C07', 'R006'),
    (10, 60000.00, 'C08', 'R005'),
    (5, 25000.00, 'C08', 'R006'),
    (4, 25000.00, 'C09', 'R006'),
    (10, 20000.00, 'C09', 'R001');

INSERT INTO MOVIMIENTOS (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', '2026-09-15', 340000.00, 'Cobro orden de servicio DEF456', 'P'),
    ('M02', '2026-09-01', 600000.00, 'Pago compra C01', 'P'),
    ('M03', '2026-10-06', 354000.00, 'Cobro orden de servicio GHI789', 'P'),
    ('M04', '2026-09-02', 450000.00, 'Pago compra C02', 'P'),
    ('M05', '2026-09-02', 450000.00, 'Pago compra C03', 'P'),
    ('M06', '2026-09-05', 4090000.00, 'Pago compra C04', 'P'),
    ('M07', '2026-09-06', 2414000.00, 'Pago compra C05', 'P'),
    ('M08', '2026-09-07', 1908000.00, 'Pago compra C06', 'P'),
    ('M09', '2026-09-08', 5480000.00, 'Cobro orden de servicio JKL321', 'P'),
    ('M10', '2026-09-08', 362000.00, 'Pago compra C07', 'P'),
    ('M11', '2026-09-12', 4744000.00, 'Cobro orden de servicio GHI789', 'P'),
    ('M12', '2026-09-17', 2615000.00, 'Cobro orden de servicio VWX135', 'P'),
    ('M13', '2026-09-24', 2850000.00, 'Cobro orden de servicio MNO654', 'P'),
    ('M14', '2026-09-25', 1053000.00, 'Cobro orden de servicio YZA864', 'P'),
    ('M15', '2026-10-03', 725000.00, 'Pago compra C08', 'P'),
    ('M16', '2026-10-07', 4952000.00, 'Cobro orden de servicio PQR987', 'P'),
    ('M17', '2026-10-07', 1414000.00, 'Cobro orden de servicio BCD579', 'P'),
    ('M18', '2026-10-14', 1085000.00, 'Cobro orden de servicio BCD579', 'P'),
    ('M19', '2026-10-15', 4542000.00, 'Cobro orden de servicio JKL321', 'P'),
    ('M20', '2026-10-21', 2530000.00, 'Cobro orden de servicio EFG102', 'X'),
    ('M21', '2026-10-23', 1107000.00, 'Cobro orden de servicio STU246', 'P'),
    ('M22', '2026-10-24', 4580000.00, 'Cobro orden de servicio STU246', 'P'),
    ('M23', '2026-10-29', 2590000.00, 'Cobro orden de servicio EFG102', 'P'),
    ('M24', '2026-10-31', 4390000.00, 'Cobro orden de servicio MNO654', 'P'),
    ('M25', '2026-11-06', 1240000.00, 'Cobro orden de servicio VWX135', 'P');

INSERT INTO COBROS (movimiento, medio_pago, fecha_expedido, orden) VALUES
    ('M01', 'T', '2026-09-15', 'OS26-00000002'),
    ('M03', 'E', '2026-10-06', 'OS26-00000003'),
    ('M09', 'T', '2026-09-08', 'OS26-00000005'),
    ('M11', 'E', '2026-09-12', 'OS26-00000013'),
    ('M12', 'B', '2026-09-17', 'OS26-00000019'),
    ('M13', 'T', '2026-09-24', 'OS26-00000006'),
    ('M14', 'C', '2026-09-25', 'OS26-00000014'),
    ('M16', 'E', '2026-10-07', 'OS26-00000007'),
    ('M17', 'B', '2026-10-07', 'OS26-00000020'),
    ('M18', 'T', '2026-10-14', 'OS26-00000008'),
    ('M19', 'T', '2026-10-15', 'OS26-00000015'),
    ('M20', 'E', '2026-10-21', 'OS26-00000021'),
    ('M21', 'B', '2026-10-23', 'OS26-00000016'),
    ('M22', 'T', '2026-10-24', 'OS26-00000009'),
    ('M23', 'C', '2026-10-29', 'OS26-00000010'),
    ('M24', 'E', '2026-10-31', 'OS26-00000017'),
    ('M25', 'B', '2026-11-06', 'OS26-00000011');

INSERT INTO PAGOS (movimiento, fecha_pago, compra) VALUES
    ('M02', '2026-09-01', 'C01'),
    ('M04', '2026-09-02', 'C02'),
    ('M05', '2026-09-02', 'C03'),
    ('M06', '2026-09-05', 'C04'),
    ('M07', '2026-09-06', 'C05'),
    ('M08', '2026-09-07', 'C06'),
    ('M10', '2026-09-08', 'C07'),
    ('M15', '2026-10-03', 'C08');
