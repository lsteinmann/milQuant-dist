options(digits = 20)

idaif_connection <- connect_idaifield(serverip = "127.0.0.1",
                                      user = "milQuant",
                                      pwd = "hallo")

get_complete_db <- function(projectname = "milet") {
  get_idaifield_docs(connection = idaif_connection,
                     projectname = projectname,
                     keep_geometry = FALSE,
                     simplified = TRUE)
}

index_query <- function(projectname = "milet",
                        uidlist = react_index(),
                        field = "type",
                        value = "Brick") {
  idf_index_query(connection = idaif_connection,
                  project = projectname,
                  field = field, value = value,
                  uidlist = uidlist,
                  keep_geometry = FALSE) %>%
    prep_for_shiny(reorder_periods = TRUE)
}


#data <- get_complete_db()

#index <- get_index(source = data)
#index <- get_index(source = get_complete_db())

#rm(data)

#test <- index_query(field = "type", value = "Pottery",
#                    uidlist = index)





#test <- test %>%
#  filter(id %in% uid_to_filter(place = "Kaletepe", index = index))



#project_list <- sofa::db_list(idaif_connection)



get_index <- function(source = get_complete_db()) {
  get_uid_list(source,
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
}


