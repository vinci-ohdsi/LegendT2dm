## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
library(CohortMethod)


## ----eval=FALSE---------------------------------------------------------------
## connectionDetails <- createConnectionDetails(dbms = "postgresql",
##                                              server = "localhost/ohdsi",
##                                              user = "joe",
##                                              password = "supersecret")
## 
## cdmDatabaseSchema <- "my_cdm_data"
## resultsDatabaseSchema <- "my_results"
## options(sqlRenderTempEmulationSchema = NULL)
## outputFolder <- "./CohortMethodOutput"


## ----eval=FALSE---------------------------------------------------------------
## library(SqlRender)
## sql <- readSql("VignetteOutcomes.sql")
## sql <- render(sql,
##               cdmDatabaseSchema = cdmDatabaseSchema,
##               resultsDatabaseSchema = resultsDatabaseSchema)
## sql <- translate(sql, targetDialect = connectionDetails$dbms)
## 
## connection <- connect(connectionDetails)
## executeSql(connection, sql)


## ----eval=FALSE---------------------------------------------------------------
## tcos <- createTargetComparatorOutcomes(targetId = 1118084,
##                                        comparatorId = 1124300,
##                                        outcomeIds = c(192671, 29735, 140673, 197494,
##                                                       198185, 198199, 200528, 257315,
##                                                       314658, 317376, 321319, 380731,
##                                                       432661, 432867, 433516, 433701,
##                                                       433753, 435140, 435459, 435524,
##                                                       435783, 436665, 436676, 442619,
##                                                       444252, 444429, 4131756, 4134120,
##                                                       4134454, 4152280, 4165112, 4174262,
##                                                       4182210, 4270490, 4286201, 4289933))
## 
## targetComparatorOutcomesList <- list(tcos)


## ----eval=TRUE----------------------------------------------------------------
nsaids <- 21603933

covarSettings <- createDefaultCovariateSettings(excludedCovariateConceptIds = nsaids,
                                                addDescendantsToExclude = TRUE)

getDbCmDataArgs <- createGetDbCohortMethodDataArgs(washoutPeriod = 183,
                                                   restrictToCommonPeriod = FALSE,
                                                   firstExposureOnly = TRUE,
                                                   removeDuplicateSubjects = "remove all",
                                                   studyStartDate = "",
                                                   studyEndDate = "",
                                                   excludeDrugsFromCovariates = FALSE,
                                                   covariateSettings = covarSettings)

createStudyPopArgs <- createCreateStudyPopulationArgs(removeSubjectsWithPriorOutcome = TRUE,
                                                      minDaysAtRisk = 1,
                                                      riskWindowStart = 0,
                                                      startAnchor = "cohort start",
                                                      riskWindowEnd = 30,
                                                      endAnchor = "cohort end")

fitOutcomeModelArgs1 <- createFitOutcomeModelArgs(modelType = "cox")


## ----eval=TRUE----------------------------------------------------------------
cmAnalysis1 <- createCmAnalysis(analysisId = 1,
                                description = "No matching, simple outcome model",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs1)


## ----eval=TRUE----------------------------------------------------------------
createPsArgs <- createCreatePsArgs() # Use default settings only

matchOnPsArgs <- createMatchOnPsArgs(maxRatio = 100)

fitOutcomeModelArgs2 <- createFitOutcomeModelArgs(modelType = "cox",
                                                  stratified = TRUE)

cmAnalysis2 <- createCmAnalysis(analysisId = 2,
                                description = "Matching",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                createPs = TRUE,
                                createPsArgs = createPsArgs,
                                matchOnPs = TRUE,
                                matchOnPsArgs = matchOnPsArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs1)

stratifyByPsArgs <- createStratifyByPsArgs(numberOfStrata = 5)

cmAnalysis3 <- createCmAnalysis(analysisId = 3,
                                description = "Stratification",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                createPs = TRUE,
                                createPsArgs = createPsArgs,
                                stratifyByPs = TRUE,
                                stratifyByPsArgs = stratifyByPsArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs2)

fitOutcomeModelArgs3 <- createFitOutcomeModelArgs(modelType = "cox",
                                                  inversePtWeighting = TRUE)

cmAnalysis4 <- createCmAnalysis(analysisId = 4,
                                description = "Inverse probability weighting",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                createPs = TRUE,
                                createPsArgs = createPsArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs3)

fitOutcomeModelArgs4 <- createFitOutcomeModelArgs(useCovariates = TRUE,
                                                  modelType = "cox",
                                                  stratified = TRUE)

cmAnalysis5 <- createCmAnalysis(analysisId = 5,
                                description = "Matching plus full outcome model",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                createPs = TRUE,
                                createPsArgs = createPsArgs,
                                matchOnPs = TRUE,
                                matchOnPsArgs = matchOnPsArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs4)

interactionCovariateIds <- c(8532001, 201826210, 21600960413) # Female, T2DM, concurent use of antithrombotic agents

fitOutcomeModelArgs5 <- createFitOutcomeModelArgs(modelType = "cox",
                                                  stratified = TRUE,
                                                  interactionCovariateIds = interactionCovariateIds)

