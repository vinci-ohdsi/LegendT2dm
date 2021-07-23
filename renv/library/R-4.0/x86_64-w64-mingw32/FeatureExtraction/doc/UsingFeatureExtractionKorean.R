## ----set-options,echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------
options(width = 200)
library(FeatureExtraction)
vignetteFolder <- "s:/temp/vignetteFeatureExtraction"


## -----------------------------------------------------------------------------
settings <- createDefaultCovariateSettings()


## -----------------------------------------------------------------------------
settings <- createDefaultCovariateSettings(excludedCovariateConceptIds = 1124300, 
                                           addDescendantsToExclude = TRUE)


## -----------------------------------------------------------------------------
settings <- createCovariateSettings(useDemographicsGender = TRUE,
                                    useDemographicsAgeGroup = TRUE,
                                    useConditionOccurrenceAnyTimePrior = TRUE)


## -----------------------------------------------------------------------------
settings <- createCovariateSettings(useConditionEraLongTerm = TRUE,
                                    useConditionEraShortTerm = TRUE,
                                    useDrugEraLongTerm = TRUE,
                                    useDrugEraShortTerm = TRUE,
                                    longTermStartDays = -180,
                                    shortTermStartDays = -14,
                                    endDays = -1)


## -----------------------------------------------------------------------------
settings <- createCovariateSettings(useConditionEraLongTerm = TRUE,
                                    useConditionEraShortTerm = TRUE,
                                    useDrugEraLongTerm = TRUE,
                                    useDrugEraShortTerm = TRUE,
                                    longTermStartDays = -180,
                                    shortTermStartDays = -14,
                                    endDays = -1,
                                    excludedCovariateConceptIds = 1124300, 
                                    addDescendantsToExclude = TRUE)


## -----------------------------------------------------------------------------
settings <- createCovariateSettings(useConditionEraLongTerm = TRUE)
settings2 <- convertPrespecSettingsToDetailedSettings(settings)
settings2$analyses[[1]]


## -----------------------------------------------------------------------------
analysisDetails <- createAnalysisDetails(analysisId = 1,
                                         sqlFileName = "DemographicsGender.sql",
                                         parameters = list(analysisId = 1,
                                                           analysisName = "Gender",
                                                           domainId = "Demographics"),
                                         includedCovariateConceptIds = c(),
                                         addDescendantsToInclude = FALSE,
                                         excludedCovariateConceptIds = c(),
                                         addDescendantsToExclude = FALSE,
                                         includedCovariateIds = c())

settings <- createDetailedCovariateSettings(list(analysisDetails))


## -----------------------------------------------------------------------------
settings <- createDefaultTemporalCovariateSettings()


## -----------------------------------------------------------------------------
settings <- createTemporalCovariateSettings(useConditionOccurrence = TRUE,
                                            useMeasurementValue = TRUE)


## -----------------------------------------------------------------------------
settings <- createTemporalCovariateSettings(useConditionOccurrence = TRUE,
                                            useMeasurementValue = TRUE,
                                            temporalStartDays = seq(-364, -7, by = 7),
                                            temporalEndDays = seq(-358, -1, by = 7))


## -----------------------------------------------------------------------------
analysisDetails <- createAnalysisDetails(analysisId = 1,
                                         sqlFileName = "MeasurementValue.sql",
                                         parameters = list(analysisId = 1,
                                                           analysisName = "MeasurementValue",
                                                           domainId = "Measurement"),
                                         includedCovariateConceptIds = c(),
                                         addDescendantsToInclude = FALSE,
                                         excludedCovariateConceptIds = c(),
                                         addDescendantsToExclude = FALSE,
                                         includedCovariateIds = c())

