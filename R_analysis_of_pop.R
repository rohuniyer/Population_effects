Sys.setenv(http_proxy="http://proxyout.lanl.gov:8080")

library(readr)

#Uncomment only if needed
pop_data <- read_csv("~/Desktop/Fun_Stuff/population_python/pop_data.csv", 
                     col_types = cols(Age = col_integer(), 
                                      County_FIPS = col_integer(), FIPS = col_integer(), 
                                      Population = col_integer(), State_FIPS = col_integer()))

colnames(pop_data) <- c("Year","State_P","State_FIPS","County_FIPS","fips","Registry","Race","Origin","Sex","Age","Population")





#tutorials for GIS 
#https://www.computerworld.com/article/3038270/data-analytics/create-maps-in-r-in-10-fairly-easy-steps.html
#orrrrr softwares to use
#http://gisgeography.com/free-gis-software/


#install.packages(c("maps", "mapdata"))
#install.packages("devtools")

library(maps)
library(mapdata)
library(ggmap)
library(ggplot2)


#Add county names with fips values
data("county.fips")

pop_data <- merge(pop_data, county.fips, by = "fips")

pop_data$subregion <- gsub(".*,","",pop_data$polyname)


usa_map <- map_data("usa")

#=============================================================================================#
# Basic USA plot
#      coord_fixed : fixed the relationship between one unit in the y direction and one unit in the x direction
#      Solid fill
plot1 <- ggplot() + geom_polygon(data = usa_map, aes(x=long, y = lat, group = group)) + 
                    coord_fixed(1.3)

#      Outline
plot2 <- ggplot() + geom_polygon(data = usa_map, aes(x=long, y = lat, group = group), 
                    fill = NA, color = "red") + coord_fixed(1.3)


#      Add points on map
labs <- data.frame(
  long = c(-122.064873, -122.306417),
  lat = c(36.951968, 47.644855),
  names = c("SWFSC-FED", "NWFSC"),
  stringsAsFactors = FALSE
)  

plot1 +
  geom_point(data = labs, aes(x = long, y = lat), color = "yellow", size = 3)

#==========================================================================================#



#==========================================================================================#
# Basic USA plot with state outlines

usa_states <- map_data("state")

plot_states <- ggplot(data = usa_states) +
                      geom_polygon(aes(x=long, y = lat, fill = region, group = group), 
                      color = "white") + 
                      coord_fixed(1.3) +
                      guides(fill = FALSE) #If true there will be a color legend

plot_states

#=========================================================================================#



#=========================================================================================#
# Choose specific states

west_coast <- subset(usa_states, region %in% c("california", "oregon", "washington"))

plot_wc <- ggplot(data = west_coast) +
                  geom_polygon(aes(x = long, y =lat, group = group), fill = "blue", 
                  color = "white") +
                  coord_fixed(1.3)


plot_wc

#=========================================================================================#




#=========================================================================================#
# County level

ca_df <- subset(usa_states, region == "california")

counties <- map_data("county")
county_df <- subset(counties, region == "california")


#    County map with white borders
ca_base <- ggplot(data = ca_df, mapping = aes(x = long, y = lat, group = group)) +
                  coord_fixed(1.3) +
                  geom_polygon(color = "black", fill = "gray")

ca_base + theme_nothing() +
         geom_polygon(data = ca_county, fill = NA, color = "white") +
         geom_polygon(color = "black", fill = NA)

#=========================================================================================#



#=========================================================================================#
# Implement population data with county map
#    Only using 2000 data for this particular one.
#USE COUNTY FIPS FOR GODS SAKE

library(stringr)
library(dplyr)



new_pop <- subset(pop_data, Year == "2000")




#new_pop <- data.frame(lapply(new_pop, function(v) {
#              if (is.character(v)) return(tolower(v))
#              else return(v)
#            }))



cacopa <- merge(counties, new_pop, by = "subregion", all = TRUE)

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

elbow_room1 <- usa_map +
          geom_polygon(data = cacopa, aes(fill = Population), color = "white") +
          geom_polygon(color = "black", fill = NA) +
          theme_bw() +
          ditch_the_axes


elbow_room1
