select DateKey  , Date  , DayOfWeek  , DayName  , DayOfMonth  , DayOfYear  , WeekOfYear  , MonthName  , MonthOfYear,Quarter,QuarterName,Year,IsAWeekday 
into [dbo].[DimDate] 
from [BikeDW].[dbo].[DimDate] 

create table DimSearchTren(
DateKey  int IDENTITY NOT NULL
	-- attributes
, 	Date  datetime   NOT NULL
,  	Cold  float NOT NULL
,  	Flu  float NOT NULL
,  	pneumonia  float NOT NULL
,	Coronavirus float NOT NULL

	-- metadata
,  	RowIsCurrent  bit DEFAULT 1 NOT NULL
,  	RowStartDate  datetime DEFAULT '12/31/1899' NOT NULL
,  	RowEndDate  datetime DEFAULT '12/31/9999' NOT NULL
,  	RowChangeReason  nvarchar(200) NULL
, CONSTRAINT DimSearchTrend PRIMARY KEY (DateKey)
)

create table DimSearcTren(
DateKey  int IDENTITY NOT NULL
	-- attributes
, 	Date  datetime   NOT NULL
,	year int	NOT NULL
,  	Cold  float NOT NULL
,  	Flu  float NOT NULL
,  	pneumonia  float NOT NULL
,	Coronavirus float NOT NULL

	-- metadata
,  	RowIsCurrent  bit DEFAULT 1 NOT NULL
,  	RowStartDate  datetime DEFAULT '12/31/1899' NOT NULL
,  	RowEndDate  datetime DEFAULT '12/31/9999' NOT NULL
,  	RowChangeReason  nvarchar(200) NULL
, CONSTRAINT DimSearcTrend PRIMARY KEY (DateKey)
)

create table DimPatiRou(
	PatientKey  int IDENTITY NOT NULL
	-- attributes
, 	PatientID float   NOT NULL
,	Date nvarchar(255)	NOT NULL
,  	Code_city  float NOT NULL
,  	type  nvarchar(255) NOT NULL


	-- metadata
,  	RowIsCurrent  bit DEFAULT 1 NOT NULL
,  	RowStartDate  datetime DEFAULT '12/31/1899' NOT NULL
,  	RowEndDate  datetime DEFAULT '12/31/9999' NOT NULL
,  	RowChangeReason  nvarchar(200) NULL
, CONSTRAINT DimPatiRoute PRIMARY KEY (PatientKey)
)

create table DimRegio(
	CodeKey  int IDENTITY NOT NULL
	-- attributes
, 	Code int   NOT NULL
,	province nvarchar(255)	NOT NULL
,  	city  nvarchar(255) NOT NULL



	-- metadata
,  	RowIsCurrent  bit DEFAULT 1 NOT NULL
,  	RowStartDate  datetime DEFAULT '12/31/1899' NOT NULL
,  	RowEndDate  datetime DEFAULT '12/31/9999' NOT NULL
,  	RowChangeReason  nvarchar(200) NULL
, CONSTRAINT DimRegion PRIMARY KEY (CodeKey)
)

create table FactSearTrend(
	Year int NOT NULL
	-- measures
	,  	Cold  float NOT NULL
,  	Flu  float NOT NULL
,  	Pneumonia  float NOT NULL
,	Coronavirus float NOT NULL
, 	CONSTRAINT PK_FactSearTrend PRIMARY KEY (Year)

)

create table FactSeaTrend(
	Year int NOT NULL
	-- measures
	,  	Cold  float NOT NULL
,  	Flu  float NOT NULL
,  	Pneumonia  float NOT NULL
,	Coronavirus float NOT NULL
, 	CONSTRAINT PK_FactSeaTrend PRIMARY KEY (Year)

)

