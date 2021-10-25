# Chevy Robertson (crr78@georgetown.edu)
# Advanced Data Visualization - Fall 2021
# A5: Interactive Visualizations - Data Munging
# 10/25/2021



# loading packages
library(tidyverse)
library(stringr)



# function adds, date, day, and hour to power readings for each home/plug combo 
add_date_info <- function(hh_plug_combo) {
  count <- 1
  for (f in list.files(path = hh_plug_combo)) {
    df <- read.csv(file = paste(hh_plug_combo, f, sep=""), header=F, sep=",")
    df[, 2] <- rep(str_sub(list.files(path=hh_plug_combo), 1, 10)[count], nrow(df))
    df[, 3] <- weekdays(as.Date(df$V2))
    
    tod <- c()
    
    for (i in 1:24) {
      hour <- rep(i, nrow(df)/24)
      tod <- c(tod, hour)
    }
    
    df[, 4] <- tod
    
    names(df) <- c("Power", "Date", "Day", "Hour")
    
    if (count == 1) {
      df_all <- df
    } else {
      df_all <- rbind(df_all, df)
    }
    
    count <- count + 1
  }
  
  return(df_all)
}



# adding date/day/hour info to each household/plug combo
# note: some plugs have been omitted in an effort to reduce clutter in the plots

fridge4  <- add_date_info("04/01/")
# ka4      <- add_date_info("04/02/")
lamp4    <- add_date_info("04/03/")
# sal4     <- add_date_info("04/04/")
freezer4 <- add_date_info("04/05/")
tablet4  <- add_date_info("04/06/")
ettm4    <- add_date_info("04/07/")
mwave4   <- add_date_info("04/08/")
tablet5  <- add_date_info("05/01/")
cm5      <- add_date_info("05/02/")
fount5   <- add_date_info("05/03/")
mwave5   <- add_date_info("05/04/")
fridge5  <- add_date_info("05/05/")
ettm5    <- add_date_info("05/06/")
# pc5      <- add_date_info("05/07/")
kettle5  <- add_date_info("05/08/")
lamp6    <- add_date_info("06/01/")
# laptop6  <- add_date_info("06/02/")
# router6  <- add_date_info("06/03/")
cm6      <- add_date_info("06/04/")
ettm6    <- add_date_info("06/05/")
fridge6  <- add_date_info("06/06/")
kettle6  <- add_date_info("06/07/")



# filtering out rows with nonsensical power values

fridge4  <- subset(fridge4, fridge4$Power >= 0)
lamp4    <- subset(lamp4, lamp4$Power >= 0)
freezer4 <- subset(freezer4, freezer4$Power >= 0)
tablet4  <- subset(tablet4, tablet4$Power >= 0)
ettm4    <- subset(ettm4, ettm4$Power >= 0)
mwave4   <- subset(mwave4, mwave4$Power >= 0)
tablet5  <- subset(tablet5, tablet5$Power >= 0)
cm5      <- subset(cm5, cm5$Power >= 0)
fount5   <- subset(fount5, fount5$Power >= 0)
mwave5   <- subset(mwave5, mwave5$Power >= 0)
fridge5  <- subset(fridge5, fridge5$Power >= 0)
ettm5    <- subset(ettm5, ettm5$Power >= 0)
kettle5  <- subset(kettle5, kettle5$Power >= 0)
lamp6    <- subset(lamp6, lamp6$Power >= 0)
cm6      <- subset(cm6, cm6$Power >= 0)
ettm6    <- subset(ettm6, ettm6$Power >= 0)
fridge6  <- subset(fridge6, fridge6$Power >= 0)
kettle6  <- subset(kettle6, kettle6$Power >= 0)



# function for grouping each df by hour, computing average power
hourly_avgs <- function(df) {
  new_df <- df %>% 
    group_by(Hour) %>%
    summarise(across(Power, mean))
  return(new_df)
}



# use the function to create the intermediate datasets for the plotly plot

# fridge data
p_fridge4 <- hourly_avgs(fridge4)
p_fridge5 <- hourly_avgs(fridge5)
p_fridge6 <- hourly_avgs(fridge6)
p_fridge  <- rbind(p_fridge4, p_fridge5)
p_fridge  <- rbind(p_fridge, p_fridge6)
p_fridge  <- hourly_avgs(p_fridge)
p_fridge  <- data.frame(p_fridge)
p_fridge$Plug <- rep("Fridge", nrow(p_fridge))

# lamp data
p_lamp4 <- hourly_avgs(lamp4)
p_lamp6 <- hourly_avgs(lamp6)
p_lamp  <- rbind(p_lamp4, p_lamp6)
p_lamp  <- hourly_avgs(p_lamp)
p_lamp  <- data.frame(p_lamp)
p_lamp$Plug <- rep("Lamp", nrow(p_lamp))

