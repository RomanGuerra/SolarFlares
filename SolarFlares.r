# Solar Flares
setwd("G:/My Drive/UH Fall 2023/COSC 3337 Data Science I/Group Project/CODE")
setwd("C:/Users/Tyler/OneDrive/Documents/Data Science I/Group Project/Dataset")
SolarData <- read.csv("Solar_flare_RHESSI_2004_05.csv")

# TASK 1
# Method 1 - Solar Flare Intensity Estimation (based on total.counts)
################ NOTES: ############################################# 
# intensity estimation techniques measure the flare intensity at a location
# (x,y) based on a set of flare events

library(dplyr)
locationX <- 100
locationY <- 100
start_date <- as.date("2004-01-01")
end_date <- as.date("2005-12-31")

# Filter
filtered_data <- SolarData %>%
filter(x.pos.asec >= (locationX - 10), x.pos.asec <= (locationX + 10))
plot(SolarData$x.pos.asec, SolarData$y.pos.asec)


###################################################
# this is a test to see if you can see my commit  #
###################################################
