setwd(GraphsDirectory)

###################################################
#                                                 #
# Add cumulative deaths to DeathsTogether df      #
#                                                 #
###################################################

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

###################################################################
#                                                                 #
# Add df for revised 2022 baseline cumulative excess deaths data  #
#                                                                 #
###################################################################


DeathsTogetherCum2022revised <- DeathsTogether2022 %>%
  filter(Date >= as.Date("2022-01-01") & Date <= as.Date("2022-12-31")) %>%
  filter(Cause == "All") %>%
  group_by(Age) %>%
  mutate(cumDeaths = cumsum(Deaths)) %>%
  mutate(cumExcess = cumsum(Excess))

DeathsTogetherCum2020_2022_revised <- rbind.data.frame(DeathsTogetherCum2020,DeathsTogetherCum2021,DeathsTogetherCum2022revised)

# Add year, ISO week and gradient of cumExcess and cumDeaths.
DeathsTogetherCum2020_2022_revised <- DeathsTogetherCum2020_2022_revised %>%
  group_by(Age) %>%
  mutate(Year = as.factor(isoyear(Date))) %>%
  mutate(WeekNo = isoweek(Date)) %>%
  mutate(gradcumExcess = (cumExcess - lag(cumExcess))/(WeekNo - lag(WeekNo))) %>%
  mutate(gradcumDeaths = (cumDeaths - lag(cumDeaths))/(WeekNo - lag(WeekNo)))

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
                     breaks = c(1,2,3,4,5,6,7,8,9),
                     labels = label_comma(accuracy = 1),
                     limits = c(0,NA)
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
                     breaks = c(1,2,3,4,5,6,7,8,9),
                     labels = label_comma(accuracy = 1),
                     limits = c(0,NA)
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


##################
setwd(RootDirectory)