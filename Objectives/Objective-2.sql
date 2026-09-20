-- ============================================================
-- OBJECTIVE 2: COST & COVERAGE INSIGHTS
-- ============================================================
USE hospital;

-- 1. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
select 
	sum(case when payer_coverage =0 then 1 else 0 end ) as zero_coverage_count,
	concat(round((sum(case when payer_coverage =0 then 1 else 0 end )/count(*))*100,2),' %') as percentage
from encounters;
-- Finding: ~48.7% (13586) of encounters had $0 payer coverage, largely driven by uninsured patients.

-- 2. What is the total claim cost generated per year, and how much of that was actually covered by payers vs. left as patient responsibility?
Select Year(start) as year , 
	   round(sum(Total_claim_cost),2) as Total_clam_cost,
       round(sum(payer_coverage),2) as Total_payer_covered,
       round(sum(Total_claim_cost) - sum(payer_coverage),2) as patient_responsibility
from encounters
group by year
order by year;
-- Finding: patient responsibility consistently makes up roughly 60-70% of total claim cost
-- every year (e.g. 2014: $8.46M of $12.01M total) - payers are covering well under half of
-- billed cost across the board, not just in edge cases.

-- 3. What are the top 10 most frequent procedures performed and the average base cost for each?
Select 	Description,
		count(*) as cnt,
		avg(base_cost) as Avg_Base_Cost
from procedures
group by 1
order by cnt desc
limit 10;
-- Finding: high-frequency procedures are routine assessments/screenings, clustered around $431 avg cost.

-- 4. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
Select 	Description,
		round(avg(base_cost),2) as Avg_base_cost,
		count(*) as cnt
from procedures
group by 1
order by Avg_base_cost desc
limit 10;
-- Finding: top costs are rare, high-acuity procedures (ICU admit ~$206K, CABG ~$47K), each performed <10 times -
-- worth noting these are outliers, not typical spend.

-- 5. What is the average total claim cost for encounters, broken down by payer?
Select en.payer as Payer_id , py.Name , round(AVG(en.Total_claim_cost),2) as average_claim_cost
from encounters en 
Join payers py on en.payer = py.Id
group by 1,2
order by average_claim_cost desc;
-- Finding: Medicaid and self-pay (no insurance) patients carry the highest average claim cost per encounter,
-- while Medicare/managed-care payers trend lower.
