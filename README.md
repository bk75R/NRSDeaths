# NRSDeaths
Calculating and reformatting NRS weekly deaths data for all available age categories

The code shared here was used to calculate the link between excess deaths and percentages of the Scottish population who received SARS-CoV-2 vaccines.
I wrote a series of blog posts on this topic here:
https://drowningindatadotblog.wordpress.com/2021/0/19/linking-excess-deaths-and-sars-cov2-vaccinations-in-scotland/

https://drowningindatadotblog.wordpress.com/2021/05/27/linking-excess-deaths-and-sars-cov-2-vaccinations-in-scotland-26-may-2021/

https://drowningindatadotblog.wordpress.com/2021/10/16/excess-deaths-and-vaccination-making-things-a-bit-clearer/

I'm making this code and data available here because the National Records of Scotland doesn't make deaths data available in a more usable format for presenting and analysing deaths in Scotland.

# NRS Death Data
The data from the NRS is available here:

Unfortunately, excess deaths are only available from the Public Health Scotland Shiny dashboard and these are grouped into 15-64 and 65+ age groups only.
This isn't helpful for tracking the effect of COVID-19, vaccination programmes and lockdowns on all causes deaths and COVID-19 deaths.

# What happens to the NRS data?
The NRS data on weekly mortality by age, sex and health board is used to calculate the overall deaths for each age group for the whole of Scotland.

