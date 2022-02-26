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
# Weekly deaths by age (All) (Scotland)
#
#
###################################

GraphFileName = " NRS Weekly Deaths by Age (2015-2019).png"

NRSWeeklyDeaths_2015_2019_Graph = ggplot(data = DeathsWeekly_pivot_aggregate_2015_2019,#filter(DeathsWeekly_pivot_aggregate_2015_2019,Year == "2019"),
                                      mapping = aes(x=Date,
                                                    y=Deaths,
                                                    colour=Age)
)+
  theme_bw()+
  scale_x_date(name = "Date (MM/YY)",
               date_breaks = "3 months",
               date_labels = "%m/%y",
               minor_breaks = "1 month")+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(0,NA),
                     labels = scales::comma
  )+
  ggtitle("NRS Weekly Deaths by Age (2015-2019)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            linetype = 1,
            #aes(),
            show.legend = TRUE)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_2015_2019_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################


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
        panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0))+
  scale_x_date(name = "Date",
               date_breaks = "12 months",
               date_labels = "%Y",
               #minor_breaks = "3 months",
               labels = YearLabelPositions2015_2019)+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(NA,NA),
                     labels = label_comma(accuracy = 1))+
  ggtitle("NRS Weekly Deaths by Age (2015-2019)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_vline(data = VlinesYears,
             aes(xintercept = Date),
             colour = "grey75",
             show.legend = FALSE)+
  
  geom_line(size = 0.2,
            alpha = 1,
            linetype = 1,
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 5,
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
        panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0))+
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
            #aes(),
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

###########################################

###################################
#
#
# Average Weekly deaths by age (All) (Scotland)
#
#
###################################

GraphFileName = " NRS Weekly Deaths by Age (2015-2019, average).png"

NRSWeeklyDeaths_Average_Graph = ggplot(data = DeathsWeekly_mean_2015_2019,
                                       mapping = aes(x=Week,
                                                     y=Deaths,
                                                     colour=Age)
)+
  theme_bw()+
  scale_x_continuous(name = "Week number")+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(0,NA),
                     labels = scales::comma)+
  ggtitle("NRS Weekly Deaths by Age (2015-2019, average)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            linetype = 1,
            #aes(),
            show.legend = TRUE)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Average_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################

###################################
#
#
# Average Weekly deaths by age (baseline for 2020-2022) (Scotland)
#
#
###################################

GraphFileName = " NRS excess deaths by age (baseline for 2020-2022).png"

NRSWeeklyDeaths_Baseline_Graph = ggplot(data = DeathsWeekly_ExcessBaseline,
                                       mapping = aes(x=Date,
                                                     y=Deaths,
                                                     colour=Age)
)+
  theme_bw()+
  scale_x_date(name = "Date (MM/YY)",
               date_breaks = "3 months",
               date_labels = "%m/%y",
               minor_breaks = "1 month")+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(0,NA),
                     labels = scales::comma)+
  ggtitle("NRS excess deaths by age (baseline for 2020-2022)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            linetype = 1,
            #aes(),
            show.legend = TRUE)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Baseline_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################


###################################
#
#
# DeathsTogether
#
#
###################################

GraphFileName = " DeathsTogether.png"

