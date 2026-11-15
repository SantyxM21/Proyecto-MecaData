-- MecaData ActoresE
/*
SV_GERENTE
-- Servicios
ad_servicio(gerente VARCHAR, vehiculo VARCHAR) : VARCHAR
    Abre una orden de servicio en su sede y devuelve su numero
up_servicio(gerente VARCHAR, numero VARCHAR, estado VARCHAR) : VOID
    Finaliza o cancela una orden en proceso de su sede
de_servicio(gerente VARCHAR, numero VARCHAR) : VOID
    Las ordenes no se eliminan: siempre se rechaza
ad_detalle_servicio(gerente VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico VARCHAR) : INTEGER
    Agrega un trabajo a una orden en proceso de su sede y devuelve su item
co_valorTotalServicio(gerente VARCHAR, numero VARCHAR) : NUMERIC
    Valor total de una orden de su sede
co_serviciosEnProcesoSede(gerente VARCHAR) : REFCURSOR
    Ordenes en proceso de su sede
co_estadoServicioVehiculo(placa VARCHAR) : REFCURSOR
    Avance del servicio en proceso de un vehiculo
-- Compras
ad_compra(gerente VARCHAR, proveedor VARCHAR) : VARCHAR
    Registra una compra de su sede y devuelve su numero
up_compra(gerente VARCHAR, numero VARCHAR, proveedor VARCHAR) : VOID
    Cambia el proveedor de una compra de su sede sin detalles ni pago
de_compra(gerente VARCHAR, numero VARCHAR) : VOID
    Elimina una compra de su sede que no tiene pago
ad_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC) : VOID
    Agrega un repuesto a una compra de su sede sin pago
up_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC) : VOID
    Cambia la cantidad o el precio de un repuesto de una compra sin pago
de_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR) : VOID
    Quita un repuesto de una compra de su sede sin pago
co_valorTotalCompra(gerente VARCHAR, numero VARCHAR) : NUMERIC
    Valor total de una compra de su sede
co_repuestosPorAgotarseSede(gerente VARCHAR) : REFCURSOR
    Repuestos por agotarse en su sede

SV_TECNICO
-- Servicios
ad_servicio(tecnico VARCHAR, vehiculo VARCHAR) : VARCHAR
    Abre una orden de servicio en su sede y devuelve su numero
up_servicio(tecnico VARCHAR, numero VARCHAR, estado VARCHAR) : VOID
    Finaliza o cancela una orden en proceso de su sede
de_servicio(tecnico VARCHAR, numero VARCHAR) : VOID
    Las ordenes no se eliminan: siempre se rechaza
ad_detalle_servicio(tecnico VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico_asignado VARCHAR) : INTEGER
    Agrega un trabajo a una orden en proceso de su sede y devuelve su item
co_valorTotalServicio(tecnico VARCHAR, numero VARCHAR) : NUMERIC
    Valor total de una orden de su sede
co_serviciosEnProcesoSede(tecnico VARCHAR) : REFCURSOR
    Ordenes en proceso de su sede
co_estadoServicioVehiculo(placa VARCHAR) : REFCURSOR
    Avance del servicio en proceso de un vehiculo
up_detalle_servicio(tecnico VARCHAR, servicio VARCHAR, item INTEGER, estado VARCHAR, horas_trabajadas NUMERIC) : VOID
    Registra las horas y el estado de un trabajo asignado a el
up_diagnostico_servicio(tecnico VARCHAR, servicio VARCHAR, item INTEGER, diagnostico JSONB) : VOID
    Registra el diagnostico de un trabajo asignado a el
-- Compras
co_valorTotalCompra(tecnico VARCHAR, numero VARCHAR) : NUMERIC
    Valor total de una compra de su sede
co_repuestosPorAgotarseSede(tecnico VARCHAR) : REFCURSOR
    Repuestos por agotarse en su sede
*/
