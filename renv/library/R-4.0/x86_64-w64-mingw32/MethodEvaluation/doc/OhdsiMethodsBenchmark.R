## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
library(MethodEvaluation)
knitr::opts_chunk$set(
  cache = FALSE,
  comment = "#>",
  error = FALSE,
  tidy = FALSE)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## library(MethodEvaluation)
## connectionDetails <- createConnectionDetails(dbms = "postgresql",
##                                              server = "localhost/ohdsi",
##                                              user = "joe",
##                                              password = "supersecret")
## 
## cdmDatabaseSchema <- "my_cdm_data"
## oracleTempSchema <- NULL
## outcomeDatabaseSchema <- "scratch"
## outcomeTable <- "ohdsi_outcomes"
## nestingCohortDatabaseSchema <- "scratch"
## nestingCohortTable <- "ohdsi_nesting_cohorts"
## outputFolder <- "/home/benchmarkOutput"
## cdmVersion <- "5"


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## createReferenceSetCohorts(connectionDetails = connectionDetails,
##                           oracleTempSchema = oracleTempSchema,
##                           cdmDatabaseSchema = cdmDatabaseSchema,
##                           outcomeDatabaseSchema = outcomeDatabaseSchema,
##                           outcomeTable = outcomeTable,
##                           nestingDatabaseSchema = nestingCohortDatabaseSchema,
##                           nestingTable = nestingCohortTable,
##                           referenceSet = "ohdsiMethodsBenchmark")


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## synthesizeReferenceSetPositiveControls(connectionDetails = connectionDetails,
##                                        oracleTempSchema = oracleTempSchema,
##                                        cdmDatabaseSchema = cdmDatabaseSchema,
##                                        outcomeDatabaseSchema = outcomeDatabaseSchema,
##                                        outcomeTable = outcomeTable,
##                                        maxCores = 10,
##                                        workFolder = outputFolder,
##                                        summaryFileName = file.path(outputFolder,
##                                                                    "allControls.csv"),
##                                        referenceSet = "ohdsiMethodsBenchmark")


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## allControls <- read.csv(file.path(outputFolder, "allControls.csv"))
## head(allControls)

