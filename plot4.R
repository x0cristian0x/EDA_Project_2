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

#read data
NEI<-readRDS("Project_2_EDA/data/summarySCC_PM25.rds")
SCC<-readRDS("Project_2_EDA/data/Source_Classification_Code.rds")


# set subdata 1999 and 2008
NEI<-subset(NEI,year=="1999"| year=="2008")

# Merge NEI and SCC
NEI<-merge(NEI,SCC,by = "SCC")

# emissions from coal combustion-related sources changed from 1999-2008
NEI<-NEI[grep("Coal",NEI$EI.Sector),]
x<-ggplot(NEI,aes(y=Emissions,x=year))
x + geom_point()
dev.copy(png,"Project_2_EDA/plot4.png")
dev.off()

