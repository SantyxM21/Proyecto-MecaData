-- MecaData Indices
--CRUD de Servicios: las ordenes se buscan por sede y estado 
CREATE INDEX IX_SERVICIOS_SEDE_ESTADO ON SERVICIOS(sede, estado);

--CRUD de Compras: los detalles de compra se buscan por repuesto
CREATE INDEX IX_DETALLE_COMPRAS_REPUESTO ON DETALLE_COMPRAS(repuesto);
