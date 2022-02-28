setwd(GraphsDirectory)

# Add cumulative deaths to DeathsTogether df
# May need a different data frame as this doesn't include COVID/non-COVID split. Just all causes & expected.

DeathsTogetherCum2020 <- DeathsTogether %>%
  filter(Date >= as.Date("2019-12-01") & Date <= as.Date("2020-12-31")) %>%
  filter(Cause == "All") %>%
  group_by(Age) %>%
  mutate(cumDeaths = cumsum(Deaths)) %>%
  mutate(cumExcess = cumsum(Excess))

DeathsTogetherCum2021 <- DeathsTogether %>%
  filter(Date >= as.Date("2021-01-01") & Date <= as.Date("2021-12-31")) %>%
  filter(Cause == "All") %>%
  group_by(Age) %>%
  mutate(cumDeaths = cumsum(Deaths)) %>%
  mutate(cumExcess = cumsum(Excess))

DeathsTogetherCum2022 <- DeathsTogether %>%
  filter(Date >= as.Date("2022-01-01") & Date <= as.Date("2022-12-31")) %>%
  filter(Cause == "All") %>%
  group_by(Age) %>%
  mutate(cumDeaths = cumsum(Deaths)) %>%
  mutate(cumExcess = cumsum(Excess))

DeathsTogetherCum2020_2022 <- rbind.data.frame(DeathsTogetherCum2020,DeathsTogetherCum2021,DeathsTogetherCum2022)

# Add year, ISO week and gradient of cumExcess and cumDeaths.
DeathsTogetherCum2020_2022 <- DeathsTogetherCum2020_2022 %>%
  group_by(Age) %>%
  mutate(Year = as.factor(isoyear(Date))) %>%
  mutate(WeekNo = isoweek(Date)) %>%
  mutate(gradcumExcess = (cumExcess - lag(cumExcess))/(WeekNo - lag(WeekNo))) %>%
  mutate(gradcumDeaths = (cumDeaths - lag(cumDeaths))/(WeekNo - lag(WeekNo)))

DeathsTogetherCum2020_2021 <- filter(DeathsTogetherCum2020_2022,Date < as.Date("2022-01-01"))

###############################################################################
#
#
# Cumulative Excess Deaths in Scotland, 2020 to 2022 (faceted by age group)
#
#
###############################################################################

YearColours = c("2020" = "grey25",
                "2021" = "grey50",
                "2022" = "black")
YearLineThicknesses = c("2020" = 0.25,
                        "2021" = 1,
                        "2022" = 1)

GraphFileName = " Cumulative Excess Deaths in Scotland, 2020 to 2022 (faceted by age group).png"

DeathsTogetherCum2020_2022_graph <- DeathsTogetherCum2020_2022 %>%
  filter(WeekNo <= isoweek(max(DeathsTogetherCum2020_2022$Date)) + 2)

NRSWeeklyDeaths_Excess_Graph = ggplot(data = DeathsTogetherCum2020_2022_graph,
                                      mapping = aes(x=WeekNo,
                                                    y=cumExcess,
                                                    colour = Year,
                                                    group = Year,
                                                    size= Year
                                                    )
                                      )+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        #panel.grid = element_line(colour = NULL),
        panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0))+
  scale_x_continuous(name = "Week number",
                     #breaks = c(0,10,20,30,40,50),
                     labels = label_comma(accuracy = 1),
                     limits = c(NA,NA)
                     )+
  scale_y_continuous(name = "Cumulative Excess Deaths",
                     labels = label_comma(accuracy = NULL))+
  ggtitle("Cumulative Excess Deaths in Scotland, 2020 to 2022 (faceted by age group)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption,
       caption.justification = "left")+
  geom_hline(yintercept = 0,
             colour = "grey75",
             linetype = "dashed")+
  geom_line(#size = 0.5,
            alpha = 1,
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 5,
             scales = "free_y")+
  scale_colour_manual(name = "Year",
                      values = YearColours)+
  scale_size_manual(name = "Year",
                    values = YearLineThicknesses)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###############################################################################
