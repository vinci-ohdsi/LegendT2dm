source("DataPulls.R")
source("PlotsAndTables.R")

# shinySettings <- list(dataFolder = "s:/SkeletonComparativeEffectStudy/AllResults/shinyData", blind = F)
dataFolder <- shinySettings$dataFolder
blind <- shinySettings$blind
connection <- NULL
positiveControlOutcome <- NULL

cohortMask <- readr::read_csv(system.file("settings", "masks.csv", package = "LegendT2dm"))
propensityScoreMask <- tibble::tibble(
  label = c("unadjusted", "matched", "stratified"),
  index = c(1, 2, 3)
)

timeAtRiskMask <- tibble::tibble(
  label = c("Intent-to-treat (ITT)", "On-treatment (OT)", "OT and censor at +agent"),
  multiplier = c(1, 0, 2)
)

mapAnalysisIdForBalance <- function(analysisId) {
  map <- c(1,5,6,
           4,5,6,
           7,5,6)
  return(map[analysisId])
}

outcomeInfo <- readr::read_csv(system.file("settings", "OutcomesOfInterest.csv", package = "LegendT2dm"))

splittableTables <- c("covariate_balance", "preference_score_dist", "kaplan_meier_dist")

files <- list.files(dataFolder, pattern = ".rds")

# Find part to remove from all file names (usually databaseId):
databaseFileName <- files[grepl("^database", files)]
removeParts <- paste0(gsub("database", "", databaseFileName), "$")

# Remove data already in global environment:
for (removePart in removeParts) {
  tableNames <- gsub("_t[0-9]+_c[0-9]+$", "", gsub(removePart, "", files[grepl(removePart, files)]))
  camelCaseNames <- SqlRender::snakeCaseToCamelCase(tableNames)
  camelCaseNames <- unique(camelCaseNames)
  camelCaseNames <- camelCaseNames[!(camelCaseNames %in% SqlRender::snakeCaseToCamelCase(splittableTables))]
  suppressWarnings(
    rm(list = camelCaseNames)
  )
}

# Load data from data folder. R data objects will get names derived from the filename:
loadFile <- function(file, removePart) {
  tableName <- gsub("_t[0-9]+_c[0-9]+$", "", gsub(removePart, "", file))
  camelCaseName <- SqlRender::snakeCaseToCamelCase(tableName)
  if (!(tableName %in% splittableTables)) {
    newData <- readRDS(file.path(dataFolder, file))
    colnames(newData) <- SqlRender::snakeCaseToCamelCase(colnames(newData))
    if (exists(camelCaseName, envir = .GlobalEnv)) {
      existingData <- get(camelCaseName, envir = .GlobalEnv)
      newData$tau <- NULL
      newData$traditionalLogRr <- NULL
      newData$traditionalSeLogRr <- NULL
      if (!all(colnames(newData) %in% colnames(existingData))) {
         stop(sprintf("Columns names do not match in %s. \nObserved:\n %s, \nExpecting:\n %s",
                      file,
                      paste(colnames(newData), collapse = ", "),
                      paste(colnames(existingData), collapse = ", ")))

      }
      newData <- rbind(existingData, newData)
      newData <- unique(newData)
    }
    assign(camelCaseName, newData, envir = .GlobalEnv)
  }
  invisible(NULL)
}
# removePart <- removeParts[2]
file <- files[grepl(removePart, files)][1]
for (removePart in removeParts) {
  invisible(lapply(files[grepl(removePart, files)], loadFile, removePart))
}

tcos <- unique(cohortMethodResult[, c("targetId", "comparatorId", "outcomeId")])
tcos <- tcos[tcos$outcomeId %in% outcomeOfInterest$outcomeId, ]
metaAnalysisDbIds <- database$databaseId[database$isMetaAnalysis == 1]

