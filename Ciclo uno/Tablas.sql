-- MecaData Tablas
CREATE TABLE AUTOMOVILES(
    vehiculo T_PLACA NOT NULL, 
    numero_puertas INTEGER NOT NULL
);

CREATE TABLE VEHICULOS(
    placa T_PLACA NOT NULL,
    kilometraje INTEGER NOT NULL,
    marca VARCHAR(30) NOT NULL,
    modelo NUMERIC(4) NOT NULL,
    cilindraje NUMERIC NOT NULL,
    color VARCHAR(20) NOT NULL,
    cliente VARCHAR(15) NOT NULL
);

CREATE TABLE CLIENTES(
    fecha_registro DATE NOT NULL,
    persona VARCHAR(15) NOT NULL
);

CREATE TABLE PERSONAS(
    cedula VARCHAR(15) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo T_CORREO NOT NULL, 
    telefono T_TELEFONO NOT NULL
);

CREATE TABLE EMPLEADOS(
    cargo T_CARGO NOT NULL,
    fecha_ingreso DATE NOT NULL,
    salario T_MONEDA NOT NULL,
    persona VARCHAR(15) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE TECNICOS(
    especialidad VARCHAR(50) NOT NULL,
    empleado VARCHAR(15) NOT NULL
);

CREATE TABLE TRABAJA(
    horas_trabajadas NUMERIC NOT NULL,
    tecnico VARCHAR(15) NOT NULL,
    detalle_orden VARCHAR(10) NOT NULL
);

CREATE TABLE DETALLE_ORDENES(
    id VARCHAR(10) NOT NULL,
    valor_cobrado T_MONEDA,
    estado T_ESTADO_ORDEN NOT NULL, 
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    catalogo_servicio VARCHAR(10) NOT NULL,
    servicio T_NUMERO_ORDEN NOT NULL
);

CREATE TABLE GARANTIAS(
    numero VARCHAR(10) NOT NULL,
    fecha_inicio DATE NOT NULL,
    condiciones VARCHAR(200) NOT NULL,
    estado T_ESTADO_GARANTIA NOT NULL, 
    detalle_orden VARCHAR(10) NOT NULL 
);

CREATE TABLE SERVICIOS(
    numero T_NUMERO_ORDEN NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado T_ESTADO_ORDEN NOT NULL, 
    vehiculo T_PLACA NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE CATALOGO_SERVICIOS(
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    precio_base T_MONEDA NOT NULL,
    tiempo_medio NUMERIC NOT NULL
);

CREATE TABLE PRESTA(
    disponible BOOLEAN NOT NULL, 
    precio_local T_MONEDA,
    catalogo_servicio VARCHAR(10) NOT NULL,
    sede VARCHAR(5) NOT NULL
);

CREATE TABLE SEDES(
    numero VARCHAR(5) NOT NULL, 
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono T_TELEFONO NOT NULL
);

CREATE TABLE INVENTARIO(
    cantidad INTEGER NOT NULL,
    sede VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE REPUESTOS(
    serie VARCHAR(20) NOT NULL,
    tipo VARCHAR(30) NOT NULL, 
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE TRASLADOS(
    numero VARCHAR(10) NOT NULL,
    cantidad INTEGER NOT NULL,
    fecha DATE NOT NULL,
    detalle VARCHAR(200),
    sede_llega VARCHAR(5) NOT NULL,
    sede_sale VARCHAR(5) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE CONSUMO_REPUESTO(
    cantidad INTEGER NOT NULL,
    fecha_uso DATE NOT NULL,
    precio T_MONEDA NOT NULL,
    repuesto VARCHAR(20) NOT NULL, 
    detalle_orden VARCHAR(10) NOT NULL
);

CREATE TABLE SUMINISTRA(
    precio_referencia T_MONEDA NOT NULL,
    proveedor VARCHAR(15) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE PROVEEDORES(
    nit VARCHAR(15) NOT NULL,
    correo T_CORREO NOT NULL,
    numero_contacto T_TELEFONO NOT NULL,
    representante VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE COMPRAS(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    sede VARCHAR(5) NOT NULL,
    proveedor VARCHAR(15) NOT NULL
);

CREATE TABLE DETALLE_COMPRAS(
    id VARCHAR(10) NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unidad T_MONEDA NOT NULL,
    compra VARCHAR(10) NOT NULL,
    repuesto VARCHAR(20) NOT NULL
);

CREATE TABLE MOVIMIENTOS(
    numero VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    valor T_MONEDA NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    estado T_ESTADO_MOVIMIENTO NOT NULL
);

CREATE TABLE COBROS(
    movimiento VARCHAR(10) NOT NULL,
    medio_pago T_MEDIO_PAGO NOT NULL,
    fecha_expedido DATE NOT NULL,
    orden T_NUMERO_ORDEN NOT NULL
);

CREATE TABLE PAGOS(
    movimiento VARCHAR(10) NOT NULL,
    fecha_pago DATE NOT NULL,
    compra VARCHAR(10) NOT NULL
);
