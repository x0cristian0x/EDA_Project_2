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



# set subdata 1999 and 2008
NEI<-subset(NEI,year=="1999"| year=="2008")

# Join NEI and SCC
NEI<-merge(NEI,SCC,by = "SCC")


# Emissions from vehicle sources changed from 1999 and 2008 in Baltimore City
NEI <-NEI[grep("Vehicle",NEI$SCC.Level.Two),]

# Data Baltimore, "fips == "24510"
vehicle_baltimore<-subset(NEI,fips=="24510")

# Data Los Angeles, "fips == "06037"
vehicle_Angeles<-subset(NEI,fips=="06037")

# Join data Los Angeles and Baltimore
vehicle<-rbind(vehicle_Angeles,vehicle_baltimore)

# Transform to factor "fips"
vehicle<-transform(vehicle,fips=factor(fips,labels = c("Los Angeles","Baltimore")))
x<-ggplot(data = vehicle,aes(x=year,y=Emissions))

# ylim = (0,400) for best visualition
x + geom_point(aes(color=fips)) + ylim(0,400) +
  geom_hline(yintercept = median(vehicle_Angeles$Emissions,na.rm = TRUE),col="RED") +
  geom_hline(yintercept = median(vehicle_baltimore$Emissions,na.rm = TRUE),col="BLUE") +
  annotate(x=2001,y=median(vehicle_Angeles$Emissions) +15,geom = "Text",
           label="Median For City",col="Green")

dev.copy(png,"Project_2_EDA/plot6.png")
dev.off()


