USE [master];
GO

CREATE DATABASE [$(dbname)]
ON PRIMARY
(
   NAME = N'$(dbname)_Data',
   FILENAME = N'$(dbpath)\$(dbname).mdf',
   SIZE = 4MB,
   MAXSIZE = 256MB,
   FILEGROWTH = 64MB
)
LOG ON
(
   NAME = N'$(dbname)_Log',
   FILENAME = N'$(dbpath)\$(dbname)_log.ldf',
   SIZE = 32MB,
   MAXSIZE = 4GB,
   FILEGROWTH = 16MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS;
GO

USE [$(dbname)]
GO

ALTER DATABASE [$(dbname)]
ADD FILEGROUP [IndexData];
GO

ALTER DATABASE [$(dbname)]
ADD FILEGROUP [DimensionData];
GO

ALTER DATABASE [$(dbname)]
ADD FILEGROUP [FactData];
GO

ALTER DATABASE [$(dbname)]
ADD FILE 
(
   NAME = [IndexDataFile], 
   FILENAME = '$(dbpath)\$(dbname)_IndexDataFile.ndf', 
   SIZE = 4MB,
   MAXSIZE = 1GB, 
   FILEGROWTH = 256MB
) TO FILEGROUP [IndexData];
GO

ALTER DATABASE [$(dbname)]
ADD FILE 
(
   NAME = [DimensionDataFile], 
   FILENAME = '$(dbpath)\$(dbname)_DimensionDataFile.ndf', 
   SIZE = 4MB,
   MAXSIZE = 1GB, 
   FILEGROWTH = 256MB
) TO FILEGROUP [DimensionData];
GO

ALTER DATABASE [$(dbname)]
ADD FILE 
(
   NAME = [FactDataFile], 
   FILENAME = '$(dbpath)\$(dbname)_FactDataFile.ndf', 
   SIZE = 4MB,
   MAXSIZE = 1GB, 
   FILEGROWTH = 256MB
) TO FILEGROUP [FactData];
GO

ALTER DATABASE [$(dbname)]
SET ANSI_NULL_DEFAULT ON,
   ANSI_NULLS ON,
   ANSI_PADDING ON,
   ANSI_WARNINGS ON,
   ARITHABORT ON,
   CONCAT_NULL_YIELDS_NULL ON,
   NUMERIC_ROUNDABORT OFF,
   QUOTED_IDENTIFIER OFF,
   RECOVERY SIMPLE,
   AUTO_CLOSE OFF,
   READ_WRITE,
   AUTO_SHRINK OFF,
   RECURSIVE_TRIGGERS OFF,
   CURSOR_CLOSE_ON_COMMIT OFF,
   CURSOR_DEFAULT GLOBAL,
   AUTO_CREATE_STATISTICS ON,
   AUTO_UPDATE_STATISTICS ON,
   TORN_PAGE_DETECTION ON,
   MULTI_USER
GO

-- Make sure first day of week is set to Sunday for this database.
SET DATEFIRST 7;
GO
