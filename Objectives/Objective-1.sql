-- ============================================================
-- OBJECTIVE 1: ENCOUNTERS OVERVIEW
-- ============================================================
USE hospital;

-- 1. How many total encounters occurred each year?

Select 
	year(start) as Year,
	count(*) as Total_encounters
from encounters
group by 1
order by Year;
-- Finding: volume grew from ~1,336 (2011) to a peak of ~3,885 (2014), then held around 2,200-2,500/year.
-- 2022 is a partial year (only 220 records), exclude from trend comparisons.


-- 2. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?

with class as (Select 
		year(start) as encounter_year,
		sum( Case when encounterclass = 'ambulatory' then 1 else 0 end) as Ambulatory,
		sum(Case when encounterclass = 'outpatient' then 1 else 0 end ) as Outpatient,
		sum( Case when encounterclass = 'wellness' then 1 else 0 end) as Wellness,
		Sum(Case When encounterclass = 'urgentcare' then 1 else 0 end) as Urgent_Care,
		Sum(case when encounterclass = 'emergency' then 1 else 0 end) as Emergency,
		Sum(Case When encounterclass = 'inpatient' then 1 else 0 end ) as Inpatient,
		count(*) as Total_encounters
from encounters
group by 1
order by encounter_year)

(Select encounter_year ,
concat(Ambulatory,' ( ',round((Ambulatory/total_encounters)*100,2),'%)') as Ambulatory,
Concat(Outpatient,' ( ',round((Outpatient/total_encounters)*100,2),'%)') as Outpatient,
concat(Wellness,' ( ', round((Wellness/total_encounters)*100,2),'%)') as Wellness,
concat(Urgent_Care,' ( ',round((Urgent_Care/total_encounters)*100,2),'%)') as Urgent_Care,
concat(Emergency,' ( ',round((Emergency/total_encounters)*100,2),'%)') as Emergency,
concat(Inpatient,' ( ',round((Inpatient/total_encounters)*100,2),'%)') as Inpatient
from class )
union all
Select 'Total' as Years,
Concat(sum(Ambulatory),   ' ( ' , round((sum(Ambulatory)  /sum(total_encounters))*100,2),'%)') as Ambulatory,
Concat(sum(Outpatient),   ' ( ' , round((sum(Outpatient) /sum(total_encounters))*100,2),'%)')  as Outpatient,
Concat(sum(Wellness),     ' ( ' , round((sum(Wellness)    /sum(total_encounters))*100,2),'%)')  as Wellness,
Concat(sum(Urgent_Care) , ' ( ' , round((sum(Urgent_Care) /sum(total_encounters))*100,2),'%)')  as  Urgent_Care,
Concat(sum(Emergency),    ' ( ' , round((sum(Emergency)   /sum(total_encounters))*100,2),'%)')   as Emergency,
Concat(sum(Inpatient),    ' ( ' , round((sum(Inpatient)   /sum(total_encounters))*100,2),'%)')  as Inpatient
from class;
-- Finding: ambulatory share climbed from ~50% (2011) to over 60% by 2014 and has stayed dominant since,
-- mostly displacing outpatient, which fell from ~24% to under 15%.


-- 3. What percentage of encounters were over 24 hours versus under 24 hours?

(Select 
	'count' AS metric,
	sum(Case when timestampdiff(minute,start,stop) >= 1440 then 1 else 0 end) as over_24_hours,
	sum(Case when timestampdiff(minute,start,stop) < 1440 then 1 else 0 end) as under_24_hours
from encounters)
union all
(Select 
	'percentage',
	concat(round((sum(Case when timestampdiff(minute,start,stop) >= 1440 then 1 else 0 end)/count(*))*100,2),' %')  as over_24_hours,
	concat(round((sum(Case when timestampdiff(minute,start,stop) < 1440 then 1 else 0 end)/count(*))*100,2),' %') as under_24_hours
from encounters
) ;
-- Finding: 95.87% of encounters are same-day (<24h); genuinely extended stays are rare (4.13%),
-- consistent with an ambulatory/wellness-heavy population.
