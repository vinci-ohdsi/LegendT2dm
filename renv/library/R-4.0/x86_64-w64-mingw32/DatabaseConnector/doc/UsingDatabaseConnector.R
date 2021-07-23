## ---- echo = FALSE, message = FALSE-------------------------------------------
library(DatabaseConnector)
oldJarFolder <- Sys.getenv("DATABASECONNECTOR_JAR_FOLDER")
Sys.setenv("DATABASECONNECTOR_JAR_FOLDER" = tempdir())

## ----eval=FALSE---------------------------------------------------------------
#  Sys.setenv("DATABASECONNECTOR_JAR_FOLDER" = "c:/temp/jdbcDrivers")

## ----eval=FALSE---------------------------------------------------------------
#  downloadJdbcDrivers("postgresql")

## ----echo=FALSE---------------------------------------------------------------
writeLines("DatabaseConnector JDBC drivers downloaded to 'c:/temp/jdbcDrivers'.")

## ----eval=FALSE---------------------------------------------------------------
#  ?jdbcDrivers

## ----eval=FALSE---------------------------------------------------------------
#  install.packages("RSQLite")

## ----eval=FALSE---------------------------------------------------------------
#  conn <- connect(dbms = "postgresql",
#                  server = "localhost/postgres",
#                  user = "joe",
#                  password = "secret")

## ----echo=FALSE---------------------------------------------------------------
writeLines("Connecting using PostgreSQL driver")

## ----eval=FALSE---------------------------------------------------------------
#  disconnect(conn)

## ----eval=FALSE---------------------------------------------------------------
#  conn <- connect(dbms = "postgresql",
#                  connectionString = "jdbc:postgresql://localhost:5432/postgres",
#                  user = "joe",
#                  password = "secret")

## ----echo=FALSE---------------------------------------------------------------
writeLines("Connecting using PostgreSQL driver")

## ----eval=FALSE---------------------------------------------------------------
#  details <- createConnectionDetails(dbms = "postgresql",
#                                     server = "localhost/postgres",
#                                     user = "joe",
#                                     password = "secret")
#  conn <- connect(details)

## ----echo=FALSE---------------------------------------------------------------
writeLines("Connecting using PostgreSQL driver")

## ----eval=FALSE---------------------------------------------------------------
#  querySql(conn, "SELECT TOP 3 * FROM person")

## ----echo=FALSE---------------------------------------------------------------
data.frame(PERSON_ID = c(1,2,3), GENDER_CONCEPT_ID = c(8507, 8507, 8507), YEAR_OF_BIRTH = c(1975, 1976, 1977))

## ----eval=FALSE---------------------------------------------------------------
#  executeSql(conn, "TRUNCATE TABLE foo; DROP TABLE foo; CREATE TABLE foo (bar INT);")

## ----eval=FALSE---------------------------------------------------------------
#  library(Andromeda)
#  x <- andromeda()
#  querySqlToAndromeda(conn, "SELECT * FROM person", andromeda = x, andromedaTableName = "person)

## ----eval=FALSE---------------------------------------------------------------
#  persons <- renderTranslatequerySql(conn,
#                                     sql = "SELECT TOP 10 * FROM @schema.person",
#                                     schema = "cdm_synpuf")

## ----eval=FALSE---------------------------------------------------------------
#  data(mtcars)
#  insertTable(conn, "mtcars", mtcars, createTable = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  conn <- dbConnect(DatabaseConnectorDriver(),
#                    dbms = "postgresql",
#                    server = "localhost/postgres",
#                    user = "joe",
#                    password = "secret")

## ----echo=FALSE---------------------------------------------------------------
writeLines("Connecting using PostgreSQL driver")

## ----eval=FALSE---------------------------------------------------------------
#  dbIsValid(conn)

## ----echo=FALSE---------------------------------------------------------------
TRUE

## ----eval=FALSE---------------------------------------------------------------
#  res <- dbSendQuery(conn, "SELECT TOP 3 * FROM person")
#  dbFetch(res)

## ----echo=FALSE---------------------------------------------------------------
data.frame(PERSON_ID = c(1,2,3), GENDER_CONCEPT_ID = c(8507, 8507, 8507), YEAR_OF_BIRTH = c(1975, 1976, 1977))

## ----eval=FALSE---------------------------------------------------------------
#  dbHasCompleted(res)

## ----echo=FALSE---------------------------------------------------------------
TRUE

## ----eval=FALSE---------------------------------------------------------------
#  dbClearResult(res)
#  dbDisconnect(res)

## -----------------------------------------------------------------------------
conn <- connect(dbms = "sqlite", server = tempfile())

# Upload cars dataset as table:
insertTable(connection = conn, 
            tableName = "cars", 
            data = cars)

querySql(conn, "SELECT COUNT(*) FROM main.cars;")

disconnect(conn)

## ---- echo = FALSE, message = FALSE-------------------------------------------
Sys.setenv("DATABASECONNECTOR_JAR_FOLDER" = oldJarFolder)

