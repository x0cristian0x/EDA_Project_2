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


# set subdata 1999 and 2008, 
NEI<-subset(NEI,year=="1999"| year=="2008")
NEI<-merge(NEI,SCC,by = "SCC")

# Remove SCC
rm(SCC)


# Plot for factor: point, nonpoint, onroad and nonroad
x<-ggplot(data = NEI,aes(x=year,y=Emissions))
x + geom_point(aes(color=type)) + 
  annotate(geom="text", x=1999, y=max(NEI$Emissions,na.rm = TRUE)-1000,
           label="Higher increase",color="black",size=3) + 
  annotate(geom="text", x=2008, y=min(NEI$Emissions,na.rm = TRUE)-100,
           label=" Decreasing",color="black",size=3)
dev.copy(png,"Project_2_EDA/plot3.png")
dev.off()

