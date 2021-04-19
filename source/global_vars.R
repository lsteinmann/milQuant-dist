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

operations <- c("all", na.omit(unique(uidlist$isRecordedIn)))
#operations <- na.omit(unique(uidlist$isRecordedIn))


drop_for_plot_vars <- c("identifier", "shortDescription", "notes",
                        "storagePlaceOther", "measuringPointID",
                        "localizationDescription", "conditionComment",
                        "comparison", "MuseumInventoryNr", "OldInventoryNr",
                        "FotoNr", "DrawingNr", "vesselFormDescription",
                        "vesselType", "provenanceInput", "fabricStructure",
                        "temperType", "temperTypeOther", "temperAmount",
                        "temperGrain", "surfaceTreatment",
                        "surfaceTreatmentDescription", "analysisMethodOther",
                        "analysisAim", "analysisActor", "analysisResult",
                        "otherNotes", "id", "isRecordedIn", "type")


periods <- jsonlite::fromJSON("external/periods.json")
periods <- factor(names(periods[[1]]), levels = names(periods[[1]]))