# freezer data
p_freezer <- hourly_avgs(freezer4)
p_freezer <- data.frame(p_freezer)
p_freezer$Plug <- rep("Freezer", nrow(p_freezer))

# tablet data
p_tablet4 <- hourly_avgs(tablet4)
p_tablet5 <- hourly_avgs(tablet5)
p_tablet  <- rbind(p_tablet4, p_tablet5)
p_tablet  <- hourly_avgs(p_tablet)
p_tablet  <- data.frame(p_tablet)
p_tablet$Plug <- rep("Tablet", nrow(p_tablet))

# entertainment data
p_ettm4 <- hourly_avgs(ettm4)
p_ettm5 <- hourly_avgs(ettm5)
p_ettm6 <- hourly_avgs(ettm6)
p_ettm  <- rbind(p_ettm4, p_ettm5)
p_ettm  <- rbind(p_ettm, p_ettm6)
p_ettm  <- hourly_avgs(p_ettm)
p_ettm  <- data.frame(p_ettm)
p_ettm$Plug <- rep("Entertainment", nrow(p_ettm))

# microwave data
p_mwave4 <- hourly_avgs(mwave4)
p_mwave5 <- hourly_avgs(mwave5)
p_mwave  <- rbind(p_mwave4, p_mwave5)
p_mwave  <- hourly_avgs(p_mwave)
p_mwave  <- data.frame(p_mwave)
p_mwave$Plug <- rep("Microwave", nrow(p_mwave))

# coffee machine data
p_cm5 <- hourly_avgs(cm5)
p_cm6 <- hourly_avgs(cm6)
p_cm  <- rbind(p_cm5, p_cm6)
p_cm  <- hourly_avgs(p_cm)
p_cm  <- data.frame(p_cm)
p_cm$Plug <- rep("Coffee Machine", nrow(p_cm))

# fountain data
p_fountain <- hourly_avgs(fount5)
p_fountain <- data.frame(p_fountain)
p_fountain$Plug <- rep("Fountain", nrow(p_fountain))

# kettle data
p_kettle5 <- hourly_avgs(kettle5)
p_kettle6 <- hourly_avgs(kettle6)
p_kettle  <- rbind(p_kettle5, p_kettle6)
p_kettle  <- hourly_avgs(p_kettle)
p_kettle  <- data.frame(p_kettle)
p_kettle$Plug <- rep("Kettle", nrow(p_kettle))



# combine all data to form the dataset used to generate the plotly plot

p_all <- rbind(p_cm, p_ettm)
p_all <- rbind(p_all, p_fountain)
p_all <- rbind(p_all, p_freezer)
p_all <- rbind(p_all, p_fridge)
p_all <- rbind(p_all, p_kettle)
p_all <- rbind(p_all, p_lamp)
p_all <- rbind(p_all, p_mwave)
p_all <- rbind(p_all, p_tablet)



# update the time of day to 24-hour time to make more sense for the plot

new_hour <- c()
for (num in p_all$Hour) {
  new_hour <- c(new_hour, paste(toString(num-1), ":00", sep=""))
}

p_all$Hour <- new_hour



# excluding freezer from analysis due to comparatively larger power values
p_all <- subset(p_all, p_all$Plug != "Freezer")

# adjusting rownames
rownames(p_all) <- c(1:nrow(p_all))



# rounding power values to nearest hundredth

new_power <- c()
for (num in p_all$Power) {
  new_power <- c(new_power, round(num, 2))
}

p_all$Power <- new_power



# write plotly dataset to csv file for plotting
write.csv(p_all, "plotly-data.csv")



# function for grouping each df by day, computing average power
daily_avgs <- function(df) {
  new_df <- df %>% 
    group_by(Day) %>%
    summarise(across(Power, mean))
  return(new_df)
}



# use the function to create the intermediate datasets for the altair plot

# fridge data
a_fridge4 <- daily_avgs(fridge4)
a_fridge5 <- daily_avgs(fridge5)
a_fridge6 <- daily_avgs(fridge6)
a_fridge  <- rbind(a_fridge4, a_fridge5)
a_fridge  <- rbind(a_fridge, a_fridge6)
a_fridge  <- daily_avgs(a_fridge)
a_fridge  <- data.frame(a_fridge)
a_fridge$Plug <- rep("Fridge", nrow(a_fridge))

