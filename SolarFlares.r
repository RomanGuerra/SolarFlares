# Libraries
# install.packages("readxl")
# install.packages("lubridate")
library(lubridate)
library(readxl)
library(dplyr)
library(ggplot2)

# Set directory (change this to your directory)
setwd("G:/My Drive/UH Fall 2023/COSC 3337 Data Science I/Group Project/CODE")
# setwd("C:/Users/Tyler/OneDrive/Documents/Data Science I/Group Project/Dataset")

# Read File
SolarData <- read.csv("Solar_flare_RHESSI_2004_05.csv")

# Add Date column with class Date
SolarData <- SolarData %>% mutate(Date = as.Date(paste(year, month, day, sep = "-")))

# Factor energy.kev
Energy_Levels <- c("6-12", "12-25", "25-50", "50-100", "100-300", "300-800", "800-7000", "7000-20000")
SolarData$energy.kev.f = factor(SolarData$energy.kev, levels = unique(Energy_Levels), ordered = T)

########################################################################################################################################


# TASK 1
## Method 1 - Solar Flare Intensity Estimation (based on total.counts)

# Set the parameters for batch creation
batch_size <- 4  # 4 months per batch
overlap <- 2     # 2-month overlap
start_date <- as.Date("2004-01-01")

for (i in 1:11) {
  batch_start_date <- start_date %m+% months(overlap * (i - 1))
  batch_end_date <- batch_start_date %m+% months(batch_size) - days(1)
  

  # Filter the data for the current batch
  batch_data <- SolarData %>%
    filter(Date >= batch_start_date, Date <= batch_end_date)
  
  method1_intensity <- batch_data %>%
    group_by(x.pos.asec, y.pos.asec) %>%
    summarise(total_intensity = sum(total.counts))
  
  intensity_by_location_method1 <- aggregate(SolarData$total.counts, 
                                             by=list(X=SolarData$x.pos.asec, Y=SolarData$y.pos.asec), sum)
  colnames(intensity_by_location_method1) <- c("x", "y", "total_intensity")
  
    # Create a heat map for the current batch
  if (i == 1 || i == 11) {
    intesity_map <- ggplot(method1_intensity, aes(x = `x.pos.asec`, y = `y.pos.asec`, fill = `total_intensity`)) +
      geom_tile() + scale_fill_gradient(low = "blue", high = "red") +
      labs(title = paste("Solar Flare Intensity by Total Counts - Batch", i, "Heat Map"), x = "X Position", y = "Y Position", fill = "Intensity", subtitle = "using group") + theme_tufte()
    print(intesity_map)

    intesity_map2 <- ggplot(intensity_by_location_method1, aes(x = `x`, y = `y`, fill = `total_intensity`)) +
      geom_tile() + scale_fill_gradient(low = "blue", high = "red") +
      labs(title = paste("Solar Flare Intensity by Total Counts - Batch", i, "Heat Map"), x = "X Position", y = "Y Position", fill = "Intensity", subtitle = "using aggregate") + theme_tufte()
    print(intesity_map2)
  }
}


for (i in 1:11) {
  batch_start_date <- start_date %m+% months(overlap * (i - 1))
  batch_end_date <- batch_start_date %m+% months(batch_size) - days(1)
  
  
  # Filter the data for the current batch
  batch_data <- SolarData %>%
    filter(Date >= batch_start_date, Date <= batch_end_date)
  
  method2_intensity <- batch_data %>%
    group_by(x.pos.asec, y.pos.asec) %>%
    summarise(total_duration = sum(duration.s))
  
  intensity_by_location_method2 <- aggregate(SolarData$duration.s, 
                                             by=list(X=SolarData$x.pos.asec, Y=SolarData$y.pos.asec), sum)
  colnames(intensity_by_location_method2) <- c("x", "y", "total_duration")
  
  if (i == 1 || i == 11) {
    # Create a heat map for the current batch
    intesity_map3 <- ggplot(method2_intensity, aes(x = `x.pos.asec`, y = `y.pos.asec`, fill = `total_duration`)) +
      geom_tile() + scale_fill_gradient(low = "blue", high = "red") +
      labs(title = paste("Solar Flare Intensity by Total Duration - Batch", i, "Heat Map"), x = "X Position", y = "Y Position", fill = "Intensity", subtitle = "using group") + theme_tufte()
    print(intesity_map3)
    
    intesity_map4 <- ggplot(intensity_by_location_method2, aes(x = `x`, y = `y`, fill = `total_duration`)) +
      geom_tile() + scale_fill_gradient(low = "blue", high = "red") +
      labs(title = paste("Solar Flare Intensity by Total Duration - Batch", i, "Heat Map"), x = "X Position", y = "Y Position", fill = "Intensity", subtitle = "using aggregate") + theme_tufte()
    print(intesity_map4)
  }
}
