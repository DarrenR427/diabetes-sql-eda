-- Total encounters and unique patients
SELECT
    COUNT(*) AS total_encounters,
    COUNT(DISTINCT patient_nbr) AS unique_patients
FROM diabetic_data;

-- Overall readmission rate (any readmission)
SELECT
    ROUND(AVG(readmitted_flag::NUMERIC) * 100, 2) AS pct_readmitted_any,
    ROUND(AVG(readmitted_30d_flag::NUMERIC) * 100, 2) AS pct_readmitted_within_30d
FROM diabetic_data_enriched;

-- Readmission rates by age group
SELECT
    age_group,
    COUNT(*) AS encounters,
    ROUND(AVG(readmitted_flag::NUMERIC) * 100, 2) AS pct_readmitted_any,
    ROUND(AVG(readmitted_30d_flag::NUMERIC) * 100, 2) AS pct_readmitted_30d
FROM diabetic_data_enriched
GROUP BY age_group
ORDER BY age_group;

-- Readmission by race and gender
SELECT
    race,
    gender,
    COUNT(*) AS encounters,
    ROUND(AVG(readmitted_flag::NUMERIC) * 100, 2) AS pct_readmitted_any,
    ROUND(AVG(readmitted_30d_flag::NUMERIC) * 100, 2) AS pct_readmitted_30d
FROM diabetic_data_enriched
GROUP BY race, gender
ORDER BY race, gender;

-- Average length of stay by age group
SELECT
    age_group,
    ROUND(AVG(time_in_hospital), 2) AS avg_days_in_hospital,
    COUNT(*) AS encounters
FROM diabetic_data_enriched
GROUP BY age_group
ORDER BY age_group;

-- Top 15 primary diagnosis codes (diag_1)
SELECT
    diag_1,
    COUNT(*) AS encounters
FROM diabetic_data_enriched
GROUP BY diag_1
ORDER BY encounters DESC
LIMIT 15;

-- How often are key diabetes meds used?
SELECT
    'insulin' AS med,
    insulin AS change_type,
    COUNT(*) AS encounters
FROM diabetic_data
GROUP BY insulin

UNION ALL

SELECT
    'metformin' AS med,
    metformin AS change_type,
    COUNT(*) AS encounters
FROM diabetic_data
GROUP BY metformin

ORDER BY med, change_type;

-- Patients with the highest number of encounters
SELECT
    patient_nbr,
    COUNT(*) AS encounter_count
FROM diabetic_data
GROUP BY patient_nbr
HAVING COUNT(*) >= 5
ORDER BY encounter_count DESC
LIMIT 20;

-- Top 5 longest stays per age group
SELECT *
FROM (
    SELECT
        encounter_id,
        patient_nbr,
        age_group,
        time_in_hospital,
        RANK() OVER (PARTITION BY age_group ORDER BY time_in_hospital DESC) AS stay_rank
    FROM diabetic_data_enriched
) t
WHERE stay_rank <= 5
ORDER BY age_group, stay_rank;
