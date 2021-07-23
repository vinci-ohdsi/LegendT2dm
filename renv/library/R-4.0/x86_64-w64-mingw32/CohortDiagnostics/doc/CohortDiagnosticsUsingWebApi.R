## ---- echo = FALSE, message = FALSE-------------------------------------------
library(SqlRender)
knitr::opts_chunk$set(
  cache = FALSE,
  comment = "#>",
  error = FALSE,
  tidy = FALSE)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## library(CohortDiagnostics)
## cohortSetReference <- read.csv("cohortsToDiagnose.csv")
## 


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## library(magrittr)
## # Set up
## baseUrl <- Sys.getenv("BaseUrl")
## # list of cohort ids
## cohortIds <- c(18345,18346)
## 
## # get specifications for the cohortIds above
## webApiCohorts <-
##         ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl) %>%
##         dplyr::filter(.data$id %in% cohortIds)
## 
## cohortsToCreate <- list()
## for (i in (1:nrow(webApiCohorts))) {
##   cohortId <- webApiCohorts$id[[i]]
##   cohortDefinition <-
##     ROhdsiWebApi::getCohortDefinition(cohortId = cohortId,
##                                       baseUrl = baseUrl)
##   cohortsToCreate[[i]] <- tidyr::tibble(
##     atlasId = webApiCohorts$id[[i]],
##     atlasName = stringr::str_trim(string = stringr::str_squish(cohortDefinition$name)),
##     cohortId = webApiCohorts$id[[i]],
##     name = stringr::str_trim(stringr::str_squish(cohortDefinition$name))
##     )
## }
## cohortsToCreate <- dplyr::bind_rows(cohortsToCreate)
## 
## readr::write_excel_csv(x = cohortsToCreate, na = "",
##                        file = "D:/temp/CohortsToCreate.csv",
##                        append = FALSE)
## 


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## baseUrl <- "http://server.org:80/WebAPI"
## inclusionStatisticsFolder <- "c:/temp/incStats"
## 
## instantiateCohortSet(connectionDetails = connectionDetails,
##                      cdmDatabaseSchema = cdmDatabaseSchema,
##                      tempEmulationSchema = tempEmulationSchema,
##                      cohortDatabaseSchema = cohortDatabaseSchema,
##                      cohortTable = cohortTable,
##                      baseUrl = baseUrl,
##                      cohortSetReference = cohortSetReference,
##                      generateInclusionStats = TRUE,
##                      inclusionStatisticsFolder = inclusionStatisticsFolder)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## databaseId <- "MyData"
## exportFolder <- "c:/temp/export"
## 
## runCohortDiagnostics(baseUrl = baseUrl,
##                      cohortSetReference = cohortSetReference,
##                      connectionDetails = connectionDetails,
##                      cdmDatabaseSchema = cdmDatabaseSchema,
##                      tempEmulationSchema = tempEmulationSchema,
##                      cohortDatabaseSchema = cohortDatabaseSchema,
##                      cohortTable = cohortTable,
##                      inclusionStatisticsFolder = inclusionStatisticsFolder,
##                      exportFolder = exportFolder,
##                      databaseId = databaseId,
##                      runInclusionStatistics = TRUE,
##                      runIncludedSourceConcepts = TRUE,
##                      runOrphanConcepts = TRUE,
##                      runTimeDistributions = TRUE,
##                      runBreakdownIndexEvents = TRUE,
##                      runIncidenceRate = TRUE,
##                      runCohortOverlap = TRUE,
##                      runCohortCharacterization = TRUE,
##                      minCellCount = 5)

