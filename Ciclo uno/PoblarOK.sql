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
    ('A', '2022-05-16', 4200000.00, '5050505050', 'S01'),
    ('T', '2024-02-01', 3300000.00, '6060606060', 'S02'),
    ('G', '2020-08-03', 7800000.00, '8080808080', 'S02');

INSERT INTO TECNICOS (especialidad, empleado) VALUES
    ('Motor', '2020202020'),
    ('Frenos', '6060606060');

INSERT INTO CATALOGO_SERVICIOS (codigo, nombre, descripcion, precio_base, tiempo_medio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.5),
    ('CS02', 'Revision de frenos', 'Revision y cambio de pastillas de freno', 220000.00, 2),
    ('CS03', 'Alineacion y balanceo', 'Alineacion de direccion y balanceo de llantas', 90000.00, 1);

INSERT INTO PRESTA (disponible, precio_local, catalogo_servicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01'),
    (TRUE, NULL, 'CS02', 'S01'),
    (FALSE, 95000.00, 'CS03', 'S01'),
    (TRUE, 155000.00, 'CS01', 'S02'),
    (TRUE, 230000.00, 'CS02', 'S02');

INSERT INTO REPUESTOS (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite'),
    ('R002', 'Freno', 'Pastillas de freno');

INSERT INTO INVENTARIO (cantidad, sede, repuesto) VALUES
    (20, 'S01', 'R001'),
    (10, 'S01', 'R002'),
    (8, 'S02', 'R001'),
    (6, 'S02', 'R002');

INSERT INTO SERVICIOS (vehiculo, sede) VALUES ('ABC123', 'S01');
INSERT INTO SERVICIOS (vehiculo, sede) VALUES ('DEF456', 'S01');
INSERT INTO SERVICIOS (vehiculo, sede) VALUES ('GHI789', 'S02');
INSERT INTO SERVICIOS (vehiculo, sede) VALUES ('GHI789', 'S02');

INSERT INTO DETALLE_ORDENES (id, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio) VALUES
    ('DO01', 160000.00, 'E', CURRENT_DATE, NULL, 'CS01', 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000001'),
    ('DO02', 220000.00, 'E', CURRENT_DATE, NULL, 'CS02', 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000002'),
    ('DO03', 230000.00, 'E', CURRENT_DATE, NULL, 'CS02', 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000003');

INSERT INTO TRABAJA (horas_trabajadas, tecnico, detalle_orden) VALUES
    (1.5, '2020202020', 'DO01'),
    (2, '2020202020', 'DO02'),
    (2.5, '6060606060', 'DO03');

INSERT INTO CONSUMO_REPUESTO (cantidad, fecha_uso, precio, repuesto, detalle_orden) VALUES
    (1, CURRENT_DATE, 25000.00, 'R001', 'DO01'),
    (2, CURRENT_DATE, 60000.00, 'R002', 'DO02'),
    (2, CURRENT_DATE, 62000.00, 'R002', 'DO03');

UPDATE DETALLE_ORDENES SET estado = 'F', fecha_fin = CURRENT_DATE WHERE id IN ('DO02', 'DO03');
UPDATE SERVICIOS SET estado = 'F' WHERE numero = 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000002';
UPDATE SERVICIOS SET estado = 'F' WHERE numero = 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000003';
UPDATE SERVICIOS SET estado = 'C' WHERE numero = 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000004';

INSERT INTO GARANTIAS (numero, fecha_inicio, condiciones, estado, detalle_orden) VALUES
    ('G01', CURRENT_DATE, 'Cubre desgaste prematuro de pastillas durante 6 meses', 'V', 'DO02'),
    ('G02', CURRENT_DATE, 'Cubre ruidos en el sistema de frenos durante 3 meses', 'V', 'DO03');

INSERT INTO TRASLADOS (numero, cantidad, fecha, detalle, sede_llega, sede_sale, repuesto) VALUES
    ('TR01', 5, '2024-04-01', 'Reposicion de filtros', 'S02', 'S01', 'R001');

INSERT INTO PROVEEDORES (nit, correo, numero_contacto, representante, nombre) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS'),
    ('900654321', 'contacto@frenosya.com', '6015551111', 'Marta Diaz', 'Frenos Ya LTDA');

INSERT INTO SUMINISTRA (precio_referencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001'),
    (45000.00, '900654321', 'R002');

INSERT INTO COMPRAS (numero, fecha, sede, proveedor) VALUES
    ('C01', '2024-03-20', 'S01', '900123456'),
    ('C02', '2025-02-11', 'S02', '900654321');

INSERT INTO DETALLE_COMPRAS (id, cantidad, precio_unidad, compra, repuesto) VALUES
    ('DC01', 30, 20000.00, 'C01', 'R001'),
    ('DC02', 10, 45000.00, 'C02', 'R002');

INSERT INTO MOVIMIENTOS (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', CURRENT_DATE, 280000.00, 'Cobro orden de servicio DEF456', 'P'),
    ('M02', '2024-03-25', 600000.00, 'Pago compra C01', 'P'),
    ('M03', CURRENT_DATE, 354000.00, 'Cobro orden de servicio GHI789', 'P'),
    ('M04', '2025-02-15', 450000.00, 'Pago compra C02', 'P');

INSERT INTO COBROS (movimiento, medio_pago, fecha_expedido, orden) VALUES
    ('M01', 'T', CURRENT_DATE, 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000002'),
    ('M03', 'E', CURRENT_DATE, 'OS' || TO_CHAR(CURRENT_DATE, 'YY') || '-00000003');

INSERT INTO PAGOS (movimiento, fecha_pago, compra) VALUES
    ('M02', '2024-03-25', 'C01'),
    ('M04', '2025-02-15', 'C02');
