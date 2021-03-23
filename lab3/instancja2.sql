-----Mirroring Oscar Teeninga INSTANCJA 2-----
--Laboratoria 1
USE master;
GO

RESTORE DATABASE sampleDBOscarTeeninga
FROM DISK = 'C:\bd3\sampleDBOscarTeeninga.bak'
WITH NORECOVERY, REPLACE, 
MOVE 'sampleDBOscarTeeninga' 
TO 'C:\Program Files\Instance2\MSSQL12.INSTANCE2\MSSQL\DATA\sampleDBOscarTeeninga',
MOVE 'sampleDBOscarTeeninga_log' 
TO 'C:\Program Files\Instance2\MSSQL12.INSTANCE2\MSSQL\DATA\sampleDBOscarTeeninga_log';
GO

RESTORE LOG sampleDBOscarTeeninga
FROM DISK = 'C:\bd3\sampleDBOscarTeeningaLog.bak'
WITH NORECOVERY;
GO

-- Laboratoria 2
USE master;
GO

IF EXISTS ( SELECT * FROM sys.tcp_endpoints WHERE name = 'Endpoint_MirroringOscarTeeninga')
DROP ENDPOINT Endpoint_MirroringOscarTeeninga
CREATE ENDPOINT Endpoint_MirroringOscarTeeninga
STATE = STARTED
AS TCP (LISTENER_PORT = 7023)
FOR DATABASE_MIRRORING
(
    ROLE = PARTNER
);
GO

SELECT name, protocol_desc, type_desc, state_desc FROM sys.database_mirroring_endpoints;
GO

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER OFF;
GO
ALTER DATABASE sampleDBOscarTeeninga SET PARTNER = 'TCP://127.0.0.1:7022';
GO  

SELECT SYSDB.name,
 CASE
	WHEN EXISTS(SELECT * FROM sys.database_mirroring_endpoints WHERE name = 'Endpoint_MirroringOscarTeeninga' AND state_desc = 'STARTED') THEN 'Mirroring is On'
	ELSE 'Mirroring is Off'
 END as IsMirrorOn,
 SYSMIR.mirroring_state_desc,
 CASE
	WHEN SYSMIR.mirroring_witness_state_desc = 'UNKNOWN' AND SYSMIR.mirroring_safety_level_desc = 'FULL' THEN 'High Safety'
	ELSE 'Unkown safety'
 END as MirrorSafety,
 SYSMIR.mirroring_role_desc,
 SYSMIR.mirroring_partner_instance  
 FROM sys.database_mirroring as SYSMIR
INNER JOIN sys.databases AS SYSDB ON SYSMIR.database_id = SYSDB.database_id
WHERE SYSMIR.database_id = 5;
GO

-- Labolatoria 3
USE sampleDBOscarTeeninga

SELECT * FROM sampleTab
GO

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER SUSPEND;
GO

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER RESUME;
GO

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 2215)
	INSERT INTO sampleTab (val)
	VALUES (2215);

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 4216)
	INSERT INTO sampleTab (val)
	VALUES (4216);

USE master

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER FAILOVER;
GO


