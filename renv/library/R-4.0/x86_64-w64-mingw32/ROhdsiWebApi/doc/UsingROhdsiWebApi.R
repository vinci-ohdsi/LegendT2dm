## ---- include = FALSE---------------------------------------------------------

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----echo=FALSE,warning=FALSE,message=FALSE-----------------------------------

library(ROhdsiWebApi)
library(dplyr)

if (Sys.getenv("baseUrl") == '') {
  server <- "ohdsiBaseUrl" 
} else {server <- "baseUrl"}
baseUrl <- Sys.getenv(server)

if (baseUrl == '') {
  baseUrl <- 'http://api.ohdsi.org:8080/WebAPI'
}


## ----eval=TRUE, echo = TRUE---------------------------------------------------

version <- ROhdsiWebApi:::getWebApiVersion(baseUrl = baseUrl)
message1 <- paste0('This Vignette was created using WebApi version: ', 
                   version, 
                   ' on baseUrl: ', 
                   baseUrl, 
                   ". The CDM had the following source data configured: ")
cdmSources <- ROhdsiWebApi::getCdmSources(baseUrl = baseUrl)
priorityVocabulary <- ROhdsiWebApi::getPriorityVocabularyKey(baseUrl = baseUrl)



## ----eval=TRUE, echo = TRUE---------------------------------------------------

cdmSources



## ----eval=TRUE, echo = TRUE---------------------------------------------------

ROhdsiWebApi::isValidSourceKey(sourceKeys = c('HCUP', 'SYNPUF1K'), baseUrl = baseUrl)



## ----eval=TRUE, echo = FALSE--------------------------------------------------
output <- ROhdsiWebApi:::.getStandardCategories() %>%
  select(.data$categoryFirstUpper) %>%
  rename(Category = .data$categoryFirstUpper) %>%
  arrange() %>%
  mutate(features = paste0("Functions for interfacing with ", 
                                  .data$Category, 
                                  " in WebApi"))
colnames(output) <- SqlRender::camelCaseToTitleCase(colnames(output))
knitr::kable(output)


## ----eval=TRUE, echo = FALSE--------------------------------------------------
output <- tidyr::tibble(functionName = library(help = "ROhdsiWebApi" )$info[[2]]) %>% 
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'isValid', replacement = 'isvalid')) %>% 
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'CdmSources', replacement = 'Cdmsources')) %>% 
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'MetaData', replacement = 'Metadata')) %>%
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'PersonProfile', replacement = 'PersonProfile')) %>% 
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'PriorityVocabularyKey', replacement = 'Priorityvocabularykey')) %>%
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'InclusionRulesAndCounts', replacement = 'Inclusionrulesandcounts')) %>% 
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'GenerationInformation', replacement = 'Generationinformation')) %>%  
  mutate(functionName = stringr::str_replace(string = functionName, pattern = 'SourceConcepts', replacement = 'Sourceconcepts')) %>% 
  mutate(functionName = stringr::word(string = .data$functionName, 1)) %>% 
  mutate(functionNameTitle = SqlRender::camelCaseToTitleCase(.data$functionName)) %>% 
  mutate(functionNameFirst = stringr::word(string = .data$functionNameTitle, start = 1 , end = 1),
                functionNameLast = stringr::word(string = .data$functionNameTitle,start = -1)) %>%
  filter(!functionNameFirst == '') %>% 
  mutate(functionNameMiddle = case_when(functionNameTitle == paste(functionNameFirst, functionNameLast) ~ '',
                                                      TRUE ~ stringr::str_replace(string = .data$functionNameTitle, 
                                                                                  pattern = .data$functionNameFirst, 
                                                                                  replacement = ''
                                                      ) %>% 
                                                        stringr::str_replace(pattern = .data$functionNameLast, 
                                                                             replacement = ''
                                                        ) %>% 
                                                        stringr::str_squish()
  )
  ) %>% 
  mutate(functionsWithPattern = case_when(.data$functionNameFirst %in% 
                                                          c('Cancel','Create','Delete','Detect','Exists',
                                                            'Get','Invoke',  'IsValid', 'Post','Resolve')
                                                        ~ TRUE, TRUE ~ FALSE
                                                        )
  )
knitr::kable(output %>% select('Function Name' = functionName, 'Description' = functionNameTitle))


## ----eval=TRUE, echo = FALSE--------------------------------------------------
verb <- output %>% 
  filter(functionsWithPattern = TRUE) %>% 
  group_by(.data$functionNameFirst) %>% 
  summarise(numberOfFunctions = n(), .groups = 'keep') %>% 
  arrange() %>% 
  ungroup() %>% 
  arrange(desc(numberOfFunctions)) %>% 
  distinct() %>% 
  rename(functionVerb = functionNameFirst) %>% 
  rename_all(SqlRender::camelCaseToTitleCase)
  
knitr::kable(verb)


## ----eval=TRUE, echo = TRUE---------------------------------------------------

ROhdsiWebApi::getDefinitionsMetadata(baseUrl = baseUrl, 
                                     category = 'cohort') %>%
  arrange(.data$id) %>%
  rename_all(.funs = SqlRender::camelCaseToTitleCase) %>%
  tail() 



