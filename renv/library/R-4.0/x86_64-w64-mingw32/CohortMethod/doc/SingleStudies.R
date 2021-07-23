## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
options(width = 200)
library(CohortMethod)


## ----eval=FALSE---------------------------------------------------------------
## install.packages("remotes")
## remotes::install_github("ohdsi/CohortMethod")


## ----eval=FALSE---------------------------------------------------------------
## connectionDetails <- createConnectionDetails(dbms = "postgresql",
##                                              server = "localhost/ohdsi",
##                                              user = "joe",
##                                              password = "supersecret")
## 
## cdmDatabaseSchema <- "my_cdm_data"
## resultsDatabaseSchema <- "my_results"
## options(sqlRenderTempEmulationSchema = NULL)


## ----eval=FALSE---------------------------------------------------------------
## library(SqlRender)
## sql <- readSql("coxibVsNonselVsGiBleed.sql")
## sql <- render(sql,
##               cdmDatabaseSchema = cdmDatabaseSchema,
##               resultsDatabaseSchema = resultsDatabaseSchema)
## sql <- translate(sql, targetDialect = connectionDetails$dbms)
## 
## connection <- connect(connectionDetails)
## executeSql(connection, sql)


## ----eval=FALSE---------------------------------------------------------------
## sql <- paste("SELECT cohort_definition_id, COUNT(*) AS count",
##              "FROM @resultsDatabaseSchema.coxibVsNonselVsGiBleed",
##              "GROUP BY cohort_definition_id")
## sql <- render(sql, resultsDatabaseSchema = resultsDatabaseSchema)
## sql <- translate(sql, targetDialect = connectionDetails$dbms)
## 
## querySql(connection, sql)

## ----echo=FALSE,message=FALSE-------------------------------------------------
data.frame(cohort_concept_id = c(1,2,3),count = c(50000,50000,15000))


## ----eval=FALSE---------------------------------------------------------------
## nsaids <- 21603933
## 
## # Define which types of covariates must be constructed:
## covSettings <- createDefaultCovariateSettings(excludedCovariateConceptIds = nsaids,
##                                               addDescendantsToExclude = TRUE)
## 
## #Load data:
## cohortMethodData <- getDbCohortMethodData(connectionDetails = connectionDetails,
##                                           cdmDatabaseSchema = cdmDatabaseSchema,
##                                           targetId = 1,
##                                           comparatorId = 2,
##                                           outcomeIds = 3,
##                                           studyStartDate = "",
##                                           studyEndDate = "",
##                                           exposureDatabaseSchema = resultsDatabaseSchema,
##                                           exposureTable = "coxibVsNonselVsGiBleed",
##                                           outcomeDatabaseSchema = resultsDatabaseSchema,
##                                           outcomeTable = "coxibVsNonselVsGiBleed",
##                                           cdmVersion = cdmVersion,
##                                           firstExposureOnly = TRUE,
##                                           removeDuplicateSubjects = TRUE,
##                                           restrictToCommonPeriod = FALSE,
##                                           washoutPeriod = 180,
##                                           covariateSettings = covSettings)
## cohortMethodData

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/cohortMethodData.zip")) {
  cohortMethodData <- loadCohortMethodData("s:/temp/cohortMethodVignette/cohortMethodData.zip")
}


## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/cohortMethodData.zip")) {
  cohortMethodData
}


## ----eval=FALSE---------------------------------------------------------------
## summary(cohortMethodData)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/cohortMethodData.zip")) {
  summary(cohortMethodData)
}


## ----eval=FALSE---------------------------------------------------------------
## saveCohortMethodData(cohortMethodData, "coxibVsNonselVsGiBleed.zip")


## ----eval=FALSE---------------------------------------------------------------
## studyPop <- createStudyPopulation(cohortMethodData = cohortMethodData,
##                                   outcomeId = 3,
##                                   firstExposureOnly = FALSE,
##                                   restrictToCommonPeriod = FALSE,
##                                   washoutPeriod = 0,
##                                   removeDuplicateSubjects = "keep all",
##                                   removeSubjectsWithPriorOutcome = TRUE,
##                                   minDaysAtRisk = 1,
##                                   riskWindowStart = 0,
##                                   startAnchor = "cohort start",
##                                   riskWindowEnd = 30,
##                                   endAnchor = "cohort end")


