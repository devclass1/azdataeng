CREATE LOGIN user_load WITH PASSWORD = 'Azure@123';
CREATE USER user_load FOR LOGIN user_load;
GRANT ADMINISTER DATABASE BULK OPERATIONS TO user_load;
GRANT CREATE TABLE TO user_load;
GRANT ALTER ON SCHEMA::dbo TO user_load;

CREATE WORKLOAD GROUP DataLoads
WITH ( 
    MIN_PERCENTAGE_RESOURCE = 100
    ,CAP_PERCENTAGE_RESOURCE = 100
    ,REQUEST_MIN_RESOURCE_GRANT_PERCENT = 100
    );

CREATE WORKLOAD CLASSIFIER [ELTLogin]
WITH (
        WORKLOAD_GROUP = 'DataLoads'
    ,MEMBERNAME = 'user_load'
);



++++++++++++

DROP TABLE [logdata]



CREATE TABLE [logdata]
(
        [Id] [int] NULL,
	[Correlationid] [varchar](200) NULL,
	[Operationname] [varchar](200) NULL,
	[Status] [varchar](100) NULL,
	[Eventcategory] [varchar](100) NULL,
	[Level] [varchar](100) NULL,
	[Time] [datetime] NULL,
	[Subscription] [varchar](200) NULL,
	[Eventinitiatedby] [varchar](1000) NULL,
	[Resourcetype] [varchar](1000) NULL,
	[Resourcegroup] [varchar](1000) NULL
)

GRANT INSERT ON logdata TO user_load;
GRANT SELECT ON logdata TO user_load;

COPY INTO [logdata] FROM 'https://devrajclass1.blob.core.windows.net/data/parquet/*.parquet'
WITH
(
FILE_TYPE='PARQUET',
CREDENTIAL=(IDENTITY= 'Shared Access Signature', SECRET='sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupx&se=2022-05-03T12:20:45Z&st=2022-05-03T04:20:45Z&spr=https&sig=qVUtlbeL9QuL1QV8IfuQa2kCXLFzTLlKyEB4PSVw1AM%3D')
)

SELECT * FROM [logdata]