## ----echo=FALSE,message=FALSE-------------------------------------------------
writeLines(" outcomeId comparatorId targetId targetName comparatorName nestingId                  nestingName        outcomeName             type targetEffectSize trueEffectSize trueEffectSizeFirstExposure oldOutcomeId mdrrTarget
1         1      1105775  1110942 omalizumab  Aminophylline  37203741 Bronchospasm and obstruction Acute pancreatitis Exposure control                1              1                           1            1   1.421960
2         1      1110942  1140088 Dyphylline     omalizumab  37203741 Bronchospasm and obstruction Acute pancreatitis Exposure control                1              1                           1            1   1.420173
3         1      1136422   943634 epinastine levocetirizine  36009773            Rhinitis allergic Acute pancreatitis Exposure control                1              1                           1            1   1.217681
4         1      1315865 40163718  prasugrel   fondaparinux  37622411              Phlebosclerosis Acute pancreatitis Exposure control                1              1                           1            1   1.196514
5         1      1315865  1350310 cilostazol   fondaparinux  37622411              Phlebosclerosis Acute pancreatitis Exposure control                1              1                           1            1   1.233415
6         1      1336926  1311276 vardenafil      tadalafil  36919202           Sexual dysfunction Acute pancreatitis Exposure control                1              1                           1            1   1.097112
  mdrrComparator
1       1.177202
2       1.421960
3       1.085877
4       1.278911
5       1.278911
6       1.060737")


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## library(SelfControlledCohort)
## runSccArgs1 <- createRunSelfControlledCohortArgs(addLengthOfExposureExposed = TRUE,
##                                                  riskWindowStartExposed = 0,
##                                                  riskWindowEndExposed = 0,
##                                                  riskWindowEndUnexposed = -1,
##                                                  addLengthOfExposureUnexposed = TRUE,
##                                                  riskWindowStartUnexposed = -1,
##                                                  washoutPeriod = 365)
## 
## sccAnalysis1 <- createSccAnalysis(analysisId = 1,
##                                   description = "Length of exposure",
##                                   runSelfControlledCohortArgs = runSccArgs1)
## 
## runSccArgs2 <- createRunSelfControlledCohortArgs(addLengthOfExposureExposed = FALSE,
##                                                  riskWindowStartExposed = 0,
##                                                  riskWindowEndExposed = 30,
##                                                  riskWindowEndUnexposed = -1,
##                                                  addLengthOfExposureUnexposed = FALSE,
##                                                  riskWindowStartUnexposed = -30,
##                                                  washoutPeriod = 365)
## 
## sccAnalysis2 <- createSccAnalysis(analysisId = 2,
##                                   description = "30 days of each exposure",
##                                   runSelfControlledCohortArgs = runSccArgs2)
## sccAnalysisList <- list(sccAnalysis1, sccAnalysis2)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## allControls <- read.csv(file.path(outputFolder , "allControls.csv"))
## eos <- list()
## for (i in 1:nrow(allControls)) {
##   eos[[length(eos) + 1]] <- createExposureOutcome(exposureId = allControls$targetId[i],
##                                                   outcomeId = allControls$outcomeId[i])
## }


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## sccResult <- runSccAnalyses(connectionDetails = connectionDetails,
##                             cdmDatabaseSchema = cdmDatabaseSchema,
##                             oracleTempSchema = oracleTempSchema,
##                             exposureTable = "drug_era",
##                             outcomeDatabaseSchema = outcomeDatabaseSchema,
##                             outcomeTable = outcomeTable,
##                             sccAnalysisList = sccAnalysisList,
##                             exposureOutcomeList = eos,
##                             outputFolder = outputFolder)
## sccSummary <- summarizeAnalyses(sccResult, outputFolder)
## write.csv(sccSummary, file.path(outputFolder, "sccSummary.csv"), row.names = FALSE)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## estimates <- readRDS(file.path(outputFolder, "sccSummary.csv"))
## estimates <- data.frame(analysisId = estimates$analysisId,
##                         targetId = estimates$exposureId,
##                         outcomeId = estimates$outcomeId,
##                         logRr = estimates$logRr,
##                         seLogRr = estimates$seLogRr,
##                         ci95Lb = estimates$irrLb95,
##                         ci95Ub = estimates$irrUb95)
## head(estimates)

## ----echo=FALSE,message=FALSE-------------------------------------------------
writeLines("  analysisId targetId outcomeId      logRr   seLogRr    ci95Lb    ci95Ub
1          1  1110942         1 -1.5000000        NA        NA 13.177433
2          1  1140088         1         NA        NA        NA        NA
3          1   943634         1         NA        NA        NA        NA
4          1 40163718         1 -0.4054651 0.6926191 0.1479317  2.234489
5          1  1350310         1 -0.2876821 0.7038381 0.1642789  2.592973
6          1  1311276         1 -0.1823216 0.5451585 0.2651910  2.247182")


## ----tidy=FALSE---------------------------------------------------------------
# Create a reference of the analysis settings:
analysisRef <- data.frame(method = "SelfControlledCohort",
                          analysisId = c(1, 2),
                          description = c("Length of exposure", 
                                          "30 days of each exposure"),
                          details = "",
                          comparative = FALSE,
                          nesting = FALSE,
                          firstExposureOnly = FALSE)
head(analysisRef)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## allControls <- read.csv(file.path(outputFolder , "allControls.csv"))
## packageOhdsiBenchmarkResults(estimates = estimates,
##                              controlSummary = allControls,
##                              analysisRef = analysisRef,
##                              databaseName = databaseName,
##                              exportFolder = file.path(outputFolder, "export"))


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## exportFolder <- file.path(outputFolder, "export")
## launchMethodEvaluationApp(exportFolder)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## exportFolder <- file.path(outputFolder, "export")
## metrics <- computeOhdsiBenchmarkMetrics(exportFolder,
##                                         mdrr = 1.25,
##                                         stratum = "All",
##                                         trueEffectSize = "Overall",
##                                         calibrated = FALSE,
##                                         comparative = FALSE)
## head(metrics)

## ----echo=FALSE,message=FALSE-------------------------------------------------
writeLines("   database               method analysisId                                           description  auc coverage   meanP  mse type1 type2 nonEstimable
1     CCAE SelfControlledCohort          1                    Length of exposure 0.89     0.21 1048.97 0.30  0.66  0.08         0.01
2     CCAE SelfControlledCohort          2                        30 days of each exposure 0.87     0.41  422.25 0.14  0.55  0.11         0.00")

