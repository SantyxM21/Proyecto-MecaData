-- MecaData PoblarOK
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543'),
    ('3030303030', 'Sofia', 'Martinez', 'sofia.martinez@mail.com', '3112223344'),
    ('5050505050', 'Camila', 'Torres', 'camila.torres@mail.com', '3125556677'),
    ('6060606060', 'Jorge', 'Ramirez', 'jorge.ramirez@mail.com', '3138889900'),
    ('7070707070', 'Pedro', 'Castro', 'pedro.castro@mail.com', '3141112233'),
    ('8080808080', 'Laura', 'Moreno', 'laura.moreno@mail.com', '3154443322');

INSERT INTO CLIENTES (fecha_registro, persona) VALUES
    ('2024-01-15', '1010101010'),
    ('2025-06-10', '7070707070');

INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010'),
    ('DEF456', 82000, 'Chevrolet', 2017, 1400, 'Gris', '1010101010'),
    ('GHI789', 15000, 'Renault', 2023, 1600, 'Blanco', '7070707070');

INSERT INTO AUTOMOVILES (vehiculo, numero_puertas) VALUES
    ('ABC123', 4),
    ('DEF456', 5),
    ('GHI789', 4);

INSERT INTO SEDES (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321');

INSERT INTO EMPLEADOS (cargo, fecha_ingreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 3500000.00, '2020202020', 'S01'),
    ('G', '2021-01-10', 8000000.00, '3030303030', 'S01'),
    ('T', '2022-05-16', 4200000.00, '5050505050', 'S01'),
    ('T', '2024-02-01', 3300000.00, '6060606060', 'S02'),
    ('G', '2020-08-03', 7800000.00, '8080808080', 'S02');

INSERT INTO TECNICOS (especialidad, empleado) VALUES
    ('Motor', '2020202020'),
    ('Alineacion', '5050505050'),
    ('Frenos', '6060606060');

INSERT INTO CATALOGO_SERVICIOS (codigo, nombre, descripcion, precio_base, tiempo_medio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.5),
    ('CS02', 'Revision de frenos', 'Revision y cambio de pastillas de freno', 220000.00, 2),
    ('CS03', 'Alineacion y balanceo', 'Alineacion de direccion y balanceo de llantas', 90000.00, 1);

INSERT INTO OFERTAS_SERVICIOS (habilitado, precio_local, catalogo_servicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01'),
    (TRUE, NULL, 'CS02', 'S01'),
    (FALSE, 95000.00, 'CS03', 'S01'),
    (TRUE, 155000.00, 'CS01', 'S02'),
    (TRUE, 230000.00, 'CS02', 'S02');

INSERT INTO REPUESTOS (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite'),
    ('R002', 'Freno', 'Pastillas de freno');

INSERT INTO SERVICIOS (numero, fecha_inicio, fecha_fin, estado, vehiculo, sede) VALUES
    ('OS26-00000001', '2026-11-03', NULL, 'E', 'ABC123', 'S01'),
    ('OS26-00000002', '2026-09-14', '2026-09-15', 'F', 'DEF456', 'S01'),
    ('OS26-00000003', '2026-10-05', '2026-10-06', 'F', 'GHI789', 'S02'),
    ('OS26-00000004', '2026-10-20', NULL, 'C', 'GHI789', 'S02');

SELECT setval('SQ_SERVICIOS_numero',
              (SELECT COALESCE(MAX(SPLIT_PART(numero, '-', 2)::INTEGER), 0) + 1 FROM SERVICIOS), false);

INSERT INTO DETALLE_ORDENES (item, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio, tecnico, horas_trabajadas) VALUES
    (1, 160000.00, 'E', '2026-11-03', NULL, 'CS01', 'OS26-00000001', '2020202020', 1.5),
    (1, 220000.00, 'F', '2026-09-14', '2026-09-15', 'CS02', 'OS26-00000002', '2020202020', 2),
    (1, 230000.00, 'F', '2026-10-05', '2026-10-06', 'CS02', 'OS26-00000003', '6060606060', 2.5);

INSERT INTO CONSUMOS (cantidad, fecha_uso, precio, repuesto, servicio, item) VALUES
    (1, '2026-11-03', 25000.00, 'R001', 'OS26-00000001', 1),
    (2, '2026-09-14', 60000.00, 'R002', 'OS26-00000002', 1),
    (2, '2026-10-05', 62000.00, 'R002', 'OS26-00000003', 1);

INSERT INTO GARANTIAS (numero, fecha_inicio, fecha_fin, condiciones, estado, servicio, item) VALUES
    ('G01', '2026-09-15', '2027-03-15', 'Cubre desgaste prematuro de pastillas durante 6 meses', 'V', 'OS26-00000002', 1),
    ('G02', '2026-10-06', '2027-01-06', 'Cubre ruidos en el sistema de frenos durante 3 meses', 'V', 'OS26-00000003', 1);

INSERT INTO TRASLADOS (numero, cantidad, fecha, detalle, sede_llega, sede_sale, repuesto) VALUES
    ('TR01', 5, '2024-04-01', 'Reposicion de filtros', 'S02', 'S01', 'R001');

INSERT INTO PROVEEDORES (nit, correo, numero_contacto, representante, nombre) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS'),
    ('900654321', 'contacto@frenosya.com', '6015551111', 'Marta Diaz', 'Frenos Ya LTDA');

INSERT INTO SUMINISTROS (precio_referencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001'),
    (45000.00, '900654321', 'R002');

INSERT INTO COMPRAS (numero, fecha, sede, proveedor) VALUES
    ('C01', '2024-03-20', 'S01', '900123456'),
    ('C02', '2025-02-11', 'S02', '900654321'),
    ('C03', '2026-08-20', 'S01', '900654321');

INSERT INTO DETALLE_COMPRAS (id, cantidad, precio_unidad, compra, repuesto) VALUES
    ('DC01', 30, 20000.00, 'C01', 'R001'),
    ('DC02', 10, 45000.00, 'C02', 'R002'),
    ('DC03', 10, 45000.00, 'C03', 'R002');

INSERT INTO MOVIMIENTOS (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', '2026-09-15', 340000.00, 'Cobro orden de servicio DEF456', 'P'),
    ('M02', '2024-03-25', 600000.00, 'Pago compra C01', 'P'),
    ('M03', '2026-10-06', 354000.00, 'Cobro orden de servicio GHI789', 'P'),
    ('M04', '2025-02-15', 450000.00, 'Pago compra C02', 'P'),
    ('M05', '2026-08-25', 450000.00, 'Pago compra C03', 'P');

INSERT INTO COBROS (movimiento, medio_pago, fecha_expedido, orden) VALUES
    ('M01', 'T', '2026-09-15', 'OS26-00000002'),
    ('M03', 'E', '2026-10-06', 'OS26-00000003');

INSERT INTO PAGOS (movimiento, fecha_pago, compra) VALUES
    ('M02', '2024-03-25', 'C01'),
    ('M04', '2025-02-15', 'C02'),
    ('M05', '2026-08-25', 'C03');
