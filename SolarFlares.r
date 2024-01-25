# Libraries
# install.packages("readxl")
# install.packages("lubridate")
# install.packages("hexbin")
# install.packages("ggthemes")
# install.packages("openxlsx")
# install.packages("ggdensity")
# install.packages("gganimate")
# install.packages("gapminder")
library(hexbin)
library(RColorBrewer)
library(lubridate)
library(readxl)
library(dplyr)
library(ggplot2)
library(ggthemes)
# library(openxlsx)
library(reshape2)
library(tibble)
library(ggdensity)
library(gganimate)
library(gapminder)

# Set directory (change this to your directory)
setwd("G:/My Drive/UH Fall 2023/COSC 3337 Data Science I/Group Project/CODE")
# setwd("C:/Users/Tyler/OneDrive/Documents/Data Science I/Group Project/Dataset")

# Read File
SolarData <- read.csv("Solar_flare_RHESSI_2004_05.csv")
AllData <- read.csv("Complete.csv")

# Add Date column with class Date
SolarData <- SolarData %>% mutate(Date = as.Date(paste(year, month, day, sep = "-")))
AllData <- AllData %>% mutate(Date = as.Date(paste(year, month, day, sep = "-")))

# Factor energy.kev
Energy_Levels <- c("6-12", "12-25", "25-50", "50-100", "100-300", "300-800", "800-7000", "7000-20000")
SolarData$energy.kev.fact = factor(SolarData$energy.kev, levels = unique(Energy_Levels), ordered = T)
AllData$energy.kev.fact = factor(AllData$energy.kev, levels = unique(Energy_Levels), ordered = T)

ggplot(AllData) + geom_histogram(aes(x=energy.kev.fact, fill = energy.kev.fact), stat = "count") + 
  theme_tufte() + labs(title = "Platform Count Histogram")

# Initial Graph
solar_map <- ggplot(SolarData, aes(x = `x.pos.asec`, y = `y.pos.asec`, color = energy.kev.fact)) +
  labs(title = "Solar Flares", x = "X (arcseconds)", y = "Y (arcseconds)", color = "Energy (kilo-electronvolts)", subtitle = "2004 to 2005") +
  geom_point() + scale_fill_continuous() + 
  theme_tufte()
print(solar_map)

# Exclude lower energies
Exclude_Levels <- c("6-12")
SolarData$energy.kev.exclude <- factor(SolarData$energy.kev, levels = Energy_Levels[!Energy_Levels %in% Exclude_Levels], ordered = T)
solar_map <- ggplot(SolarData, aes(x = `x.pos.asec`, y = `y.pos.asec`, color = energy.kev.exclude)) +
  labs(title = "Solar Flares", x = "X (arcseconds)", y = "Y (arcseconds)", color = "Energy (kilo-electronvolts)", subtitle = "2004 to 2005 (excluding 6-12 keV)") +
  geom_point() + scale_fill_continuous(type = "viridis") +
  theme_tufte()
print(solar_map)

Exclude_Levels <- c("6-12", "12-25")
SolarData$energy.kev.exclude <- factor(SolarData$energy.kev, levels = Energy_Levels[!Energy_Levels %in% Exclude_Levels], ordered = T)
solar_map <- ggplot(SolarData, aes(x = `x.pos.asec`, y = `y.pos.asec`, color = energy.kev.exclude)) +
  labs(title = "Solar Flares", x = "X (arcseconds)", y = "Y (arcseconds)", color = "Energy (kilo-electronvolts)", subtitle = "2004 to 2005 (excluding 6-25 keV)") +
  geom_point() + scale_fill_continuous(type = "viridis") +
  theme_tufte()
print(solar_map)

table(SolarData$energy.kev)

############################################################
# TASK 1
## Method 1 - Solar Flare Intensity Estimation (based on total.counts)

# Set the parameters for batch creation
batch_size <- 4  # 4 months per batch
overlap <- 2     # 2-month overlap
start_date <- as.Date("2004-01-01")
cordinate_plane <- 1000
bins_count <- 20

