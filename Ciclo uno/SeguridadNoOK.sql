-- MecaData SeguridadNoOK
-- Cuenta: Gerente

-- Caso 1: No puede usar los servicios del tecnico
SELECT SV_TECNICO.up_detalle_servicio('2020202020', 'OS26-00000001', 3, 'F', 1);

-- Caso 2: No puede saltarse los servicios y leer la tabla directamente
SELECT * FROM SERVICIOS;

-- Caso 3: No puede usar el componente directamente
SELECT SV_COMPRAS.de('3030303030', 'C000000010');


-- Cuenta: Tecnico

-- Caso 4: No puede usar los servicios del gerente (el tecnico no registra compras)
SELECT SV_GERENTE.ad_compra('3030303030', '900123456');
