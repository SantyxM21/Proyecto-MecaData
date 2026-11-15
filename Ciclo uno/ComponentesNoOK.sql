-- MecaData ComponentesNoOK
-- Caso 1: El vehiculo ZZZ999 no esta registrado
-- FK_SERVICIOS_VEHICULO rechaza el insert
SELECT SV_SERVICIOS.ad('3030303030', 'ZZZ999');

-- Caso 2: Un servicio finalizado (OS26-00000002) no se puede modificar
-- tg_1_SERVICIOS_bu lanza 'No se pueden modificar los servicios finalizados'
SELECT SV_SERVICIOS.up('3030303030', 'OS26-00000002', 'C');

-- Caso 3: Los servicios no se pueden eliminar, ni siquiera los cancelados (OS26-00000004)
-- de lanza 'No se permite eliminar los servicios'
SELECT SV_SERVICIOS.de('8080808080', 'OS26-00000004');

-- Caso 4: La sede S01 no tiene habilitado el servicio CS03
-- tg_1_DETALLE_ORDENES_bi lanza 'La sede no tiene habilitado ese servicio del catalogo'
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS03', NULL);

-- Caso 5: No se agregan detalles a un servicio finalizado (OS26-00000002)
-- tg_1_DETALLE_ORDENES_bi lanza 'Solo se pueden agregar detalles a los servicios en proceso'
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000002', 'CS01', NULL);

-- Caso 6: El item 2 de OS26-00000001 no tiene horas trabajadas, no se puede finalizar
-- CK_DETALLE_ORDENES_ESTADO_TECNICO rechaza el update
SELECT SV_SERVICIOS.up_detalle('5050505050', 'OS26-00000001', 2, 'F', NULL);

-- Caso 7: El item 9 no existe en la orden OS26-00000001
-- up_detalle lanza 'El detalle no existe o no esta asignado al tecnico'
SELECT SV_SERVICIOS.up_detalle('5050505050', 'OS26-00000001', 9, 'F', 2);

-- Caso 8: Quien ejecuta el detalle debe ser un tecnico (3030303030 es gerente)
-- FK_DETALLE_ORDENES_TECNICO rechaza el insert
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS01', '3030303030');

-- Caso 9: Ana (1010101010) es cliente, no empleada: no puede abrir servicios
-- ad lanza 'La persona no es empleado de ninguna sede'
SELECT SV_SERVICIOS.ad('1010101010', 'ABC123');

-- Caso 10: La gerente de S02 no puede agregar detalles a una orden de S01 (OS26-00000001)
-- ad_detalle lanza 'El servicio no existe o no pertenece a la sede del empleado'
SELECT SV_SERVICIOS.ad_detalle('8080808080', 'OS26-00000001', 'CS01', NULL);

-- Caso 11: El item 1 de OS26-00000001 es de 2020202020 otro tecnico no lo puede modificar
-- up_detalle lanza 'El detalle no existe o no esta asignado al tecnico'
SELECT SV_SERVICIOS.up_detalle('5050505050', 'OS26-00000001', 1, 'F', 1);

-- Caso 12: La orden OS26-00000001 tiene detalles en proceso, no se puede finalizar
-- tg_1_SERVICIOS_bu lanza 'No se puede finalizar un servicio con detalles en proceso'
SELECT SV_SERVICIOS.up('3030303030', 'OS26-00000001', 'F');

-- Caso 13: El tecnico 6060606060 trabaja en S02, no se le puede asignar un detalle de una orden de S01
-- tg_1_DETALLE_ORDENES_bi lanza 'El tecnico no trabaja en la sede del servicio'
SELECT SV_SERVICIOS.ad_detalle('3030303030', 'OS26-00000001', 'CS01', '6060606060');

-- Caso 14: El tecnico 2020202020 no registra compras
-- ad lanza 'El empleado no es gerente de ninguna sede'
SELECT SV_COMPRAS.ad('2020202020', '900123456');

-- Caso 15: El proveedor 900123456 no tiene precio de referencia para las pastillas (R002) y no se indica precio
-- tg_2_DETALLE_COMPRAS_bi lanza 'Se debe indicar el precio por unidad, el proveedor no tiene precio de referencia para ese repuesto'
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C000000010', 'R002', 1, NULL);

-- Caso 16: La compra C01 ya tiene pago
-- tg_1_DETALLE_COMPRAS_bi lanza 'La compra ya tiene pago y no se puede modificar'
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C01', 'R001', 5, NULL);

-- Caso 17: El repuesto R001 ya esta en la compra C000000010
-- PK_DETALLE_COMPRAS rechaza el insert
SELECT SV_COMPRAS.ad_detalle('3030303030', 'C000000010', 'R001', 5, NULL);

-- Caso 18: La cantidad comprada debe ser mayor a cero
-- CK_DETALLE_COMPRAS_CANTIDAD rechaza el update
SELECT SV_COMPRAS.up_detalle('3030303030', 'C000000010', 'R001', 0, NULL);

-- Caso 19: La compra C01 ya tiene pago, no se puede eliminar
-- de lanza 'La compra ya tiene pago y no se puede eliminar' y la FK_PAGOS_COMPRA rechaza el DELETE directo
SELECT SV_COMPRAS.de('3030303030', 'C01');

-- Caso 20: La compra C000000010 ya tiene detalles, no se le puede cambiar el proveedor
-- tg_1_COMPRAS_bu lanza 'No se puede cambiar el proveedor de una compra que ya tiene detalles'
SELECT SV_COMPRAS.up('3030303030', 'C000000010', '900654321');

-- Caso 21: Un tecnico no modifica compras, aunque sean de su sede
-- up_detalle lanza 'La compra no existe o no pertenece a la sede del gerente'
SELECT SV_COMPRAS.up_detalle('2020202020', 'C000000010', 'R001', 1, NULL);

-- Caso 22: La gerente de S02 no puede eliminar una compra de S01
-- de lanza 'La compra no existe o no pertenece a la sede del gerente'
SELECT SV_COMPRAS.de('8080808080', 'C000000010');
