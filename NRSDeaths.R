##########################################################
# Name of script - NRSDeaths
# Original author: bk75R
#
# Type of script: calls other R scripts to download data and create graphs
#
############################################################

# Load libraries
library(readxl)
library(writexl)
library(httr)
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(lubridate)
library(ISOweek)
library(facetscales)
library(scales)

###########################
#                         #
# Create paths            #
#                         #
###########################

# Set working directories
RootDirectory <- getwd() # This should be the directory in which the .R file is found.
DataDirectory <- paste(RootDirectory,"/data",sep = "")
NRSAgesDataDirectory <- paste(RootDirectory,"/data/NRSAgesData",sep = "")
GraphsDirectory <- paste(RootDirectory,"/graphs",sep = "")

setwd(RootDirectory) # wd is directory of script


###################################################
#                                                 #
# Set up graph info                               #
#                                                 #
###################################################

# Create subtitle and caption
GraphSubtitle = paste("Graph by @bouncingkitten | https://www.drowningindata.blog | ","Created ",(as.character(format(Sys.Date(),"%d/%m/%Y"))))
# Data URL is linked from https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/deaths-involving-coronavirus-covid-19-in-scotland/related-statistics
# and the data files used for deaths are:
# 
# "Weekly deaths by sex and age group in NHS health boards, 2020 - 2022"
# https://www.nrscotland.gov.uk/files//statistics/covid19/weekly-deaths-by-sex-age-group-health-board-2020-2022.xlsx
# 
# "Weekly deaths by sex and age group, 2000 to 2019"
# https://www.nrscotland.gov.uk/files//statistics/covid19/weekly-deaths-by-sex-age-2000-2019.zip

GraphCaption = "Data source: National Records of Scotland, Deaths involving coronavirus (COVID-19) in Scotland - Related Statistics"


# Create root graph filename
GraphFileNameRoot = as.character(format(Sys.Date(),"%Y-%m-%d"))

# Define standard graph width and height (mm)
graphwidth = 250
graphheight = 175
NoDays = 60 # How many historic days on the graphs?

############################################################
#                                                          #
# Call scripts to download and save data and create graphs #
#                                                          #
############################################################

source("NRSDeaths_DataExcelRead.R") # Read the NRS death by HB data and save it.

source("NRSDeaths_2000-2019DataCSVRead.R") # Read 2000-2019 deaths data

source("NRSDeaths_2022Excess.R") # Calculate baseline and excess for 2022

source("NRSDeaths_GraphsCheck.R") # Graph deaths data to check it's all there.

source("NRSDeaths_InquiryGraphs.R") # Inquiry graphs, various on cumulative excess deaths and gradient changes.

source("NRSDeaths_WriteDataFiles.R") # Write calculated excess deaths data into files usable in spreadsheets.

setwd(RootDirectory)