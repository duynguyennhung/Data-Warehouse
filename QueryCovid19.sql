select *
into [dbo].[StageCase]
from [Covid_19].[dbo].Case$

select *
into [dbo].[StagePatient]
from [Covid_19].[dbo].Patientnew

select *
into [dbo].[StagePatientRoute]
from [Covid_19].[dbo].PatientRouteCodecity$

select *
into [dbo].[StageRegion]
from [Covid_19].[dbo].Region$


select min(confirmed_date) As StartOrderDate
, max(confirmed_date) As EndOrderDate
, min(released_date) As StartShippedDate
, min(released_date) As EndShippedDate
from [Covid_19].[dbo].Patientnew$

select * into StageDate
from [Covid_19].[dbo].['2019-2020-covid19 (1)$']

use CovidDW

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
) 

CREATE TABLE [dbo].[DimCase](
[case_id] [float] NULL,
	[group] [bit] NOT NULL,
	[infection_case] [nvarchar](255) NULL)
 --CONSTRAINT [PK_case1] FOREIGN KEY (case_id)
 --  REFERENCES DimPatient ()	

CREATE TABLE [dbo].[DimPatientRoute](
	[Patient_RKey] int identity not null,
	[patient_id] [float] NULL,
	[date] [datetime] NULL,
	[code_city] [float] NULL,
	[type] [nvarchar](255) NULL)
	--CONSTRAINT PatientRoutePK PRIMARY KEY ([patient_id], [date],[code_city],[type]))
DROp table DimPatientRoute
CREATE TABLE [dbo].[DimRegion](
[code] [float] primary key not  NULL,
	[province] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL)


CREATE TABLE [dbo].[Dimdatecovid](
	[date key] [float] primary key not NULL,
	[full date] [datetime] NULL,
	[day of week] [float] NULL,
	[day num in month] [float] NULL,
	[day num overall] [float] NULL,
	[day name] [nvarchar](255) NULL,
	[day abbrev] [nvarchar](255) NULL,
	[weekday flag] [nvarchar](255) NULL,
	[week num in year] [float] NULL,
	[week num overall] [float] NULL,
	[week begin date] [datetime] NULL,
	[week begin date key] [float] NULL,
	[month] [float] NULL,
	[month num overall] [float] NULL,
	[month name] [nvarchar](255) NULL,
	[month abbrev] [nvarchar](255) NULL,
	[quarter] [float] NULL,
	[year] [float] NULL,
	[yearmo] [float] NULL,
	[fiscal month] [float] NULL,
	[fiscal quarter] [float] NULL,
	[fiscal year] [float] NULL,
	[month end flag] [nvarchar](255) NULL,
	[same day year ago] [datetime] NULL
) 
--drop table Dimdatecovid

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
drop table FactPantientInf
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

insert into FactProvince
(
[code] ,
[city]  ,
Total_confirmed,
Total_released,
Total_desceased)
select code,C.city,
  count(confirmed_date) as Total_confirmed ,
  count(released_date) as Total_released,
  count(deceased_date) as Total_desceased
from DimPatient s
join CovidDW.dbo.DimRegion c
on s.code_city = c.code 
group by c.code,C.city

select *  from DimPatient


Create table FactCase
(
[case_id] [float] not null,
[infection_case] nvarchar(255),
Numbner_ofPatient [float],

CONSTRAINT CaseKey PRIMARY KEY ([case_id])
)

insert into FactCase
([case_id],
[infection_case],
Numbner_ofPatient)
select c.case_id, c.infection_case,
	count(s.patient_id) as Numbner_ofPatient
from DimPatient s
join CovidDW.dbo.DimCase c
on s.infected_case_id = c.case_id 
group by c.case_id, c.infection_case


Create table FactRIA
(
type_route nvarchar(255) not null,
Type_Infect float not null
)

insert into FactRIA
(
type,
Type_Infect
)
select type,
	count(patient_id) as Type_Infect
from dbo.DimPatientRoute
group by type





select COUNT(deceased_date)
from DimPatient

insert into DimPatient
([patient_id],
	[sex] ,
	[birth_year] ,
	[age]  ,
	[country]  ,
	[code_city]  ,
	[infected_by]  ,
	[infected_case_id]  ,
	[contact_number]  ,
	[confirmed_date]  ,
	[released_date]  ,
	[deceased_date]  ,
	[state]  )
select
 [patient_id],
	[sex] ,
	[birth_year] ,
	[age]  ,
	[country]  ,
	[code_city]  ,
	[infected_by]  ,
	[infected_case_id]  ,
	[contact_number]  ,
	[confirmed_date]  ,
	[released_date]  ,
	[deceased_date]  ,
	[state]  
from StageCovid.dbo.StagePatient



insert into DimPatientRoute
([patient_id]  ,
	[date]  ,
	[code_city]  ,
	[type] )
select
[patient_id]  ,
	[date]  ,
	[code_city]  ,
	[type]
from StageCovid.dbo.StagePatientRoute

insert into DimRegion
([code],
	[province],
	[city])
select [code],
	[province],
	[city]
from  StageCovid.dbo.StageRegion

insert into DimCase
([case_id] ,
	[group],
	[infection_case])
select
[case_id] ,
	[group],
	[infection_case]
from  StageCovid.dbo.StageCase

insert into Dimdatecovid
([date key],
	[full date] ,
	[day of week] ,
	[day num in month] ,
	[day num overall] ,
	[day name],
	[day abbrev],
	[weekday flag] ,
	[week num in year],
	[week num overall] ,
	[week begin date] ,
	[week begin date key],
	[month] ,
	[month num overall],
	[month name] ,
	[month abbrev] ,
	[quarter] ,
	[year] ,
	[yearmo],
	[fiscal month] ,
	[fiscal quarter] ,
	[fiscal year] ,
	[month end flag],
	[same day year ago])
select 
[date key],
	[full date] ,
	[day of week] ,
	[day num in month] ,
	[day num overall] ,
	[day name],
	[day abbrev],
	[weekday flag] ,
	[week num in year],
	[week num overall] ,
	[week begin date] ,
	[week begin date key],
	[month] ,
	[month num overall],
	[month name] ,
	[month abbrev] ,
	[quarter] ,
	[year] ,
	[yearmo],
	[fiscal month] ,
	[fiscal quarter] ,
	[fiscal year] ,
	[month end flag],
	[same day year ago]
from StageCovid.dbo.StageDate



use Covid_19


select sum(dayy)/(select COUNT(patient_id) from Patientnew$ where released_date is not null) as timeavg
from (select DATEDIFF(day,confirmed_date,released_date) as dayy
		from Patientnew$
		where released_date is not null) a 

select max(dayy) , min(dayy)
from (select DATEDIFF(day,confirmed_date,released_date) as dayy
		from Patientnew$
		where released_date is not null) a