#
#
# Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group)
#
#
###############################################################################

YearColours = c("2020" = "grey25",
                "2021" = "grey50",
                "2022" = "black")
YearLineThicknesses = c("2020" = 0.25,
                        "2021" = 1,
                        "2022" = 1)

GraphFileName = " Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group).png"

NRSWeeklyDeaths_Excess_Graph = ggplot(data = DeathsTogetherCum2020_2021,
                                      mapping = aes(x=WeekNo,
                                                    y=cumExcess,
                                                    colour = Year,
                                                    group = Year,
                                                    size= Year
                                      )
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        #panel.grid = element_line(colour = NULL),
        panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0))+
  scale_x_continuous(name = "Week number",
                     breaks = c(0,10,20,30,40,50))+
  scale_y_continuous(name = "Cumulative Excess Deaths",
                     labels = scales::comma)+
  ggtitle("Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption,
       caption.justification = "left")+
  geom_hline(yintercept = 0,
             colour = "grey75",
             linetype = "dashed")+
  geom_line(#size = 0.5,
    alpha = 1,
    show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 5,
             scales = "free_y")+
  scale_colour_manual(name = "Year",
                      values = YearColours)+
  scale_size_manual(name = "Year",
                    values = YearLineThicknesses)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###############################################################################



###############################################################################
#
#
# Gradient of Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group)
#
#
###############################################################################
# 
# 
# GraphCaptionOld <- GraphCaption
# GraphCaption <- "Data source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/\ndeaths-involving-coronavirus-covid-19-in-scotland/related-statistics"
# 
# GraphFileName = " Gradient of Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group).png"
# 
# NRSWeeklyDeaths_gradExcess_Graph = ggplot(data = DeathsTogetherCum2020_2021,
#                                       mapping = aes(x=WeekNo,
#                                                     y=gradcumExcess,
#                                                     colour = Year,
#                                                     group = Year,
#                                                     size = Year
#                                       )
# )+
#   theme_minimal()+
#   theme(panel.background = element_rect(fill = 'white', color = 'white'),
#         plot.background = element_rect(fill = 'white', color = 'white'),
#         legend.position="bottom",
#         legend.justification = "centre",
#         strip.background = element_blank(),
#         strip.placement = "outside",
#         plot.caption = element_text(hjust = 0))+
#   scale_x_continuous(name = "Week number")+
#   scale_y_continuous(name = "Gradient of Cumulative Excess Deaths",
#                      labels = scales::comma)+
#   ggtitle("Gradient of Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group)",
#           subtitle = GraphSubtitle)+
#   labs(caption = GraphCaption,
#        caption.justification = "left")+
#   geom_point(size = 1,
#              alpha = 0.5,
#              show.legend = FALSE)+
#   geom_smooth(method = "loess",
#               formula = y ~ x,
#               span = 0.5,
#               show.legend = TRUE)+
#   facet_wrap(vars(Age),
#              ncol = 5,
#              scales = "free_y")+
#   scale_colour_manual(name = "Year",
#                       values = YearColours)+
#   scale_size_manual(name = "Year",
#                     values = YearLineThicknesses)
# 
# #Save graph
# ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
#        plot = NRSWeeklyDeaths_gradExcess_Graph,
#        device="png",
#        width=graphwidth,
#        height=graphheight,
#        units="mm",
#        dpi=300
# )
# 
# GraphCaption <- GraphCaptionOld


