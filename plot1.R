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


# Emition Total 1999-2008
total<-tapply(NEI$Emissions, NEI$year, sum)
total<-data.frame(Emition=total,year=row.names(total))
plot(total$year,total$Emition,xlim = c(1999,2008))
dev.copy(png,"Project_2_EDA/plot1.png")
dev.off()
