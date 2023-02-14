
# Update cohort SQL

sqlFiles <- list.files("inst/sql/sql_server/outcome/original",
                       pattern = "*\\.sql")

for (file in sqlFiles) {
  VaTools::translateToCustomVaSql(
    file.path("inst/sql/sql_server/outcome/original", file),
    NULL,
    file.path("inst/sql/sql_server/outcome", file))
}

# remotes::install_github("suchard-group/VaTools", INSTALL_opts = c("--no-multiarch"))
