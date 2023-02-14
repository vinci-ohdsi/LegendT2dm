
--COPY ROWS ONLY RELATED TO THE PERSON (based on a cohort table with SUBJECT_IDs)
SELECT * INTO @output_cdm_database_schema.CONDITION_ERA	FROM 	@input_cdm_database_schema.CONDITION_ERA	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.CONDITION_OCCURRENCE	FROM 	@input_cdm_database_schema.CONDITION_OCCURRENCE	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.DEATH	FROM 	@input_cdm_database_schema.DEATH	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.DEVICE_EXPOSURE	FROM 	@input_cdm_database_schema.DEVICE_EXPOSURE	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.DOSE_ERA	FROM 	@input_cdm_database_schema.DOSE_ERA	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.DRUG_ERA	FROM 	@input_cdm_database_schema.DRUG_ERA	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.DRUG_EXPOSURE	FROM 	@input_cdm_database_schema.DRUG_EXPOSURE	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.MEASUREMENT	FROM 	@input_cdm_database_schema.MEASUREMENT	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.NOTE	FROM 	@input_cdm_database_schema.NOTE	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.OBSERVATION	FROM 	@input_cdm_database_schema.OBSERVATION	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.OBSERVATION_PERIOD	FROM 	@input_cdm_database_schema.OBSERVATION_PERIOD	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.PAYER_PLAN_PERIOD	FROM 	@input_cdm_database_schema.PAYER_PLAN_PERIOD	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.PERSON	FROM 	@input_cdm_database_schema.PERSON	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.PROCEDURE_OCCURRENCE	FROM 	@input_cdm_database_schema.PROCEDURE_OCCURRENCE	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.SPECIMEN	FROM 	@input_cdm_database_schema.SPECIMEN	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.VISIT_DETAIL	FROM 	@input_cdm_database_schema.VISIT_DETAIL	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;
SELECT * INTO @output_cdm_database_schema.VISIT_OCCURRENCE	FROM 	@input_cdm_database_schema.VISIT_OCCURRENCE	WHERE PERSON_ID IN (SELECT distinct SUBJECT_ID as PERSON_ID FROM @cohort_database_schema.@cohort_table)	;

-- COPY ALL ROWS WITH NO FILTER
SELECT * INTO @output_cdm_database_schema.ATTRIBUTE_DEFINITION	FROM 	@input_cdm_database_schema.ATTRIBUTE_DEFINITION	;
SELECT * INTO @output_cdm_database_schema.CARE_SITE	FROM 	@input_cdm_database_schema.CARE_SITE	;
SELECT * INTO @output_cdm_database_schema.CDM_SOURCE	FROM 	@input_cdm_database_schema.CDM_SOURCE	;
SELECT * INTO @output_cdm_database_schema.COHORT	FROM 	@input_cdm_database_schema.COHORT	;
SELECT * INTO @output_cdm_database_schema.COHORT_ATTRIBUTE	FROM 	@input_cdm_database_schema.COHORT_ATTRIBUTE	;
SELECT * INTO @output_cdm_database_schema.COHORT_DEFINITION	FROM 	@input_cdm_database_schema.COHORT_DEFINITION	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_ANCESTOR_CUSTOM	FROM 	@input_cdm_database_schema.CONCEPT_ANCESTOR_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_ANCESTOR_STOCK	FROM 	@input_cdm_database_schema.CONCEPT_ANCESTOR_STOCK	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_CLASS_CUSTOM	FROM 	@input_cdm_database_schema.CONCEPT_CLASS_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_CLASS_STOCK	FROM 	@input_cdm_database_schema.CONCEPT_CLASS_STOCK	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_CUSTOM	FROM 	@input_cdm_database_schema.CONCEPT_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_RELATIONSHIP_CUSTOM	FROM 	@input_cdm_database_schema.CONCEPT_RELATIONSHIP_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_RELATIONSHIP_STOCK	FROM 	@input_cdm_database_schema.CONCEPT_RELATIONSHIP_STOCK	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_STOCK	FROM 	@input_cdm_database_schema.CONCEPT_STOCK	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_SYNONYM_CUSTOM	FROM 	@input_cdm_database_schema.CONCEPT_SYNONYM_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.CONCEPT_SYNONYM_STOCK	FROM 	@input_cdm_database_schema.CONCEPT_SYNONYM_STOCK	;
SELECT * INTO @output_cdm_database_schema.COST	FROM 	@input_cdm_database_schema.COST	;
SELECT * INTO @output_cdm_database_schema.DOMAIN_CUSTOM	FROM 	@input_cdm_database_schema.DOMAIN_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.DOMAIN_STOCK	FROM 	@input_cdm_database_schema.DOMAIN_STOCK	;
SELECT * INTO @output_cdm_database_schema.DRUG_STRENGTH_CUSTOM	FROM 	@input_cdm_database_schema.DRUG_STRENGTH_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.DRUG_STRENGTH_STOCK	FROM 	@input_cdm_database_schema.DRUG_STRENGTH_STOCK	;
SELECT * INTO @output_cdm_database_schema.FACT_RELATIONSHIP	FROM 	@input_cdm_database_schema.FACT_RELATIONSHIP	;
SELECT * INTO @output_cdm_database_schema.LOCATION	FROM 	@input_cdm_database_schema.LOCATION	;
SELECT * INTO @output_cdm_database_schema.PROVIDER	FROM 	@input_cdm_database_schema.PROVIDER	;
SELECT * INTO @output_cdm_database_schema.RELATIONSHIP_CUSTOM	FROM 	@input_cdm_database_schema.RELATIONSHIP_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.RELATIONSHIP_STOCK	FROM 	@input_cdm_database_schema.RELATIONSHIP_STOCK	;
SELECT * INTO @output_cdm_database_schema.VOCABULARY_CUSTOM	FROM 	@input_cdm_database_schema.VOCABULARY_CUSTOM	;
SELECT * INTO @output_cdm_database_schema.VOCABULARY_STOCK	FROM 	@input_cdm_database_schema.VOCABULARY_STOCK	;

