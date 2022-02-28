# NRSDeaths
Calculating and reformatting NRS weekly deaths data for all available detailed age categories

This code and data are being made available here because the National Records of Scotland (NRS) doesn't make excess deaths data available in a more detailed format for presenting and analysing deaths by age group in Scotland.

## NRS Death Data
The data used in the excess deaths calculations are available here:
https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/deaths-involving-coronavirus-covid-19-in-scotland/related-statistics

Two datasets were used to calculate excess deaths:

* _["Weekly deaths by sex and age group in NHS health boards, 2020 - 2022"](https://www.nrscotland.gov.uk/files//statistics/covid19/weekly-deaths-by-sex-age-group-health-board-2020-2022.xlsx)
  * This gives weekly deaths for 2020 to 2022 divided by cause.
* _["Weekly deaths by sex and age group, 2000 to 2019"](https://www.nrscotland.gov.uk/files//statistics/covid19/weekly-deaths-by-sex-age-2000-2019.zip)
  * This was used to calculate the baseline data using weekly mortality by age group from 2015 to 2019
  * This dataset was unzipped and is shared in the `/data` directory. 

### Where is the detailed excess deaths dataset from NRS?
Unfortunately, excess deaths are only available from the [Public Health Scotland Shiny dashboard](https://scotland.shinyapps.io/phs-covid-wider-impact/) and these are grouped into "Under 65" and "65 and over" age groups only. This isn't helpful for tracking the effect of COVID-19, vaccination programmes and lockdowns on all causes deaths and COVID-19 deaths in more detail.

### Which age groups are covered?
The calculations in this code allows the calculation of the following age groups:

|   |   |   |   |
|---|---|---|---|
| 0 | 1 to 4 | 5 to 9 | 10 to 14|
| 15 to 19 | 20 to 24 | 25 to 29 | 30 to 34 |
| 35 to 39 | 40 to 44 | 45 to 49 | 50 to 54 |
| 55 to 59 | 60 to 64 | 65 to 69 | 70 to 74 |
| 75 to 79 | 80 to 84 | 85 to 89 | 90+ |
|   |   |   |   |

### The "Weekly deaths by sex and age group in NHS health boards, 2020 - 2022" has "90 to 94" and "95+" age groups too. What happened to them?

The oldest age group in the "Weekly deaths by sex and age group, 2000 to 2019" data is 90+. To allow a comparison between the 2000-2019 and 2020-2022 datasets the "90 to 94" and "95+" age groups were summed to create a "90+" age group in the "...2020 - 2022" dataset.

## How were excess deaths calculated?

Excess deaths were calculated in this way.

### Average deaths for 2015-2019 were calculated

![2022-02-28 NRS Weekly Deaths by Age (2015-2019, average) - faceted](https://user-images.githubusercontent.com/82215025/155972266-172bff67-39a9-46cc-9c20-b166dc3517c4.png)

These data were used as the "baseline" expected death rate for 2020 to 2022.
NRS now use 2016-2019 plus 2021 deaths as the baseline for 2022 (https://nrscotland.gov.uk/files/statistics/covid19/covid-deaths-methodology-excess-deaths-in-2022.pdf). **The dataset used here does not yet use the same method as NRS for 2022 excess deaths.** It will be updated to match the method used by NRS.

### Excess deaths were then calculated using the average deaths as the baseline

Excess deaths were calculated by subtracting the 2015-2019 average weekly deaths baseline data from the 2020-2022 weekly deaths data for each age group.

![2022-02-28 Excess Deaths in Scotland (2020-2022) - faceted](https://user-images.githubusercontent.com/82215025/155972750-f9b6b5e9-c863-45fd-8650-9a46898f4c9b.png)

## Cumulative excess deaths 

Cumulative excess deaths were also calculated. Graphing cumulative excess deaths can show more clearly when their weekly rate has changed over the year.

![2022-02-28 Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group)](https://user-images.githubusercontent.com/82215025/155980426-5b8649dc-7208-43b6-a862-505fc29934a1.png)

![2022-02-28 Cumulative Excess Deaths in Scotland, 2020 to 2022 (faceted by age group)](https://user-images.githubusercontent.com/82215025/155980449-1d4eabaa-7813-4fbd-90e2-3c41058620a0.png)

## Licensing

The data shared here available from the National Records Scotland website is made available under the [Open Government License](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/). The NRS provides more information on how their data is made available here: https://www.nrscotland.gov.uk/about-us/corporate-information#open%20data



