## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
library(FeatureExtraction)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## library(SqlRender)
## sql <- readSql("LengthOfObsCohortAttr.sql")
## sql <- render(sql,
##                  cdm_database_schema = cdmDatabaseSchema,
##                  cohort_database_schema = cohortDatabaseSchema,
##                  cohort_table = "rehospitalization",
##                  cohort_attribute_table = "loo_cohort_attr",
##                  attribute_definition_table = "loo_attr_def",
##                  cohort_definition_ids = c(1,2))
## sql <- translate(sql, targetDialect = connectionDetails$dbms)
## 
## connection <- connect(connectionDetails)
## executeSql(connection, sql)


## ----eval=FALSE---------------------------------------------------------------
## looCovSet <- createCohortAttrCovariateSettings(attrDatabaseSchema = cohortDatabaseSchema,
##                                                cohortAttrTable = "loo_cohort_attr",
##                                                attrDefinitionTable = "loo_attr_def",
##                                                includeAttrIds = c(),
##                                                isBinary = FALSE,
##                                                missingMeansZero = FALSE)


## ----eval=FALSE---------------------------------------------------------------
## covariates <- getDbCovariateData(connectionDetails = connectionDetails,
##                                  cdmDatabaseSchema = cdmDatabaseSchema,
##                                  cohortDatabaseSchema = cohortDatabaseSchema,
##                                  cohortTable = "rehospitalization",
##                                  cohortId = 1,
##                                  covariateSettings = looCovSet)


## ----eval=FALSE---------------------------------------------------------------
## covariateSettings <- createCovariateSettings(useDemographicsGender = TRUE,
##                                              useDemographicsAgeGroup = TRUE,
##                                              useDemographicsRace = TRUE,
##                                              useDemographicsEthnicity = TRUE,
##                                              useDemographicsIndexYear = TRUE,
##                                              useDemographicsIndexMonth = TRUE)
## 
## looCovSet <- createCohortAttrCovariateSettings(attrDatabaseSchema = cohortDatabaseSchema,
##                                                cohortAttrTable = "loo_cohort_attr",
##                                                attrDefinitionTable = "loo_attr_def",
##                                                includeAttrIds = c())
## 
## covariateSettingsList <- list(covariateSettings, looCovSet)
## 
## covariates <- getDbCovariateData(connectionDetails = connectionDetails,
##                                  cdmDatabaseSchema = cdmDatabaseSchema,
##                                  cohortDatabaseSchema = resultsDatabaseSchema,
##                                  cohortTable = "rehospitalization",
##                                  cohortId = 1,
##                                  covariateSettings = covariateSettingsList)

