-- MecaData Tablas
CREATE TABLE Automoviles(
    vehiculo TPlaca NOT NULL, 
    numeroPuertas int NOT NULL
);

CREATE TABLE Vehiculos(
    placa TPlaca NOT NULL,
    kilometraje int NOT NULL,
    marca VARCHAR(30) NOT NULL,
    modelo NUMERIC(4) NOT NULL,
    cilindraje NUMERIC NOT NULL,
    color VARCHAR(20) NOT NULL,
    cliente VARCHAR(15) NOT NULL
);

CREATE TABLE Clientes(
    direccion VARCHAR(100),
    fechaRegistro DATE NOT NULL,
    persona VARCHAR(15) NOT NULL
);

CREATE TABLE Personas(
    cedula VARCHAR(15) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo TCorreo NOT NULL, 
    telefono TTelefono NOT NULL
);

CREATE TABLE Empleados(
    cargo TCargo NOT NULL,
    fechaIngreso DATE NOT NULL,
    salario TMoneda NOT NULL,
    persona VARCHAR(15) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE Tecnicos(
    especialidad VARCHAR(50) NOT NULL,
    empleado VARCHAR(15) NOT NULL
);

CREATE TABLE Trabaja(
    horasTrabajadas NUMERIC NOT NULL,
    tecnico VARCHAR(15) NOT NULL,
    detalleOrden VARCHAR(10) NOT NULL
);

CREATE TABLE DetalleOrdenes(
    id VARCHAR(10) NOT NULL,
    valorCobrado TMoneda,
    estado TEstadoOrden NOT NULL, 
    fechaInicio DATE NOT NULL,
    fechaFin DATE,
    catalogoServicio VARCHAR(10) NOT NULL,
    servicio TNumeroOrden NOT NULL
);

CREATE TABLE Garantias(
    numero VARCHAR(10) NOT NULL,
    fechaInicio DATE NOT NULL,
    condiciones VARCHAR(200) NOT NULL,
    estado TEstadoGarantia NOT NULL, 
    detalleOrden VARCHAR(10) NOT NULL 
);

CREATE TABLE Servicios(
    numero TNumeroOrden NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE,
    estado TEstadoOrden NOT NULL, 
    vehiculo TPlaca NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE CatalogoServicios(
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    precioBase TMoneda NOT NULL,
    tiempoMedio NUMERIC NOT NULL
);

CREATE TABLE Presta(
    disponible boolean NOT NULL, 
    precioLocal TMoneda,
    catalogoServicio VARCHAR(10) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE Sedes(
    numero VARCHAR(5) NOT NULL, 
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono TTelefono NOT NULL
);

CREATE TABLE Inventario(
    cantidad int NOT NULL,
    sede VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE Repuestos(
    serie VARCHAR(20) NOT NULL,
    tipo VARCHAR(30) NOT NULL, 
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Traslados(
    numero VARCHAR(10) NOT NULL,
    cantidad int NOT NULL,
    fecha DATE NOT NULL,
    detalle VARCHAR(200),
    sedeLlega VARCHAR(5) NOT NULL,
    sedeSale VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE ConsumoRepuesto(
    cantidad int NOT NULL,
    fechaUso DATE NOT NULL,
    precio TMoneda NOT NULL,
    repuesto VARCHAR(20) NOT NULL, 
    detalleOrden VARCHAR(10) NOT NULL
);

CREATE TABLE Suministra(
    precioReferencia TMoneda NOT NULL,
    proveedor VARCHAR(15) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE Proveedores(
    nit VARCHAR(15) NOT NULL,
    correo TCorreo NOT NULL,
    numeroContacto TTelefono NOT NULL,
    representante VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100)
);

CREATE TABLE Compras(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    sede VARCHAR(5) NOT NULL,
    proveedor VARCHAR(15) NOT NULL
);

CREATE TABLE DetalleCompras(
    id VARCHAR(10) NOT NULL,
    cantidad int NOT NULL,
    precioUnidad TMoneda NOT NULL,
    compra VARCHAR(10) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE Movimientos(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    valor TMoneda NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    estado TEstadoMovimiento NOT NULL
);

CREATE TABLE Cobros(
    movimiento VARCHAR(10) NOT NULL,
    medioPago TMedioPago NOT NULL,
    fechaExpedido DATE NOT NULL,
    orden TNumeroOrden NOT NULL
);

CREATE TABLE Pagos(
    movimiento VARCHAR(10) NOT NULL,
    fechaPago DATE NOT NULL,
    compra VARCHAR(10) NOT NULL
);
