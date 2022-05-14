library(rgdal)

convert_with_crs <- function(coords, from_epsg, to_epsg) {
  epsg <- paste("+init=epsg:", from_epsg, sep = "")
  original_coords <- SpatialPoints(cbind(coords[, 1],
                                         coords[, 2]),
                                   proj4string = CRS(projargs = epsg))
  to_epsg <- paste("+init=epsg:", to_epsg, sep = "")
  new_coords <- spTransform(original_coords, CRS(to_epsg))
  return(new_coords)
}


make_sp_polygon <- function(coords, from_epsg, to_epsg) {
  coords <- convert_with_crs(coords,
                             from_epsg = from_epsg,
                             to_epsg = to_epsg)
  poly <- sp::Polygon(coords = coords, hole = FALSE)
  return(poly)
}



building_data <- reactive({
  buildings <- milet_active() %>%
    select_by(by = "type", value = "Building")

  for (i in seq_along(buildings)) {
    type <- buildings[[i]]$geometry$type
    if (is.null(type)) {
      next
    } else if (type == "Polygon" | type == "MultiPolygon") {
      coordslist <- buildings[[i]]$geometry$coordinates
      for (item in seq_along(coordslist)) {
        coordslist[[item]] <- make_sp_polygon(coordslist[[item]],
                                              from_epsg = 32635,
                                              to_epsg = 4326)
        buildings[[i]]$geometry$coordinates[[item]] <- coordslist[[item]]
      }
      polylist <- buildings[[i]]$geometry$coordinates
      polylist <- Polygons(polylist, ID = buildings[[i]]$identifier)
      buildings[[i]]$geometry$coordinates <- polylist
    }
  }

  library(sp)
  sp_prep <- lapply(buildings, function(x) unlist(x$geometry$coordinates))
  sp_prep <- SpatialPolygons(sp_prep, pO = 1:length(buildings),
                             proj4string=CRS("+init=epsg:4326"))

  building_data <- buildings %>%
    prep_for_shiny(reorder_periods = TRUE)

  keep <- c("identifier", "shortDescription", "description",
            "relation.liesWithin", "period.start", "period.end",
            "buildingCategory", "context", "buildingType",
            "buildingContractor", "associatedDeity",
            "excavatedIn", "excavatedBy",
            "gazId", "literature")

  building_data <- building_data %>%
    dplyr::select(keep) %>%
    mutate(relation.liesWithin = as.factor(unlist(relation.liesWithin)),
           shortDescription = as.character(unlist(shortDescription)),
           buildingCategory = as.factor(unlist(buildingCategory)),
           period.start = as.factor(unlist(period.start)),
           period.end = as.factor(unlist(period.end)),
           description = as.character(unlist(description)),
           gazId = as.character(unlist(gazId))) %>%
    mutate(URL = ifelse(gazId > 1,
                        paste("https://gazetteer.dainst.org/place/",
                              gazId, sep = ""),
                        NA))

  rownames(building_data) <- building_data$identifier


  building_data$lit <- NA
  for (i in 1:nrow(building_data)) {
    list <- building_data$literature[i]
    list <- unlist(list)
    if (is.null(list)) {
      next
    } else {
      building_data$lit[i] <- paste(list, collapse = "; ")
    }
  }


  building_data$label <-
    paste('<b><a href="', building_data$URL, '">', building_data$identifier,
          '</a></b><br/>Datierung: ', building_data$period.start, '--',
          building_data$period.end, '<br/><br/>', building_data$description)#,
  #'<br/><br/>Literatur: ', mat$lit)

  building_data <- SpatialPolygonsDataFrame(Sr = sp_prep, data = building_data)
  building_data
})



library(leaflet)





output$buildings_leaf <- renderLeaflet({

buildingCategory <- building_data()$buildingCategory
buildingCategory.pal <- colorFactor(rainbow(length(buildingCategory)),
                                    buildingCategory)

period.start <- building_data()$period.start
period.start.pal <- colorFactor(heat.colors(length(period.start)), period.start)

period.end <- building_data()$period.end
period.end.pal <- colorFactor(heat.colors(length(period.end)), period.end)

periods <- as.factor(unique(c(as.character(unique(building_data()$period.end)),
                              as.character(unique(building_data()$period.start)))))
periods.pal <- colorFactor(topo.colors(length(periods)), periods)


  leaflet() %>%
    addPolygons(data = building_data(), fillOpacity = 0,
                color = ~buildingCategory.pal(buildingCategory),
                popup = ~label, group = "buildingCategory") %>%
    addPolygons(data = building_data(), color = "none", fillOpacity = 0.6,
                fillColor = ~periods.pal(period.start),
                popup = ~label, group = "period.start") %>%
    addPolygons(data = building_data(), color = "none", fillOpacity = 0.6,
                fillColor = ~periods.pal(period.end),
                popup = ~label, group = "period.end") %>%
    addMarkers(lng = 27.277, lat = 37.53,
               popup="Milet")%>%
    addProviderTiles("Esri.WorldImagery") %>%
    addLegend(pal = buildingCategory.pal, values = buildingCategory,
              title = "Gebäudekategorie",
              position = "bottomright",
              group = "buildingCategory") %>%
    addLegend(pal = periods.pal, values = periods,
              title = "Datierung",
              position = "bottomleft") %>%
    addLayersControl(
      baseGroups = c("period.start", "period.end"),
      options = layersControlOptions(collapsed = FALSE),
      overlayGroups = c("buildingCategory"),
    )

})