# Method 1
for (i in 1:11) {
  batch_start_date <- start_date %m+% months(overlap * (i - 1))
  batch_end_date <- batch_start_date %m+% months(batch_size) - days(1)
  

  # Filter the data for the current batch
  batch_data <- SolarData %>%
    filter(Date >= batch_start_date, Date <= batch_end_date)
  
  # Method 1
  method1_intensity <- batch_data %>%
    group_by(x.pos.asec, y.pos.asec) %>%
    summarise(total_intensity = sum(total.counts))
  
  # Create a heat map for the required batch
  if (i == 1 || i == 11) {
    intesity_map <- ggplot(method1_intensity, aes(x = x.pos.asec, y = `y.pos.asec`)) +
      labs(title = paste("Solar Flare Intensity by Total Counts - Batch", i), x = "X (arcseconds)", y = "Y (arcseconds)", fill = "Intensity", subtitle = "2004 - 2005") +
      geom_hex(bins = bins_count) + scale_fill_continuous(type = "viridis") + coord_cartesian(xlim = c(-cordinate_plane, cordinate_plane), ylim = c(-cordinate_plane, cordinate_plane)) +
      theme_tufte()
    print(intesity_map)
    
    # intesity_map <- ggplot(method1_intensity, aes(x = `x.pos.asec`, y = `y.pos.asec`)) + geom_point() +
    #   labs(title = paste("Solar Flare - Batch", i), x = "X (arcseconds)", y = "Y (arcseconds)", fill = "Intensity", subtitle = "2004 - 2005") + 
    #   scale_fill_continuous(type = "viridis") + coord_cartesian(xlim = c(-cordinate_plane, cordinate_plane), ylim = c(-cordinate_plane, cordinate_plane)) +
    #   theme_tufte()
    # print(intesity_map)
    
    intesity_map <- ggplot(method1_intensity, aes(x = `x.pos.asec`, y = `y.pos.asec`)) + stat_density_2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
      labs(title = paste("Solar Flare - Batch", i), x = "X (arcseconds)", y = "Y (arcseconds)", fill = "Intensity", subtitle = "2004 - 2005") + 
      scale_fill_continuous(type = "viridis", guide = "none") + coord_cartesian(xlim = c(-cordinate_plane, cordinate_plane), ylim = c(-cordinate_plane, cordinate_plane)) +
      theme_tufte()
    print(intesity_map)
  }
}

# Method 2
for (i in 1:11) {
  batch_start_date <- start_date %m+% months(overlap * (i - 1))
  batch_end_date <- batch_start_date %m+% months(batch_size) - days(1)
  
  # Filter the data for the current batch
  batch_data <- SolarData %>%
    filter(Date >= batch_start_date, Date <= batch_end_date)
  
  # Method 2
  method2_intensity <- batch_data %>%
    group_by(x.pos.asec, y.pos.asec) %>%
    summarise(total_intensity = sum((duration.s*.6 + energy.kev.f*.4)))
  
  # Create a heat map for the required batch
  if (i == 1 || i == 11) {
    intesity_map4 <- ggplot(method2_intensity, aes(x = `x.pos.asec`, y = `y.pos.asec`)) +
      labs(title = paste("Solar Flare Intensity by Total Duration - Batch", i, "Heat Map"), x = "X (arcseconds)", y = "Y (arcseconds)", fill = "Intensity", subtitle = "2004 - 2005") + 
      geom_hex() + scale_fill_continuous(type = "viridis") + coord_cartesian(xlim = c(-cordinate_plane, cordinate_plane), ylim = c(-cordinate_plane, cordinate_plane)) +
      theme_tufte()
    print(intesity_map4)
  }
}

############################################################

# Animation Code
# need to install ffmpeg into your computer, it is not a library.
# Solar Flares
p <- ggplot(SolarData, aes(x = x.pos.asec, y = `y.pos.asec`, color = energy.kev.fact)) + geom_point() +
  theme_tufte() +
  transition_time(month) + ease_aes('linear')