create table FactRIA(
	PatientKey INT NOT NULL
,	CodeKey	int NOT NULL
	-- measures
,  	City_Infect  float NOT NULL
,  	Type_Infect  float NOT NULL

,	CONSTRAINT FK_CodeKey FOREIGN KEY (CodeKey) REFERENCES DimRegio(CodeKey)
,	CONSTRAINT FK_PatientKey FOREIGN KEY (PatientKey) REFERENCES DimPatiRou(PatientKey))

CREATE TABLE [dbo].[DimPatient](
	[patient_id] [float] primary key not NULL,
	[sex] [nvarchar](255) NULL,
	[birth_year] [float] NULL,
	[age] [nvarchar](255) NULL,
	[country] [nvarchar](255) NULL,
	[code_city] [float] NULL,
	[infected_by] [float] NULL,
	[infected_case_id] [float] NULL,
	[contact_number] [float] NULL,
	[confirmed_date] [datetime] NULL,
	[released_date] [datetime] NULL,
	[deceased_date] [varchar](50)NULL,
	[state] [nvarchar](255) NULL
	,  	RowIsCurrent  bit DEFAULT 1 NOT NULL
,  	RowStartDate  datetime DEFAULT '12/31/1899' NOT NULL
,  	RowEndDate  datetime DEFAULT '12/31/9999' NOT NULL
,  	RowChangeReason  nvarchar(200) NULL
) 

CREATE TABLE [dbo].[DimCase](
[case_id] [float] NULL,
	[group] [bit] NOT NULL,
	[infection_case] [nvarchar](255) NULL
	,  	RowIsCurrent  bit DEFAULT 1 NOT NULL
,  	RowStartDate  datetime DEFAULT '12/31/1899' NOT NULL
,  	RowEndDate  datetime DEFAULT '12/31/9999' NOT NULL
,  	RowChangeReason  nvarchar(200) NULL)

CREATE TABLE [dbo].[DimPatientRoute](
	[Patient_RKey] int identity not null,
	[patient_id] [float] NULL,
	[date] [datetime] NULL,
	[code_city] [float] NULL,
	[type] [nvarchar](255) NULL
	,  	RowIsCurrent  bit DEFAULT 1 NOT NULL
,  	RowStartDate  datetime DEFAULT '12/31/1899' NOT NULL
,  	RowEndDate  datetime DEFAULT '12/31/9999' NOT NULL
,  	RowChangeReason  nvarchar(200) NULL)

CREATE TABLE [dbo].[DimRegion](
[code] [float] primary key not  NULL,
	[province] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL)


Create table FactPatientInf
(
[patient_id] [float] not null,
--[date key] [float] not null,
[code] [float] not null,
[confirmed_datekey] [float] ,
[released_datekey] [float] ,
[sex] nvarchar(255),
[age] nvarchar(255),
[city] nvarchar(255),
[contact_number] float,
TimeReleased [float] ,
CONSTRAINT PatientKey PRIMARY KEY ([patient_id],[code])
)

insert into FactPatientInf
([patient_id],
[code] ,
[confirmed_datekey]  ,
[released_datekey],
[sex],[age],[city],
[contact_number],
TimeReleased)
select s.patient_id, c.code, 
Day(s.confirmed_date) + MONTH(s.confirmed_date) * 100 + YEAR(s.confirmed_date) * 10000 As
confirmed_datekey,
case when s.released_date is null then null
else Day(s.released_date) + MONTH(s.released_date) * 100 + YEAR(s.released_date) *
10000
end as released_datekey,s.sex,s.age,C.city,s.contact_number,
  DATEDIFF(day,confirmed_date,released_date) 
from DimPatient s
join CovidDW.dbo.DimRegion c
on s.code_city = c.code

Create table FactProvince
(
--[patient_id] [float] not null,
[code] [float] not null,
[city] nvarchar(255),
Total_confirmed [float],
Total_released [float],
Total_desceased [float],
CONSTRAINT ProvinceKey PRIMARY KEY ([code])
)

Create table FactCase
(
[case_id] [float] not null,
[infection_case] nvarchar(255),
Numbner_ofPatient [float],

CONSTRAINT CaseKey PRIMARY KEY ([case_id])
)

