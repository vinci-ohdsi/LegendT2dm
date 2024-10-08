rJava::.jinit(parameters="-Xmx100g", force.init = TRUE)
options(java.parameters = c("-Xms200g", "-Xmx200g"))

library(LegendT2dm)

Sys.setenv(DATABASECONNECTOR_JAR_FOLDER="d:/Drivers")
options(andromedaTempFolder = "E:/andromedaTemp")
oracleTempSchema <- NULL

# Feb 2023: fast forward data version to the latest accessible
# cdmDatabaseSchema <- "cdm_truven_ccae_v2182"
# serverSuffix <- "truven_ccae"
# cohortDatabaseSchema <- "scratch_fbu2"
# databaseId <- "CCAE"
# databaseName <- "IBM Health MarketScan Commercial Claims and Encounters Database"
# databaseDescription <- "IBM Health MarketScan® Commercial Claims and Encounters Database (CCAE) represent data from individuals enrolled in United States employer-sponsored insurance health plans. The data includes adjudicated health insurance claims (e.g. inpatient, outpatient, and outpatient pharmacy) as well as enrollment data from large employers and health plans who provide private healthcare coverage to employees, their spouses, and dependents. Additionally, it captures laboratory tests for a subset of the covered lives. This administrative claims database includes a variety of fee-for-service, preferred provider organizations, and capitated health plans."
# tablePrefix <- "legend_t2dm_ccae"
# outputFolder <- "E:/LegendT2dmOutput_ccae_drug2"

# # Feb 2023: fast forward data version to the latest accessible
# cdmDatabaseSchema <- "cdm_optum_ehr_v2247" #v2137
# serverSuffix <- "optum_ehr"
# cohortDatabaseSchema <- "scratch_fbu2"
# databaseId <- "OptumEHR"
# databaseName <- "Optum© de-identified Electronic Health Record Dataset"
# databaseDescription <- "Optum© de-identified Electronic Health Record Dataset represents Humedica’s Electronic Health Record data a medical records database. The medical record data includes clinical information, inclusive of prescriptions as prescribed and administered, lab results, vital signs, body measurements, diagnoses, procedures, and information derived from clinical Notes using Natural Language Processing (NLP)."
# tablePrefix <- "legend_t2dm_optum_ehr"
# outputFolder <- "E:/LegendT2dmOutput_optum_ehr_drug2"

# Feb 2023: fast forward data version to the latest accessible
# cdmDatabaseSchema <- "cdm_truven_mdcr_v2322" #v2183
# serverSuffix <- "truven_mdcr"
# cohortDatabaseSchema <- "scratch_fbu2"
# databaseId<- "MDCR"
# databaseName <- "IBM Health MarketScan Medicare Supplemental and Coordination of Benefits Database"
# databaseDescription <- "IBM Health MarketScan® Medicare Supplemental and Coordination of Benefits Database (MDCR) represents health services of retirees in the United States with primary or Medicare supplemental coverage through privately insured fee-for-service, point-of-service, or capitated health plans. These data include adjudicated health insurance claims (e.g. inpatient, outpatient, and outpatient pharmacy). Additionally, it captures laboratory tests for a subset of the covered lives."
# tablePrefix <- "legend_t2dm_mdcr"
# outputFolder <- "E:/LegendT2dmOutput_mdcr_drug2"

# # Feb 2023: fast forward data version to the latest accessible
# TBD: run drug-level study on MDCD
cdmDatabaseSchema <- "cdm_truven_mdcd_v2321" #v2128
serverSuffix <- "truven_mdcd"
cohortDatabaseSchema <- "scratch_fbu2"
databaseId<- "MDCD"
databaseName <- "IBM Health MarketScan® Multi-State Medicaid Database"
databaseDescription <- "IBM MarketScan® Multi-State Medicaid Database (MDCD) adjudicated US health insurance claims for Medicaid enrollees from multiple states and includes hospital discharge diagnoses, outpatient diagnoses and procedures, and outpatient pharmacy claims as well as ethnicity and Medicare eligibility. Members maintain their same identifier even if they leave the system for a brief period however the dataset lacks lab data."
tablePrefix <- "legend_t2dm_mdcd"
outputFolder <- "E:/LegendT2dmOutput_mdcd_drug2"

