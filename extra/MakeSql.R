
# Update cohort SQL

sqlFiles <- list.files("inst/sql/sql_server/original",
                       pattern = ".epro.*\\.sql")

for (file in sqlFiles) {
  VaTools::translateToCustomVaSql(
    file.path("inst/sql/sql_server/original", file),
    NULL,
    file.path("extras/VaSql", file))
}

# remotes::install_github("suchard-group/VaTools", INSTALL_opts = c("--no-multiarch"))
