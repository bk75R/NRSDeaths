setwd(DataDirectory)

# Save data files in a spreadsheet-friendly format

sheets <- list("All cause and baseline" = DeathsTogether,
               "Mean deaths 2015-2019" = DeathsWeekly_mean_2015_2019
               )
write_xlsx(sheets,"NRSExcessDeaths.xlsx")

setwd(RootDirectory)