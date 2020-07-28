library(ggplot2)
library(dplyr)
#Create path
if(!file.exists("Project_2_EDA")){
  dir.create("Project_2_EDA")  }

#Download Data
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("Project_2_EDA/data.zip")){download.file(url,
                                                         destfile = "Project_2_EDA/data.zip",
                                                         overwrite = T)
}
unzip("Project_2_EDA/data.zip",exdir = "Project_2_EDA/data")

# Read data
NEI<-readRDS("Project_2_EDA/data/summarySCC_PM25.rds")
SCC<-readRDS("Project_2_EDA/data/Source_Classification_Code.rds")


# set subdata 1999 to 2008 with SCC
NEI<-merge(NEI,SCC,by = "SCC")

# Baltimore City, fips == "24510"
baltimore<-subset(NEI,fips == "24510")

# Gruop data 
group_type_year<-baltimore %>% 
                  group_by(year,type) %>% 
                  summarise(Emissions_type=sum(Emissions)) %>% 
                  select(Emissions_type,type,year)

# transform type in factor
group_type_year<-transform(group_type_year,type=factor(type))

# Remove SCC
rm(SCC)


# Plot for factor: point, nonpoint, onroad and nonroad
x<-ggplot(data = group_type_year,aes(x=year,y=Emissions_type, group=type) )
x + geom_point(aes(color=type)) + geom_line(aes(col=type)) + 
  labs(x="Year", y="Type of Emissions for Baltimore", 
       title = "Type Emissions for year")
dev.copy(png,"Project_2_EDA/plot3.png")
dev.off()

