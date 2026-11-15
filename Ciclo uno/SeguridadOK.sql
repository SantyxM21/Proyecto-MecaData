-- MecaData SeguridadOK
-- Cuenta: Gerente

-- Caso 1: La gerente de S01 consulta las ordenes en proceso de su sede: OS26-00000001
BEGIN;
SELECT SV_GERENTE.co_serviciosEnProcesoSede('3030303030');
FETCH ALL IN "co_enProceso";
COMMIT;

-- Caso 2: Consulta el valor total de la compra C000000010 de su sede: 25 x 19000 = 475000
SELECT SV_GERENTE.co_valorTotalCompra('3030303030', 'C000000010');


-- Cuenta: Tecnico

-- Caso 3: La tecnica 5050505050 registra 2 horas y finaliza su trabajo (item 2 de OS26-00000001)
SELECT SV_TECNICO.up_detalle_servicio('5050505050', 'OS26-00000001', 2, 'F', 2);

-- Caso 4: El tecnico 6060606060 consulta los repuestos por agotarse en su sede (S02)
BEGIN;
SELECT SV_TECNICO.co_repuestosPorAgotarseSede('6060606060');
FETCH ALL IN "co_porAgotarse";
COMMIT;
