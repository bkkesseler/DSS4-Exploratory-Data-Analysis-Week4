## Week 4 Project for Exploratory Data Analysis (Data Science Specialization 
## Course 4)

## Clear the workspace
rm(list = ls())

## Load libraries as needed
if (!require("RColorBrewer")) {
        install.packages("RColorBrewer")
        library(RColorBrewer)
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

## Have total emissions from PM2.5 decreased in the United States from 
## 1999 to 2008? Using the base plotting system, make a plot showing the total
## PM2.5 emission from all sources for each of the years 1999, 2002, 2005, 
## and 2008.

## Aggregate the data by year
NEI_by_year <- aggregate(Emissions ~ year, NEI, sum)

## Set up the png device
png(filename="plot1.png",width=480,height=480,units="px")

## Plot the data
with(NEI_by_year,
     barplot(
             Emissions,
             year,
             names.arg=year[1:4],
             xlab="Year",
             ylab="PM2.5 Emissions (in tons)",
             main="Total US PM2.5 Emissions")
     )

## Close the device
dev.off()

## Clear the workspace
rm(list = ls())

## Conclusion is that total emissions from PM2.5 have decreased each year, from
## 1999 to 2008, for the years available (1999, 2002, 2005, 2008)