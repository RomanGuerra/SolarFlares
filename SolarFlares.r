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

#############################################################################
#install.packages("readxl")
library(readxl)

#subtask for task 1


#1.
#Method 1
########################################################################################################################################

# Set the path to your xlsx file
file_path <- "/Users/miguelgarcia/Desktop/University of Houston/Fall 2023/Data Science 1 3337/Group_Project/Solar_flare_RHESSI_2004_05.xlsx"

# Read the xlsx file
data_solar_flare_2004 <- read_excel(file_path)


# Group by x.pos.asec and y.pos.asec and calculate the sum of total.counts for each location
intensity_by_location_method1 <- aggregate(data_solar_flare_2004$total.counts, 
                                   by=list(X=data_solar_flare_2004$x.pos.asec, Y=data_solar_flare_2004$y.pos.asec), sum)

# Rename the columns
colnames(intensity_by_location_method1) <- c("X", "Y", "Total_Intensity")


########################################################################################################################################



#2
#Method 2
########################################################################################################################################


# Compute a derived intensity value by multiplying duration.s and energy.kev
data_solar_flare_2004$derived_intensity <- data_solar_flare_2004$duration.s * as.numeric(as.character(data_solar_flare_2004$energy.kev))

# Group by x.pos.asec and y.pos.asec and calculate the sum of derived_intensity for each location
intensity_by_location_method2 <- aggregate(data_solar_flare_2004$derived_intensity, 
                                           by=list(X=data_solar_flare_2004$x.pos.asec, Y=data_solar_flare_2004$y.pos.asec), sum)

# Rename the columns
colnames(intensity_by_location_method2) <- c("X", "Y", "Derived_Intensity")


########################################################################################################################################

# subtask 3 - create intensity maps for months 1+2+3+4 for method 1 and method 2
library(ggplot2)

# find months 1+2+3+4
filtered_by_months_1_4 = subset(intensity_by_location_method1, month %in% 1:4)

# create intensity map for method 1
ggplot(filtered_by_months_1_4, aes(x=X, y=Y, fill=Total_Intensity)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "red") + 
    labs(title= "Intensity Map for Method 1", x = "X Position", y = "Y Position") +
    theme_minimal()

# use intensity by location method 2
filtered_by_months_1_4 = subset(intensity_by_location_method2, month %in% 1:4)

  # create intensity map for method 2
ggplot(filtered_by_months_1_4, aes(x=X, y=Y, fill="Derived_Intensity")) +
    geom_tile() +
    scale_fill_gradient(low="white", high="red") +
    labs(title= "Intensity Map for Method 2", x= "X Position", y= "Y Position") +
    theme_minimal()  


##############################################################################################
# subtask 4 - create intensity maps for months 21+22+23+24

# method 1
# find months 21+22+23+24
filtered_by_months_21_24 = subset(intensity_by_location_method1, month %in% 21:24)

# create intensity map for method 1
ggplot(filtered_by_months_21_24, aes(x=X, y=Y, fill=Total_Intensity)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "red") + 
    labs(title= "Intensity Map for Method 1", x = "X Position", y = "Y Position") +
    theme_minimal()

# method 2
filtered_by_months_21_24 = subset(intensity_by_location_method2, month %in% 21:24)

# create intensity map for method 2
ggplot(filtered_by_months_21_24, aes(x=X, y=Y, fill=Total_Intensity)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "red") + 
    labs(title= "Intensity Map for Method 1", x = "X Position", y = "Y Position") +
    theme_minimal()