setwd(GraphsDirectory)



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
                     # breaks = c(1,2,3,4,5,6,7,8,9), # Needs more weeks
                     # breaks = seq(1,max(DeathsTogetherCum2020_2022_revised_graph$WeekNo),1), # Too many weeks
                     breaks = seq(10,max(DeathsTogetherCum2020_2022_graph$WeekNo),10), # Just right?
                     labels = label_comma(accuracy = 1),
                     # limits = c(0,NA) # No defined max limit
                     limits = c(0,max(DeathsTogetherCum2020_2022_graph$WeekNo)) # Max limit same as max(WeekNo)
                     )+
  scale_y_continuous(name = "Cumulative Excess Deaths",
                     labels = label_comma(accuracy = NULL))+
  ggtitle("Cumulative Excess Deaths in Scotland, 2020 to 2022 (using 2015-2019 deaths baseline)",
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

#######################################################################################################
#                                                                                                     #
#                                                                                                     #
# Cumulative Excess Deaths in Scotland, 2020 to 2022 (faceted by age group) - revised 2022 baseline   #
#                                                                                                     #
#                                                                                                     #
#######################################################################################################

YearColours = c("2020" = "grey25",
                "2021" = "grey50",
                "2022" = "black")
YearLineThicknesses = c("2020" = 0.25,
                        "2021" = 1,
                        "2022" = 1)

GraphFileName = " Cumulative Excess Deaths in Scotland, 2020 to 2022 (revised 2022 baseline).png"

DeathsTogetherCum2020_2022_revised_graph <- DeathsTogetherCum2020_2022_revised %>%
  filter(WeekNo <= isoweek(max(DeathsTogetherCum2020_2022_revised$Date)) + 2)

NRSWeeklyDeaths_Excess_Graph_revised2022baseline <- ggplot(data = DeathsTogetherCum2020_2022_revised_graph,
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
                     # breaks = c(1,2,3,4,5,6,7,8,9), # Needs more weeks
                     # breaks = seq(1,max(DeathsTogetherCum2020_2022_revised_graph$WeekNo),1), # Too many weeks
                     breaks = seq(10,max(DeathsTogetherCum2020_2022_revised_graph$WeekNo),10), # Just right?
                     labels = label_comma(accuracy = 1),
                     # limits = c(0,NA) # No defined max limit
                     limits = c(0,max(DeathsTogetherCum2020_2022_revised_graph$WeekNo)) # Max limit same as max(WeekNo)
  )+
  scale_y_continuous(name = "Cumulative Excess Deaths",
                     labels = label_comma(accuracy = NULL))+
  ggtitle("Cumulative Excess Deaths in Scotland, 2020 to 2022 (using 2016 to 2019 plus 2021 deaths as 2022 baseline)",
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
       plot = NRSWeeklyDeaths_Excess_Graph_revised2022baseline,
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

# Line colours and thicknesses for 2020 to 2021
YearColours20_21 <- c("2020" = "grey25",
                      "2021" = "grey50")
YearLineThicknesses20_21 <- c("2020" = 0.25,
                              "2021" = 1)

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
                     breaks = c(10,20,30,40,50))+
  scale_y_continuous(name = "Cumulative Excess Deaths",
                     labels = scales::comma)+
  ggtitle("Cumulative Excess Deaths in Scotland, 2020 and 2021",
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
                      values = YearColours20_21)+
  scale_size_manual(name = "Year",
                    values = YearLineThicknesses20_21)

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


##################
setwd(RootDirectory)