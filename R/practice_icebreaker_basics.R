#### Practice Problem: Loading and manipulating a data frame ####
# Don't forget: Comment anywhere the code isn't obvious to you!

# Load the readxl and dplyr packages
library(readxl); library(dplyr)
# Use the read_excel function to load the class survey data
icebreaker <- read_excel("C:/logs/workshop/R/intro-r-2024/data/icebreaker_answers.xlsx")
# Take a peek!

# Create a travel_speed column in your data frame using vector operations and 
#   assignment
icebreaker <- icebreaker %>% mutate(travel_speed = travel_distance/travel_time)
# Look at a summary of the new variable--seem reasonable?
summary(icebreaker)
# Choose a travel mode, and use a pipe to filter the data by your travel mode
icebreaker %>% filter(travel_mode=="light rail") %>% 
# Note the frequency of the mode (# of rows returned)
nrow()
# Repeat the above, but this time assign the result to a new data frame
lightrail <- icebreaker %>% filter(travel_mode=="light rail")
# Look at a summary of the speed variable for just your travel mode--seem 
#   reasonable?
summary(lightrail$travel_speed)
# Filter the data by some arbitrary time, distance, or speed threshold
icebreaker %>% filter(travel_time>60)
# Stretch yourself: Repeat the above, but this time filter the data by two 
#   travel modes (Hint: %in%)
icebreaker %>% filter(travel_mode %in% c("bus","light rail"))
