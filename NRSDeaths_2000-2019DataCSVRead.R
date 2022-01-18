################################################
#                                              #
#                                              #
# Read .csv files with deaths (2000-2019)      #
#                                              #
#                                              #
################################################

# Set WD to ages data path
setwd(NRSAgesDataDirectory)

# Get list of .csv files in directory
DeathsFilesList = list.files(path = NRSAgesDataDirectory,
                             pattern = "*.csv",
                             ignore.case = TRUE
                             )
# This won't download the data each time as the files are zipped.


# Set up basic data frame that will be filled by loop
DeathsWeekly_pivot_aggregate_All = data.frame(Date = as.Date("2020-01-01", origin = "1970-01-01"),
                                              ISODate = "2020-W1-01",
                                              Year = 2020,
                                              Week = 1,
                                              Age = as.factor("0"),
                                              Deaths = 0
                                              )
DeathsWeekly_pivot_aggregate_All = DeathsWeekly_pivot_aggregate_All[NULL,]
DeathsWeekly_pivot_aggregate = DeathsWeekly_pivot_aggregate_All


DeathsColNames = c("Age","Total",as.character(seq(from = 1,to = 53,by =1)))
DWAggColNames = c("Date","ISODate","Year","Week","Age","Deaths")

# Run through all files and add into DeathsWeekly_pivot_aggregate_All
for (FileCounter in 1:length(DeathsFilesList)) {

  DeathsWeekly_pivot_aggregate = DeathsWeekly_pivot_aggregate[NULL,]
  
  # B4:BD4 - column names
  # B5:BD24 - female data
  # B25:BD44 - male data

  # Read female data
  DeathsWeekly_Female = read.csv(DeathsFilesList[FileCounter],skip = 3,nrows = 20)
  DeathsWeekly_Female = DeathsWeekly_Female %>%
    select(-Sex)
  colnames(DeathsWeekly_Female) = DeathsColNames
  
  FileYear = str_sub(str_split(DeathsFilesList[FileCounter],".csv")[[1]][1],-4)
  
  DeathsWeekly_Female_pivot = DeathsWeekly_Female %>%
    pivot_longer(!Age,names_to = "Week",values_to = "Deaths")
  DeathsWeekly_Female_pivot = DeathsWeekly_Female_pivot %>%
    mutate(Sex = rep("F",nrow(DeathsWeekly_Female_pivot))) %>% # Add Sex column
    relocate(Sex) %>%
    mutate(Year = rep(FileYear,nrow(DeathsWeekly_Female_pivot))) %>% # Add year column
    relocate(Week) %>%
    relocate(Year) %>%
    filter(Week != "Total")
  DeathsWeekly_Female_pivot = DeathsWeekly_Female_pivot %>% # Add ISO dates and dates (first day of week, Sunday)
    mutate(ISODate = paste(Year,"-W",sprintf("%02d",as.integer(Week)),"-","1",sep = "")) %>%
    mutate(Date = ISOweek2date(ISODate)) %>%
    relocate(ISODate) %>%
    relocate(Date)
  # Read male data
  DeathsWeekly_Male = read.csv(DeathsFilesList[FileCounter],skip = 23,nrows = 20)
  
  DeathsWeekly_Male = DeathsWeekly_Male %>%
    select(-X) # Inherets blank name from empty cell above.
  colnames(DeathsWeekly_Male) = DeathsColNames
  
  DeathsWeekly_Male_pivot = DeathsWeekly_Male %>%
    pivot_longer(!Age,names_to = "Week",values_to = "Deaths")
  DeathsWeekly_Male_pivot = DeathsWeekly_Male_pivot %>%
    mutate(Sex = rep("F",nrow(DeathsWeekly_Male_pivot))) %>% # Add Sex column
    relocate(Sex) %>%
    mutate(Year = rep(FileYear,nrow(DeathsWeekly_Male_pivot))) %>% # Add year column
    relocate(Week) %>%
    relocate(Year) %>%
    filter(Week != "Total")
  
  DeathsWeekly_Male_pivot = DeathsWeekly_Male_pivot %>% # Add ISO dates and dates (first day of week, Sunday)
    mutate(ISODate = paste(Year,"-W",sprintf("%02d",as.integer(Week)),"-","1",sep = "")) %>%
    mutate(Date = ISOweek2date(ISODate)) %>%
    relocate(ISODate) %>%
    relocate(Date)
  
  # Put all data together and calculate total deaths each week
  DeathsWeekly_pivot = rbind.data.frame(DeathsWeekly_Female_pivot,DeathsWeekly_Male_pivot)
  
  # Get formats correct
  DeathsWeekly_pivot$Date = as.character(DeathsWeekly_pivot$Date)
  DeathsWeekly_pivot$Date = as.Date(DeathsWeekly_pivot$Date,
                                    origin = "1970-01-01")
  DeathsWeekly_pivot$Year = as.numeric(DeathsWeekly_pivot$Year)
  DeathsWeekly_pivot$Week = as.numeric(DeathsWeekly_pivot$Week)
  DeathsWeekly_pivot$Age = as.factor(DeathsWeekly_pivot$Age)
  
  # Aggregate sex results to give total per week
  DeathsWeekly_pivot_aggregate = aggregate(x = DeathsWeekly_pivot$Deaths,by=list(DeathsWeekly_pivot$Date,
                                                                                 DeathsWeekly_pivot$ISODate,
                                                                                 DeathsWeekly_pivot$Year,
                                                                                 DeathsWeekly_pivot$Week,
                                                                                 DeathsWeekly_pivot$Age
                                                                                 ),
                                           FUN=sum)
  colnames(DeathsWeekly_pivot_aggregate) = DWAggColNames
  
  # Add aggregated df into basic df
  DeathsWeekly_pivot_aggregate_All = rbind.data.frame(DeathsWeekly_pivot_aggregate_All,DeathsWeekly_pivot_aggregate)

}

