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


####################################### steps to creating method 1 according to ChatGPT ###############################################

# Creating Method 1 for Solar Flare Intensity Estimation based on the total.counts attribute involves a series of steps. This method aims to estimate the intensity of solar flares in a specific location based on the total counts recorded for flare events. Here are the steps to implement Method 1:

# Step 1: Data Preparation
# 1.1. Collect the solar flare dataset for Set 1 (2004-2005).
setwd("G:/My Drive/UH Fall 2023/COSC 3337 Data Science I/Group Project/CODE")
setwd("C:/Users/Tyler/OneDrive/Documents/Data Science I/Group Project/Dataset")
SolarData <- read.csv("Solar_flare_RHESSI_2004_05.csv")

# 1.2. Filter the data to include only relevant attributes for this method: 'total.counts', 'X pos [asec]', and 'Y pos [asec]'.
filtered_data = subset(SolarData, select = c(total.counts, x.pos.asec, y.pos.asec))

# Step 2: Spatial Grid Creation
# 2.1. Define a spatial grid to represent the region of interest (e.g., the solar disk). The grid cells should align with the X and Y positions.
cell_size = 10

grid = expand.grid(
    X = seq(min(SolarData$x.pos.asec), max(SolarData$x.pos.asec), by = cell_size),
    Y = seq(min(SolarData$y.pos.asec), max(SolarData$y.pos.asec), by = cell_size)
)

# 2.2. Calculate the dimensions and resolution of the grid cells based on the solar flare data.
num_rows = ceiling((max(SolarData$y.pos.asec) - min(SolarData$y.pos.asec)) / cell_size)
num_cols = ceiling((max(SolarData$x.pos.asec) - min(SolarData$x.pos.asec)) / cell_size)

# Step 3: Aggregating Data
# 3.1. Group the flare events by their X and Y positions and assign them to the corresponding grid cells.
library(dplyr)
grouped_data = SolarData %>% group_by(
                            X = cut('x.pos.asec', breaks=unique(grid$X)),
                            Y = cut('y.pos.asec', breaks=unique(grid$Y))) %>% 
            summarize(Total_Counts=sum('total.counts'))


# 3.2. In each grid cell, calculate the total count of all flare events falling within that cell.

# Step 4: Intensity Estimation
# 4.1. For each grid cell, calculate the intensity as the total count of flare events within the cell.
# 4.2. You can also normalize the intensity values to compare the relative intensity in different regions of the solar disk.

# Step 5: Visualization
# 5.1. Create visualizations of the intensity map, with grid cells color-coded to represent the intensity level.
# 5.2. You can use heatmaps or contour plots to visualize the intensity across the solar disk.

# Step 6: Analysis
# 6.1. Analyze the intensity map to identify regions with high solar flare intensity.
# 6.2. Compare the results with other datasets or solar activity information to draw conclusions about solar flare hotspots.

# Step 7: Validation and Testing
# 7.1. Validate the method's performance using known solar flare events.
# 7.2. Test the method on different time periods or datasets to ensure its generalizability.

# Step 8: Documentation and Reporting
# 8.1. Document the method, including the mathematical formulation for intensity estimation.
# 8.2. Prepare a report summarizing the findings, including the identified high-intensity regions and any insights gained from the analysis.

# By following these steps, you can create Method 1 for solar flare intensity estimation based on the total.counts attribute. This method will help you generate intensity maps that highlight regions of high solar flare activity on the Sun's surface during the specified time period.
