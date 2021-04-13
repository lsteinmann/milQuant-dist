library(idaifieldR)

idaif_connection <- connect_idaifield(serverip = "192.168.2.21", user = "shiny",
                                      pwd = "hallo")
milet <- get_idaifield_docs(connection = idaif_connection,
                            projectname = "milet",
                            keep_geometry = FALSE,
                            simplified = TRUE)


uidlist <- get_uid_list(milet, verbose = TRUE)

operations <- unique(uidlist$isRecordedIn)
