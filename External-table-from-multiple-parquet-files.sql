-- Step 1: Create External Data Source (public blob, so no credential needed)
CREATE EXTERNAL DATA SOURCE AzureBlobStorageLogs
WITH (
    LOCATION = 'https://sbstorage3045.blob.core.windows.net/sbcontainer/input/input_ac/'
);

-- Step 2: Create External File Format
CREATE EXTERNAL FILE FORMAT ParquetFileFormat
WITH (
    FORMAT_TYPE = PARQUET
);

-- Step 3: Create External Table
CREATE EXTERNAL TABLE dbo.ActivityLogsExternal
[Correlationid] varchar(200),
   [Operationname] varchar(300),
   [Status] varchar(100),
   [Eventcategory] varchar(100),
   [Level] varchar(100),
   [Time] varchar(100),
   [Subscription] varchar(200),
   [Eventinitiatedby] varchar(1000),
   [Resourcetype] varchar(300),
   [Resourcegroup] varchar(1000),
   [Resource] varchar(2000))
WITH (
    LOCATION = '/',
    DATA_SOURCE = AzureBlobStorageLogs,
    FILE_FORMAT = ParquetFileFormat
);
