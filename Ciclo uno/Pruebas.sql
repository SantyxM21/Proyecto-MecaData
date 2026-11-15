-- MecaData Pruebas
/*
Ana Gomez lleva su Chevrolet DEF-456 a la Sede Norte porque le toca el cambio de aceite.
La recibe Luis Perez, tecnico de la sede, que abre la orden de servicio y se asigna el
trabajo. Ana pregunta si de una vez le pueden hacer la alineacion, pero la Sede Norte no
tiene habilitado ese servicio. Luis tambien quiere pasarle la revision de frenos a Jorge,
pero Jorge trabaja en la Sede Sur. Camila, la otra tecnica de la sede, intenta registrar
horas en el trabajo de Luis y el sistema no la deja. Luis hace el cambio de aceite,
registra su diagnostico y sus horas, y cierra la orden para cobrarla.
*/
BEGIN;

-- Paso 1 : Luis abre la orden para el vehiculo DEF456.
--      Queda con el numero consecutivo, la fecha de hoy, en estado E y en la sede de Luis (S01).
SELECT SV_TECNICO.ad_servicio('2020202020', 'DEF456');
SELECT * FROM SERVICIOS WHERE numero = 'OS26-00000024';

-- Paso 2 : Luis agrega el cambio de aceite (CS01) y se lo asigna a si mismo.
--      Queda como item 1, en estado E y con el precio local de S01 (160000).
--      Luego intenta agregar la alineacion (CS03), que S01 no tiene habilitada, y el sistema lo rechaza.
SELECT SV_TECNICO.ad_detalle_servicio('2020202020', 'OS26-00000024', 'CS01', '2020202020');
DO $$
BEGIN
    PERFORM SV_TECNICO.ad_detalle_servicio('2020202020', 'OS26-00000024', 'CS03', '2020202020');
    RAISE NOTICE 'FALLA LA PRUEBA: se agrego un servicio que la sede no tiene habilitado';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 3 : Luis intenta agregar la revision de frenos (CS02) asignada a Jorge,
--      que trabaja en la Sede Sur, y el sistema lo rechaza.
DO $$
BEGIN
    PERFORM SV_TECNICO.ad_detalle_servicio('2020202020', 'OS26-00000024', 'CS02', '6060606060');
    RAISE NOTICE 'FALLA LA PRUEBA: se asigno un trabajo a un tecnico de otra sede';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 4 : Camila intenta registrar horas en el trabajo de Luis y el sistema lo rechaza.
--      Luis intenta cerrar la orden con el cambio de aceite aun en proceso y el sistema lo rechaza.
DO $$
BEGIN
    PERFORM SV_TECNICO.up_detalle_servicio('5050505050', 'OS26-00000024', 1, 'F', 2);
    RAISE NOTICE 'FALLA LA PRUEBA: una tecnica registro trabajo en un detalle que no es suyo';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;
DO $$
BEGIN
    PERFORM SV_TECNICO.up_servicio('2020202020', 'OS26-00000024', 'F');
    RAISE NOTICE 'FALLA LA PRUEBA: se finalizo una orden con detalles en proceso';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 5 : Luis registra el diagnostico y 1.5 horas, finaliza su trabajo y cierra la orden.
--      La fecha de fin se asigna automaticamente y el valor total a cobrar es 160000.
--      Se verifica que la orden y su detalle quedaron en F, con fecha de fin, tecnico, horas,
--      valor y diagnostico.
SELECT SV_TECNICO.up_diagnostico_servicio('2020202020', 'OS26-00000024', 1,
    '{"sintomas": ["testigo de cambio de aceite encendido"], "hallazgos": "Aceite degradado y filtro saturado", "recomendaciones": ["proximo cambio en 5000 km"]}');
SELECT SV_TECNICO.up_detalle_servicio('2020202020', 'OS26-00000024', 1, 'F', 1.5);
SELECT SV_TECNICO.up_servicio('2020202020', 'OS26-00000024', 'F');
SELECT SV_TECNICO.co_valorTotalServicio('2020202020', 'OS26-00000024');
SELECT  s.numero, s.estado AS estadoOrden, s.fecha_fin AS finOrden,
        d.item, d.estado AS estadoDetalle, d.fecha_fin AS finDetalle,
        d.tecnico, d.horas_trabajadas, d.valor_cobrado,
        d.diagnostico ->> 'hallazgos' AS hallazgos
