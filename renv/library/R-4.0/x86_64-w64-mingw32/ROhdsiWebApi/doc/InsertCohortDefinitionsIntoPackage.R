## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----eval=FALSE, echo = TRUE--------------------------------------------------
## 
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
##     name = webApiCohorts$id[[i]],
##     cohortName = stringr::str_trim(stringr::str_squish(cohortDefinition$name))
##   )
## }
## 
## cohortsToCreate <- dplyr::bind_rows(cohortsToCreate)
## 
## readr::write_excel_csv(x = cohortsToCreate, na = "",
##                        file = "inst/settings/CohortsToCreate.csv",
##                        append = FALSE)
## 


## ----eval=FALSE, echo = TRUE--------------------------------------------------
## # Insert cohort definitions from ATLAS into package -----------------------
## ROhdsiWebApi::insertCohortDefinitionSetInPackage(
##   fileName = "inst/settings/CohortsToCreate.csv",
##   baseUrl = baseUrl,
##   insertTableSql = TRUE,
##   insertCohortCreationR = TRUE,
##   generateStats = TRUE,
##   packageName = 'yourFavoritePackage'
## )