# # Feb 2023: fast forward data version to the latest accessible
cdmDatabaseSchema <- "cdm_optum_extended_dod_v2323" #v2228 #v2134
serverSuffix <- "optum_extended_dod"
cohortDatabaseSchema <- "scratch_fbu2"
databaseId <- "OptumDod"
databaseName <- "Optum Clinformatics Extended Data Mart - Date of Death (DOD)"
databaseDescription <- "Optum Clinformatics Extended DataMart is an adjudicated US administrative health claims database for members of private health insurance, who are fully insured in commercial plans or in administrative services only (ASOs), Legacy Medicare Choice Lives (prior to January 2006), and Medicare Advantage (Medicare Advantage Prescription Drug coverage starting January 2006).  The population is primarily representative of commercial claims patients (0-65 years old) with some Medicare (65+ years old) however ages are capped at 90 years.  It includes data captured from administrative claims processed from inpatient and outpatient medical services and prescriptions as dispensed, as well as results for outpatient lab tests processed by large national lab vendors who participate in data exchange with Optum.  This dataset also provides date of death (month and year only) for members with both medical and pharmacy coverage from the Social Security Death Master File (however after 2011 reporting frequency changed due to changes in reporting requirements) and location information for patients is at the US state level."
tablePrefix <- "legend_t2dm_optum_dod"
outputFolder <- "E:/LegendT2dmOutput_optum_dod_drug2"


conn <- DatabaseConnector::createConnectionDetails(
  dbms = "redshift",
  server = paste0(keyring::key_get("epi_server"), "/", !!serverSuffix),
  port = 5439,
  user = keyring::key_get("redshiftUser"),
  password = keyring::key_get("redshiftPassword"),
  extraSettings = "ssl=true&sslfactory=com.amazon.redshift.ssl.NonValidatingFactory",
  pathToDriver = 'D:/Drivers')

# ## DO NOT RUN: connecting to database
# connection = DatabaseConnector::connect(conn)
# DatabaseConnector::disconnect(connection)

# Feasibility assessment ---------------------------------------------------------
assessPhenotypes(connectionDetails = conn,
                 cdmDatabaseSchema = cdmDatabaseSchema,
                 oracleTempSchema = oracleTempSchema,
                 cohortDatabaseSchema = cohortDatabaseSchema,
                 outputFolder = outputFolder,
                 tablePrefix = tablePrefix,
                 indicationId = 'drug',
                 databaseId = databaseId,
                 databaseName = databaseName,
                 databaseDescription = databaseDescription,
                 createExposureCohorts = TRUE,
                 runExposureCohortDiagnostics = TRUE,
                 createOutcomeCohorts = TRUE,
                 runOutcomeCohortDiagnostics = FALSE) #TRUE)

assessPropensityModels(connectionDetails = conn,
                       cdmDatabaseSchema = cdmDatabaseSchema,
                       tablePrefix = tablePrefix,
                       indicationId = 'drug',
                       oracleTempSchema = oracleTempSchema,
                       cohortDatabaseSchema = cohortDatabaseSchema,
                       outputFolder = outputFolder,
                       databaseId = databaseId,
                       maxCores = 16)


# Cohort Explorer
# to check one example cohort
# CohortDiagnostics::launchCohortExplorer(connectionDetails = conn,
#                                         cdmDatabaseSchema = cdmDatabaseSchema,
#                                         cohortDatabaseSchema = cohortDatabaseSchema,
#                                         cohortTable = paste0(tablePrefix,'_',
#                                                              'dpp4i','_cohort'),
#                                         cohortId = 111100000)

# check out cohort table rows first to make sure things are there
# connection = connect(conn)
# sql = 'SELECT *
#       FROM scratch_fbu2.legend_t2dm_mdcr_dpp4i_cohort'
# sql <- SqlRender::translate(sql, targetDialect = connection@dbms)
# allCohorts <- DatabaseConnector::querySql(connection, sql)