FROM SERVICIOS s
JOIN DETALLE_ORDENES d ON d.servicio = s.numero
WHERE s.numero = 'OS26-00000024';

ROLLBACK;



/*
Laura Moreno, la gerente de la Sede Sur, revisa los repuestos por agotarse y ve que le quedan
pocas pastillas de freno. Decide hacerle un pedido a Frenos Ya LTDA. Mientras arma la compra
intenta incluir filtros de aceite sin decir el precio, pero no hay un precio de referencia de
Frenos Ya para ese repuesto. Luego corrige la
cantidad de pastillas y el precio que le dieron por telefono. Jorge, un tecnico de la sede,
intenta cambiar la cantidad de la compra y el sistema no lo deja, solo la gerente la modifica.
*/
BEGIN;

-- Paso 1 : Laura consulta los repuestos por agotarse de su sede y abre una compra
--      a "Frenos Ya LTDA". Queda con el numero consecutivo, la fecha de hoy y en la sede de Laura (S02).
SELECT SV_GERENTE.co_repuestosPorAgotarseSede('8080808080');
FETCH ALL IN "co_porAgotarse";
CLOSE "co_porAgotarse";
SELECT SV_GERENTE.ad_compra('8080808080', '900654321');
SELECT * FROM COMPRAS WHERE numero = 'C000000012';

-- Paso 2 : Laura agrega 12 pastillas de freno (R002) sin indicar precio
--      y se toma el precio de referencia del proveedor (45000). Luego intenta agregar filtros
--      de aceite (R001) sin precio. "Frenos Ya" no tiene precio de referencia para ese repuesto
--      y el sistema le pide indicarlo.
SELECT SV_GERENTE.ad_detalle_compra('8080808080', 'C000000012', 'R002', 12, NULL);
DO $$
BEGIN
    PERFORM SV_GERENTE.ad_detalle_compra('8080808080', 'C000000012', 'R001', 5, NULL);
    RAISE NOTICE 'FALLA LA PRUEBA: se agrego un detalle sin precio';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 3 : Laura se equivoca y deja la cantidad en cero el sistema
--      lo rechaza. Luego la corrige a 10 unidades a 44000 cada una.
DO $$
BEGIN
    PERFORM SV_GERENTE.up_detalle_compra('8080808080', 'C000000012', 'R002', 0, NULL);
    RAISE NOTICE 'FALLA LA PRUEBA: se acepto una cantidad de cero';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;
SELECT SV_GERENTE.up_detalle_compra('8080808080', 'C000000012', 'R002', 10, 44000);

-- Paso 4 : Jorge, tecnico de la Sede Sur, intenta subir la cantidad de la compra
--      y el sistema lo rechaza: las compras solo las modifica la gerente.
DO $$
BEGIN
    PERFORM SV_COMPRAS.up_detalle('6060606060', 'C000000012', 'R002', 50, NULL);
    RAISE NOTICE 'FALLA LA PRUEBA: un tecnico modifico una compra';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Rechazado como se esperaba: %', SQLERRM;
END;
$$;

-- Paso 5 : Laura verifica que la compra quedo bien: un solo detalle de 10 pastillas
--      a 44000, valor total de 440000, y las pastillas disponibles en su sede aumentaron en 10.
SELECT  c.numero, c.fecha, c.sede, c.proveedor,
        dc.repuesto, dc.cantidad, dc.precio_unidad
FROM COMPRAS c
JOIN DETALLE_COMPRAS dc ON dc.compra = c.numero
WHERE c.numero = 'C000000012';
SELECT SV_GERENTE.co_valorTotalCompra('8080808080', 'C000000012');
SELECT SV_GERENTE.co_repuestosPorAgotarseSede('8080808080');
FETCH ALL IN "co_porAgotarse";

ROLLBACK;