###############################################################################
#
#
# Gradient of Cumulative Deaths in Scotland, 2020 and 2021 (faceted by age group)
#
#
###############################################################################
# 
# 
# GraphCaptionOld <- GraphCaption
# GraphCaption <- "Data source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/\ndeaths-involving-coronavirus-covid-19-in-scotland/related-statistics"
# 
# GraphFileName = " Gradient of Cumulative Deaths in Scotland, 2020 and 2021 (faceted by age group).png"
# 
# NRSWeeklygradCumDeaths_Graph = ggplot(DeathsTogetherCum2020_2021,
#   #data = filter(DeathsTogetherCum2020_2021,WeekNo > 40),
#                                   mapping = aes(x=WeekNo,
#                                                 y=gradcumDeaths,
#                                                 colour = Year,
#                                                 group = Year,
#                                                 size = Year
#                                   )
# )+
#   theme_minimal()+
#   theme(panel.background = element_rect(fill = 'white', color = 'white'),
#         plot.background = element_rect(fill = 'white', color = 'white'),
#         legend.position="bottom",
#         legend.justification = "centre",
#         strip.background = element_blank(),
#         strip.placement = "outside",
#         plot.caption = element_text(hjust = 0))+
#   scale_x_continuous(name = "Week number")+
#   scale_y_continuous(name = "Gradient of Cumulative Deaths",
#                      labels = scales::comma)+
#   ggtitle("Gradient of Cumulative Deaths in Scotland, 2020 and 2021 (faceted by age group)",
#           subtitle = GraphSubtitle)+
#   labs(caption = GraphCaption,
#        caption.justification = "left")+
#   geom_point(size = 1,
#              alpha = 0.5,
#              show.legend = FALSE)+
#   geom_smooth(method = "loess",
#               formula = y ~ x,
#               span = 0.5,
#               show.legend = TRUE)+
#   facet_wrap(vars(Age),
#              ncol = 5,
#              scales = "free_y")+
#   scale_colour_manual(name = "Year",
#                       values = YearColours)+
#   scale_size_manual(name = "Year",
#                     values = YearLineThicknesses)
# 
# #Save graph
# ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
#        plot = NRSWeeklygradCumDeaths_Graph,
#        device="png",
#        width=graphwidth,
#        height=graphheight,
#        units="mm",
#        dpi=300
# )
# 
# GraphCaption <- GraphCaptionOld


###############################################################################
#
#
# Gradient of Cumulative Deaths in Scotland, 2021 (faceted by age group)
#
#
###############################################################################

# GraphCaptionOld <- GraphCaption
# GraphCaption <- "Data source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/\ndeaths-involving-coronavirus-covid-19-in-scotland/related-statistics"
# 
# GraphFileName = " Gradient of Cumulative Deaths in Scotland, 2021 (faceted by age group).png"
# 
# NRSWeeklygradCumDeaths_Graph = ggplot(#DeathsTogetherCum2020_2021,
#                                       data = filter(DeathsTogetherCum2020_2021,Year == 2021),
#                                       mapping = aes(x=WeekNo,
#                                                     y=gradcumDeaths,
#                                                     colour = Year,
#                                                     group = Year,
#                                                     size = Year
#                                       )
# )+
#   theme_minimal()+
#   theme(panel.background = element_rect(fill = 'white', color = 'white'),
#         plot.background = element_rect(fill = 'white', color = 'white'),
#         legend.position="bottom",
#         legend.justification = "centre",
#         strip.background = element_blank(),
#         strip.placement = "outside",
#         plot.caption = element_text(hjust = 0))+
#   scale_x_continuous(name = "Week number")+
#   scale_y_continuous(name = "Gradient of Cumulative Deaths",
#                      labels = scales::comma)+
#   ggtitle("Gradient of Cumulative Deaths in Scotland, 2021 (faceted by age group)",
#           subtitle = GraphSubtitle)+
#   labs(caption = GraphCaption,
#        caption.justification = "left")+
#   # geom_line(size = 0.5,
#   #           alpha = 1,
#   #           show.legend = TRUE)+
#   geom_point(size = 1,
#              alpha = 0.5,
#              show.legend = FALSE)+
#   geom_smooth(method = "loess",
#               formula = y ~ x,
#               span = 0.5,
#               show.legend = FALSE)+
#   facet_wrap(vars(Age),
#              ncol = 5,
#              scales = "free_y")+
#   scale_colour_manual(name = "Year",
#                       values = YearColours)+
#   scale_size_manual(name = "Year",
#                     values = YearLineThicknesses)
# 
# #Save graph
# ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
#        plot = NRSWeeklygradCumDeaths_Graph,
#        device="png",
#        width=graphwidth,
#        height=graphheight,
#        units="mm",
#        dpi=300
# )
# 
# GraphCaption <- GraphCaptionOld


