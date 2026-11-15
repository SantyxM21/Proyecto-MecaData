-- MecaData Atributos
ALTER TABLE AUTOMOVILES ADD CONSTRAINT CK_AUTOMOVILES_NUMERO_PUERTAS
    CHECK (numero_puertas > 0);

ALTER TABLE VEHICULOS ADD CONSTRAINT CK_VEHICULOS_KILOMETRAJE
    CHECK (kilometraje >= 0);

ALTER TABLE VEHICULOS ADD CONSTRAINT CK_VEHICULOS_CILINDRAJE
    CHECK (cilindraje > 0);

ALTER TABLE EMPLEADOS ADD CONSTRAINT CK_EMPLEADOS_SALARIO
    CHECK (salario > 0);

ALTER TABLE CATALOGO_SERVICIOS ADD CONSTRAINT CK_CATALOGO_SERVICIOS_PRECIO_BASE
    CHECK (precio_base > 0);

ALTER TABLE CATALOGO_SERVICIOS ADD CONSTRAINT CK_CATALOGO_SERVICIOS_TIEMPO_MEDIO
    CHECK (tiempo_medio > 0);

ALTER TABLE OFERTAS_SERVICIOS ADD CONSTRAINT CK_OFERTAS_SERVICIOS_PRECIO_LOCAL
    CHECK (precio_local > 0);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_ITEM
    CHECK (item > 0);

ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_HORAS_TRABAJADAS
    CHECK (horas_trabajadas > 0);

--Estructura del diagnostico: objeto con sintomas (arreglo no vacio), hallazgos (texto)
--y, opcionalmente recomendaciones (arreglo)
ALTER TABLE DETALLE_ORDENES ADD CONSTRAINT CK_DETALLE_ORDENES_DIAGNOSTICO
    CHECK (diagnostico IS NULL OR (
        jsonb_typeof(diagnostico) = 'object'
        AND diagnostico ? 'sintomas'
        AND diagnostico ? 'hallazgos'
        AND CASE WHEN jsonb_typeof(diagnostico -> 'sintomas') = 'array'
                THEN jsonb_array_length(diagnostico -> 'sintomas') > 0
                ELSE FALSE END
        AND jsonb_typeof(diagnostico -> 'hallazgos') = 'string'
        AND (NOT diagnostico ? 'recomendaciones'
            OR jsonb_typeof(diagnostico -> 'recomendaciones') = 'array')
    ));

ALTER TABLE TRASLADOS ADD CONSTRAINT CK_TRASLADOS_CANTIDAD
    CHECK (cantidad > 0);

ALTER TABLE CONSUMOS ADD CONSTRAINT CK_CONSUMOS_CANTIDAD
    CHECK (cantidad > 0);

ALTER TABLE DETALLE_COMPRAS ADD CONSTRAINT CK_DETALLE_COMPRAS_CANTIDAD
    CHECK (cantidad > 0);
