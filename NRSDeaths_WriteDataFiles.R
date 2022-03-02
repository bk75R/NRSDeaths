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

# Save to disk
sheets <- list("Excess deaths" = DeathsTogether2022ExcessWide,
               "All cause deaths" = DeathsTogether2022ACWide,
               "Baseline deaths" = DeathsTogether2022BaselineWide,
               "Mean deaths 2015-2019" = DeathsWeekly_mean_2015_2019_Wide,
               "Mean deaths 2016 to 19+21" = DeathsWeekly_mean_2016_2019_2021_Wide
               )
write_xlsx(sheets,"NRSExcessDeaths.xlsx")

setwd(RootDirectory)