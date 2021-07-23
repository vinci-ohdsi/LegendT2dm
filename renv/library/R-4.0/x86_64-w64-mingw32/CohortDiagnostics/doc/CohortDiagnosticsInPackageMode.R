## ---- echo = FALSE, message = FALSE-------------------------------------------
library(SqlRender)
knitr::opts_chunk$set(
  cache = FALSE,
  comment = "#>",
  error = FALSE,
  tidy = FALSE)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## ROhdsiWebApi::insertCohortDefinitionSetInPackage(fileName = "CohortsToCreate.csv",
##                                                  baseUrl = Sys.getenv("baseUrl"),
##                                                  insertTableSql = TRUE,
##                                                  insertCohortCreationR = TRUE,
##                                                  generateStats = TRUE,
##                                                  packageName = "SkeletonCohortDiagnosticsStudy")