animate(p, renderer = ffmpeg_renderer())
anim_save("Video.mp4")

# Heat Map
intesity_map <- ggplot(SolarData, aes(x = `x.pos.asec`, y = `y.pos.asec`)) + stat_density_2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
  labs(title = paste("Solar Flares Anitmation", i), x = "X (arcseconds)", y = "Y (arcseconds)", fill = "Intensity", subtitle = "2004 - 2005") + 
  scale_fill_continuous(type = "viridis", guide = "none") + coord_cartesian(xlim = c(-cordinate_plane, cordinate_plane), ylim = c(-cordinate_plane, cordinate_plane)) +
  theme_tufte() + transition_time(month) + ease_aes('linear')
animate(intesity_map, renderer = ffmpeg_renderer())
anim_save("Video.mp4")
print(intesity_map)

# Heat Map All Data
intesity_map <- ggplot(AllData, aes(x = `x.pos.asec`, y = `y.pos.asec`,)) + stat_density_2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
  labs(title = paste("Solar Flares Animation"), x = "X (arcseconds)", y = "Y (arcseconds)", fill = "Intensity", subtitle = "Month: {frame_time}") +
  scale_fill_continuous(type = "viridis", guide = "none") + coord_cartesian(xlim = c(-cordinate_plane, cordinate_plane), ylim = c(-cordinate_plane, cordinate_plane)) +
  theme_tufte() + transition_time(month) + ease_aes('linear') + facet_wrap(~TimeSeries)
animate(intesity_map, renderer = ffmpeg_renderer())
anim_save("Task3Animation.mp4")

############################################################

#convert method1_intensities into a matrix In order for our function find hotspots to work

##################CHECKKKK#############################

# Assuming that method1_intensity is already grouped and summarized

# Get the range of coordinates
x_range <- range(method1_intensity$`x.pos.asec`, na.rm = TRUE)
y_range <- range(method1_intensity$`y.pos.asec`, na.rm = TRUE)

# Create a sequence of x and y coordinates that cover the full range
x_coords <- seq(from = min(x_range), to = max(x_range), by = 1)
y_coords <- seq(from = min(y_range), to = max(y_range), by = 1)

# Initialize a matrix to store the intensity values
intensity_map <- matrix(0, nrow = length(y_coords), ncol = length(x_coords), 
                        dimnames = list(y_coords, x_coords))

# Fill the intensity_map matrix with the total_intensity values
for (i in 1:nrow(method1_intensity)) {
  # Find the index in the matrix that corresponds to the x and y coordinates
  x_index <- which(x_coords == method1_intensity$`x.pos.asec`[i])
  y_index <- which(y_coords == method1_intensity$`y.pos.asec`[i])
  
  # Assign the total intensity to the correct position in the matrix
  # Check if the indices are within the bounds of the matrix
  if (length(x_index) == 1 && length(y_index) == 1) {
    intensity_map[y_index, x_index] <- method1_intensity$`total_intensity`[i]
  }
}

# Define thresholds
d1 <- 400  # High intensity threshold
d2 <- 200  # Medium intensity threshold

# Function to find hotspots
find_hotspots <- function(intensity_map, threshold) {
  hotspots <- which(intensity_map > threshold, arr.ind = TRUE)
  hotspots_df <- as.data.frame(hotspots, stringsAsFactors = FALSE)
  colnames(hotspots_df) <- c("Y", "X")
  hotspots_df$Intensity <- intensity_map[hotspots]
  return(hotspots_df)
}

# Find hotspots for both thresholds
hotspots_d1 <- find_hotspots(intensity_map, d1)
hotspots_d2 <- find_hotspots(intensity_map, d2)