# lamp data
a_lamp4 <- daily_avgs(lamp4)
a_lamp6 <- daily_avgs(lamp6)
a_lamp  <- rbind(a_lamp4, a_lamp6)
a_lamp  <- daily_avgs(a_lamp)
a_lamp  <- data.frame(a_lamp)
a_lamp$Plug <- rep("Lamp", nrow(a_lamp))

# freezer data
a_freezer <- daily_avgs(freezer4)
a_freezer <- data.frame(a_freezer)
a_freezer$Plug <- rep("Freezer", nrow(a_freezer))

# tablet data
a_tablet4 <- daily_avgs(tablet4)
a_tablet5 <- daily_avgs(tablet5)
a_tablet  <- rbind(a_tablet4, a_tablet5)
a_tablet  <- daily_avgs(a_tablet)
a_tablet  <- data.frame(a_tablet)
a_tablet$Plug <- rep("Tablet", nrow(a_tablet))

# entertainment data
a_ettm4 <- daily_avgs(ettm4)
a_ettm4 <- a_ettm4[c(1:7), ]
a_ettm5 <- daily_avgs(ettm5)
a_ettm6 <- daily_avgs(ettm6)
a_ettm  <- rbind(a_ettm4, a_ettm5)
a_ettm  <- rbind(a_ettm, a_ettm6)
a_ettm  <- daily_avgs(a_ettm)
a_ettm  <- data.frame(a_ettm)
a_ettm$Plug <- rep("Entertainment", nrow(a_ettm))

# microwave data
a_mwave4 <- daily_avgs(mwave4)
a_mwave5 <- daily_avgs(mwave5)
a_mwave  <- rbind(a_mwave4, a_mwave5)
a_mwave  <- daily_avgs(a_mwave)
a_mwave  <- data.frame(a_mwave)
a_mwave$Plug <- rep("Microwave", nrow(a_mwave))

# coffee machine data
a_cm5 <- daily_avgs(cm5)
a_cm6 <- daily_avgs(cm6)
a_cm  <- rbind(a_cm5, a_cm6)
a_cm  <- daily_avgs(a_cm)
a_cm  <- data.frame(a_cm)
a_cm$Plug <- rep("Coffee Machine", nrow(a_cm))

# fountain data
a_fountain <- daily_avgs(fount5)
a_fountain <- data.frame(a_fountain)
a_fountain$Plug <- rep("Fountain", nrow(a_fountain))

# kettle data
a_kettle5 <- daily_avgs(kettle5)
a_kettle6 <- daily_avgs(kettle6)
a_kettle  <- rbind(a_kettle5, a_kettle6)
a_kettle  <- daily_avgs(a_kettle)
a_kettle  <- data.frame(a_kettle)
a_kettle$Plug <- rep("Kettle", nrow(a_kettle))



# combine all data to form the dataset used to generate the altair plot

a_all <- rbind(a_fridge, a_lamp)
a_all <- rbind(a_all, a_freezer)
a_all <- rbind(a_all, a_tablet)
a_all <- rbind(a_all, a_ettm)
a_all <- rbind(a_all, a_mwave)
a_all <- rbind(a_all, a_cm)
a_all <- rbind(a_all, a_fountain)
a_all <- rbind(a_all, a_kettle)



# reorder the data by day of week sequence, beginning with Monday

# gathering data by day
a_mon <- subset(a_all, a_all$Day == "Monday")
a_tue <- subset(a_all, a_all$Day == "Tuesday")
a_wed <- subset(a_all, a_all$Day == "Wednesday")
a_thu <- subset(a_all, a_all$Day == "Thursday")
a_fri <- subset(a_all, a_all$Day == "Friday")
a_sat <- subset(a_all, a_all$Day == "Saturday")
a_sun <- subset(a_all, a_all$Day == "Sunday")

# joining in order of regular day sequence
a_all <- rbind(a_mon, a_tue)
a_all <- rbind(a_all, a_wed)
a_all <- rbind(a_all, a_thu)
a_all <- rbind(a_all, a_fri)
a_all <- rbind(a_all, a_sat)
a_all <- rbind(a_all, a_sun)



# adjust the rownames
rownames(a_all) <- c(1:nrow(a_all))

# excluding freezer from analysis due to comparatively larger power values
a_all <- subset(a_all, a_all$Plug != "Freezer")

# adjusting rownames
rownames(a_all) <- c(1:nrow(a_all))



# rounding power values to nearest hundredth

new_power <- c()
for (num in a_all$Power) {
  new_power <- c(new_power, round(num, 2))
}

a_all$Power <- new_power



# renaming columns
names(a_all) <- c("Day", "Power(watts)", "Appliance")

# write altair dataset to csv file for plotting
write.csv(a_all, "altair-data.csv")


