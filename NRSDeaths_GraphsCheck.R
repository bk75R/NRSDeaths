setwd(GraphsDirectory)

ScaleDeathLinetypes <- c("All" = "solid",
                         "Baseline" = "dashed")
ScaleDeathPointTypes <- c("All" = 1,
                         "Baseline" = 2)
LineLabels <- c("All" = "All causes deaths (2021)",
                "Baseline" = "Expected deaths (based on 2015-2019 deaths)")

VlinesYears <- data.frame(Date = c(as.Date("2015-01-01"),
                                   as.Date("2016-01-01"),
                                   as.Date("2017-01-01"),
                                   as.Date("2018-01-01"),
                                   as.Date("2019-01-01")),
                                   Year = c(2015,2016,2017,2018,2019)
                          )

YearLabelPositions2015_2019 <- c(as.Date("2015-03-06"),
                                 as.Date("2016-03-06"),
                                 as.Date("2017-03-06"),
                                 as.Date("2018-03-06"),
                                 as.Date("2019-03-06"))


###################################
#
#
# Weekly deaths by age (All) (Scotland) - faceted
#
#
###################################

GraphFileName = " NRS Weekly Deaths by Age (2015-2019) - faceted.png"

NRSWeeklyDeaths_2015_2019_Graph = ggplot(data = DeathsWeekly_pivot_aggregate_2015_2019,
                                         mapping = aes(x=Date,
                                                       y=Deaths,
                                                       group=Age)
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        plot.caption = element_text(hjust = 0)
        )+
  scale_x_date(name = "Date",
               breaks = c(as.Date("2015-01-01"),
                          as.Date("2016-01-01"),
                          as.Date("2017-01-01"),
                          as.Date("2018-01-01"),
                          as.Date("2019-01-01")),
               date_labels = "%Y")+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(NA,NA),
                     labels = label_comma(accuracy = 1))+
  ggtitle("NRS Weekly Deaths by Age (2015-2019)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.25,
            alpha = 1,
            linetype = 1,
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_2015_2019_Graph,
       device="png",
       width=500,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################

###################################
#
#
# Average Weekly deaths by age (All) (Scotland)
#
#
###################################

GraphFileName = " NRS Weekly Deaths by Age (2015-2019, average) - faceted.png"

NRSWeeklyDeaths_Average_Graph = ggplot(data = DeathsWeekly_mean_2015_2019,
                                         mapping = aes(x=Week,
                                                       y=Deaths,
                                                       group=Age)
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        plot.caption = element_text(hjust = 0)
        )+
  scale_x_continuous(name = "Week number",
                     breaks = c(0,10,20,30,40,50))+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(NA,NA),
                     labels = label_number(accuracy = NULL))+
  ggtitle("NRS Weekly Deaths by Age (2015-2019, average)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            linetype = 1,
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Average_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###################################
#
#
# Average Weekly deaths by age (All) (Scotland) [2016-2019 plus 2021]
#
#
###################################

GraphFileName = " NRS Weekly Deaths by Age (2016-2019 plus 2021, average) - faceted.png"

NRSWeeklyDeaths_Average_Graph_2022 = ggplot(data = DeathsWeekly_mean_2016_2019_2021,
                                       mapping = aes(x=Week,
                                                     y=Deaths,
                                                     group=Age)
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        plot.caption = element_text(hjust = 0)
  )+
  scale_x_continuous(name = "Week number",
                     breaks = c(0,10,20,30,40,50))+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(NA,NA),
                     labels = label_number(accuracy = NULL))+
  ggtitle("NRS Weekly Deaths by Age (2016 to 2019 plus 2021, average)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            linetype = 1,
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Average_Graph_2022,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################
# Calculate summary data
###########################################

DeathsTogetherSummary <- DeathsTogether %>% 
  filter(Date >= as.Date("2021-04-01")) %>%
  select(Age,Deaths,Cause) %>%
  group_by(Age,Cause) %>%
  summarise(deaths = sum(Deaths)) %>%
  pivot_wider(names_from = "Cause",
              values_from = "deaths") %>%
  mutate(Difference = All - Baseline)

DeathsTogetherSummarySum = sum(DeathsTogetherSummary$Difference)

           
##########################################

###################################
#
#
# ExcessDeaths - faceted
#
#
###################################

GraphFileName = " Excess Deaths in Scotland (2020-2022) - faceted.png"

NRSWeeklyDeaths_Excess_Graph = ggplot(data = filter(DeathsTogether,Cause == "All"),
                                      mapping = aes(x=Date,
                                                    y=Excess,
                                                    group=Age)
                                      )+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        #panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0)
        )+
  scale_x_date(#limits = c(as.Date("2021-04-01"),NA),
    name = "Date",
    #date_breaks = "12 months",
    breaks = c(as.Date("2020-01-01"),as.Date("2021-01-01"),as.Date("2022-01-01")),
    date_labels = "%Y")+
  scale_y_continuous(name = "Weekly Deaths",
                     #limits = c(-25,100),
                     labels = label_number(accuracy = NULL))+
  ggtitle("Excess Deaths in Scotland (2020-2022) using 2015-2019 average deaths as baseline",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            #linetype = 1,
            #aes(),
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph,
       device="png",
       width=graphwidth*2,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################

###################################
#
#
# ExcessDeaths - faceted (2022 NRS baseline)
#
#
###################################

GraphFileName = " Excess Deaths in Scotland (2020-2022 using updated baseline) - faceted.png"

NRSWeeklyDeaths_Excess_Graph_2022 = ggplot(data = filter(DeathsTogether2022,Cause == "All"),
                                      mapping = aes(x=Date,
                                                    y=Excess,
                                                    group=Age)
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        #panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0)
  )+
  scale_x_date(#limits = c(as.Date("2021-04-01"),NA),
    name = "Date",
    #date_breaks = "12 months",
    breaks = c(as.Date("2020-01-01"),as.Date("2021-01-01"),as.Date("2022-01-01")),
    date_labels = "%Y")+
  scale_y_continuous(name = "Weekly Deaths",
                     #limits = c(-25,100),
                     labels = label_number(accuracy = NULL))+
  ggtitle("Excess Deaths in Scotland (2020-2022) using 2016 to 2019 plus 2021 average deaths as baseline",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            #linetype = 1,
            #aes(),
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph_2022,
       device="png",
       width=graphwidth*2,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################

setwd(RootDirectory)