# Function to visualize hotspots
visualize_hotspots <- function(intensity_map, hotspots_df) {
  intensity_df <- as.data.frame(melt(intensity_map))
  colnames(intensity_df) <- c("X", "Y", "Intensity")
  
  # Create the plot
  p <- ggplot(intensity_df, aes(x = X, y = Y, fill = Intensity)) +
    geom_tile() +
    scale_fill_viridis_c(option = "C") +
    labs(title = "Intensity Map with Hotspots", x = "X Coordinate", y = "Y Coordinate") +
    theme_minimal() +
    theme(legend.position = "right")
  
  # Add the hotspots if any
  if (nrow(hotspots_df) > 0) {
    p <- p + geom_point(data = hotspots_df, aes(x = X, y = Y), color = "red", size = 2)
  }
  
  # Print the plot
  print(p)
}

visualize_hotspots(intensity_map, hotspots_d1)
visualize_hotspots(intensity_map, hotspots_d2)

################### Time Series ###########################

# store hotspot information for each batch
hotspot_information <- list()

# iterate over the 11 batches
for (i in 1:11) {
  batch_start_date <- start_date %m+% months(overlap * (i - 1))
  batch_end_date <- batch_start_date %m+% months(batch_size) - days(1)
  
  
  # Filter the data for the current batch
  batch_data <- SolarData %>%
    filter(Date >= batch_start_date, Date <= batch_end_date)
  
  # find hotspot for threshold d1
  hotspots <- find_hotspots(intensity_map, d1)
  
  # store the hotspot information to be plotted later
  hotspot_information[i] <- hotspots
}

############################################################

# Read File
SolarData_2004_05 <- read.csv("Solar_flare_RHESSI_2004_05.csv")

SolarData_2015_16 <- read.csv("Solar_flare_RHESSI_2015_16.csv")

#using total counts for Intensity
SolarData_2004_05_intensity <- SolarData_2004_05$total.counts
SolarData_2015_16_intensity <- SolarData_2015_16$total.counts

#Using total counts like we did in task 1 to see the intensity
summary_2004_05_total_counts <- summary(SolarData_2004_05_intensity)
summary_2015_16_total_counts <- summary(SolarData_2015_16_intensity)

#print summaries
print("Summary for Total Counts (2004-2005):")
print(summary_2004_05_total_counts)
print("Summary for Total Counts (2015-2016):")
print(summary_2015_16_total_counts)

#plot for Solar Flare 2004-2005
ggplot(SolarData_2004_05,aes(x = x.pos.asec, y = y.pos.asec)) + geom_point() + ggtitle("Spatial Distribution of Solar Flares (2004-2005)")

#plot for Solar Flare 2015-2016
ggplot(SolarData_2015_16,aes(x = x.pos.asec, y = y.pos.asec)) + geom_point() + ggtitle("Spatial Distribution of Solar Flares (2015-2016)")

#analyze various counts(minimum, median, mean, etc) 
summary(SolarData_2004_05)
summary(SolarData_2015_16)

#peak.c/s Flare peak time (peak counts/ second in energy range 6-12 keV, averaged over active collimators, including background)

# Comparison of peak count rates for intensity
summary_2004_05_peak <- summary(SolarData_2004_05$`peak.c/s`)
summary_2015_16_peak <- summary(SolarData_2015_16$`peak.c.s`)

print("Summary for Peak Count Rates (2004-2005):")
print(summary_2004_05_peak)
print("Summary for Peak Count Rates (2015-2016):")
print(summary_2015_16_peak)

# Spatial statistics computation, average position of X pos and Y pos
mean_x_pos_2004_05 <- mean(SolarData_2004_05$x.pos.asec, na.rm = TRUE)
mean_y_pos_2004_05 <- mean(SolarData_2004_05$y.pos.asec, na.rm = TRUE)
mean_x_pos_2015_16 <- mean(SolarData_2015_16$x.pos.asec, na.rm = TRUE)
mean_y_pos_2015_16 <- mean(SolarData_2015_16$y.pos.asec, na.rm = TRUE)

print("Average X Position (2004-2005):")
print(mean_x_pos_2004_05)
print("Average Y Position (2004-2005):")
print(mean_y_pos_2004_05)
print("Average X Position (2015-2016):")
print(mean_x_pos_2015_16)
print("Average Y Position (2015-2016):")
print(mean_y_pos_2015_16)