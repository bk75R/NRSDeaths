setwd(DataDirectory)

##----------------------------------------------------------------------------##
# It might easier for the general public to conceptualise all-cuase death in
# absolute numbers, rather than excess. So, create plot for 2019 to 2022 and
# facet by:
#
# 0 to 19
# 20 to 44
# 45 to 69
# 70+
#
# As these categries reduce the data to reflect the lifecourse stages:
# young, early-mid, late-mid, older
#
# TidyStewart, 18 March 2022
##----------------------------------------------------------------------------##

# Steve has done the heavy-lifting, all data already in
NRSDeaths

# Create a copy
NRSDeathsNewAge = NRSDeaths

# Change age to factor levels
NRSDeathsNewAge$Age <- as.factor(NRSDeathsNewAge$Age)

# Setup the new age groups
NRSDeathsNewAge <- NRSDeaths %>%
                    mutate (AgeNew =
                    case_when ( Age == "0" ~ "0 to 19",
                                Age == "1 to 4" ~ "0 to 19",
                                Age == "5 to 9" ~ "0 to 19",
                                Age == "10 to 14" ~ "0 to 19",
                                Age == "15 to 19" ~ "0 to 19",

                                Age == "20 to 24" ~ "20 to 44",
                                Age == "25 to 29" ~ "20 to 44",
                                Age == "30 to 34" ~ "20 to 44",
                                Age == "35 to 39" ~ "20 to 44",
                                Age == "40 to 44" ~ "20 to 44",

                                Age == "45 to 49" ~ "45 to 69",
                                Age == "50 to 54" ~ "45 to 69",
                                Age == "55 to 59" ~ "45 to 69",
                                Age == "60 to 64" ~ "45 to 69",
                                Age == "65 to 69" ~ "45 to 69",

                                Age == "70 to 74" ~ "70+",
                                Age == "75 to 79" ~ "70+",
                                Age == "80 to 84" ~ "70+",
                                Age == "85 to 89" ~ "70+",
                                Age == "90 to 94" ~ "70+",
                                Age == "95+" ~ "70+"
                              ))


NRSDeathsNewAge <- NRSDeathsNewAge %>% relocate (AgeNew, .after = Age)

##----------------------------------------------------------------------------##
## Plot
##----------------------------------------------------------------------------##
GraphFileName = " NRS Weekly Deaths by Age (2019-2022) - absolute.png"

NRSWeeklyDeaths_2019_2022_Absolute_Graph <-
      ggplot(data = NRSDeathsNewAge,
               mapping = aes(x=Date,
                             y=Deaths,
                          colour = Year)) +
            geom_point(size = 0.25,
                      alpha = 1,
                      linetype = 1,
                      show.legend = TRUE)+
                      geom_smooth(method='lm',formula=y~x) +
  facet_wrap(vars(AgeNew),
             nrow = 4,
             scales = "free_y")+
  theme_minimal()+
  theme(panel.background = element_rect(fill = 'white', color = 'white'),
        plot.background = element_rect(fill = 'white', color = 'white'),
        legend.position="bottom",
        legend.justification = "centre",
        strip.background = element_blank(),
        strip.placement = "outside",
        plot.caption = element_text(hjust = 0)
        )+
  # scale_x_date(name = "Date",
  #              breaks = c(as.Date("2015-01-01"),
  #                         as.Date("2016-01-01"),
  #                         as.Date("2017-01-01"),
  #                         as.Date("2018-01-01"),
  #                         as.Date("2019-01-01")),
  #              date_labels = "%Y")+
  scale_y_continuous(name = "Weekly Deaths",
                     limits = c(NA,NA))+
                     #labels = label_comma(accuracy = 1))+
  ggtitle("NRS Weekly Deaths by Age (2020-2022)") +
          # subtitle = GraphSubtitle)+
  labs(caption = "Data source: National Records of Scotland")
