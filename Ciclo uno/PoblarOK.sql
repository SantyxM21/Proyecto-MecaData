-- MecaData PoblarOK
INSERT INTO Personas (cedula, nombre, apellido, correo, telefono) VALUES
    ('1010101010', 'Ana', 'Gomez', 'ana.gomez@mail.com', '3001234567'),
    ('2020202020', 'Luis', 'Perez', 'luis.perez@mail.com', '3109876543');

INSERT INTO Clientes (direccion, fechaRegistro, persona) VALUES
    ('Calle 10 # 5-20', '2024-01-15', '1010101010');

INSERT INTO Vehiculos (placa, kilometraje, marca, modelo, cilindraje, color, cliente) VALUES
    ('ABC123', 45000, 'Mazda', 2020, 2000, 'Rojo', '1010101010');

INSERT INTO Automoviles (vehiculo, numeroPuertas) VALUES
    ('ABC123', 4);

INSERT INTO Sedes (numero, nombre, direccion, telefono) VALUES
    ('S01', 'Sede Norte', 'Av 19 # 100-10', '6011234567'),
    ('S02', 'Sede Sur', 'Cra 30 # 1-50', '6017654321');

INSERT INTO Empleados (cargo, fechaIngreso, salario, persona, sede) VALUES
    ('T', '2023-03-01', 3500000.00, '2020202020', 'S01');

INSERT INTO Tecnicos (especialidad, empleado) VALUES
    ('Motor', '2020202020');

INSERT INTO CatalogoServicios (codigo, nombre, descripcion, precioBase, tiempoMedio) VALUES
    ('CS01', 'Cambio de aceite', 'Cambio de aceite y filtro', 150000.00, 1.5);

INSERT INTO Presta (disponible, precioLocal, catalogoServicio, sede) VALUES
    (TRUE, 160000.00, 'CS01', 'S01');

INSERT INTO Servicios (numero, fechaInicio, fechaFin, estado, vehiculo, sede) VALUES
    ('OS24-00000001', '2024-05-10', '2024-05-11', 'F', 'ABC123', 'S01');

INSERT INTO DetalleOrdenes (id, valorCobrado, estado, fechaInicio, fechaFin, catalogoServicio, servicio) VALUES
    ('DO01', 160000.00, 'F', '2024-05-10', '2024-05-11', 'CS01', 'OS24-00000001');

INSERT INTO Trabaja (horasTrabajadas, tecnico, detalleOrden) VALUES
    (1.5, '2020202020', 'DO01');

INSERT INTO Garantias (numero, fechaInicio, condiciones, estado, detalleOrden) VALUES
    ('G01', '2024-05-11', 'Cubre fugas durante 3 meses', 'V', 'DO01');

INSERT INTO Repuestos (serie, tipo, nombre) VALUES
    ('R001', 'Filtro', 'Filtro de aceite');

INSERT INTO Inventario (cantidad, sede, repuesto) VALUES
    (20, 'S01', 'R001');

INSERT INTO Traslados (numero, cantidad, fecha, detalle, sedeLlega, sedeSale, repuesto) VALUES
    ('TR01', 5, '2024-04-01', 'Reposicion de filtros', 'S02', 'S01', 'R001');

INSERT INTO ConsumoRepuesto (cantidad, fechaUso, precio, repuesto, detalleOrden) VALUES
    (1, '2024-05-10', 25000.00, 'R001', 'DO01');

INSERT INTO Proveedores (nit, correo, numeroContacto, representante, nombre, direccion) VALUES
    ('900123456', 'ventas@repuestos.com', '6015550000', 'Carlos Ruiz', 'Repuestos SAS', 'Calle 80 # 20-30');

INSERT INTO Suministra (precioReferencia, proveedor, repuesto) VALUES
    (20000.00, '900123456', 'R001');

INSERT INTO Compras (numero, fecha, sede, proveedor) VALUES
    ('C01', '2024-03-20', 'S01', '900123456');

INSERT INTO DetalleCompras (id, cantidad, precioUnidad, compra, repuesto) VALUES
    ('DC01', 30, 20000.00, 'C01', 'R001');

INSERT INTO Movimientos (numero, fecha, valor, descripcion, estado) VALUES
    ('M01', '2024-05-11', 185000.00, 'Cobro orden OS24-00000001', 'P'),
    ('M02', '2024-03-25', 600000.00, 'Pago compra C01', 'P');

INSERT INTO Cobros (movimiento, medioPago, fechaExpedido, orden) VALUES
    ('M01', 'T', '2024-05-11', 'OS24-00000001');

INSERT INTO Pagos (movimiento, fechaPago, compra) VALUES
    ('M02', '2024-03-25', 'C01');