settings <-  createDetailedTemporalCovariateSettings(list(analysisDetails))


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## connectionDetails <- createConnectionDetails(dbms = "postgresql",
##                                              server = "localhost/ohdsi",
##                                              user = "joe",
##                                              password = "supersecret")
## 
## cdmDatabaseSchema <- "my_cdm_data"
## resultsDatabaseSchema <- "my_results"


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## library(SqlRender)
## sql <- readSql("cohortsOfInterest.sql")
## sql <- render(sql,
##               cdmDatabaseSchema = cdmDatabaseSchema,
##               resultsDatabaseSchema = resultsDatabaseSchema)
## sql <- translate(sql, targetDialect = connectionDetails$dbms)
## 
## connection <- connect(connectionDetails)
## executeSql(connection, sql)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## sql <- paste("SELECT cohort_definition_id, COUNT(*) AS count",
##              "FROM @resultsDatabaseSchema.cohorts_of_interest",
##              "GROUP BY cohort_definition_id")
## sql <- render(sql, resultsDatabaseSchema = resultsDatabaseSchema)
## sql <- translate(sql, targetDialect = connectionDetails$dbms)
## 
## querySql(connection, sql)

## ----echo=FALSE,message=FALSE-------------------------------------------------
data.frame(cohort_concept_id = c(1124300,1118084),count = c(240761,47293))


## ----eval=FALSE---------------------------------------------------------------
## covariateSettings <- createDefaultCovariateSettings()
## 
## covariateData <- getDbCovariateData(connectionDetails = connectionDetails,
##                                     cdmDatabaseSchema = cdmDatabaseSchema,
##                                     cohortDatabaseSchema = resultsDatabaseSchema,
##                                     cohortTable = "cohorts_of_interest",
##                                     cohortId = 1118084,
##                                     rowIdField = "subject_id",
##                                     covariateSettings = covariateSettings)
## 
## summary(covariateData)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "covariatesPerPerson"))) {
  covariateData <- loadCovariateData(file.path(vignetteFolder, "covariatesPerPerson"))
  summary(covariateData)
}


## ----eval=FALSE---------------------------------------------------------------
## covariateData$covariates

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "covariatesPerPerson"))) {
  covariateData$covariates %>%
    mutate(rowId = row_number())
}


## ----eval=FALSE---------------------------------------------------------------
## saveCovariateData(covariateData, "covariates")


## ----eval=FALSE---------------------------------------------------------------
## tidyCovariates <- tidyCovariateData(covariateData,
##                                     minFraction = 0.001,
##                                     normalize = TRUE,
##                                     removeRedundancy = TRUE)


## ----eval=FALSE---------------------------------------------------------------
## deletedCovariateIds <- tidyCovariates$metaData$deletedInfrequentCovariateIds
## head(deletedCovariateIds)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "deletedInfrequentCovariateIds.rds"))){
  deletedCovariateIds <- readRDS(file.path(vignetteFolder, "deletedInfrequentCovariateIds.rds"))
  head(deletedCovariateIds)
}


## ----eval=FALSE---------------------------------------------------------------
## deletedCovariateIds <- tidyCovariates$metaData$deletedRedundantCovariateIds
## head(deletedCovariateIds)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "deletedRedundantCovariateIds.rds"))){
  deletedCovariateIds <- readRDS(file.path(vignetteFolder, "deletedRedundantCovariateIds.rds"))
  head(deletedCovariateIds)
}


## ----eval=FALSE---------------------------------------------------------------
## covariateData2 <- aggregateCovariates(covariateData)


## ----eval=FALSE---------------------------------------------------------------
## covariateSettings <- createDefaultCovariateSettings()
## 
## covariateData2 <- getDbCovariateData(connectionDetails = connectionDetails,
##                                      cdmDatabaseSchema = cdmDatabaseSchema,
##                                      cohortDatabaseSchema = resultsDatabaseSchema,
##                                      cohortTable = "cohorts_of_interest",
##                                      cohortId = 1118084,
##                                      covariateSettings = covariateSettings,
##                                      aggregated = TRUE)
## summary(covariateData2)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "aggregatedCovariates"))){
  covariateData2 <- loadCovariateData(file.path(vignetteFolder, "aggregatedCovariates"))
  summary(covariateData2)
}


