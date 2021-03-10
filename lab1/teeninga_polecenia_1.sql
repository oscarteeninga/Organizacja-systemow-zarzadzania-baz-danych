CREATE DATABASE sampleDBOscarTeeninga;

USE sampleDBOscarTeeninga;

CREATE TABLE sampleTab (
	id int PRIMARY KEY IDENTITY(1,1),
	val int NOT NULL
);

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

ALTER DATABASE sampleDBOscarTeeninga SET RECOVERY FULL;

BACKUP DATABASE sampleDBOscarTeeninga to DISK = 'C:\bd3\sampleDBOscarTeeninga.bak';
BACKUP LOG sampleDBOscarTeeninga to DISK = 'C:\bd3\sampleDBOscarTeeningaLog.bak';

-- Drugi serwer
USE master;

RESTORE FILELISTONLY
FROM DISK = 'C:\bd3\sampleDBOscarTeeninga.bak'
GO

RESTORE DATABASE sampleDBOscarTeeninga
FROM DISK = 'C:\bd3\sampleDBOscarTeeninga.bak'
WITH NORECOVERY, REPLACE, 
MOVE 'sampleDBOscarTeeninga' 
TO 'C:\Program Files\Instance2\MSSQL12.INSTANCE2\MSSQL\DATA\sampleDBOscarTeeninga',
MOVE 'sampleDBOscarTeeninga_log' 
TO 'C:\Program Files\Instance2\MSSQL12.INSTANCE2\MSSQL\DATA\sampleDBOscarTeeninga_log'

RESTORE LOG sampleDBOscarTeeninga
FROM DISK = 'C:\bd3\sampleDBOscarTeeningaLog.bak'
WITH NORECOVERY