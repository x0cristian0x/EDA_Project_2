library(ggplot2)

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



# Set subdata 1999 and 2008, 
NEI<-subset(NEI,year=="1999"| year=="2008")

# Join Data NEI and SCC
NEI<-merge(NEI,SCC,by = "SCC")



# Emissions from vehicle from 1999-2008 in Baltimore City
vehicle <-NEI[grep("Vehicle",NEI$SCC.Level.Two),]
vehicle_baltimore<-subset(vehicle,fips=="24510")
plot(vehicle_baltimore$year,vehicle_baltimore$Emissions)
dev.copy(png,"Project_2_EDA/plot5.png")
dev.off()