setwd(DataDirectory)

# Save data files in a spreadsheet-friendly format

# Pivot dataframes to (spreadsheet-friendly) wide format 
DeathsTogether2022ACWide <- DeathsTogether2022 %>%
  filter(Cause == "All") %>%
  select(Date,Age,Deaths) %>%
  pivot_wider(names_from = Age, values_from = Deaths)

DeathsTogether2022BaselineWide <- DeathsTogether2022 %>%
  filter(Cause == "Baseline") %>%
  select(Date,Age,Deaths) %>%
  pivot_wider(names_from = Age, values_from = Deaths)

DeathsTogether2022ExcessWide <- DeathsTogether2022 %>%
  filter(Cause == "All") %>%
  select(Date,Age,Excess) %>%
  pivot_wider(names_from = Age, values_from = Excess)

DeathsWeekly_mean_2015_2019_Wide <- DeathsWeekly_mean_2015_2019 %>%
  pivot_wider(names_from = Age, values_from = Deaths)

DeathsWeekly_mean_2016_2019_2021_Wide <- DeathsWeekly_mean_2016_2019_2021 %>%
  pivot_wider(names_from = Age, values_from = Deaths)

ExplanatoryText <- as.data.frame(c("Created by @bouncingkitten",
                                   "https://www.drowningindata.blog",
                                   "",
                                   "Scripts and data are available from",
                                   "https://github.com/bk75R/NRSDeaths",
                                   "",
                                   "See the README file for more details at",
                                   "https://github.com/bk75R/NRSDeaths/blob/main/README.md",
                                   "",
                                   "Each page in the spreadsheet contains data with the first column showing date or week number.",
                                   "The top row contains age categories which match all those available in the National Records Scotland 2000-2019 weekly death data.",
                                   "",
                                   "'Excess Deaths' contains excess deaths for 2020-2022 calculated using the mean of the 2015 to 2019 weekly deaths as a baseline for 2020 and 2021, and the mean of 2016 to 2019 plus 2021 deaths as the baseline for 2022 weekly deaths.",
                                   "'All cause deaths' contains all cause deaths for 2020-2022 reformatted from the 'Weekly deaths by age and sex' datasets",
                                   "'Baseline deaths' contains the baseline calculated using 2015-2019 (for 2020 and 2021) deaths and 2016 to 2019 plus 2021 (for 2022) deaths.",
                                   "'Mean deaths 2015-2019' contains mean weekly deaths from 2015 to 2019 (with the first column containing week number)",
                                   "'Mean deaths 2016 to 19+21' contains mean weekly deaths from 2016 to 2019 plus 2021 (with the first column containing week number)",
                                   "",
                                   "Original data is sourced from National Records Scotland",
                                   "https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/deaths-involving-coronavirus-covid-19-in-scotland/related-statistics",
                                   "and is shared under the Open Government Licence",
                                   "https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/",
                                   "",
                                   "The code and data shared here is licensed under the Unlicense:",
                                   "https://github.com/bk75R/NRSDeaths/blob/main/LICENSE"))

colnames(ExplanatoryText) <- "Excess Deaths in Scotland 2020-2022"

# Save to disk
sheets <- list("Explanation" = ExplanatoryText,
               "Excess deaths" = DeathsTogether2022ExcessWide,
               "All cause deaths" = DeathsTogether2022ACWide,
               "Baseline deaths" = DeathsTogether2022BaselineWide,
               "Mean deaths 2015-2019" = DeathsWeekly_mean_2015_2019_Wide,
               "Mean deaths 2016 to 19+21" = DeathsWeekly_mean_2016_2019_2021_Wide
               )
write_xlsx(sheets,paste(GraphFileNameRoot," Excess Deaths in Scotland 2020-2022.xlsx",sep=""))

setwd(RootDirectory)