## ----eval=TRUE, echo = TRUE---------------------------------------------------

ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl) %>% 
  arrange(.data$id) %>% 
  rename_all(.funs = SqlRender::camelCaseToTitleCase) %>% 
  tail() 


## ----eval=TRUE, echo = TRUE---------------------------------------------------

ROhdsiWebApi::getDefinitionsMetadata(baseUrl = baseUrl, 
                                     category = 'estimation') %>% 
  arrange(.data$id) %>% 
  rename_all(.funs = SqlRender::camelCaseToTitleCase) %>% 
  tail()


## ----eval=TRUE, echo = TRUE---------------------------------------------------

ROhdsiWebApi::getEstimationDefinitionsMetaData(baseUrl = baseUrl) %>% 
  arrange(.data$id) %>% 
  rename_all(.funs = SqlRender::camelCaseToTitleCase) %>% 
  tail()


## ----eval=TRUE, echo = TRUE---------------------------------------------------

jsonExpression <- '{
  "items": [
    {
      "concept": {
        "CONCEPT_ID": 81097,
        "CONCEPT_NAME": "Feltys syndrome",
        "STANDARD_CONCEPT": "S",
        "STANDARD_CONCEPT_CAPTION": "Standard",
        "INVALID_REASON": "V",
        "INVALID_REASON_CAPTION": "Valid",
        "CONCEPT_CODE": "57160007",
        "DOMAIN_ID": "Condition",
        "VOCABULARY_ID": "SNOMED",
        "CONCEPT_CLASS_ID": "Clinical Finding"
      },
      "isExcluded": true,
      "includeDescendants": false,
      "includeMapped": false
    },
    {
      "concept": {
        "CONCEPT_ID": 80809,
        "CONCEPT_NAME": "Rheumatoid arthritis",
        "STANDARD_CONCEPT": "S",
        "STANDARD_CONCEPT_CAPTION": "Standard",
        "INVALID_REASON": "V",
        "INVALID_REASON_CAPTION": "Valid",
        "CONCEPT_CODE": "69896004",
        "DOMAIN_ID": "Condition",
        "VOCABULARY_ID": "SNOMED",
        "CONCEPT_CLASS_ID": "Clinical Finding"
      },
      "isExcluded": false,
      "includeDescendants": true,
      "includeMapped": false
    },
    {
      "concept": {
        "CONCEPT_ID": 4035611,
        "CONCEPT_NAME": "Seropositive rheumatoid arthritis",
        "STANDARD_CONCEPT": "S",
        "STANDARD_CONCEPT_CAPTION": "Standard",
        "INVALID_REASON": "V",
        "INVALID_REASON_CAPTION": "Valid",
        "CONCEPT_CODE": "239791005",
        "DOMAIN_ID": "Condition",
        "VOCABULARY_ID": "SNOMED",
        "CONCEPT_CLASS_ID": "Clinical Finding"
      },
      "isExcluded": false,
      "includeDescendants": true,
      "includeMapped": false
    }
  ]
}'




## ----eval=TRUE, echo = TRUE, warning=FALSE, message = FALSE-------------------
# check if there is a concept set by this name, if yes, delete it
exists <- ROhdsiWebApi::existsConceptSetName(conceptSetName = conceptSetName, baseUrl = baseUrl)
exists



## ----eval=TRUE, echo = TRUE, warning=FALSE, message = FALSE-------------------
if (!isFALSE(exists)) {
  ROhdsiWebApi::deleteConceptSetDefinition(conceptSetId = exists$id, baseUrl = baseUrl)
}


## ----eval=TRUE, echo = FALSE--------------------------------------------------

rExpression <- RJSONIO::fromJSON(jsonExpression)



## ----eval=FALSE---------------------------------------------------------------
## returnFromPostRequest <- ROhdsiWebApi::postConceptSetDefinition(baseUrl = baseUrl,
##                                                                 conceptSetDefinition = rExpression,
##                                                                 name = conceptSetName)


## ----eval=FALSE, echo = FALSE-------------------------------------------------
## returnFromPostRequest


## ----eval=FALSE, echo = FALSE-------------------------------------------------
## conceptSetDefinition = getConceptSetDefinition(conceptSetId = returnFromPostRequest$id,
##                                                baseUrl = baseUrl)
## conceptTbl <-
##   convertConceptSetDefinitionToTable(conceptSetDefinition)
## names(conceptTbl) <-
##   SqlRender::camelCaseToTitleCase(names(conceptTbl))
## conceptTbl


## ----eval=FALSE, echo = FALSE-------------------------------------------------
## resolvedConcepts = resolveConceptSet(conceptSetDefinition = conceptSetDefinition, baseUrl = baseUrl)
## print("Note: Showing only the first 10 concept id's")
## resolvedConcepts[1:10]


## ----eval=FALSE, echo = FALSE-------------------------------------------------
## json <-
##   getConceptSetDefinition(baseUrl = baseUrl,
##                           conceptSetId = returnFromPostRequest$id
##                           )$expression %>%
##   RJSONIO::toJSON(pretty = TRUE)