cmAnalysis6 <- createCmAnalysis(analysisId = 6,
                                description = "Stratification plus interaction terms",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                createPs = TRUE,
                                createPsArgs = createPsArgs,
                                stratifyByPs = TRUE,
                                stratifyByPsArgs = stratifyByPsArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs5)


## ----eval=TRUE----------------------------------------------------------------
cmAnalysisList <- list(cmAnalysis1, 
                       cmAnalysis2, 
                       cmAnalysis3, 
                       cmAnalysis4, 
                       cmAnalysis5, 
                       cmAnalysis6)


## ----eval=TRUE----------------------------------------------------------------
comparatorIds = list(drugInSameClass = 1124300,
                     drugWithSameIndication = 1125315)

tcos <- createTargetComparatorOutcomes(targetId = 1118084,
                                     comparatorId = comparatorIds,
                                     outcomeIds = 192671)

targetComparatorOutcomesList2 <- list(tcos)


## ----eval=TRUE----------------------------------------------------------------
cmAnalysis1 <- createCmAnalysis(analysisId = 1,
                                description = "Analysis using drug in same class",
                                comparatorType = "drugInSameClass",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                createPs = TRUE,
                                createPsArgs = createPsArgs,
                                matchOnPs = TRUE,
                                matchOnPsArgs = matchOnPsArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs1)

cmAnalysis2 <- createCmAnalysis(analysisId = 2,
                                description = "Analysis using drug with same indication",
                                comparatorType = "drugWithSameIndication",
                                getDbCohortMethodDataArgs = getDbCmDataArgs,
                                createStudyPopArgs = createStudyPopArgs,
                                createPs = TRUE,
                                createPsArgs = createPsArgs,
                                matchOnPs = TRUE,
                                matchOnPsArgs = matchOnPsArgs,
                                fitOutcomeModel = TRUE,
                                fitOutcomeModelArgs = fitOutcomeModelArgs1)

cmAnalysisList2 <- list(cmAnalysis1, cmAnalysis2)


## ----eval=FALSE---------------------------------------------------------------
## result <- runCmAnalyses(connectionDetails = connectionDetails,
##                         cdmDatabaseSchema = cdmDatabaseSchema,
##                         exposureDatabaseSchema = cdmDatabaseSchema,
##                         exposureTable = "drug_era",
##                         outcomeDatabaseSchema = resultsDatabaseSchema,
##                         outcomeTable = "outcomes",
##                         cdmVersion = cdmVersion,
##                         outputFolder = outputFolder,
##                         cmAnalysisList = cmAnalysisList,
##                         targetComparatorOutcomesList = targetComparatorOutcomesList,
##                         getDbCohortMethodDataThreads = 1,
##                         createPsThreads = 1,
##                         psCvThreads = 10,
##                         createStudyPopThreads = 4,
##                         trimMatchStratifyThreads = 10,
##                         fitOutcomeModelThreads = 4,
##                         outcomeCvThreads = 10)


## ----eval=FALSE---------------------------------------------------------------
## psFile <- result$psFile[result$targetId == 1118084 &
##                         result$comparatorId == 1124300 &
##                         result$outcomeId == 192671 &
##                         result$analysisId == 5]
## ps <- readRDS(file.path(outputFolder, psFile))
## plotPs(ps)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette2/outcomeModelReference.rds")) {
  outputFolder <- "s:/temp/cohortMethodVignette2"
  result <- readRDS("s:/temp/cohortMethodVignette2/outcomeModelReference.rds")
  psFile <- result$psFile[result$targetId == 1118084 & 
                            result$comparatorId == 1124300 & 
                            result$outcomeId == 192671 &
                            result$analysisId == 5]
  ps <- readRDS(file.path(outputFolder, psFile))
  plotPs(ps)
}


## ----eval=FALSE---------------------------------------------------------------
## analysisSum <- summarizeAnalyses(result, outputFolder)
## head(analysisSum)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette2/analysisSummary.rds")) {
  analysisSum <- readRDS("s:/temp/cohortMethodVignette2/analysisSummary.rds")
  head(analysisSum)
}


## ----eval=FALSE---------------------------------------------------------------
## install.packages("EmpiricalCalibration")
## library(EmpiricalCalibration)
## 
## # Analysis 1: No matching, simple outcome model
## negCons <- analysisSum[analysisSum$analysisId == 1 & analysisSum$outcomeId != 192671, ]
## hoi <-  analysisSum[analysisSum$analysisId == 1 & analysisSum$outcomeId == 192671, ]
## null <- fitNull(negCons$logRr, negCons$seLogRr)
## plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
if (file.exists("s:/temp/cohortMethodVignette2/analysisSummary.rds")) {
  library(EmpiricalCalibration)
  negCons <- analysisSum[analysisSum$analysisId == 1 & analysisSum$outcomeId != 192671, ]
  hoi <-  analysisSum[analysisSum$analysisId == 1 & analysisSum$outcomeId == 192671, ]
  null <- fitNull(negCons$logRr, negCons$seLogRr)
  plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)
}


