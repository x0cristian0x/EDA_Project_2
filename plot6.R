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


# Join NEI and SCC
NEI<-merge(NEI,SCC,by = "SCC")


# Emissions from vehicle sources changed from 1999 and 2008 in Baltimore City
NEI <-NEI[grep("Vehicle",NEI$SCC.Level.Two),]

# Data Baltimore, "fips == "24510"
vehicle_baltimore<-subset(NEI,fips=="24510"& type=="ON-ROAD")

# Group data Baltimore
x_baltimore<-vehicle_baltimore %>% 
  group_by(year,fips) %>% 
  summarise(Emissions=sum(Emissions)) %>% 
  select(Emissions,year,fips)

# Data Los Angeles, "fips == "06037"
vehicle_Angeles<-subset(NEI,fips=="06037"& type=="ON-ROAD")

# Group data Los angeles
x_Angeles<-vehicle_Angeles %>% 
  group_by(year,fips) %>% 
  summarise(Emissions=sum(Emissions)) %>% 
  select(Emissions,year,fips)

# Join data Los Angeles and Baltimore
x_join<-rbind(x_baltimore,x_Angeles)

# transform fips to factor
x_join<-transform(x_join,fips=factor(fips,labels = c("Baltimore","Los Angeles")))

# plot
x<-ggplot(data=x_join,aes(x=year,y=Emissions,group=fips))
x + geom_point(aes(col=fips)) + geom_line(aes(col=fips)) +
  labs(x="year",y="city",title = "Compare data by cities")

dev.copy(png,"Project_2_EDA/plot6.png")
dev.off()




  