##########################################################
# Name of script - NRSDeaths
# Original author: bk75R
#
# Type of script: calls other R scripts to download data and create graphs
#
############################################################

# Load libraries
library(readxl)
library(httr)
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(lubridate)
library(ISOweek)
library(facetscales)

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
GraphSubtitle = paste("Created: ",(as.character(format(Sys.Date(),"%d/%m/%Y"))),"\nhttps://www.drowningindata.blog")
GraphCaption = "Data source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/\nweekly-and-monthly-data-on-births-and-deaths/deaths-involving-coronavirus-covid-19-in-scotland/related-statistics"

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

setwd(RootDirectory)