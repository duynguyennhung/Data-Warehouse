insert into COVIDDW.dbo.DimSearcTren   (Date, Year,Cold, Flu, pneumonia,   Coronavirus) 
select   date  , YEAR(date) ,cold  , flu  , pneumonia  , coronavirus 
from COVIDStage.dbo.StageSearchTrend

insert into COVIDDW.dbo.FactSearTrend(Year,Cold,Flu,Pneumonia,Coronavirus)
select YEAR ,SUM(Cold) as Cold,SUM(Flu) as Flu,SUM(Pneumonia) as Pneumonia,SUM(Coronavirus) as Coronavirus
from [COVIDStage].[dbo].[StageFactSerTren] a
group by YEAR

insert into COVIDDW.dbo.FactSeaTrend(Year,Cold,Flu,Pneumonia,Coronavirus)
select distinct a.Year ,SUM(Cold) as Cold,SUM(Flu) as Flu,SUM(Pneumonia) as Pneumonia,SUM(Coronavirus) as Coronavirus
from DimSearcTren a
group by a.Year

insert into COVIDDW.dbo.FactSeaTrend(Year,Cold,Flu,Pneumonia,Coronavirus)
select distinct a.Year ,SUM(Cold) as Cold,SUM(Flu) as Flu,SUM(Pneumonia) as Pneumonia,SUM(Coronavirus) as Coronavirus
from DimSearcTren a
group by a.Year

insert into COVIDDW.dbo.DimPatiRou   (PatientID, Date,Code_city, type) 
select   patient_id  , date ,code_city  , type 
from COVIDStage.dbo.StageRoute

insert into COVIDDW.dbo.DimRegio   (Code, province,city) 
select   code  , province ,city 
from COVIDStage.dbo.StageRegion

insert into COVIDDW.dbo.FactRIA   (PatientKey, CodeKey,City_Infect,Type_Infect) 
select   b.PatientKey ,a.CodeKey,count(PatientID) 
from COVIDDW.dbo.DimRegio a ,COVIDDW.dbo.DimPatiRou b,(select b.type,count(PatientID) as a from COVIDDW.dbo.DimRegio a,COVIDDW.dbo.DimPatiRou b where a.Code=b.Code_city group by b.type) c,
(select a.province,count(PatientID) as a from COVIDDW.dbo.DimRegio a,COVIDDW.dbo.DimPatiRou b where a.Code=b.Code_city group by a.province)
where a.Code=b.Code_city

select b.type,a.province,count(PatientID),count(PatientID) as a from COVIDDW.dbo.DimRegio a,COVIDDW.dbo.DimPatiRou b where a.Code=b.Code_city group by cube (b.type,a.province)
 
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


