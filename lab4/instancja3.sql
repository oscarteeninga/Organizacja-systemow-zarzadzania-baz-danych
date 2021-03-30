-----Mirroring Oscar Teeninga INSTANCJA 2-----
-- Laboratoria 4
IF EXISTS ( SELECT * FROM sys.tcp_endpoints WHERE name = 'Endpoint_WitnessgOscarTeeninga')
DROP ENDPOINT Endpoint_WitnessgOscarTeeninga
CREATE ENDPOINT Endpoint_WitnessgOscarTeeninga
STATE = STARTED
AS TCP (LISTENER_PORT = 7024)
FOR DATABASE_MIRRORING
(
    ROLE = WITNESS
);
GO

select * from sys.database_mirroring_endpoints
GO