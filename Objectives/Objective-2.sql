USE Hospital;

-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
select 
sum(case when payer_coverage =0 then 1 else 0 end ) as zero_coverage_count,
concat(round((sum(case when payer_coverage =0 then 1 else 0 end )/count(*))*100,2),' %') as percentage
from encounters;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?

Select 	Description,
		count(*) as cnt,
		avg(base_cost) as Avg_Base_Cost
from procedures
group by 1
order by cnt desc
limit 10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

Select 	Description,
		round(avg(base_cost),2) as Avg_base_cost,
		count(*) as cnt
from procedures
group by 1
order by Avg_base_cost desc
limit 10;

-- d. What is the average total claim cost for encounters, broken down by payer?

Select en.payer as Payer_id , py.Name , round(AVG(en.Total_claim_cost),2) as average_claim_cost
from encounters en 
Join payers py on en.payer = py.Id
group by 1,2
order by average_claim_cost desc;

