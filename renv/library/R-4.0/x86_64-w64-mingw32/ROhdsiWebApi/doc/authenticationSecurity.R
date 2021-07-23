## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

# Note: This vignette simulates interaction with a WebAPI endpoint for 
# demonstration purposes but is written so that it can be rendered to html
# without relying on any external resources like a WebAPI endpoint.


## h1  {

##   margin-top: 60px;

## }


## ---- eval=FALSE--------------------------------------------------------------
## library(ROhdsiWebApi)
## baseUrl <- "https://yourSecureAtlas.ohdsi.org/"
## getCdmSources(baseUrl)

## ---- error=TRUE, echo=FALSE--------------------------------------------------
stop("Error: http error 401: Unauthorized request. Try running `authorizeWebAPI()`")


## ---- eval=FALSE--------------------------------------------------------------
## authorizeWebApi(baseUrl,
##                 authMethod = "db",
##                 webApiUsername = Sys.getenv("WEBAPI_USERNAME"),
##                 webApiPassword = Sys.getenv("WEBAPI_PASSWORD"))
## 


## ---- eval=FALSE--------------------------------------------------------------
## authorizeWebApi(baseUrl, authMethod = "windows")


## ---- eval=FALSE--------------------------------------------------------------
## ls(ROhdsiWebApi:::ROWebApiEnv)


## ---- echo=FALSE--------------------------------------------------------------
print("https://yourSecureAtlas.ohdsi.org/")


## ---- eval=FALSE--------------------------------------------------------------
## ROhdsiWebApi:::ROWebApiEnv[["https://yourSecureAtlas.ohdsi.org/"]]


## ---- echo=FALSE--------------------------------------------------------------
cat('$authHeader
[1] "Bearer gSyJhbzciOiJI0ZUxMiJ9.eyJzdWIiOIJhZGFtLx57wgSyJhb..."')


## ---- eval=FALSE--------------------------------------------------------------
## getCdmSources(baseUrl)


## ---- echo=FALSE--------------------------------------------------------------
tibble::tibble(sourceId = 911:912, 
               sourceName = c("SynPUF 110k", "SynPUF 2.3m"), 
               sourceKey = c("synpuf-110k", "synpuf-2m"), 
               sourceDialect = c("postgresql", "postgresql"), 
               cdmDatabaseSchema = c("cdm_531", "cdm_531"), 
               vocabDatabaseSchema = c("cdm_531", "cdm_531"), 
               resultsDatabaseSchema = c("results_atlas_278", "results_atlas_278")) 


## ---- eval=FALSE--------------------------------------------------------------
## baseUrl <- "https://atlas.ohdsi.org/WebAPI"
## 
## # Bearer copied from Google developer tools
## token <- "Bearer eyJsdfiem3Mcju7KRc4cCI6MTYxNDk5MTMxNX0.oVFpFnvhFK3SqYlRhdj"
## 
## setAuthHeader(baseUrl, authHeader = token)
## 
## getCdmSources(baseUrl)


## ---- echo=FALSE--------------------------------------------------------------
tibble::tibble(sourceId = 1L, 
               sourceName = "SYNPUF 5%", 
               sourceKey = "SYNPUF5PCT", 
               sourceDialect = "postgresql", 
               cdmDatabaseSchema = "synpuf5pct", 
               vocabDatabaseSchema = "unrestricted_vocabs", 
               resultsDatabaseSchema = "synpuf5pct_results")


## ---- eval=FALSE--------------------------------------------------------------
## tryCatch(getCdmSources(baseUrl),
##          error = function(s) {
##            if(grepl("http error 401", e)) {
##              authorizeWebApi(baseUrl,
##                 authMethod = "db",
##                 webApiUsername = Sys.getenv("WEBAPI_USERNAME"),
##                 webApiPassword = Sys.getenv("WEBAPI_PASSWORD"))
##              getCdmSources(baseUrl)
##            } else {
##              stop(e)
##            }
##          })

