## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
library(ParallelLogger)


## -----------------------------------------------------------------------------
logger <- createLogger(name = "SIMPLE",
                       threshold = "INFO",
                       appenders = list(createConsoleAppender(layout = layoutTimestamp)))

registerLogger(logger)

logTrace("This event is below the threshold (INFO)")

logInfo("Hello world")


## -----------------------------------------------------------------------------
clearLoggers()

logger <- createLogger(name = "SIMPLE",
                       threshold = "INFO",
                       appenders = list(createConsoleAppender(layout = layoutTimestamp)))

registerLogger(logger)

logInfo("Hello world")


## ---- eval=FALSE--------------------------------------------------------------
## addDefaultConsoleLogger()


## ---- eval=FALSE--------------------------------------------------------------
## registerLogger(createLogger(name = "DEFAULT_CONSOLE_LOGGER",
##                             threshold = "INFO",
##                             appenders = list(createConsoleAppender(layout = layoutSimple))))


## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
logFileName <- tempfile()

## ---- eval=FALSE--------------------------------------------------------------
## logFileName <- "log.txt"

## -----------------------------------------------------------------------------
logger <- createLogger(name = "PARALLEL",
                       threshold = "TRACE",
                       appenders = list(createFileAppender(layout = layoutParallel,
                                                           fileName = logFileName)))
registerLogger(logger)

logTrace("Executed this line")

logDebug("There are ",  length(getLoggers()), " loggers")

logInfo("Hello world")


## -----------------------------------------------------------------------------
writeLines(readChar(logFileName, file.info(logFileName)$size))


## -----------------------------------------------------------------------------
unlink(logFileName)


## ---- eval=FALSE--------------------------------------------------------------
## addDefaultFileLogger(logFileName)


## ---- eval=FALSE--------------------------------------------------------------
## registerLogger(createLogger(name = "DEFAULT_FILE_LOGGER",
##                             threshold = "TRACE",
##                             appenders = list(createFileAppender(layout = layoutParallel,
##                                                                 fileName = logFileName))))


## ---- eval=FALSE--------------------------------------------------------------
## addDefaultErrorReportLogger()


## ---- eval=FALSE--------------------------------------------------------------
## fileName <- file.path(getwd(), "errorReportR.txt")
## 
## registerLogger(createLogger(name = "DEFAULT_ERRORREPORT_LOGGER",
##                             threshold = "FATAL",
##                             appenders = list(createFileAppender(layout = layoutErrorReport,
##                                                                 fileName = fileName,
##                                                                 overwrite = TRUE,
##                                                                 expirationTime = 60))))


## ---- eval=FALSE--------------------------------------------------------------
## mailSettings <- list(from = "someone@gmail.com",
## to = c("someone_else@gmail.com"),
## smtp = list(host.name = "smtp.gmail.com",
## port = 465,
## user.name = "someone@gmail.com",
## passwd = "super_secret!",
## ssl = TRUE),
## authenticate = TRUE,
## send = TRUE)
## 
## logger <- createLogger(name = "EMAIL",
## threshold = "FATAL",
## appenders = list(createEmailAppender(layout = layoutEmail,
## mailSettings = mailSettings)))
## registerLogger(logger)
## 
## logFatal("No more data to process")


## ---- eval=FALSE--------------------------------------------------------------
## addDefaultEmailLogger(mailSettings)


## ---- eval=FALSE--------------------------------------------------------------
## registerLogger(createLogger(name = "DEFAULT_EMAIL_LOGGER",
## threshold = "FATAL",
## appenders = list(createEmailAppender(layout = layoutEmail,
## mailSettings = mailSettings))))


## ---- eval=FALSE--------------------------------------------------------------
## clearLoggers()
## addDefaultFileLogger(logFileName)
## 
## warning("Danger!")
## 
## # This throws a warning:
## as.numeric('a')
## 
## # This throws an error:
## a <- b
## 
## writeLines(readChar(logFileName, file.info(logFileName)$size))

## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
# knitr seems to use the same hook to capture warnings and errors, so minor cheat here:
clearLoggers()
addDefaultFileLogger(logFileName)
logWarn("Danger!")
logWarn("Warning: NAs introduced by coercion")
logFatal("Error: object a not found")
writeLines(readChar(logFileName, file.info(logFileName)$size))


## -----------------------------------------------------------------------------
unlink(logFileName) # Clean up log file from the previous example
clearLoggers() # Clean up the loggers from the previous example

addDefaultFileLogger(logFileName)

cluster <- makeCluster(3)

fun <- function(x) {
  ParallelLogger::logInfo("The value of x is ", x)
  # Do something
  if (x == 6)
    ParallelLogger::logDebug("X equals 6")
  return(NULL)
}

dummy <- clusterApply(cluster, 1:10, fun, progressBar = FALSE)

stopCluster(cluster)

writeLines(readChar(logFileName, file.info(logFileName)$size))


## ---- eval=FALSE--------------------------------------------------------------
## subSubTask <- function() {
##   addDefaultFileLogger("subSubTaskLog.txt")
##   # do something
## }
## 
## subTask <- function() {
##   addDefaultFileLogger("subTaskLog.txt")
##   # do something
##   subSubTask()
## }
## 
## mainTask <- function() {
##   addDefaultFileLogger("mainTaskLog.txt")
##   # do something
##   subTask()
## }


## ---- eval=FALSE--------------------------------------------------------------
## subSubTask <- function() {
##   # do something
## }
## 
## subTask <- function() {
##   # do something
##   subSubTask()
## }
## 
## mainTask <- function() {
##   addDefaultFileLogger("log.txt")
##   # do something
##   subTask()
## }


## ---- eval=FALSE--------------------------------------------------------------
## mainTask <- function() {
##   addDefaultFileLogger("log.txt")
##   on.exit(unregisterLogger("DEFAULT_FILE_LOGGER"))
##   # do something
## }


## ---- eval=FALSE--------------------------------------------------------------
## launchLogViewer(logFileName)


## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
unlink(logFileName)

