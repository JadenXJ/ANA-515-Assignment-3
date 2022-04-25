getwd()

#1. Import
library(tidyverse)
storm_data <- read_csv("C:\\Users\\Owner\\Documents\\StormEvents_details-ftp_v1.0_d2000_c20210803.csv")

#2. Limit Data
new_storm_data<-storm_data[c(7:10,13:16,18,20,27,47:48)]

#3. Arranging Data
library(dplyr)
arrange(storm_data, BEGIN_YEARMONTH)

#4. change state and county names
new_storm_data$STATE = str_to_title(new_storm_data$STATE,locale="en")
new_storm_data$CZ_NAME = str_to_title(new_storm_data$CZ_NAME,locale="en")

#5. Limit Events
filter(new_storm_data,CZ_TYPE=="C") 
select(new_storm_data,BEGIN_DATE_TIME, END_DATE_TIME,EPISODE_ID,EVENT_ID,STATE,STATE_FIPS,CZ_NAME,CZ_FIPS,EVENT_TYPE,SOURCE,END_LAT,END_LON)

#6. Padding & Unite
str_pad(new_storm_data$STATE_FIPS, width = 3, side = "left", pad = "0")
str_pad(new_storm_data$CZ_FIPS, width = 3, side = "left", pad = "0")

new_storm_dataII<-unite(new_storm_data,FIPS,4,7,sep = "",remove = TRUE)
#had to make a new subset because the unite function was working but was not changing new_storm_data dataframes columns

#7. Rename column name to lower case
rename_all(new_storm_dataII,tolower)

#8.Making State DF
data("state")
us_state_info <- data.frame(state=state.name,region=state.region,area=state.area)

#9.Number of Events by State
storm_data_mI <- data.frame(table(new_storm_dataII$STATE))

storm_data_mI<- rename(storm_data_mI, state = var1)

num_events_by_state <- merge(x=storm_data_mI,y=us_state_info,by.x = "state",by.y = "state")

head(num_events_by_state)

#10. Plotting
storm_plot<- ggplot(num_events_by_state, aes(x=area, y=Freq))+
       geom_point(aes(color = region))+
        labs(x="land area (sq miles)",
             y="# of storm events in 2000")
storm_plot