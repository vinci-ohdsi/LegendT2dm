## ---- echo = FALSE, message = FALSE-------------------------------------------
library(SqlRender)
knitr::opts_chunk$set(
  cache = FALSE,
  comment = "#>",
  error = FALSE,
  tidy = FALSE)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## connectionDetails <- createConnectionDetails(dbms = "postgresql",
##                                              server = "localhost/ohdsi",
##                                              user = "joe",
##                                              password = "supersecret")
## 
## cdmDatabaseSchema <- "my_cdm_data"
## tempEmulationSchema <- NULL
## cohortDatabaseSchema <- "my_schema"
## cohortTable <- "my_cohort_table"


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## createCohortTable(connectionDetails = connectionDetails,
##                   cohortDatabaseSchema = cohortDatabaseSchema,
##                   cohortTable = cohortTable)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## preMergeDiagnosticsFiles("C:/temp/allZipFiles")