###############################################################################
#
#
# Gradient of Cumulative Excess Deaths in Scotland, 2021 (faceted by age group)
#
#
###############################################################################

YearColours = c("2020" = "red",
                "2021" = "blue")

GraphFileName = " Gradient of Cumulative Excess Deaths in Scotland, 2021 (faceted by age group).png"

NRSWeeklygradCumExcessDeaths_Graph = ggplot(#DeathsTogetherCum2020_2021,
  data = filter(DeathsTogetherCum2020_2021,Year == 2021),
  mapping = aes(x=WeekNo,
                y=gradcumExcess,
                colour = Year,
                group = Year
  )
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        plot.caption = element_text(hjust = 0))+
  scale_x_continuous(name = "Week number")+
  scale_y_continuous(name = "Gradient of Cumulative Excess Deaths",
                     labels = scales::comma)+
  ggtitle("Gradient of Cumulative Excess Deaths in Scotland, 2021 (faceted by age group)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption,
       caption.justification = "left")+
  # geom_line(size = 0.5,
  #           alpha = 1,
  #           show.legend = TRUE)+
  geom_point(size = 1,
             alpha = 0.5,
             show.legend = FALSE)+
  geom_smooth(method = "loess",
              formula = y ~ x,
              span = 0.5,
              show.legend = FALSE)+
  geom_hline(yintercept = 0,
             linetype = "dashed",
             colour = "grey50",
             size = 1)+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklygradCumExcessDeaths_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###############################################################################
#
#
# Gradient of Cumulative Excess Deaths in Scotland, Age 65+, 2021
#
#
###############################################################################

YearColours = c("2020" = "red",
                "2021" = "blue")

GraphFileName = " Gradient of Cumulative Excess Deaths in Scotland (age 65 and over) 2021.png"

GraphDataOver65 <- DeathsTogetherCum2020_2021 %>%
  filter(Age == "65 to 69" | Age == "70 to 74" | Age == "75 to 79" | Age == "80 to 84" | Age == "85 to 89" | Age == "90+") #%>%
  #filter(WeekNo >= 10 & WeekNo <= 30)

# https://colorbrewer2.org/#type=diverging&scheme=RdYlBu&n=6
# I don't like the yellow in the middle. Not enough contrast with bg.
# GraphColoursOver65 <- c("65 to 69" = "#4575b4",
#                         "70 to 74" = "#91bfdb",
#                         "75 to 79" = "#e0f3f8",
#                         "80 to 84" = "#fee090",
#                         "85 to 89" = "#fc8d59",
#                         "90+" = "#d73027")

# https://colorbrewer2.org/#type=diverging&scheme=BrBG&n=6
# Lots of browns and blueish greens here.
# 75 to 79 and 80 to 84 colours look too light though.
# GraphColoursOver65 <- c("65 to 69" = "#8c510a",
#                         "70 to 74" = "#d8b365",
#                         "75 to 79" = "#f6e8c3",
#                         "80 to 84" = "#c7eae5",
#                         "85 to 89" = "#5ab4ac",
#                         "90+" = "#01665e")

# https://colorbrewer2.org/#type=diverging&scheme=PuOr&n=6
# GraphColoursOver65 <- c("65 to 69" = "#b35806",
# Too many light colours.
#                         "70 to 74" = "#f1a340",
#                         "75 to 79" = "#fee0b6",
#                         "80 to 84" = "#d8daeb",
#                         "85 to 89" = "#998ec3",
#                         "90+" = "#542788")

# https://github.com/BlakeRMills/MetBrewer/blob/main/R/PaletteCode.R
# Palette: Cassatt 2 (first three and last three colours)
# Too dark!
# GraphColoursOver65 <- c("65 to 69" = "#2d223c",
#                         "70 to 74" = "#574571",
#                         "75 to 79" = "#90719f",
#                         "80 to 84" = "#466c4b",
#                         "85 to 89" = "#2c4b27",
#                         "90+" = "#0e2810")