## ----eval=FALSE---------------------------------------------------------------
## getAttritionTable(studyPop)


## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/studyPop.rds")) {
  studyPop <- readRDS("s:/temp/cohortMethodVignette/studyPop.rds")
  table <- getAttritionTable(studyPop)
  truncLeft <- function(x, n){
    nc <- nchar(x)
    x[nc > (n - 3)] <- paste(substr(table$description[nc > (n - 3)], 1, n - 3), '...')
    x
  }
  table$description <- truncLeft(table$description,30)
  table
}


## ----eval=FALSE---------------------------------------------------------------
## ps <- createPs(cohortMethodData = cohortMethodData, population = studyPop)

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  ps <- readRDS("s:/temp/cohortMethodVignette/ps.rds")
}


## ----eval=FALSE---------------------------------------------------------------
## computePsAuc(ps)

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  0.81;#computePsAuc(ps)
}


## ----eval=FALSE---------------------------------------------------------------
## plotPs(ps,
##        scale = "preference",
##        showCountsLabel = TRUE,
##        showAucLabel = TRUE,
##        showEquiposeLabel = TRUE)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  plotPs(ps, scale = "preference", showCountsLabel = TRUE, showAucLabel = TRUE, showEquiposeLabel = TRUE)
}


## ----eval=FALSE---------------------------------------------------------------
## getPsModel(ps, cohortMethodData)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/cohortMethodData.zip")) {
  propensityModel <- getPsModel(ps, cohortMethodData)
  truncRight <- function(x, n){
    nc <- nchar(x)
    x[nc > (n - 3)] <- paste('...',substr(x[nc > (n - 3)], nc[nc > (n - 3)] - n + 1, nc[nc > (n - 3)]),sep = "")
    x
  }
  propensityModel$covariateName <- truncRight(as.character(propensityModel$covariateName), 40)
  head(propensityModel)
  }


## ----eval=FALSE---------------------------------------------------------------
## trimmedPop <- trimByPsToEquipoise(ps)
## plotPs(trimmedPop, ps, scale = "preference")

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  trimmedPop <- trimByPsToEquipoise(ps)
  plotPs(trimmedPop, ps, scale = "preference")
}


## ----eval=FALSE---------------------------------------------------------------
## stratifiedPop <- stratifyByPs(ps, numberOfStrata = 5)
## plotPs(stratifiedPop, ps, scale = "preference")

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  stratifiedPop <- stratifyByPs(ps, numberOfStrata = 5)
  plotPs(stratifiedPop, ps, scale = "preference")
}


## ----eval=FALSE---------------------------------------------------------------
##   matchedPop <- matchOnPs(ps, caliper = 0.2, caliperScale = "standardized logit", maxRatio = 1)
##   plotPs(matchedPop, ps)

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  matchedPop <- matchOnPs(ps, caliper = 0.2, caliperScale = "standardized logit", maxRatio = 1)
  plotPs(matchedPop, ps)
}


## ----eval=FALSE---------------------------------------------------------------
## getAttritionTable(matchedPop)


## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  getAttritionTable(matchedPop)
  table <- getAttritionTable(matchedPop)
  truncLeft <- function(x, n){
    nc <- nchar(x)
    x[nc > (n - 3)] <- paste(substr(table$description[nc > (n - 3)], 1, n - 3), '...')
    x
  }
  table$description <- truncLeft(table$description,30)
  table
}


## ----eval=FALSE---------------------------------------------------------------
## drawAttritionDiagram(matchedPop)

## ----echo=FALSE,message=FALSE,eval=TRUE,fig.width=5,fig.height=6--------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel3.rds")) {
  drawAttritionDiagram(matchedPop)
}


## ----eval=FALSE---------------------------------------------------------------
## balance <- computeCovariateBalance(matchedPop, cohortMethodData)

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/balance.rds")) {
  balance <- readRDS("s:/temp/cohortMethodVignette/balance.rds")
}

