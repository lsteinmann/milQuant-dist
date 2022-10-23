options(digits = 20)

get_complete_db <- function(connection = NULL,
                            projectname = "rtest") {
  docs <- get_idaifield_docs(connection = connection,
                             projectname = projectname,
                             raw = FALSE)
  #docs <- simplify_idaifield(docs, keep_geometry = FALSE,
  #                           replace_uids = TRUE)
  return(docs)
}

index_query <- function(connection = NULL,
                        projectname = "rtest",
                        uidlist = react_index(),
                        field = "type",
                        value = "Brick") {
  result <- idf_index_query(connection = connection,
                            projectname = projectname,
                            field = field, value = value,
                            uidlist = uidlist,
                            keep_geometry = TRUE) %>%
    prep_for_shiny(reorder_periods = reorder_periods)
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


