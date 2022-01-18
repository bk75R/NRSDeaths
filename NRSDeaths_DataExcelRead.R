setwd(DataDirectory)

# Read the file from the website.
NRSDeathsURL = "https://www.nrscotland.gov.uk/files//statistics/covid19/weekly-deaths-by-sex-age-group-health-board-2020-2021.xlsx"

GraphFileNameRoot = as.character(format(Sys.Date(),"%Y-%m-%d"))
NRSDeathsFileName = paste(GraphFileNameRoot,"_NRS_HBdeaths.xlsx",sep="")
NRSDeathsColNames = c("Week","HBcode","HB","Sex","Age","Cause","Deaths")

##########################################
#
#
# NRS deaths data
#
#
##########################################

# Download data into tmp files
GET(NRSDeathsURL, write_disk(NRSDeathsFileName, overwrite = TRUE))

# Read deaths column to get maximum no. of rows to read
NRSDeathsCol <- read_xlsx(NRSDeathsFileName,
                       sheet = 2, # "Data" 
                       range = cell_cols("G:G")
)
# Read all deaths data in sheet 2
NRSDeaths <- read_xlsx(NRSDeathsFileName,
                       sheet = 2, # "Data" 
                       range = cell_limits(c(4,1),c(nrow(NRSDeathsCol),7)),
                       col_names = FALSE
                       )
rm(NRSDeathsCol)
colnames(NRSDeaths) = NRSDeathsColNames

NRSDeaths = NRSDeaths %>%
  mutate(Year = paste("20",str_sub(Week,1,2),sep = "")) %>% # Split up "20W01" date format
  mutate(Week = str_sub(Week,4,5)) %>% # Create Week number column
  mutate(ISODate = paste(Year,"-W",Week,"-","1",sep = "")) %>%
  mutate(Date = ISOweek2date(ISODate)) %>% # Create Year column
  relocate(Year) %>%
  relocate(ISODate) %>%
  relocate(Date) # Reorder columns

# Aggregate deaths by Date, Age and Cause
NRSDeaths_ByType_aggregate = aggregate(x = NRSDeaths$Deaths,by=list(NRSDeaths$Date,NRSDeaths$Age,NRSDeaths$Cause),FUN=sum)
colnames(NRSDeaths_ByType_aggregate) = c("Date","Age","Cause","Deaths")

# Aggregate this by Date and Age
NRSDeaths_AllSum = aggregate(x = NRSDeaths_ByType_aggregate$Deaths,by=list(NRSDeaths_ByType_aggregate$Date,NRSDeaths_ByType_aggregate$Age),FUN=sum)
colnames(NRSDeaths_AllSum) = c("Date","Age","Deaths")
Cause = rep("All",nrow(NRSDeaths_AllSum))
NRSDeaths_AllSum = cbind(NRSDeaths_AllSum,Cause)
NRSDeaths_AllSum = NRSDeaths_AllSum %>%
  relocate(Cause, .before = "Deaths")

# Aggregate COVID deaths
NRSDeaths_COVID_aggregate = NRSDeaths_ByType_aggregate %>%
  filter(Cause == unique(NRSDeaths$Cause)[2] | Cause == unique(NRSDeaths$Cause)[3])
# This combines "COVID-19 contributory factor" and "COVID-19 underlying cause".
# These should be retained as separate categories.


# Calculate sum of COVID deaths (by date and age)
NRSDeaths_COVIDSum = aggregate(x = NRSDeaths_COVID_aggregate$Deaths,by=list(NRSDeaths_COVID_aggregate$Date,NRSDeaths_COVID_aggregate$Age),FUN=sum)
colnames(NRSDeaths_COVIDSum) = c("Date","Age","Deaths")
Cause = rep("COVID",nrow(NRSDeaths_COVIDSum))
NRSDeaths_COVIDSum = cbind(NRSDeaths_COVIDSum,Cause)
NRSDeaths_COVIDSum = NRSDeaths_COVIDSum %>%
  relocate(Cause, .before = "Deaths")

# Aggregate non-COVID deaths
NRSDeaths_NonCOVID_aggregate = NRSDeaths_ByType_aggregate %>%
  filter(Cause == unique(NRSDeaths$Cause)[1])

# Calculate sum of non-COVID deaths (by date and age)
NRSDeaths_NonCOVIDSum = aggregate(x = NRSDeaths_NonCOVID_aggregate$Deaths,by=list(NRSDeaths_NonCOVID_aggregate$Date,NRSDeaths_NonCOVID_aggregate$Age),FUN=sum)
colnames(NRSDeaths_NonCOVIDSum) = c("Date","Age","Deaths")
Cause = rep("Non-COVID",nrow(NRSDeaths_NonCOVIDSum))
NRSDeaths_NonCOVIDSum = cbind(NRSDeaths_NonCOVIDSum,Cause)
NRSDeaths_NonCOVIDSum = NRSDeaths_NonCOVIDSum %>%
  relocate(Cause, .before = "Deaths")
 
# Reset WD to ScriptWD for next script
setwd(RootDirectory)