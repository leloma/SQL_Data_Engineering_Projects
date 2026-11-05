-- Show each job's salary next to the overall market median

SELECT job_title_short, salary_year_avg,
    (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    ) AS market_median_average
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


--Stage only jobs that are remote before aggregating it to determine the remote median salary per job
SELECT job_title_short, MEDIAN(salary_year_avg) AS median_salary,
    (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    ) AS market_remote_median_average
FROM 
    (
        SELECT job_title_short,salary_year_avg
        FROM job_postings_fact 
        WHERE job_work_from_home = TRUE
    )
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
LIMIT 10;

--Subquery in Having
-- Keep only job titles whose median salary is above the overall median:

SELECT job_title_short, MEDIAN(salary_year_avg) AS median_salary,
    (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    ) AS market_remote_median_average

FROM job_postings_fact 
WHERE job_work_from_home = TRUE
AND salary_year_avg IS NOT NULL
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
LIMIT 10;



-- CTEs
-- Compare how much more (or less) remote roles pay compared to onsit roles for each job title
-- Use a CTE to calculate the median salary by title and work arrangement
WITH work_arrangement_median AS (
SELECT job_title_short, job_work_from_home, MEDIAN(salary_year_avg)::INT median_salary
FROM job_postings_fact
WHERE job_country = 'United States'
GROUP BY
job_title_short, job_work_from_home
)

SELECT r.job_title_short, r.median_salary AS remote_median, o.median_salary AS on_site_median,
(remote_median - on_site_median) AS difference
FROM work_arrangement_median AS r
INNER JOIN work_arrangement_median AS o
ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE 
AND o.job_work_from_home = FALSE
ORDER BY difference DESC;


--WHERE EXISTS
SELECT * FROM range(8) AS src(key)
WHERE NOT EXISTS (
    SELECT 1 from range(5) AS tgt(key)
    WHERE src.key = tgt.key
); 

-- Final example
-- Identify job postings that have no associated skills before loading them into a data mart

SELECT *
FROM job_postings_fact AS jpf
WHERE NOT EXISTS (
    SELECT 1 FROM 
    skills_job_dim AS sjd
    WHERE jpf.job_id = sjd.job_id
)
ORDER BY job_id;