# https://github.com/BlakeRMills/MetBrewer/blob/main/R/PaletteCode.R
# Palette: Cassatt 2 (first three and last three colours)
# GraphColoursOver65 <- c("65 to 69" = "#574571",
#                         "70 to 74" = "#90719f",
#                         "75 to 79" = "#466c4b",
#                         "80 to 84" = "#c1d1aa",
#                         "85 to 89" = "#7fa074",
#                         "90+" = "#2c4b27")

# Use something like the standard colours instead. Easier to distinguish.
# Just use scale_colour_brewer(palette = "Dark2")

NRSWeeklygradCumExcessDeaths_Over65_Graph = ggplot(#GraphDataOver65,
  data = filter(GraphDataOver65,Year == 2021),
  mapping = aes(x=WeekNo,
                y=gradcumExcess,
                colour = Age)
  )+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        plot.caption = element_text(hjust = 0),
        aspect.ratio=1)+
  scale_x_continuous(name = "Week number",
                     limits = c(5,35) # Start of the year
                     #limits = c(36,NA) # End of the year.
                     )+
  scale_y_continuous(name = "Gradient of Cumulative Excess Deaths",
                     labels = scales::comma#,
                     #limits = c(-25,50)
                     )+
  ggtitle("Gradient of Cumulative Excess Deaths in Scotland (age 65 and over) 2021",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption,
       caption.justification = "left")+
  # geom_line(size = 0.5,
  #           alpha = 0.5,
  #           show.legend = FALSE)+
  # geom_point(size = 1,
  #            alpha = 0.25,
  #            show.legend = FALSE)+
  geom_smooth(size = 2,
              method = "loess",
              se = FALSE,
              formula = y ~ x,
              span = 0.5,
              n = 100,
              orientation = "x",
              show.legend = TRUE)+
  geom_hline(yintercept = 0,
             linetype = "dashed",
             colour = "grey50",
             size = 1)+
  scale_colour_brewer(palette = "Dark2")
  #scale_colour_manual(values = GraphColoursOver65)#+
  # facet_wrap(vars(Age),
  #            ncol = 3,
  #            scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklygradCumExcessDeaths_Over65_Graph,
       device="png",
       width=graphwidth,
       height=graphwidth,
       units="mm",
       dpi=300
)

###############################################################################
#
#
# Gradient of Cumulative Excess Deaths in Scotland, Age 65+, 2021 (faceted by age group)
#
#
###############################################################################

GraphFileName = " Gradient of Cumulative Excess Deaths in Scotland (age 65 and over) 2021 [faceted by age group].png"

NRSWeeklygradCumExcessDeaths_Over65_Graph = ggplot(#GraphDataOver65,
  data = filter(GraphDataOver65,Year == 2021),
  mapping = aes(x=WeekNo,
                y=gradcumExcess,
                colour = Age)
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        plot.caption = element_text(hjust = 0))+
  scale_x_continuous(name = "Week number",
                     limits = c(5,35) # Start of the year(ish)
                     #limits = c(36,NA) # End of the year
                     )+
  scale_y_continuous(name = "Gradient of Cumulative Excess Deaths",
                     labels = scales::comma)+
  ggtitle("Gradient of Cumulative Excess Deaths in Scotland (age 65 and over) 2021",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption,
       caption.justification = "left")+
  geom_line(size = 0.5,
            alpha = 0.5,
            show.legend = FALSE)+
  geom_point(size = 1,
             alpha = 0.5,
             show.legend = FALSE)+
  geom_smooth(size = 2,
              method = "loess",
              se = FALSE,
              formula = y ~ x,
              span = 0.5,
              n = 50,
              orientation = "x",
              show.legend = FALSE)+
  geom_hline(yintercept = 0,
             linetype = "dashed",
             colour = "grey50",
             size = 1)+
  scale_colour_brewer(palette = "Dark2")+
  #scale_colour_manual(values = GraphColoursOver65)+
  facet_wrap(vars(Age),
           ncol = 3,
           scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklygradCumExcessDeaths_Over65_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

##################
setwd(RootDirectory)