DeathsWeekly_pivot_aggregate_All = DeathsWeekly_pivot_aggregate_All %>%
  filter(ISODate != "2000-W53-1") %>%
  filter(ISODate != "2001-W53-1") %>%
  filter(ISODate != "2002-W53-1") %>% # Filter out these non-existent weeks. Doesn't work when ORred for no apparent reason.
  filter(ISODate != "2003-W53-1") %>%
  filter(ISODate != "2005-W53-1") %>%
  filter(ISODate != "2006-W53-1") %>%
  filter(ISODate != "2007-W53-1") %>%
  filter(ISODate != "2008-W53-1") %>%
  filter(ISODate != "2010-W53-1") %>%
  filter(ISODate != "2011-W53-1") %>%
  filter(ISODate != "2012-W53-1") %>%
  filter(ISODate != "2013-W53-1") %>%
  filter(ISODate != "2014-W53-1") %>%
  filter(ISODate != "2016-W53-1") %>%
  filter(ISODate != "2017-W53-1") %>%
  filter(ISODate != "2018-W53-1") %>%
  filter(ISODate != "2019-W53-1")
  
  
DeathsWeekly_pivot_aggregate_2015_2019 = DeathsWeekly_pivot_aggregate_All %>%
  filter(Year >= "2015")

DeathsWeekly_mean_2015_2019 = aggregate(x = DeathsWeekly_pivot_aggregate_2015_2019$Deaths,by=list(DeathsWeekly_pivot_aggregate_2015_2019$Week,
                                                                                                  DeathsWeekly_pivot_aggregate_2015_2019$Age),
                                        FUN=mean)
colnames(DeathsWeekly_mean_2015_2019) = c("Week","Age","Deaths")

