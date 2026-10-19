-- MecaData PoblarOK
INSERT INTO PERSONAS (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543');

INSERT INTO CLIENTES (fecha_registro, persona) VALUES
    ('2024-01-15', '1010101010');

INSERT INTO VEHICULOS (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010');

INSERT INTO AUTOMOVILES (vehiculo, numero_puertas) VALUES
    ('ABC123', 4);

INSERT INTO SEDES (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321');

INSERT INTO EMPLEADOS (cargo, fecha_ingreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 3500000.00, '2020202020', 'S01');

INSERT INTO TECNICOS (especialidad, empleado) VALUES
    ('Motor', '2020202020');

INSERT INTO CATALOGO_SERVICIOS (codigo, nombre, descripcion, precio_base, tiempo_medio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.5);

INSERT INTO PRESTA (disponible, precio_local, catalogo_servicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01');
INSERT INTO SERVICIOS (vehiculo, sede) VALUES
    ('ABC123', 'S01');

-- El numero del servicio lo genera el disparador, por eso se consulta en lugar de escribirlo
INSERT INTO DETALLE_ORDENES (id, valor_cobrado, estado, fecha_inicio, fecha_fin, catalogo_servicio, servicio) VALUES
    ('DO01', 160000.00, 'F', CURRENT_DATE, CURRENT_DATE, 'CS01',
     (SELECT MAX(numero) FROM SERVICIOS WHERE vehiculo = 'ABC123'));

INSERT INTO TRABAJA (horas_trabajadas, tecnico, detalle_orden) VALUES
    (1.5, '2020202020', 'DO01');

INSERT INTO GARANTIAS (numero, fecha_inicio, condiciones, estado, detalle_orden) VALUES
    ('G01', CURRENT_DATE, 'Cubre fugas durante 3 meses', 'V', 'DO01');

INSERT INTO REPUESTOS (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite');

INSERT INTO INVENTARIO (cantidad, sede, repuesto) VALUES
    (20, 'S01', 'R001');

INSERT INTO TRASLADOS (numero, cantidad, fecha, detalle, sede_llega, sede_sale, repuesto) VALUES
    ('TR01', 5, '2024-04-01', 'Reposicion de filtros', 'S02', 'S01', 'R001');

INSERT INTO CONSUMO_REPUESTO (cantidad, fecha_uso, precio, repuesto, detalle_orden) VALUES
    (1, CURRENT_DATE, 25000.00, 'R001', 'DO01');

INSERT INTO PROVEEDORES (nit, correo, numero_contacto, representante, nombre) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS');

INSERT INTO SUMINISTRA (precio_referencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001');

INSERT INTO COMPRAS (numero, fecha, sede, proveedor) VALUES
    ('C01', '2024-03-20', 'S01', '900123456');

INSERT INTO DETALLE_COMPRAS (id, cantidad, precio_unidad, compra, repuesto) VALUES
    ('DC01', 30, 20000.00, 'C01', 'R001');

INSERT INTO MOVIMIENTOS (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', CURRENT_DATE, 185000.00, 'Cobro orden ' || (SELECT MAX(numero) FROM SERVICIOS WHERE vehiculo = 'ABC123'), 'P'),
    ('M02', '2024-03-25', 600000.00, 'Pago compra C01', 'P');

INSERT INTO COBROS (movimiento, medio_pago, fecha_expedido, orden) VALUES
    ('M01', 'T', CURRENT_DATE, (SELECT MAX(numero) FROM SERVICIOS WHERE vehiculo = 'ABC123'));

INSERT INTO PAGOS (movimiento, fecha_pago, compra) VALUES
    ('M02', '2024-03-25', 'C01');
