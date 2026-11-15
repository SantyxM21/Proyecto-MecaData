-- MecaData CRUDE
/* CRUD de SERVICIOS

COMO gerente
QUIERO mantener las ordenes de servicio de mi sede
PARA PODER llevar el control de los trabajos que se le hacen a cada vehiculo
-
Adicion
------------
Se debe asignar automaticamente el numero (OSAA-########), la fecha de inicio (hoy) y el estado (en proceso)
SQ_SERVICIOS_numero y valores por omision de numero, fecha_inicio y estado
La fecha de inicio no puede ser futura.
tg_1_SERVICIOS_bi (tg.restringe)
El servicio se realiza sobre un vehiculo registrado y en una sede existente.
FK_SERVICIOS_VEHICULO, FK_SERVICIOS_SEDE
Cada detalle se identifica por su item dentro del servicio y aplica un servicio del catalogo.
PK_DETALLE_ORDENES, CK_DETALLE_ORDENES_ITEM, FK_DETALLE_ORDENES_CATALOGO_SERVICIO
Solo se agregan detalles a servicios en proceso y de servicios del catalogo que la sede tiene habilitados.
El valor cobrado es el precio local de la sede; si no tiene, el precio base del catalogo.
SV_SERVICIOS.ad_detalle (componente)
Quien ejecuta el detalle debe ser un tecnico.
FK_DETALLE_ORDENES_TECNICO
-
Modificacion
---------------------
Los servicios finalizados o cancelados no se pueden modificar y la fecha de inicio no puede quedar en el futuro.
tg_1_SERVICIOS_bu (tg.restringe)
Al finalizar un servicio la fecha de fin se asigna automaticamente.
tg_2_SERVICIOS_bu (tg.automatiza), CK_SERVICIOS_ESTADO_FECHA_FIN, CK_SERVICIOS_FECHAS
Al cancelar un servicio sus detalles en proceso quedan cancelados automaticamente.
tg_1_SERVICIOS_au (tg.automatiza)
Un detalle solo se puede finalizar si tiene tecnico, horas trabajadas y fecha de fin.
CK_DETALLE_ORDENES_ESTADO_TECNICO, CK_DETALLE_ORDENES_ESTADO_FECHA_FIN, CK_DETALLE_ORDENES_FECHAS
Las horas trabajadas deben ser mayores a cero.
CK_DETALLE_ORDENES_HORAS_TRABAJADAS
-
Eliminacion
-------------------
No esta permitido eliminar un servicio; un servicio que no continua se cancela.
tg_2_SERVICIOS_bd (tg.restringe) */

/* CRUD de COMPRAS

COMO gerente
QUIERO mantener las compras de repuestos de mi sede
PARA PODER abastecer el inventario y saber cuanto se le debe a cada proveedor
-
Adicion
------------
Se debe asignar automaticamente el numero (C#########) y la fecha (hoy)
SQ_COMPRAS_numero y valores por omision de numero y fecha
La fecha de la compra no puede ser futura.
tg_1_COMPRAS_bi (tg.restringe)
Solo el gerente registra compras, y siempre para su propia sede.
SV_COMPRAS.ad (componente)
La compra la hace una sede existente a un proveedor registrado.
FK_COMPRAS_SEDE, FK_COMPRAS_PROVEEDOR
Cada detalle se identifica por el repuesto dentro de la compra: un repuesto aparece una sola vez por compra.
PK_DETALLE_COMPRAS, FK_DETALLE_COMPRAS_REPUESTO
La cantidad comprada debe ser mayor a cero.
CK_DETALLE_COMPRAS_CANTIDAD
Si no se indica el precio por unidad se toma el precio de referencia del proveedor
si el proveedor no tiene precio de referencia para ese repuesto, el precio se debe indicar.
tg_2_DETALLE_COMPRAS_bi (tg.automatiza)
-
Modificacion
---------------------
Solo el gerente de la sede de la compra la modifica.
SV_COMPRAS.up, SV_COMPRAS.ad_detalle, SV_COMPRAS.up_detalle, SV_COMPRAS.de_detalle (componente)
Una compra que ya tiene pago no se puede modificar. De una compra solo cambia el proveedor,
y solo mientras no tenga detalles; el numero, la fecha y la sede no cambian.
tg_1_COMPRAS_bu (tg.restringe)
Los detalles de una compra que ya tiene pago no se agregan, no se modifican y no se eliminan.
tg_1_DETALLE_COMPRAS_bi, tg_1_DETALLE_COMPRAS_bu, tg_1_DETALLE_COMPRAS_bd (tg.restringe)
Los pagos de las compras no se modifican ni se eliminan.
tg_1_PAGOS_bu, tg_1_PAGOS_bd (tg.restringe)
-
Eliminacion
-------------------
Solo el gerente de la sede de la compra la elimina.
SV_COMPRAS.de (componente)
Una compra que ya tiene pago no se puede eliminar.
SV_COMPRAS.de (componente), FK_PAGOS_COMPRA
Con la compra se eliminan sus detalles.
FK_DETALLE_COMPRAS_COMPRA (ON DELETE CASCADE) */
