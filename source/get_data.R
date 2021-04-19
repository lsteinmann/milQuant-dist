library(idaifieldR)

idaif_connection <- connect_idaifield(serverip = "192.168.2.21",
                                      user = "milQUant",
                                      pwd = "hallo")

get_idaifield_data <- function(projectname = "milet") {
  get_idaifield_docs(connection = idaif_connection,
                     projectname = projectname,
                     keep_geometry = FALSE,
                     simplified = TRUE)
}


get_idaifield_data()

uidlist <- get_uid_list(get_idaifield_data(), verbose = TRUE) %>%
  mutate(Operation = ifelse(is.na(isRecordedIn),
                            liesWithin,
                            isRecordedIn)) %>%
  mutate(Operation = ifelse(is.na(Operation),
                            "none",
                            Operation))
