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
(
    [resourceId] NVARCHAR(500),
    [time] DATETIME2,
    [operationName] NVARCHAR(200),
    [category] NVARCHAR(200),
    [resultType] NVARCHAR(100),
    [level] NVARCHAR(100),
    [properties] NVARCHAR(MAX)
)
WITH (
    LOCATION = '/',
    DATA_SOURCE = AzureBlobStorageLogs,
    FILE_FORMAT = ParquetFileFormat
);