--CREATE VIEWS
CREATE VIEW @output_cdm_database_schema.CONCEPT AS SELECT * FROM @output_cdm_database_schema.CONCEPT_STOCK UNION ALL SELECT * FROM @output_cdm_database_schema.CONCEPT_CUSTOM ;
CREATE VIEW @output_cdm_database_schema.CONCEPT_ANCESTOR AS SELECT * FROM @output_cdm_database_schema.CONCEPT_ANCESTOR_STOCK UNION ALL SELECT * FROM @output_cdm_database_schema.CONCEPT_ANCESTOR_CUSTOM ;
CREATE VIEW @output_cdm_database_schema.CONCEPT_CLASS AS SELECT * FROM @output_cdm_database_schema.CONCEPT_CLASS_STOCK UNION ALL SELECT * FROM @output_cdm_database_schema.CONCEPT_CLASS_CUSTOM ;
CREATE VIEW @output_cdm_database_schema.CONCEPT_RELATIONSHIP AS SELECT * FROM @output_cdm_database_schema.CONCEPT_RELATIONSHIP_CUSTOM UNION ALL SELECT * FROM @output_cdm_database_schema.CONCEPT_RELATIONSHIP_STOCK ;
CREATE VIEW @output_cdm_database_schema.CONCEPT_SYNONYM AS SELECT * FROM @output_cdm_database_schema.CONCEPT_SYNONYM_STOCK UNION SELECT * FROM @output_cdm_database_schema.CONCEPT_SYNONYM_CUSTOM ;
CREATE VIEW @output_cdm_database_schema.DOMAIN AS SELECT * FROM @output_cdm_database_schema.DOMAIN_STOCK UNION ALL SELECT * FROM @output_cdm_database_schema.DOMAIN_CUSTOM ;
CREATE VIEW @output_cdm_database_schema.DRUG_STRENGTH AS SELECT * FROM @output_cdm_database_schema.DRUG_STRENGTH_STOCK UNION ALL SELECT * FROM @output_cdm_database_schema.DRUG_STRENGTH_CUSTOM ;
CREATE VIEW @output_cdm_database_schema.RELATIONSHIP AS SELECT * FROM @output_cdm_database_schema.RELATIONSHIP_STOCK UNION ALL SELECT * FROM @output_cdm_database_schema.RELATIONSHIP_CUSTOM ;
CREATE VIEW @output_cdm_database_schema.VOCABULARY AS SELECT * FROM @output_cdm_database_schema.VOCABULARY_STOCK UNION ALL SELECT * FROM @output_cdm_database_schema.VOCABULARY_CUSTOM ;
