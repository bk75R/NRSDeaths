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

### Average deaths for 2015 to 2019 were calculated
![2022-02-28 NRS Weekly Deaths by Age (2015-2019, average) - faceted](https://user-images.githubusercontent.com/82215025/155989654-3646ec6f-2801-4ac6-b819-2edaf8cac687.png)
These data were used as the "baseline" expected death rate for 2020 to 2021.

### Average deaths for 2016 to 2019 plus 2021 were calculated
![2022-02-28 NRS Weekly Deaths by Age (2016-2019 plus 2021, average) - faceted](https://user-images.githubusercontent.com/82215025/156440945-077dd899-2b1d-408b-a1ac-222abf9ed1e1.png)
NRS use 2016-2019 plus 2021 deaths as the baseline for 2022 (https://nrscotland.gov.uk/files/statistics/covid19/covid-deaths-methodology-excess-deaths-in-2022.pdf). The same baseline as NRS was used to calculate 2022 excess deaths.

### Excess deaths were then calculated using the average deaths as the baseline

Excess deaths were calculated by subtracting the 2015 to 2019 average weekly deaths baseline data from the 2020 and 2021 weekly deaths data, and the 2016 to 2019 plus 2021 average weekly deaths baseline data from the 2022 weekly deaths data, for each age group.
![2022-03-02 Excess Deaths in Scotland (2020-2022 using updated baseline) - faceted](https://user-images.githubusercontent.com/82215025/156441332-835b5544-7e92-485a-a8a5-42be2f8080b3.png)

## Cumulative excess deaths 

Cumulative excess deaths were also calculated. Graphing cumulative excess deaths can show more clearly when their weekly rate has changed over the year.

![2022-02-28 Cumulative Excess Deaths in Scotland, 2020 and 2021 (faceted by age group)](https://user-images.githubusercontent.com/82215025/155989769-66797cea-424e-4694-bd1d-7fa3a8fe8aa0.png)

![2022-03-02 Cumulative Excess Deaths in Scotland, 2020 to 2022 (revised 2022 baseline)](https://user-images.githubusercontent.com/82215025/156439326-ddd857b9-c457-4cf3-bcb9-6497df1b08c4.png)

# Data format

The data are available in a `.xlsx` file in the `/data` folder.

## Excess deaths
![NRSExcessDeaths excel sheet - excess](https://user-images.githubusercontent.com/82215025/156439986-95dd178a-6ee2-41b8-94bc-d9dd5138d7b2.png)
## All cause deaths
![NRSExcessDeaths excel sheet - all cause](https://user-images.githubusercontent.com/82215025/156440016-360c119e-0458-4f1f-881c-c2400355379d.png)
## Baseline deaths
![NRSExcessDeaths excel sheet - baseline](https://user-images.githubusercontent.com/82215025/156440055-55f2ffec-8d94-48fc-9905-38f92a83fa68.png)
## Mean deaths 2015 to 2019
![NRSExcessDeaths excel sheet - mean 2015-2019](https://user-images.githubusercontent.com/82215025/156440077-691a6eb7-9da5-4cf6-8a1e-2c4220affa73.png)
## Mean deaths 2016 to 2019 plus 2021
![NRSExcessDeaths excel sheet - mean 2016-2019 + 2021](https://user-images.githubusercontent.com/82215025/156440107-913f2a59-73eb-4490-8366-40e901470891.png)

## Licensing

The data shared here available from the National Records Scotland website is made available under the [Open Government License](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/). The NRS provides more information on how their data is made available here: https://www.nrscotland.gov.uk/about-us/corporate-information#open%20data



