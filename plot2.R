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



# Baltimore City, fips == "24510"
baltimore<-subset(NEI,fips == "24510")
total_baltimore<-tapply(baltimore$Emissions, baltimore$year,sum)
total_baltimore<-data.frame(Emition=total_baltimore,
                            year=as.numeric(row.names(total_baltimore)))
plot(total_baltimore$year,total_baltimore$Emition)
dev.copy(png,"Project_2_EDA/plot2.png")
dev.off()

