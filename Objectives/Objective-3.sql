-- ============================================================
-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS
-- ============================================================
USE hospital;

-- 1. How many unique patients were admitted each quarter over time?
Select 
	year(start) as year,
	Quarter(start) as quarter,
	count(distinct patient) as patients_count
from encounters
group by 1, 2 
order by year,quarter;   
-- Finding: unique patients per quarter roughly tracks overall encounter volume, growing from
-- ~150-160/quarter in 2011 to 250+ by 2013 as the patient base expanded.

-- 2. How many patients were readmitted within 30 days of a previous encounter?
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
-- Finding: 773 distinct patients had at least one 30-day readmission, totaling 17,346 readmission
-- events. This counts any encounter type (ambulatory/wellness included), so the high event count
-- mostly reflects frequent routine follow-ups, not just hospital readmissions.


-- 3. Which patients had the most readmissions? (top 10)
with ordered as (
    select
        patient,
        start,
        lag(stop) over (partition by patient order by start) as prev_stop
    from encounters
)
Select
    p.id as patient_id,
    p.first,
    p.last,
    count(*) as readmission_count
from ordered o
join patients p ON o.patient = p.id
where o.prev_stop is not null
group by p.id, p.first, p.last
order by readmission_count DESC
limit 10;
-- Finding: top patient (Kimberly627 Collier206) has 1,380 readmission events - likely someone with
-- very frequent recurring visits (e.g. chronic condition management) rather than a genuine
-- hospital-readmission pattern.

-- 4. How many patients had only a single encounter ever (one-time patients), and what share of the total patient base does that represent?
with patient_count as(
	Select patient , count(*) as n
	from encounters
	group by patient
)
Select sum(case When n=1 then 1 else 0 end) as one_time_patients,
count(*) as total_patients,
Round(sum(case When n=1 then 1 else 0 end)/count(*)*100,2) as pct_one_time
from patient_count;
-- Finding: only 12.3% of patients (120 of 974) had just a single encounter ever - the large
-- majority are repeat/ongoing patients, reinforcing the chronic-care-heavy profile of this
-- population.
 
 -- 5. What does the distribution of patients look like by total encounter count (e.g., 1, 2–5, 6–10, 10+ encounters)
 with patient_counts as (
    Select patient, count(*) as n
    from encounters
    group by patient
)
select
    Case When n = 1 Then '1'
         When n Between 2 And 5 Then '2-5'
         When n Between 6 And 10 Then '6-10'
         Else '10+' End as encounter_count_bucket,
    count(*) as patients
from patient_counts
group by encounter_count_bucket
order by MIN(n);
-- Finding: 554 of 974 patients (57%) fall in the "10+" encounter bucket - the patient base
-- skews heavily toward high-utilization/chronic patients rather than occasional visitors.

		

 