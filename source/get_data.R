options(digits = 20)

idaif_connection <- connect_idaifield(serverip = "127.0.0.1",
                                      user = "milQUant",
                                      pwd = "hallo")

get_idaifield_data <- function(projectname = "milet") {
  get_idaifield_docs(connection = idaif_connection,
                     projectname = projectname,
                     keep_geometry = TRUE,
                     simplified = TRUE)
}


project_list <- sofa::db_list(idaif_connection)

uidlist <- get_uid_list(get_idaifield_data(),
                        verbose = TRUE,
                        gather_trenches = TRUE) %>%
  mutate(Operation = ifelse(is.na(isRecordedIn),
                            liesWithin,
                            isRecordedIn)) %>%
  mutate(Operation = ifelse(is.na(Operation),
                            "none",
                            Operation))


