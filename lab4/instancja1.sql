-----Mirroring Oscar Teeninga INSTANCJA 1-----
-- Laboratoria 1
IF NOT EXISTS (
  SELECT name
  FROM sys.databases
  WHERE name = 'sampleDBOscarTeeninga'
)
CREATE DATABASE sampleDBOscarTeeninga;
GO

USE sampleDBOscarTeeninga;
GO

IF OBJECT_ID('dbo.sampleTab', 'U') IS NOT NULL
  DROP TABLE sampleTab;
GO

CREATE TABLE sampleTab (
	id int PRIMARY KEY IDENTITY,
	val int NOT NULL
);
GO

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 30)
	INSERT INTO sampleTab (val)
	VALUES (30);

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 8)
	INSERT INTO sampleTab (val)
	VALUES (8);

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 1998)
	INSERT INTO sampleTab (val)
	VALUES (1998);

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 44)
	INSERT INTO sampleTab (val)
	VALUES (44);

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 2115)
	INSERT INTO sampleTab (val)
	VALUES (2115);
GO

ALTER DATABASE sampleDBOscarTeeninga SET RECOVERY FULL;
GO

BACKUP DATABASE sampleDBOscarTeeninga to DISK = 'C:\bd3\sampleDBOscarTeeninga.bak';
BACKUP LOG sampleDBOscarTeeninga to DISK = 'C:\bd3\sampleDBOscarTeeningaLog.bak';
GO

-- Laboratoria 2
USE master;
GO

IF EXISTS ( SELECT * FROM sys.tcp_endpoints WHERE name = 'Endpoint_PrincipalOscarTeeninga')
DROP ENDPOINT Endpoint_PrincipalOscarTeeninga;
CREATE ENDPOINT Endpoint_PrincipalOscarTeeninga
STATE = STARTED
AS TCP (LISTENER_PORT = 7022)
FOR DATABASE_MIRRORING
(
    ROLE = PARTNER
);
GO

SELECT name, protocol_desc, type_desc, state_desc FROM sys.database_mirroring_endpoints;
GO

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER OFF;
GO
ALTER DATABASE sampleDBOscarTeeninga SET PARTNER = 'TCP://127.0.0.1:7023';
GO

SELECT SYSDB.name,
 CASE
	WHEN EXISTS(SELECT * FROM sys.database_mirroring_endpoints WHERE name = 'Endpoint_PrincipalOscarTeeninga' AND state_desc = 'STARTED') THEN 'Mirroring is On'
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

--Laboratoria 3

USE sampleDBOscarTeeninga;
GO

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 23)
	INSERT INTO sampleTab (val)
	VALUES (23);

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 24)
	INSERT INTO sampleTab (val)
	VALUES (24);

SELECT * FROM sampleTab
GO

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER SUSPEND;
GO

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER RESUME;
GO

USE master

ALTER DATABASE sampleDBOscarTeeninga SET PARTNER FAILOVER;
GO

-- Laboratoria 4
ALTER DATABASE sampleDBOscarTeeninga   
  SET WITNESS = 'TCP://127.0.0.1:7024'


IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 57)
	INSERT INTO sampleTab (val)
	VALUES (57);

IF NOT EXISTS (SELECT * FROM sampleTab WHERE val = 113)
	INSERT INTO sampleTab (val)
	VALUES (113);

SELECT * from sampleTab