-- Lab - Loading data into a table - COPY Command - CSV

-- Never use the admin account for load operations.
-- Create a seperate user for load operations


-- This has to be run in the master database
CREATE LOGIN user_load WITH PASSWORD = 'Passw0rd123#';

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

-- Drop the external table if it exists
DROP EXTERNAL TABLE logdata

-- Create a normal table
-- Login as the new user and create the table
-- Here I have added more constraints when it comes to the width of the data type

CREATE TABLE [logdata]
(
    [Id] [int] ,
	[Correlationid] [varchar](200) ,
	[Operationname] [varchar](200) ,
	[Status] [varchar](100) ,
	[Eventcategory] [varchar](100) ,
	[Level] [varchar](100) ,
	[Time] [datetime] ,
	[Subscription] [varchar](200) ,
	[Eventinitiatedby] [varchar](1000) ,
	[Resourcetype] [varchar](1000) ,
	[Resourcegroup] [varchar](1000) 
)

-- Grant the required privileges to the new user

GRANT INSERT ON logdata TO user_load;
GRANT SELECT ON logdata TO user_load;



SELECT * FROM [logdata]

-- Here there is no authentication/authorization, so you need to allow public access for the container
COPY INTO logdata FROM 'https://devrajclass1.blob.core.windows.net/data1/input/Log.csv'
WITH
(
FIRSTROW=2
)




