**Diabetes Hospital Encounters – SQL Exploratory Data Analysis (EDA)**

This project analyzes over 100,000+ hospital encounters from diabetic patients across 130 U.S. hospitals.
Using PostgreSQL, I designed a full database schema, engineered new features, and wrote analytical SQL queries to explore readmissions, length of stay, diagnoses, and medication usage.

---

**This project demonstrates skills used in:**

-Healthcare analytics

-Public health informatics

-SQL data modeling

-EDA for large medical datasets

-Feature engineering with SQL views

-Query optimization and reporting

---

**Dataset Overview:**

**Source:** Diabetes 130-US hospitals database 

**Rows:** ~100k encounters

**Columns:** 50+ clinical and administrative variables

**Includes:**

-Patient demographics (age, race, gender)

-Admission & discharge details

-Diagnoses (ICD-9 codes)

-Medication changes

-Number of lab procedures

-Readmission status (NO, >30 days, <30 days)

---

**The SQL schema for this project uses a single table called diabetic_data, created with:**

-Appropriate numeric, text, and small-int datatypes

-Double-quoted medication columns containing hyphens

-Support for all categorical values in the dataset

**Full schema available in:**
schema.sql

Feature Engineering (SQL View)

---

**I created a new SQL view called diabetic_data_enriched to simplify analysis and add analytical features.**

**Added fields include:**

-age_group → converts age ranges like “[50-60)” into usable bins

-readmitted_flag → 1 if any readmission

-readmitted_30d_flag → 1 if readmitted within 30 days

-inpatient_flag → 1 if patient has inpatient history

**This view transforms raw data into a more analytics-friendly format using SQL only.**

Full view available in:
view_enriched.sql

---

**Core Analysis Questions:**

All queries are located in:
analysis.sql

**Here are some of the business questions answered:**

**1. How many unique patients and encounters are in the dataset?**

SELECT COUNT(*) AS total_encounters,
       COUNT(DISTINCT patient_nbr) AS unique_patients
FROM diabetic_data;

**2. What is the overall readmission rate?**

SELECT ROUND(AVG(readmitted_flag::NUMERIC) * 100, 2) AS pct_readmitted_any,
       ROUND(AVG(readmitted_30d_flag::NUMERIC) * 100, 2) AS pct_readmitted_30d
FROM diabetic_data_enriched;

**3. Which age groups have the highest 30-day readmission rates?**

SELECT age_group,
       COUNT(*) AS encounters,
       ROUND(AVG(readmitted_30d_flag::NUMERIC) * 100, 2) AS pct_readmitted_30d
FROM diabetic_data_enriched
GROUP BY age_group
ORDER BY age_group;

**4. What diagnoses appear most frequently?**

SELECT diag_1, COUNT(*) AS encounters
FROM diabetic_data_enriched
GROUP BY diag_1
ORDER BY encounters DESC
LIMIT 15;

**5. Which patients have the highest number of encounters?**

SELECT patient_nbr,
       COUNT(*) AS encounter_count
FROM diabetic_data
GROUP BY patient_nbr
HAVING COUNT(*) >= 5
ORDER BY encounter_count DESC
LIMIT 20;

**6. What medications are used most often?**

Includes insights on insulin, metformin, and combination therapies.

**7. Which age groups stay in the hospital the longest?**

Uses average time_in_hospital by age group.

**8️. Window Function Analysis**

**Ranks the top 5 longest stays within each age group:**

RANK() OVER (PARTITION BY age_group ORDER BY time_in_hospital DESC)

---

**Key Insights:**

-Patients aged 70–79 show the highest estimated readmission rates.

-Insulin and metformin were the most frequently used medications.

-Certain discharge types are associated with higher readmission risk.

-“High-utilization” patients (5+ encounters) often present chronic complications.

---

**Skills Demonstrated:**

-SQL data modeling (CREATE TABLE)

-Data transformation (views, CASE statements)

-Analytical SQL (GROUP BY, filters, aggregates)

-Window functions (RANK, PARTITION BY)

-Data cleaning & EDA

-Healthcare analytics

---

**Tools Used:**

-PostgreSQL

-pgAdmin 4

-SQL (CTEs, Views, Window Functions)

-GitHub

---

**How to Reproduce:**

-Run the schema in schema.sql

-Import the dataset (CSV)

-Run view_enriched.sql

-Execute all queries in analysis.sql
