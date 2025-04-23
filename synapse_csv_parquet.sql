## SQL Code for Azure Synapse Analytics to Convert CSV to Parquet and Upload to Azure Blob Storage
-- First, create an external file format for the CSV file
CREATE EXTERNAL FILE FORMAT MarketingSalesCsvFormat
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        FIRST_ROW = 2, -- Skip header row
        USE_TYPE_DEFAULT = TRUE
    )
);

-- Create an external data source for your Azure Blob Storage
-- Replace with your actual storage account name and container name
CREATE EXTERNAL DATA SOURCE MarketingSalesBlobStorage
WITH (
    TYPE = HADOOP,
    LOCATION = 'wasbs://<your-container-name>@<your-storage-account-name>.blob.core.windows.net',
    CREDENTIAL = <your-credential-name> -- You'll need to create a database scoped credential first
);

-- Create an external table pointing to your CSV file
CREATE EXTERNAL TABLE MarketingSalesCsvExternal
(
    [Date] DATE,
    [Product] VARCHAR(50),
    [Sales_Amount] DECIMAL(18, 2),
    [Units_Sold] INT,
    [Cost] DECIMAL(18, 2),
    [Profit] DECIMAL(18, 2),
    [Region] VARCHAR(50),
    [Marketing_Spend] DECIMAL(18, 2),
    [Conversion_Rate] DECIMAL(18, 4),
    [Customer_ID] VARCHAR(50),
    [Sales_Target] DECIMAL(18, 2)
)
WITH (
    LOCATION = '/path/to/your/marketing_sales_data_with_extra_columns.csv',
    DATA_SOURCE = MarketingSalesBlobStorage,
    FILE_FORMAT = MarketingSalesCsvFormat
);

-- Create an external file format for Parquet
CREATE EXTERNAL FILE FORMAT MarketingSalesParquetFormat
WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);

-- Create an external table for the Parquet output
CREATE EXTERNAL TABLE MarketingSalesParquetExternal
WITH (
    LOCATION = '/output/path/marketing_sales_data.parquet',
    DATA_SOURCE = MarketingSalesBlobStorage,
    FILE_FORMAT = MarketingSalesParquetFormat
)
AS
SELECT * FROM MarketingSalesCsvExternal;

-- If you prefer to use CETAS (Create External Table As Select) for better performance:
CREATE EXTERNAL TABLE MarketingSalesParquetExternal
WITH (
    LOCATION = '/output/path/marketing_sales_data.parquet',
    DATA_SOURCE = MarketingSalesBlobStorage,
    FILE_FORMAT = MarketingSalesParquetFormat
)
AS
SELECT 
    [Date],
    [Product],
    [Sales_Amount],
    [Units_Sold],
    [Cost],
    [Profit],
    [Region],
    [Marketing_Spend],
    [Conversion_Rate],
    [Customer_ID],
    [Sales_Target]
FROM MarketingSalesCsvExternal;
