## Week 4 Project for Exploratory Data Analysis (Data Science Specialization 
## Course 4) - Question 5

## Clear the workspace
rm(list = ls())

## Load libraries as needed
if (!require("ggplot2")) {
        install.packages("ggplot2")
        library(ggplot2)
}

## Check to see if the file is present, if it is, continue
## If the file is not present, check to see if the zip file is present, if it 
##   is, unzip the file
## If the zip file is not present, download it, and unzip the file 
if (
        length(
                grep("Source_Classification_Code.rds",list.files())
                ) > 0
        ) { print("Text file present, continuing") 
                } else if (
        length( 
                grep("exdata-data-FNEI_data.zip",list.files())
                ) > 0
        ) { 
        print("Text file missing, zip file present, unzipping")
        unzip("exdata-data-FNEI_data.zip",overwrite=TRUE)
                } else { 
        print("Downloading file, then unzipping") 
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                      "exdata-data-FNEI_data.zip")
        unzip("exdata-data-FNEI_data.zip",overwrite=TRUE)
        }

## Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## How have emissions from motor vehicle sources changed from 1999-2008 in 
## Baltimore City?

## Subset to Baltimore (fips == "24510") data
Baltimore <- NEI$fips == "24510"
NEI_Baltimore <- NEI[Baltimore,]

## Subset to motor-vehicle sources
## type = "ON-ROAD" seems to cover this.
NEI_Baltimore_motor_vehicle_sources <- subset(NEI_Baltimore,type=="ON-ROAD")

## Aggregate by year
NEI_Baltimore_motor_vehicle_by_year <- aggregate(Emissions ~ year,
                                                NEI_Baltimore_motor_vehicle_sources,
                                                sum)

## Set up the png device
png(filename="plot5.png",width=480,height=480,units="px")

## Plot the data
base_plot <- ggplot(NEI_Baltimore_motor_vehicle_by_year,
                    aes(x=year,y=Emissions))

plot5 <- base_plot + geom_bar(stat="identity")

plot5 <- plot5 + geom_smooth(method="lm",se=FALSE,col="blue",
                             lwd=2)

plot5 <- plot5 + theme_bw() + xlab('Year') + ylab('PM2.5 Emissions (in tons)')

plot5 <- plot5 + scale_x_continuous(breaks=c(1999,2002,2005,2008))

plot5 <- plot5 + ggtitle("Baltimore PM2.5 Emissions from Motor Vehicle Related Sources")

plot5 <- plot5 + theme(legend.position="none")

plot5 

## Close the device
dev.off()

## Clear the workspace
rm(list = ls())

## Conclusion is that Baltimore PM2.5 emissions from motor vehicle sources have
## decreased from 1999 to 2008, but most sharply from 1999  to 2002, with a 
## less drastic decline from 2002 to 2008.