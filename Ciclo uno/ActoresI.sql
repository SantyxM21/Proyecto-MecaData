-- MecaData ActoresI
CREATE SCHEMA SV_GERENTE;

CREATE OR REPLACE FUNCTION SV_GERENTE.ad_servicio(gerente VARCHAR, vehiculo VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_SERVICIOS.ad(ad_servicio.gerente, ad_servicio.vehiculo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.up_servicio(gerente VARCHAR, numero VARCHAR, estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up(up_servicio.gerente, up_servicio.numero, up_servicio.estado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.de_servicio(gerente VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.de(de_servicio.gerente, de_servicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.ad_detalle_servicio(gerente VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico VARCHAR)
RETURNS INTEGER AS $$
BEGIN
    RETURN SV_SERVICIOS.ad_detalle(ad_detalle_servicio.gerente, ad_detalle_servicio.servicio, ad_detalle_servicio.catalogo_servicio, ad_detalle_servicio.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_valorTotalServicio(gerente VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_SERVICIOS.co_valorTotal(co_valorTotalServicio.gerente, co_valorTotalServicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_serviciosEnProcesoSede(gerente VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_enProceso(co_serviciosEnProcesoSede.gerente);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_estadoServicioVehiculo(placa VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_estado(co_estadoServicioVehiculo.placa);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;






CREATE OR REPLACE FUNCTION SV_GERENTE.ad_compra(gerente VARCHAR, proveedor VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_COMPRAS.ad(ad_compra.gerente, ad_compra.proveedor);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.up_compra(gerente VARCHAR, numero VARCHAR, proveedor VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.up(up_compra.gerente, up_compra.numero, up_compra.proveedor);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.de_compra(gerente VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.de(de_compra.gerente, de_compra.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.ad_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.ad_detalle(ad_detalle_compra.gerente, ad_detalle_compra.compra, ad_detalle_compra.repuesto, ad_detalle_compra.cantidad, ad_detalle_compra.precio_unidad);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.up_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR, cantidad INTEGER, precio_unidad NUMERIC)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.up_detalle(up_detalle_compra.gerente, up_detalle_compra.compra, up_detalle_compra.repuesto, up_detalle_compra.cantidad, up_detalle_compra.precio_unidad);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.de_detalle_compra(gerente VARCHAR, compra VARCHAR, repuesto VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_COMPRAS.de_detalle(de_detalle_compra.gerente, de_detalle_compra.compra, de_detalle_compra.repuesto);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_valorTotalCompra(gerente VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_COMPRAS.co_valorTotal(co_valorTotalCompra.gerente, co_valorTotalCompra.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_repuestosPorAgotarseSede(gerente VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_COMPRAS.co_porAgotarse(co_repuestosPorAgotarseSede.gerente);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



CREATE SCHEMA SV_TECNICO;

CREATE OR REPLACE FUNCTION SV_TECNICO.ad_servicio(tecnico VARCHAR, vehiculo VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    RETURN SV_SERVICIOS.ad(ad_servicio.tecnico, ad_servicio.vehiculo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_servicio(tecnico VARCHAR, numero VARCHAR, estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up(up_servicio.tecnico, up_servicio.numero, up_servicio.estado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.de_servicio(tecnico VARCHAR, numero VARCHAR)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.de(de_servicio.tecnico, de_servicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.ad_detalle_servicio(tecnico VARCHAR, servicio VARCHAR, catalogo_servicio VARCHAR, tecnico_asignado VARCHAR)
RETURNS INTEGER AS $$
BEGIN
    RETURN SV_SERVICIOS.ad_detalle(ad_detalle_servicio.tecnico, ad_detalle_servicio.servicio, ad_detalle_servicio.catalogo_servicio, ad_detalle_servicio.tecnico_asignado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_valorTotalServicio(tecnico VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_SERVICIOS.co_valorTotal(co_valorTotalServicio.tecnico, co_valorTotalServicio.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_serviciosEnProcesoSede(tecnico VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_enProceso(co_serviciosEnProcesoSede.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_estadoServicioVehiculo(placa VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_SERVICIOS.co_estado(co_estadoServicioVehiculo.placa);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_detalle_servicio(tecnico VARCHAR, servicio VARCHAR, item INTEGER, estado VARCHAR, horas_trabajadas NUMERIC)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up_detalle(up_detalle_servicio.tecnico, up_detalle_servicio.servicio, up_detalle_servicio.item, up_detalle_servicio.estado, up_detalle_servicio.horas_trabajadas);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_diagnostico_servicio(tecnico VARCHAR, servicio VARCHAR, item INTEGER, diagnostico JSONB)
RETURNS VOID AS $$
BEGIN
    PERFORM SV_SERVICIOS.up_diagnostico(up_diagnostico_servicio.tecnico, up_diagnostico_servicio.servicio, up_diagnostico_servicio.item, up_diagnostico_servicio.diagnostico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



CREATE OR REPLACE FUNCTION SV_TECNICO.co_valorTotalCompra(tecnico VARCHAR, numero VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN SV_COMPRAS.co_valorTotal(co_valorTotalCompra.tecnico, co_valorTotalCompra.numero);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_repuestosPorAgotarseSede(tecnico VARCHAR)
RETURNS REFCURSOR AS $$
BEGIN
    RETURN SV_COMPRAS.co_porAgotarse(co_repuestosPorAgotarseSede.tecnico);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
