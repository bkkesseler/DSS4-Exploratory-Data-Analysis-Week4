## Week 4 Project for Exploratory Data Analysis (Data Science Specialization 
## Course 4) - Question 6

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

## Compare emissions from motor vehicle sources in Baltimore City with 
## emissions from motor vehicle sources in Los Angeles County, California 
## (fips == "06037"). Which city has seen greater changes over time in motor 
## vehicle emissions?

## Subset to Baltimore (fips == "24510") data
Baltimore <- NEI$fips == "24510"
NEI_Baltimore <- NEI[Baltimore,]

## Subset to motor-vehicle sources in Baltimore
## type = "ON-ROAD" seems to cover this.
NEI_Baltimore_motor_vehicle_sources <- subset(NEI_Baltimore,type=="ON-ROAD")

## Aggregate by year
NEI_Baltimore_motor_vehicle_by_year <- aggregate(Emissions ~ year,
                                                NEI_Baltimore_motor_vehicle_sources,
                                                sum)

## Add indicator for Baltimore
NEI_Baltimore_motor_vehicle_by_year$location <- "Baltimore"

## Subset to LA County (fips == "06037") data
LACounty <- NEI$fips == "06037"
NEI_LACounty <- NEI[LACounty,]

## Subset to motor-vehicle sources in LA
## type = "ON-ROAD" seems to cover this.
NEI_LACounty_motor_vehicle_sources <- subset(NEI_LACounty,type=="ON-ROAD")

## Aggregate by year
NEI_LACounty_motor_vehicle_by_year <- aggregate(Emissions ~ year,
                                                 NEI_LACounty_motor_vehicle_sources,
                                                 sum)

## Add indicator for Baltimore
NEI_LACounty_motor_vehicle_by_year$location <- "LA County"

## Append the data sets
NEI_motor_vehicle_by_year <- rbind(NEI_Baltimore_motor_vehicle_by_year,
                                   NEI_LACounty_motor_vehicle_by_year)

## Set up the png device
png(filename="plot6.png",width=960,height=480,units="px")

## Plot the data
base_plot <- ggplot(NEI_motor_vehicle_by_year,
                    aes(x=year,y=Emissions,color=location,fill=location))

plot6 <- base_plot + geom_bar(stat="identity")

plot6 <- plot6 + geom_smooth(method="lm",se=FALSE,col="black",
                             lwd=2)

plot6 <- plot6 + theme_bw() + xlab('Year') + ylab('PM2.5 Emissions (in tons)')

plot6 <- plot6 + scale_x_continuous(breaks=c(1999,2002,2005,2008))

plot6 <- plot6 + ggtitle("Baltimore and LA County PM2.5 Emissions from Motor Vehicle Related Sources")

plot6 <- plot6 + theme(legend.position="none")

plot6 <- plot6 + facet_wrap(~location,scales='free')

plot6 

## Close the device
dev.off()

## Clear the workspace
rm(list = ls())

## Conclusion is that Baltimore saw a decline in PM2.5 emissions from motor
## vehicle sources from 1999 to 2008, mostly from 1999 to 2002, while LA County
## saw an increase in PM2.5 emissions from motor vehicle sources from 1999-2008.
## The increase in LA County is not monotonic, with 2008 showing less than 2002
## and 2005, but still a higher value than 1999.
## Also, the PM2.5 emissions from on-road sources in LA County are far greater
## than in Baltimore.