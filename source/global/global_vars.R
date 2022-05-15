## Design

uhhcol <- c("#e2001a", "#3b515b")
uhhcol <- colorRampPalette(uhhcol)

uhhcol_two <- c("#3b515b", "#b6bfc3", "#e2001a", "#f07f8c", "#80b8dd", "#0271bb")
uhhcol_two <- colorRampPalette(uhhcol_two)


Plot_Base_Theme <- theme(panel.background = element_blank(),
                         panel.grid.major = element_line(color = "grey60",
                                                         linetype = "dashed"),
                         panel.grid.minor = element_line(color = "grey80",
                                                         linetype = "dotted"),
                         axis.text.x = element_text(angle = 45,
                                                    hjust = 1,
                                                    vjust = 1,
                                                    size = 14),
                         axis.title = element_text(size = 16),
                         legend.position = "bottom")



## Global Variables

#operations <- c("all", sort(na.omit(unique(index$Place))))


drop_for_plot_vars <- c("identifier", "shortDescription", "notes",
                        "storagePlaceOther", "measuringPointID",
                        "localizationDescription", "conditionComment",
                        "comparison", "MuseumInventoryNr", "OldInventoryNr",
                        "FotoNr", "DrawingNr", "vesselFormDescription",
                        "fabricStructure", "temperType", "temperTypeOther",
                        "temperAmount", "temperGrain", "surfaceTreatment",
                        "surfaceTreatmentDescription", "analysisMethodOther",
                        "analysisAim", "analysisActor", "analysisResult",
                        "otherNotes", "id", "relation.isRecordedIn",
                        "relation.isDepictedIn", "relation.liesWithin",
                        "relation.liesWithinLayer",
                        "relation.isSameAs",
                        "type", "workflow",
                        "analysisMethod", "localization")


periods <- jsonlite::fromJSON("external/periods.json")
periods <- c(names(periods[[1]]), "multiple", "unbestimmt")
periods <- factor(periods,
                  levels = periods,
                  ordered = TRUE)

#period_colors <- read.csv("external/period_colors.csv", header = FALSE)[,1]
period_colors <- viridis::viridis_pal(option = "D")(length(periods)-2)
period_colors <- c(period_colors, "#cd2436", "#a6a6a6")

scale_fill_period <- scale_fill_manual(name = "Period",
                                       values = period_colors,
                                       breaks = periods,
                                       limits = periods)

find_types <- c("Find", "Pottery", "Terracotta", "Brick", "Bone", "Loomweight",
                "Glass", "Metal", "Stone", "Wood", "Coin", "PlasterFragment",
                "Mollusk", "Sculpture")



#all_types <- unique(index$type)