## ----eval=FALSE---------------------------------------------------------------
## covariateData2$covariates

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "aggregatedCovariates"))) {
  covariateData2$covariates
}

## ----eval=FALSE---------------------------------------------------------------
## covariateData2$covariatesContinuous

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "aggregatedCovariates"))) {
  covariateData2$covariatesContinuous
}


## ----eval=FALSE---------------------------------------------------------------
## result <- createTable1(covariateData2)
## print(result, row.names = FALSE, right = FALSE)


## ----comment=NA,echo=FALSE,message=FALSE--------------------------------------
if (file.exists(file.path(vignetteFolder, "aggregatedCovariates"))){
  result <- createTable1(covariateData2)
  print(result, row.names = FALSE, right = FALSE)
}


## ----eval=FALSE---------------------------------------------------------------
## covariateSettings <- createTable1CovariateSettings()
## 
## covariateData2b <- getDbCovariateData(connectionDetails = connectionDetails,
##                                       cdmDatabaseSchema = cdmDatabaseSchema,
##                                       cohortDatabaseSchema = resultsDatabaseSchema,
##                                       cohortTable = "cohorts_of_interest",
##                                       cohortId = 1118084,
##                                       covariateSettings = covariateSettings,
##                                       aggregated = TRUE)
## summary(covariateData2b)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "table1Covariates"))){
  covariateData2b <- loadCovariateData(file.path(vignetteFolder, "table1Covariates"))
  summary(covariateData2b)
}


## ----eval=FALSE---------------------------------------------------------------
## settings <- createTable1CovariateSettings(excludedCovariateConceptIds = c(1118084, 1124300),
##                                           addDescendantsToExclude = TRUE)
## 
## covCelecoxib <- getDbCovariateData(connectionDetails = connectionDetails,
##                                    cdmDatabaseSchema = cdmDatabaseSchema,
##                                    cohortDatabaseSchema = resultsDatabaseSchema,
##                                    cohortTable = "cohorts_of_interest",
##                                    cohortId = 1118084,
##                                    covariateSettings = settings,
##                                    aggregated = TRUE)
## 
## covDiclofenac <- getDbCovariateData(connectionDetails = connectionDetails,
##                                     cdmDatabaseSchema = cdmDatabaseSchema,
##                                     cohortDatabaseSchema = resultsDatabaseSchema,
##                                     cohortTable = "cohorts_of_interest",
##                                     cohortId = 1124300,
##                                     covariateSettings = settings,
##                                     aggregated = TRUE)
## 
## std <- computeStandardizedDifference(covCelecoxib, covDiclofenac)


## ----eval=FALSE---------------------------------------------------------------
## head(std)


## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "covDiclofenac"))){
  covCelecoxib <- loadCovariateData(file.path(vignetteFolder, "covCelecoxib"))
  covDiclofenac <- loadCovariateData(file.path(vignetteFolder, "covDiclofenac"))
  std <- computeStandardizedDifference(covCelecoxib, covDiclofenac)
  truncRight <- function(x, n) {
    nc <- nchar(x)
    x[nc > (n-3)] <- paste('...',substr(x[nc > (n-3)], nc[nc > (n-3)]-n+1, nc[nc > (n-3)]),sep="")
    x
   }
   std$covariateName <- truncRight(as.character(std$covariateName), 30)
   head(std)
}


## ----eval=FALSE---------------------------------------------------------------
## result <- createTable1(covCelecoxib, covDiclofenac)
## print(result, row.names = FALSE, right = FALSE)


## ----comment=NA,echo=FALSE,message=FALSE--------------------------------------
if (file.exists(file.path(vignetteFolder, "covDiclofenac"))){
  result <- createTable1(covCelecoxib, covDiclofenac)
  print(result, row.names = FALSE, right = FALSE)
}

