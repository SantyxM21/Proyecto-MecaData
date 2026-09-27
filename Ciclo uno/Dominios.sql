-- MecaData Dominios
CREATE DOMAIN TPlaca AS VARCHAR(6)
    CHECK (VALUE ~ '^[A-Z]{3}[0-9]{3}$'); -- ABC123

CREATE DOMAIN TCorreo AS VARCHAR(50)
    CHECK (VALUE LIKE ('%@%.%')); -- debe tener @ y . para ser considerad email

CREATE DOMAIN TTelefono AS VARCHAR(15)
    CHECK (VALUE ~ '^[0-9]{7,15}$'); -- solo números, minimo 7 caracteres y maximo 15

CREATE DOMAIN TCargo AS CHAR(1)
    CHECK (VALUE IN ('G','I','T','A')); --

CREATE DOMAIN TEstadoOrden AS CHAR(1)
    CHECK (VALUE IN ('F','E','C'));

CREATE DOMAIN TEstadoGarantia AS CHAR(1)
    CHECK (VALUE IN ('R','X','A','V'));

CREATE DOMAIN TEstadoMovimiento AS CHAR(1)
    CHECK (VALUE IN ('P', 'X'));

CREATE DOMAIN TMedioPago AS CHAR(1)
    CHECK (VALUE IN ('E','B','C','T'));

CREATE DOMAIN TMoneda AS NUMERIC(20,2)
    CHECK (VALUE >= 0); -- valor mayor a 0 y solo 2 decimales

CREATE DOMAIN TNumeroOrden AS VARCHAR(13)
    CHECK (VALUE ~ '^OS[0-9]{2}-[0-9]{8}$'); -- estructura especial para orden eje: OS26-00000001
