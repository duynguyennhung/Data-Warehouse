select date  , cold  , flu  , pneumonia  , coronavirus 
into [dbo].[StageSearchTrend] 
from [COVID19].[dbo].[SearchTrend] 

select year,cold , flu,pneumonia  , coronavirus 
into [dbo].[StageFactSerTren]
from (select YEAR(date) as year,cold , flu,pneumonia  , coronavirus from StageSearchTrend) b

select patient_id , date ,code_city ,type
into [COVIDStage].[dbo].[StageRoute]
from [COVID19].[dbo].[PatientRoute] 

select code ,province ,city
into [COVIDStage].[dbo].[StageRegion]
from [COVID19].[dbo].[Region] 
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




