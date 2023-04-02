options(digits = 20)

get_index <- function(source = login_connection()) {
  uidlist <- get_field_index(source,
                          verbose = TRUE,
                          gather_trenches = TRUE) %>%
    mutate(Operation = ifelse(is.na(isRecordedIn),
                              liesWithin,
                              isRecordedIn)) %>%
    mutate(Operation = ifelse(category %in% c("Type","TypeCatalog"),
                              "Typenkatalog",
                              Operation)) %>%
    mutate(Place = ifelse(category %in% c("Type","TypeCatalog"),
                          "Typenkatalog",
                          Place)) %>%
    mutate(Operation = ifelse(is.na(Operation),
                              "none",
                              Operation))
  return(uidlist)
}


