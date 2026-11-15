-- MecaData ComponentesOK
-- Caso 1: La gerente de S02 (8080808080) abre un servicio para el vehiculo GHI789.
-- Queda en la sede de la gerente, con el numero consecutivo, la fecha de hoy y el estado E
SELECT SV_SERVICIOS.ad('8080808080', 'GHI789');
SELECT * FROM SERVICIOS WHERE numero = (SELECT MAX(numero) FROM SERVICIOS);

-- Caso 2: Se le agrega un cambio de aceite a ese servicio.
-- Queda como item 1, en estado E y con el precio local de S02 (155000)
SELECT SV_SERVICIOS.ad_detalle('8080808080', (SELECT MAX(numero) FROM SERVICIOS), 'CS01', '6060606060');

-- Caso 3: A la orden OS26-00000001 (S01) se le agrega una revision de frenos.
-- Queda como item 2 y con el precio base (220000) porque S01 no tiene precio local
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS02', '5050505050');

-- Caso 4: El tecnico 2020202020 finaliza el item 1 de la orden OS26-00000001. Queda en F y con fecha de fin de hoy
SELECT SV_SERVICIOS.up_detalle('2020202020', 'OS26-00000001', 1, 'F', NULL);
SELECT item, estado, fecha_fin, valor_cobrado, tecnico, horas_trabajadas
FROM DETALLE_ORDENES WHERE servicio = 'OS26-00000001' ORDER BY item;

-- Caso 5: Valor total de la orden OS26-00000001: 160000 + 220000 + (1 x 25000) = 405000
SELECT SV_SERVICIOS.co_valorTotal('3030303030', 'OS26-00000001');

-- Caso 6: Estado del servicio del vehiculo ABC123: item 1 en F e item 2 en E
BEGIN;
SELECT SV_SERVICIOS.co_estado('ABC123');
FETCH ALL IN "co_estado";
COMMIT;

-- Caso 7: Se cancela el servicio abierto en el caso 1. Su detalle en proceso queda cancelado
SELECT SV_SERVICIOS.up('8080808080', (SELECT MAX(numero) FROM SERVICIOS), 'C');
SELECT servicio, item, estado FROM DETALLE_ORDENES WHERE servicio = (SELECT MAX(numero) FROM SERVICIOS);

-- Caso 8: Ordenes en proceso de la sede de la gerente 3030303030 (S01): OS26-00000001
BEGIN;
SELECT SV_SERVICIOS.co_enProceso('3030303030');
FETCH ALL IN "co_enProceso";
COMMIT;

-- Caso 9: La gerente de S01 (3030303030) abre una compra al proveedor 900123456.
-- Queda en la sede de la gerente, con el numero consecutivo C000000010 y la fecha de hoy
SELECT SV_COMPRAS.ad('3030303030', '900123456');
SELECT * FROM COMPRAS WHERE numero = 'C000000010';

-- Caso 10: Se agregan 20 filtros de aceite (R001) sin indicar precio.
-- Se toma el precio de referencia del proveedor (20000)
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C000000010', 'R001', 20, NULL);

-- Caso 11: Se corrige el detalle: son 25 unidades a 19000
SELECT SV_COMPRAS.up_detalle('3030303030', 'C000000010', 'R001', 25, 19000);
SELECT * FROM DETALLE_COMPRAS WHERE compra = 'C000000010';

-- Caso 12: El tecnico 2020202020 (S01) consulta el valor total de la compra: 25 x 19000 = 475000
SELECT SV_COMPRAS.co_valorTotal('2020202020', 'C000000010');

-- Caso 13: La gerente de S02 abre la compra C000000011 por error, le agrega un detalle,
-- quita el detalle y elimina la compra
SELECT SV_COMPRAS.ad('8080808080', '900654321');
SELECT SV_COMPRAS.ad_detalle('8080808080', 'C000000011', 'R002', 5, 44000);
SELECT SV_COMPRAS.de_detalle('8080808080', 'C000000011', 'R002');
SELECT SV_COMPRAS.de('8080808080', 'C000000011');
SELECT COUNT(*) AS comprasC5 FROM COMPRAS WHERE numero = 'C000000011';

-- Caso 14: Repuestos por agotarse en la sede de la gerente 3030303030 (S01).
-- Los filtros de aceite ya incluyen las 25 unidades de la compra C000000010
BEGIN;
SELECT SV_COMPRAS.co_porAgotarse('3030303030');
FETCH ALL IN "co_porAgotarse";
COMMIT;