NRSWeeklyDeaths_Excess_Graph = ggplot(data = DeathsTogether,
                                        mapping = aes(x=Date,
                                                      y=Deaths,
                                                      colour=Age,
                                                      linetype = Cause)
)+
  theme_bw()+
  scale_x_date(limits = c(as.Date("2020-12-01"),NA),
    name = "Date (MM/YY)",
               date_breaks = "1 week",
               date_labels = "%d/%m/%y"#,
               #minor_breaks = "1 month"
               )+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(0,NA),
                     labels = scales::comma)+
  ggtitle("DeathsTogether",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  geom_line(size = 0.5,
            alpha = 1,
            #linetype = 1,
            #aes(),
            show.legend = TRUE)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

###########################################

###################################
#
#
# DeathsTogether (faceted)
#
#
###################################

GraphCaptionOld <- GraphCaption
GraphCaption <- "Data source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/\ndeaths-involving-coronavirus-covid-19-in-scotland/related-statistics"

GraphFileName = " Deaths - All Causes and Expected (faceted by age group).png"

NRSWeeklyDeaths_Excess_Graph = ggplot(data = filter(DeathsTogether,Date >= as.Date("2021-04-01")),
                                      mapping = aes(x=Date,
                                                    y=Deaths,
                                                    #colour=Age,
                                                    linetype = Cause)
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside")+
  scale_x_date(#limits = c(as.Date("2021-04-01"),NA),
               name = "Month",
               date_breaks = "1 month",
               date_labels = "%b"
  )+
  scale_y_continuous(name = "Weekly Deaths",
                     labels = scales::comma)+
  ggtitle("Deaths - All Causes and Expected (faceted by age group)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption,
       caption.justification = "left")+
  geom_line(size = 0.5,
            alpha = 1,
            show.legend = TRUE)+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")+
  scale_linetype_manual(name = "Type of Death",
                        values = ScaleDeathLinetypes,
                        labels = LineLabels)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

GraphCaption <- GraphCaptionOld

DeathsTogetherSummary <- DeathsTogether %>% 
  filter(Date >= as.Date("2021-04-01")) %>%
  select(Age,Deaths,Cause) %>%
  group_by(Age,Cause) %>%
  summarise(deaths = sum(Deaths)) %>%
  pivot_wider(names_from = "Cause",
              values_from = "deaths") %>%
  mutate(Difference = All - Baseline)

DeathsTogetherSummarySum = sum(DeathsTogetherSummary$Difference)

           
           

###########################################


###################################
#
#
# DeathsTogether (faceted) with loess smoothed fits
#
#
###################################

GraphCaptionOld <- GraphCaption
GraphCaption <- "Data source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/\ndeaths-involving-coronavirus-covid-19-in-scotland/related-statistics"

GraphFileName = " Deaths - All Causes and Expected with fit lines (faceted by age group).png"

NRSWeeklyDeaths_Excess_Graph = ggplot(data = filter(DeathsTogether,Date >= as.Date("2021-04-01")),
                                      mapping = aes(x=Date,
                                                    y=Deaths,
                                                    #colour=Age,
                                                    shape = Cause,
                                                    linetype = Cause)
)+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside")+
  scale_x_date(#limits = c(as.Date("2021-04-01"),NA),
    name = "Month",
    date_breaks = "1 month",
    date_labels = "%b"
  )+
  scale_y_continuous(name = "Weekly Deaths",
                     labels = scales::comma)+
  ggtitle("Deaths - All Causes and Expected with Fit Lines (faceted by age group)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption,
       caption.justification = "left")+
  # geom_line(size = 0.5,
  #           alpha = 1,
  #           show.legend = TRUE)+
  geom_point(size = 1,
             colour = "black",
             fill = "black")+
  geom_smooth(se = FALSE,
              span = 0.5,
              size = 0.5,
              colour = "black")+
  facet_wrap(vars(Age),
             ncol = 4,
             scales = "free_y")+
  scale_linetype_manual(name = "Type of Death",
                        values = ScaleDeathLinetypes,
                        labels = LineLabels)+
  scale_shape_manual(name = "Type of Death",
                     values = ScaleDeathPointTypes,
                     labels = LineLabels)

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

GraphCaption <- GraphCaptionOld

###########################################

###################################
#
#
# ExcessDeaths
#
#
###################################
#graphheight = 2*graphheight

GraphFileName = " Excess Deaths in Scotland (2020-2022).png"

NRSWeeklyDeaths_Excess_Graph = ggplot(data = filter(DeathsTogether,Cause == "All"),
                                      mapping = aes(x=Date,
                                                    y=Excess,
                                                    colour=Age)
)+
  theme_bw()+
  scale_x_date(limits = c(as.Date("2020-12-01"),NA),
               name = "Date (MM/YY)",
               date_breaks = "1 month",
               date_labels = "%m/%y"#,
               #minor_breaks = "1 week"
  )+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(-25,100),
                     labels = scales::comma)+
  ggtitle("Excess Deaths in Scotland (2020-2022)",
          subtitle = GraphSubtitle)+
  labs(caption = GraphCaption)+
  # geom_hline(yintercept = 0,
  #            linetype = "dashed",
  #            colour = "grey50")+
  geom_line(size = 0.5,
            alpha = 1,
            #linetype = 1,
            #aes(),
            show.legend = TRUE)#+
  # facet_wrap(vars(Age),
  #            ncol = 1,
  #            scales = "fixed")

#Save graph
ggsave(filename = paste(GraphFileNameRoot,GraphFileName,sep=""),
       plot = NRSWeeklyDeaths_Excess_Graph,
       device="png",
       width=graphwidth,
       height=graphheight,
       units="mm",
       dpi=300
)

#graphheight = 0.5*graphheight
###########################################

setwd(RootDirectory)