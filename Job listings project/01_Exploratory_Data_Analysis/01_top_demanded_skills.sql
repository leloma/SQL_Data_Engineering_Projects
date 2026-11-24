/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work
*/

--Option 1
SELECT sjd.skill_id, sd.skills ,COUNT(sjd.skill_id),
FROM skills_job_dim sjd
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
INNER JOIN job_postings_fact jpf ON sjd.job_id = jpf.job_id
WHERE jpf.job_work_from_home = TRUE AND jpf.job_title_short = 'Data Engineer'
GROUP BY sjd.skill_id, sd.skills
ORDER BY COUNT(sjd.skill_id) DESC
LIMIT 10;


--Option 2
SELECT sd.skills ,COUNT(jpf.job_id),
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sd.skill_id = sjd.skill_id 
WHERE jpf.job_work_from_home = TRUE AND jpf.job_title_short = 'Data Engineer'
GROUP BY sd.skills
ORDER BY COUNT(sjd.skill_id) DESC
LIMIT 10;


/*
Insights:

- SQL and Python remain the foundational skills for data engineers
- Cloud platforms (AWS, Azure) are critical for modern data engineering
- Big data tools like Spark continue to be highly valued
- Data pipeline tools (Airflow, Snowflake, Databricks) show growing demand
- Java and GCP round out the top 10 most requested skills

 skills   │ count(jpf.job_id) │
│  varchar   │       int64       │
├────────────┼───────────────────┤
│ sql        │             29221 │
│ python     │             28776 │
│ aws        │             17823 │
│ azure      │             14143 │
│ spark      │             12799 │
│ airflow    │              9996 │
│ snowflake  │              8639 │
│ databricks │              8183 │
│ java       │              7267 │
│ gcp        │              6446 │
└────────────┴───────────────────┘

*/