## ----eval=FALSE---------------------------------------------------------------
## plotCovariateBalanceScatterPlot(balance, showCovariateCountLabel = TRUE, showMaxLabel = TRUE)

## ----echo=FALSE,message=FALSE,eval=TRUE,fig.width=7,fig.height=4.5------------
if (file.exists("s:/temp/cohortMethodVignette/balance.rds")) {
  plotCovariateBalanceScatterPlot(balance, 
                                  showCovariateCountLabel = TRUE, 
                                  showMaxLabel = TRUE)
}

## ----eval=FALSE---------------------------------------------------------------
## plotCovariateBalanceOfTopVariables(balance)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE,fig.width=8,fig.height=5----
if (file.exists("s:/temp/cohortMethodVignette/balance.rds")) {
  plotCovariateBalanceOfTopVariables(balance)
}


## ----eval=FALSE---------------------------------------------------------------
## createCmTable1(balance)


## ----comment=NA,echo=FALSE,message=FALSE--------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/balance.rds")) {
  table1 <- createCmTable1(balance)
  print(table1, row.names = FALSE, right = FALSE)
}


## ----eval=FALSE---------------------------------------------------------------
## insertDbPopulation(population = matchedPop,
##                    cohortIds = c(101,100),
##                    connectionDetails = connectionDetails,
##                    cohortDatabaseSchema = resultsDatabaseSchema,
##                    cohortTable = "coxibVsNonselVsGiBleed",
##                    createTable = FALSE,
##                    cdmVersion = cdmVersion)


## ----eval=FALSE---------------------------------------------------------------
## computeMdrr(population = studyPop,
##             modelType = "cox",
##             alpha = 0.05,
##             power = 0.8,
##             twoSided = TRUE)


## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/studyPop.rds")) {
computeMdrr(population = studyPop,
            modelType = "cox",
            alpha = 0.05,
            power = 0.8,
            twoSided = TRUE)
}


## ----eval=FALSE---------------------------------------------------------------
## computeMdrr(population = matchedPop,
##             modelType = "cox",
##             alpha = 0.05,
##             power = 0.8,
##             twoSided = TRUE)


## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/studyPop.rds")) {
computeMdrr(population = matchedPop,
            modelType = "cox",
            alpha = 0.05,
            power = 0.8,
            twoSided = TRUE)
}


## ----eval=FALSE---------------------------------------------------------------
## getFollowUpDistribution(population = matchedPop)

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/studyPop.rds")) {
getFollowUpDistribution(population = matchedPop)
}


## ----eval=FALSE---------------------------------------------------------------
## plotFollowUpDistribution(population = matchedPop)

## ----echo=FALSE,message=FALSE,eval=TRUE,fig.width=8,fig.height=5--------------
if (file.exists("s:/temp/cohortMethodVignette/studyPop.rds")) {
plotFollowUpDistribution(population = matchedPop)
}


## ----eval=FALSE---------------------------------------------------------------
## outcomeModel <- fitOutcomeModel(population = studyPop,
##                                 modelType = "cox")
## outcomeModel

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel1.rds")) {
  outcomeModel <- readRDS("s:/temp/cohortMethodVignette/OutcomeModel1.rds")
  outcomeModel
}


## ----eval=FALSE---------------------------------------------------------------
## outcomeModel <- fitOutcomeModel(population = matchedPop,
##                                 modelType = "cox",
##                                 stratified = TRUE)
## outcomeModel

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel2.rds")) {
  outcomeModel <- readRDS("s:/temp/cohortMethodVignette/OutcomeModel2.rds")
  outcomeModel
}


## ----eval=FALSE---------------------------------------------------------------
## outcomeModel <- fitOutcomeModel(population = ps,
##                                 modelType = "cox",
##                                 inversePtWeighting = TRUE)
## outcomeModel

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel2w.rds")) {
  outcomeModel <- readRDS("s:/temp/cohortMethodVignette/OutcomeModel2w.rds")
  outcomeModel
}


## ----eval=FALSE---------------------------------------------------------------
## interactionCovariateIds <- c(8532001, 201826210, 21600960413)
## # 8532001 = Female
## # 201826210 = Type 2 Diabetes
## # 21600960413 = Concurent use of antithrombotic agents
## outcomeModel <- fitOutcomeModel(population = matchedPop,
##                                 modelType = "cox",
##                                 stratified = TRUE,
##                                 interactionCovariateIds = interactionCovariateIds)
## outcomeModel


## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel4.rds")) {
  outcomeModel <- readRDS("s:/temp/cohortMethodVignette/OutcomeModel4.rds")
  outcomeModel
}


## ----eval=FALSE---------------------------------------------------------------
## balanceFemale <- computeCovariateBalance(population = matchedPop,
##                                          cohortMethodData = cohortMethodData,
##                                          subgroupCovariateId = 8532001)
## plotCovariateBalanceScatterPlot(balanceFemale)

## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE,fig.width=8,fig.height=5----
if (file.exists("s:/temp/cohortMethodVignette/balanceFemale.rds")) {
  balanceFemale <- readRDS("s:/temp/cohortMethodVignette/balanceFemale.rds")
  plotCovariateBalanceScatterPlot(balanceFemale)
}


## ----eval=FALSE---------------------------------------------------------------
## outcomeModel <- fitOutcomeModel(population = matchedPop,
##                                 cohortMethodData = cohortMethodData,
##                                 modelType = "cox",
##                                 stratified = TRUE,
##                                 useCovariates = TRUE)
## outcomeModel

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel3.rds")) {
  outcomeModel <- readRDS("s:/temp/cohortMethodVignette/OutcomeModel3.rds")
  outcomeModel
}


## ----eval=FALSE---------------------------------------------------------------
## exp(coef(outcomeModel))

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel3.rds")) {
  exp(coef(outcomeModel))
}


## ----eval=FALSE---------------------------------------------------------------
## exp(confint(outcomeModel))

## ----echo=FALSE,message=FALSE,eval=TRUE---------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel3.rds")) {
  exp(confint(outcomeModel))
}


## ----eval=FALSE---------------------------------------------------------------
## getOutcomeModel(outcomeModel, cohortMethodData)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists("s:/temp/cohortMethodVignette/OutcomeModel3.rds")) {
  outcomeModel <- getOutcomeModel(outcomeModel, cohortMethodData)
  truncRight <- function(x, n){
    nc <- nchar(x)
    x[nc > (n - 3)] <- paste('...',substr(x[nc > (n - 3)], nc[nc > (n - 3)] - n + 1, nc[nc > (n - 3)]),sep = "")
    x
  }
  outcomeModel$name <- truncRight(as.character(outcomeModel$name), 40)
  outcomeModel
}


## ----eval=FALSE---------------------------------------------------------------
## plotKaplanMeier(matchedPop, includeZero = FALSE)

## ----echo=FALSE, message=FALSE, results='hide'--------------------------------
if (file.exists("s:/temp/cohortMethodVignette/ps.rds")) {
  plotKaplanMeier(matchedPop, includeZero = FALSE)
}


## ----eval=FALSE---------------------------------------------------------------
## plotTimeToEvent(cohortMethodData = cohortMethodData,
##                 outcomeId = 3,
##                 firstExposureOnly = FALSE,
##                 washoutPeriod = 0,
##                 removeDuplicateSubjects = FALSE,
##                 minDaysAtRisk = 1,
##                 riskWindowStart = 0,
##                 startAnchor = "cohort start",
##                 riskWindowEnd = 30,
##                 endAnchor = "cohort end")
## 

## ----echo=FALSE, message=FALSE, results='hide'--------------------------------
if (file.exists("s:/temp/cohortMethodVignette/cohortMethodData.zip")) {
  plotTimeToEvent(cohortMethodData = cohortMethodData,
                  outcomeId = 3,
                  firstExposureOnly = FALSE,
                  washoutPeriod = 0,
                  removeDuplicateSubjects = FALSE,
                  minDaysAtRisk = 1,
                  riskWindowStart = 0,
                  startAnchor = "cohort start",
                  riskWindowEnd = 30,
                  endAnchor = "cohort end")
  
}


## ----eval=TRUE----------------------------------------------------------------
citation("CohortMethod")


## ----eval=TRUE----------------------------------------------------------------
citation("Cyclops")

