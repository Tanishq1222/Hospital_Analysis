-- ================================================================
-- OBJECTIVE 4: PATIENT DEMOGRAPHICS & ACCESS TO CARE
-- ================================================================

-- 1. What is the age distribution of patients at the time of their first encounter (e.g., under 18, 18–40, 41–65, 65+)? 
with first_encounter as (
    Select patient, MIN(start) as first_start
    from encounters
    group by patient
),
age_calc as (
    Select
        fe.patient,
        TIMESTAMPDIFF(YEAR, p.birthdate, fe.first_start) as age_at_first
    from first_encounter fe
    join patients p on fe.patient = p.id
)
Select
    CasE When age_at_first < 18 Then 'Under 18'
         When age_at_first < 41 Then '18-40'
         When age_at_first < 66 Then '41-65'
         ELSE '65+' END as age_group,
    COUNT(*) as patients
from age_calc
group by age_group
Order by MIN(age_at_first);
-- Finding: no patients under 18 at their first recorded encounter (youngest is ~20) 
-- this is an adult-only patient population. 65+ is the largest group (457 of 974, ~47%), 

-- 2. How does average total claim cost differ across gender, race, and ethnicity groups? 
Select p.gender, ROUND(AVG(e.total_claim_cost), 2) as avg_claim_cost, COUNT(*) as encounters
from encounters e join patients p on e.patient = p.id
group by p.gender;

Select p.race, ROUND(AVG(e.total_claim_cost), 2) as avg_claim_cost, COUNT(*) as encounters
from encounters e join patients p on e.patient = p.id
group by p.race
Order by avg_claim_cost DESC;

Select p.ethincity, ROUND(AVG(e.total_claim_cost), 2) as avg_claim_cost, COUNT(*) as encounters
from encounters e join patients p on e.patient = p.id
group by p.ethincity
Order by avg_claim_cost DESC;
-- Finding: average claim cost is notably higher for male patients ($4,085 vs $3,252 female),
-- for patients recorded as Native American ($7,828, though a small sample at 859 encounters)
-- and Black ($5,193), and for Hispanic patients ($6,306 vs $3,109 non-Hispanic) - worth a
-- deeper look at whether this reflects case mix/acuity differences rather than a direct
-- cost disparity, since this is aggregate cost, not cost per condition.

-- 3. Which cities or states have the highest concentration of patients, and how does encounter volume compare across them? 
Select
    p.city,
    p.state,
    COUNT(DISTINCT p.id) as patients,
    COUNT(e.id) as encounters
from patients p
LEFT join encounters e on e.patient = p.id
group by p.city, p.state
Order by patients DESC
LIMIT 10;
-- Finding: Boston accounts for over half the patient base (541 of 974) and the large majority
-- of encounters (15,817) - the dataset is heavily Boston-centered, so any city-level comparison
-- outside Boston will be based on small samples (all other cities have <100 patients each).

-- 4. How does marital status correlate with encounter frequency or encounter class (e.g., do single patients use emergency/urgent care more than married patients)?
with base as (
    Select p.marital, e.encounterclass
    from encounters e
    join patients p on e.patient = p.id
    where p.marital IN ('M', 'S')
),
totals as (
    Select marital, COUNT(*) as total from base group by marital
)
Select
    b.marital,
    b.encounterclass,
    COUNT(*) as n,
    ROUND(100.0 * COUNT(*) / t.total, 2) as pct_within_marital_status
from base b
join totals t on b.marital = t.marital
group by b.marital, b.encounterclass
Order by b.marital, pct_within_marital_status DESC;
-- Finding: contrary to the assumption in the question, married patients ('M') actually show a
-- HIGHER share of emergency (8.8% vs 5.7%) and urgent care (13.9% vs 9.1%) encounters than
-- single patients ('S') - married patients do not use emergency/urgent care less; if anything
-- the opposite is true in this dataset.