## test code? only run one section
# execute(connectionDetails = connectionDetails,
#         cdmDatabaseSchema = cdmDatabaseSchema,
#         oracleTempSchema = oracleTempSchema,
#         cohortDatabaseSchema = cohortDatabaseSchema,
#         outputFolder = outputFolder,
#         indicationId = "class",
#         databaseId = databaseId,
#         databaseName = databaseName,
#         databaseDescription = databaseDescription,
#         tablePrefix = tablePrefix,
#         createExposureCohorts = FALSE,
#         createOutcomeCohorts = FALSE,
#         fetchAllDataFromServer = FALSE,
#         generateAllCohortMethodDataObjects = FALSE,
#         runCohortMethod = FALSE,
#         runSections = c(1),
#         computeCovariateBalance = FALSE,
#         exportToCsv = TRUE,
#         maxCores = 16)

## full-on execution of CES; run all sections of analyses
execute(connectionDetails = conn,
        cdmDatabaseSchema = cdmDatabaseSchema,
        oracleTempSchema = oracleTempSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        outputFolder = outputFolder,
        indicationId = "drug",
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription,
        minCohortSize = 1000,
        tablePrefix = tablePrefix,
        createExposureCohorts = FALSE,
        createOutcomeCohorts = FALSE,
        fetchAllDataFromServer = FALSE,
        generateAllCohortMethodDataObjects = FALSE,
        runCohortMethod = TRUE,
        runSections = c(1:7),
        computeCovariateBalance = TRUE,
        exportToCsv = TRUE,
        maxCores = 10)

# re-run compute covariate and results export
exportSettings = LegendT2dm:::createExportSettings(exportAnalysisInfo = FALSE,
                                                   exportStudyResults = FALSE,
                                                   exportStudyDiagnostics = TRUE,
                                                   exportDateTimeInfo = FALSE,
                                                   exportBalanceOnly = TRUE)
execute(
  connectionDetails = conn,
  cdmDatabaseSchema = cdmDatabaseSchema,
  oracleTempSchema = oracleTempSchema,
  cohortDatabaseSchema = cohortDatabaseSchema,
  outputFolder = outputFolder,
  indicationId = "drug",
  databaseId = databaseId,
  databaseName = databaseName,
  databaseDescription = databaseDescription,
  tablePrefix = tablePrefix,
  createExposureCohorts = FALSE,
  createOutcomeCohorts = FALSE,
  fetchAllDataFromServer = FALSE,
  generateAllCohortMethodDataObjects = FALSE,
  runCohortMethod = FALSE,
  runSections = c(1:7),
  computeCovariateBalance = TRUE,
  exportToCsv = TRUE,
  exportSettings = exportSettings,
  maxCores = 16
)


#### test staged execution code on a big JnJ data source ----
# prepareStagedExecution(originalOutputFolder = outputFolder,
#                        outputFolderHeader = outputFolder,
#                        indicationId = "drug",
#                        stages = 10)
#
# ## try this out (only run the first 1/10 of target-comparator pairs):
# newOutputFolder1 = file.path(paste0(outputFolder, "-1"))
#
# indicationId = "drug"
#
# execute(connectionDetails = conn,
#         cdmDatabaseSchema = cdmDatabaseSchema,
#         oracleTempSchema = oracleTempSchema,
#         cohortDatabaseSchema = cohortDatabaseSchema,
#         outputFolder = newOutputFolder1,
#         indicationId = indicationId,
#         databaseId = databaseId,
#         databaseName = databaseName,
#         databaseDescription = databaseDescription,
#         tablePrefix = tablePrefix,
#         createExposureCohorts = FALSE,
#         createOutcomeCohorts = FALSE,
#         createPairedExposureSummary = FALSE,
#         fetchAllDataFromServer = FALSE,
#         generateAllCohortMethodDataObjects = TRUE,
#         runCohortMethod = TRUE,
#         computeCovariateBalance = TRUE,
#         exportToCsv = TRUE,
#         maxCores = 16)
