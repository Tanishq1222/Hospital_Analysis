USE hospital;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?

Select 
	year(start) as year,
	Quarter(start) as quarter,
	count(distinct patient) as patients_count
from encounters
group by 1, 2 
order by year,quarter;   

-- b. How many patients were readmitted within 30 days of a previous encounter?
with cte as(Select 
patient,
start,stop,
Lag(stop) over (partition by patient order by start) as previous
from encounters
)

Select 	count(*) as readmision_events,
		count(distinct patient) as readmisiion_patients
from cte
where previous is not null and 
datediff(start,previous) <=30;

-- c. Which patients had the most readmissions? 
with cte as(Select 
patient,
start,stop,
Lag(stop) over (partition by patient order by start) as previous
from encounters
)

Select patient,
	count(*) readmission
from cte
group by 1
order by readmission desc