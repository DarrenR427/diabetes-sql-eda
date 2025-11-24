CREATE OR REPLACE VIEW diabetic_data_enriched AS
SELECT
    encounter_id,
    patient_nbr,
    race,
    gender,
    age,
    weight,
    admission_type_id,
    discharge_disposition_id,
    admission_source_id,
    time_in_hospital,
    payer_code,
    medical_specialty,
    num_lab_procedures,
    num_procedures,
    num_medications,
    number_outpatient,
    number_emergency,
    number_inpatient,
    diag_1,
    diag_2,
    diag_3,
    number_diagnoses,
    max_glu_serum,
    A1Cresult,
    metformin,
    repaglinide,
    nateglinide,
    chlorpropamide,
    glimepiride,
    acetohexamide,
    glipizide,
    glyburide,
    tolbutamide,
    pioglitazone,
    rosiglitazone,
    acarbose,
    miglitol,
    troglitazone,
    tolazamide,
    examide,
    citoglipton,
    insulin,
    "glyburide-metformin",
    "glipizide-metformin",
    "glimepiride-pioglitazone",
    "metformin-rosiglitazone",
    "metformin-pioglitazone",
    change,
    diabetesMed,
    readmitted,

    -- Age group from string like "[50-60)"
    CASE
        WHEN age LIKE '[0-10)%' OR age LIKE '[0-10)'  THEN '0–9'
        WHEN age LIKE '[10-20)%' OR age LIKE '[10-20)' THEN '10–19'
        WHEN age LIKE '[20-30)%' OR age LIKE '[20-30)' THEN '20–29'
        WHEN age LIKE '[30-40)%' OR age LIKE '[30-40)' THEN '30–39'
        WHEN age LIKE '[40-50)%' OR age LIKE '[40-50)' THEN '40–49'
        WHEN age LIKE '[50-60)%' OR age LIKE '[50-60)' THEN '50–59'
        WHEN age LIKE '[60-70)%' OR age LIKE '[60-70)' THEN '60–69'
        WHEN age LIKE '[70-80)%' OR age LIKE '[70-80)' THEN '70–79'
        WHEN age LIKE '[80-90)%' OR age LIKE '[80-90)' THEN '80–89'
        WHEN age LIKE '[90-100)%' OR age LIKE '[90-100)' THEN '90–99'
        ELSE 'Unknown'
    END AS age_group,

    -- Any readmission (YES/NO flag)
    CASE
        WHEN readmitted = 'NO' THEN 0
        ELSE 1
    END AS readmitted_flag,

    -- 30-day readmission flag
    CASE
        WHEN readmitted = '<30' THEN 1
        ELSE 0
    END AS readmitted_30d_flag,

    -- Inpatient visit flag
    CASE
        WHEN number_inpatient > 0 THEN 1
        ELSE 0
    END AS inpatient_flag

FROM diabetic_data;