## ----eval=FALSE---------------------------------------------------------------
## # Analysis 2: Matching
## negCons <- analysisSum[analysisSum$analysisId == 2 & analysisSum$outcomeId != 192671, ]
## hoi <-  analysisSum[analysisSum$analysisId == 2 & analysisSum$outcomeId == 192671, ]
## null <- fitNull(negCons$logRr, negCons$seLogRr)
## plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
if (file.exists("s:/temp/cohortMethodVignette2/analysisSummary.rds")) {
  negCons <- analysisSum[analysisSum$analysisId == 2 & analysisSum$outcomeId != 192671, ]
  hoi <-  analysisSum[analysisSum$analysisId == 2 & analysisSum$outcomeId == 192671, ]
  null <- fitNull(negCons$logRr, negCons$seLogRr)
  plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)
}


## ----eval=FALSE---------------------------------------------------------------
## # Analysis 3: Stratification
## negCons <- analysisSum[analysisSum$analysisId == 3 & analysisSum$outcomeId != 192671, ]
## hoi <-  analysisSum[analysisSum$analysisId == 3 & analysisSum$outcomeId == 192671, ]
## null <- fitNull(negCons$logRr, negCons$seLogRr)
## plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
if (file.exists("s:/temp/cohortMethodVignette2/analysisSummary.rds")) {
  negCons <- analysisSum[analysisSum$analysisId == 3 & analysisSum$outcomeId != 192671, ]
  hoi <-  analysisSum[analysisSum$analysisId == 3 & analysisSum$outcomeId == 192671, ]
  null <- fitNull(negCons$logRr, negCons$seLogRr)
  plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)
}


## ----eval=FALSE---------------------------------------------------------------
## # Analysis 4: Inverse probability of treatment weighting
## negCons <- analysisSum[analysisSum$analysisId == 4 & analysisSum$outcomeId != 192671, ]
## hoi <-  analysisSum[analysisSum$analysisId == 4 & analysisSum$outcomeId == 192671, ]
## null <- fitNull(negCons$logRr, negCons$seLogRr)
## plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
if (file.exists("s:/temp/cohortMethodVignette2/analysisSummary.rds")) {
  negCons <- analysisSum[analysisSum$analysisId == 4 & analysisSum$outcomeId != 192671, ]
  hoi <-  analysisSum[analysisSum$analysisId == 4 & analysisSum$outcomeId == 192671, ]
  null <- fitNull(negCons$logRr, negCons$seLogRr)
  plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)
}


## ----eval=FALSE---------------------------------------------------------------
## # Analysis 5: Stratification plus full outcome model
## negCons <- analysisSum[analysisSum$analysisId == 5 & analysisSum$outcomeId != 192671, ]
## hoi <-  analysisSum[analysisSum$analysisId == 5 & analysisSum$outcomeId == 192671, ]
## null <- fitNull(negCons$logRr, negCons$seLogRr)
## plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
if (file.exists("s:/temp/cohortMethodVignette2/analysisSummary.rds")) {
  negCons <- analysisSum[analysisSum$analysisId == 5 & analysisSum$outcomeId != 192671, ]
  hoi <-  analysisSum[analysisSum$analysisId == 5 & analysisSum$outcomeId == 192671, ]
  null <- fitNull(negCons$logRr, negCons$seLogRr)
  plotCalibrationEffect(negCons$logRr, negCons$seLogRr, hoi$logRr, hoi$seLogRr, null)
}


## ----eval=FALSE---------------------------------------------------------------
## # Analysis 6: Stratification plus interaction terms
## negCons <- analysisSum[analysisSum$analysisId == 6 & analysisSum$outcomeId != 192671, ]
## hoi <-  analysisSum[analysisSum$analysisId == 6 & analysisSum$outcomeId == 192671, ]
## null <- fitNull(negCons$logRrI8532001, negCons$seLogRrI8532001)
## plotCalibrationEffect(logRrNegatives = negCons$logRrI8532001,
##                       seLogRrNegatives = negCons$seLogRrI8532001,
##                       logRrPositives = hoi$logRrI8532001,
##                       seLogRrPositives = hoi$seLogRrI8532001, null)

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette2/analysisSummary.rds")) {
  negCons <- analysisSum[analysisSum$analysisId == 6 & analysisSum$outcomeId != 192671, ]
  hoi <-  analysisSum[analysisSum$analysisId == 6 & analysisSum$outcomeId == 192671, ]
  null <- fitNull(negCons$logRrI8532001, negCons$seLogRrI8532001)
  plotCalibrationEffect(logRrNegatives = negCons$logRrI8532001, 
                        seLogRrNegatives = negCons$seLogRrI8532001, 
                        logRrPositives = hoi$logRrI8532001, 
                        seLogRrPositives = hoi$seLogRrI8532001, null)
}


## ----eval=TRUE----------------------------------------------------------------
citation("CohortMethod")


## ----eval=TRUE----------------------------------------------------------------
citation("Cyclops")

