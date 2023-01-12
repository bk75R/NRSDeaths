setwd(DataDirectory)

##########################################
# NRSDeaths_2022Excess.R                 #
# ======================                 #
#                                        #
# Calculate excess and baseline for 2022 #
#                                        #
##########################################

# Create df with 2016-2019 deaths
DeathsWeekly_pivot_2016_2019 <- DeathsWeekly_pivot_aggregate_All %>%
  filter(Year >= 2016) %>%
  select(Date,Week,Age,Deaths)

# Refactor DeathsWeekly_pivot_2016_2019
DeathsWeekly_pivot_2016_2019$Age = recode_factor(DeathsWeekly_pivot_2016_2019$Age,
                                                           "0" = "0",
                                                           "1-4" = "1 to 4",
                                                           "5-9" = "5 to 9",
                                                           "10-14" = "10 to 14",
                                                           "15-19" = "15 to 19",
                                                           "20-24" = "20 to 24",
                                                           "25-29" = "25 to 29",
                                                           "30-34" = "30 to 34",
                                                           "35-39" = "35 to 39",
                                                           "40-44" = "40 to 44",
                                                           "45-49" = "45 to 49",
                                                           "50-54" = "50 to 54",
                                                           "55-59" = "55 to 59",
                                                           "60-64" = "60 to 64",
                                                           "65-69" = "65 to 69",
                                                           "70-74" = "70 to 74",
                                                           "75-79" = "75 to 79",
                                                           "80-84" = "80 to 84",
                                                           "85-89" = "85 to 89",
                                                           "90+" = "90+")
# Add in 2021 deaths
DeathsWeekly_pivot_2021 <- DeathsTogetherCum2021 %>%
  select(Date,Age,Deaths) %>% # 'Cause' is 'All' in this data frame
  mutate(Week = isoweek(Date)) %>%
  relocate(Week, .after = "Date")

DeathsWeekly_pivot_aggregate_2016_2019_2021 <- rbind.data.frame(DeathsWeekly_pivot_2016_2019,DeathsWeekly_pivot_2021)

# Aggregate and find mean
DeathsWeekly_mean_2016_2019_2021 = aggregate(x = DeathsWeekly_pivot_aggregate_2016_2019_2021$Deaths,
                                             by=list(DeathsWeekly_pivot_aggregate_2016_2019_2021$Week,
                                                     DeathsWeekly_pivot_aggregate_2016_2019_2021$Age),
                                             FUN=mean)

colnames(DeathsWeekly_mean_2016_2019_2021) = c("Week","Age","Deaths")

# Create baseline for 2020, 2021 and 2022 data (2 off 2015-2019 mean deaths, plus 1 off 2016-2019 + 2021 mean deaths)
DeathsWeekly_ExcessBaseline_2022 <- rbind.data.frame(DeathsWeekly_mean_2015_2019,DeathsWeekly_mean_2015_2019,DeathsWeekly_mean_2016_2019_2021)
Year2020 <- as.data.frame(x = rep("2020",nrow(DeathsWeekly_mean_2015_2019)))
colnames(Year2020) <- "Year"
Year2021 <- as.data.frame(x = rep("2021",nrow(DeathsWeekly_mean_2015_2019)))
colnames(Year2021) <- "Year"
Year2022 <- as.data.frame(x = rep("2022",nrow(DeathsWeekly_mean_2016_2019_2021)))
colnames(Year2022) <- "Year"
Year2020_2022 <- rbind.data.frame(Year2020,Year2021,Year2022)
colnames(Year2020_2022) = "Year"
DeathsWeekly_ExcessBaseline_2022 <- cbind.data.frame(Year2020_2022,DeathsWeekly_ExcessBaseline_2022)
rm(Year2020,Year2021,Year2022,Year2020_2022)

DeathsWeekly_ExcessBaseline_2022 <- DeathsWeekly_ExcessBaseline_2022 %>%
  mutate(ISODate = paste(Year,"-W",sprintf("%02d",as.integer(Week)),"-","1",sep = "")) %>%
  mutate(Date = ISOweek2date(ISODate)) %>%
  relocate(ISODate) %>%
  relocate(Date) %>%
  filter(ISODate != "2022-W01-1") # Remove W01 of 2022 since W53 of 2021 overlaps it.

# Calculate excess deaths
# Trim DeathsWeekly_ExcessBaseline to same length as NRSDeaths_AllSum_refactored based on dates
DeathsWeekly_ExcessBaseline_2022_trim = DeathsWeekly_ExcessBaseline_2022 %>%
  filter(Date >= min(NRSDeaths_AllSum_refactored$Date) & Date <= max(NRSDeaths_AllSum_refactored$Date))
Cause = rep("Baseline",nrow(DeathsWeekly_ExcessBaseline_2022_trim))
DeathsWeekly_ExcessBaseline_2022_trim = cbind.data.frame(DeathsWeekly_ExcessBaseline_2022_trim,Cause)
rm(Cause)

NRSDeaths_AllSum_refactored = NRSDeaths_AllSum_refactored %>%
  complete(Date,nesting(Age,Cause),fill = list(Deaths = 0)) # This df has missing values - where deaths were 0 for a given factor on a certain date, the value was missed out.

# Form final DeathsTogether data frame.

NRSDeaths_AllSum_refactored_2022 <- filter(NRSDeaths_AllSum_refactored, Date < as.Date("2023-01-01"))
DeathsTogether2022 = bind_rows(select(DeathsWeekly_ExcessBaseline_2022_trim,Date,Age,Deaths,Cause),NRSDeaths_AllSum_refactored_2022) %>%
  #filter(Year == 2022) %>%
  group_by(Date,Age) %>% # Age factors are named differently.
  mutate(Excess = Deaths[Cause == "All"] - Deaths[Cause == "Baseline"])

# Reorder factors
DeathsTogether2022$Age <- factor(DeathsTogether2022$Age, levels=c("0","1 to 4","5 to 9","10 to 14",
                                                                    "15 to 19","20 to 24","25 to 29",
                                                                    "30 to 34","35 to 39","40 to 44",
                                                                    "45 to 49","50 to 54","55 to 59",
                                                                    "60 to 64","65 to 69","70 to 74",
                                                                    "75 to 79","80 to 84","85 to 89",
                                                                    "90+"))
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

#################################
setwd(RootDirectory)