# Recode factors to match those in the NRS Deaths (2020-2021) data.
DeathsWeekly_mean_2015_2019$Age = recode_factor(DeathsWeekly_mean_2015_2019$Age,
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
# Create dates for 2020 and 2021 attached to DeathsWeekly_mean_2015_2019 data
# Basically, get 2020-W5-1 etc for each date and repeat dataset for 2021

DeathsWeekly_ExcessBaseline = rbind.data.frame(DeathsWeekly_mean_2015_2019,DeathsWeekly_mean_2015_2019)
Year2020 = as.data.frame(x = rep("2020",nrow(DeathsWeekly_mean_2015_2019)))
colnames(Year2020) = "Year"
Year2021 = as.data.frame(x = rep("2021",nrow(DeathsWeekly_mean_2015_2019)))
colnames(Year2021) = "Year"
Year20202021 = rbind.data.frame(Year2020,Year2021)
colnames(Year20202021) = "Year"
DeathsWeekly_ExcessBaseline = cbind.data.frame(Year20202021,DeathsWeekly_ExcessBaseline)
rm(Year2020,Year2021,Year20202021)

DeathsWeekly_ExcessBaseline = DeathsWeekly_ExcessBaseline %>%
  mutate(ISODate = paste(Year,"-W",sprintf("%02d",as.integer(Week)),"-","1",sep = "")) %>%
  mutate(Date = ISOweek2date(ISODate)) %>%
  relocate(ISODate) %>%
  relocate(Date)


# Calculate excess deaths
# SUbtract average(2015-2019) from 2020 and 2021 deaths.

# Need to recategorise data first: NRS 2015-2019 has "90+" as oldest age category, but 2020-2021 weekly deaths has "90 to 94" and "95+"

NRSDeaths_AllSum_oldest = NRSDeaths_AllSum %>%
  filter(Age == "90 to 94" | Age == "95+")
NRSDeaths_AllSum_oldest_agg = aggregate(x = NRSDeaths_AllSum_oldest$Deaths,by=list(NRSDeaths_AllSum_oldest$Date,
                                                                                   NRSDeaths_AllSum_oldest$Cause),
                                    FUN=sum) # Add together death values from "90-94" and "95+" into "90+"
aggAges = rep("90+",nrow(NRSDeaths_AllSum_oldest_agg)) # Create list of "90+" factors of same length as NRSDeaths_AllSum_oldest_agg
NRSDeaths_AllSum_oldest_agg = cbind.data.frame(NRSDeaths_AllSum_oldest_agg,aggAges)
colnames(NRSDeaths_AllSum_oldest_agg) = c("Date","Cause","Deaths","Age")
NRSDeaths_AllSum_oldest_agg = NRSDeaths_AllSum_oldest_agg %>%
  relocate(Age, .after = Date)

NRSDeaths_AllSum_refactored = NRSDeaths_AllSum %>%
  filter(Age != "90 to 94", Age != "95+")
NRSDeaths_AllSum_refactored = rbind.data.frame(NRSDeaths_AllSum_refactored,NRSDeaths_AllSum_oldest_agg)
rm(NRSDeaths_AllSum_oldest_agg,aggAges,NRSDeaths_AllSum_oldest)



# Now that 2015-2019 deaths and 2020-2021 deaths are factored in the same way, calculate the excess.
# How?

# Trim DeathsWeekly_ExcessBaseline to same length as NRSDeaths_AllSum_refactored based on dates

DeathsWeekly_ExcessBaseline_trim = DeathsWeekly_ExcessBaseline %>%
  filter(Date >= min(NRSDeaths_AllSum_refactored$Date) & Date <= max(NRSDeaths_AllSum_refactored$Date))
Cause = rep("Baseline",nrow(DeathsWeekly_ExcessBaseline_trim))
DeathsWeekly_ExcessBaseline_trim = cbind.data.frame(DeathsWeekly_ExcessBaseline_trim,Cause)
rm(Cause)
NRSDeaths_AllSum_refactored = NRSDeaths_AllSum_refactored %>%
  complete(Date,nesting(Age,Cause),fill = list(Deaths = 0)) # This df has missing values - where deaths were 0 for a given factor on a certain date, the value was missed out.

# Form final DeathsTogether data frame.
DeathsTogether = bind_rows(select(DeathsWeekly_ExcessBaseline_trim,Date,Age,Deaths,Cause),NRSDeaths_AllSum_refactored) %>%
  group_by(Date,Age) %>% # Age factors are named differently.
  mutate(Excess = Deaths[Cause == "All"] - Deaths[Cause == "Baseline"])


setwd(RootDirectory)