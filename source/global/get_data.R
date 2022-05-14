options(digits = 20)

idaif_conn <- connect_idaifield(serverip = "127.0.0.1",
                                user = "user",
                                pwd = "hallo")



get_complete_db <- function(connection = idaif_conn,
                            projectname = "rtest") {
  docs <- get_idaifield_docs(connection = connection,
                             projectname = projectname,
                             keep_geometry = FALSE,
                             simplified = TRUE)
  return(docs)
}

index_query <- function(connection = idaif_conn,
                        projectname = "rtest",
                        uidlist = react_index(),
                        field = "type",
                        value = "Brick") {
  result <- idf_index_query(connection = connection,
                            projectname = projectname,
                            field = field, value = value,
                            uidlist = uidlist,
                            keep_geometry = FALSE) %>%
    prep_for_shiny(reorder_periods = TRUE)
  return(result)
}


get_index <- function(source = get_complete_db()) {
  uidlist <- get_uid_list(source,
                          verbose = TRUE,
                          gather_trenches = TRUE) %>%
    mutate(Operation = ifelse(is.na(isRecordedIn),
                              liesWithin,
                              isRecordedIn)) %>%
    mutate(Operation = ifelse(type %in% c("Type","TypeCatalog"),
                              "Typenkatalog",
                              Operation)) %>%
    mutate(Place = ifelse(type %in% c("Type","TypeCatalog"),
                          "Typenkatalog",
                          Place)) %>%
    mutate(Operation = ifelse(is.na(Operation),
                              "none",
                              Operation))
  return(uidlist)
}


