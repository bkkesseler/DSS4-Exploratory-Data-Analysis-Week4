## Week 4 Project for Exploratory Data Analysis (Data Science Specialization 
## Course 4) - Question 2

## Clear the workspace
rm(list = ls())

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

## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
## plot answering this question.

## Subset to Baltimore (fips == "24510") data
Baltimore <- NEI$fips == "24510"
NEI_Baltimore <- NEI[Baltimore,]

## Aggregate the data by year
NEI_Baltimore_by_year <- aggregate(Emissions ~ year, NEI_Baltimore, sum)

## Set up the png device
png(filename="plot2.png",width=480,height=480,units="px")

## Plot the data
xvals <- with(NEI_Baltimore_by_year,
     barplot(
             Emissions,
             year,
             names.arg=year[1:4],
             xlab="Year",
             ylab="PM2.5 Emissions (in tons)",
             main="Total Baltimore PM2.5 Emissions")
     )

lines(xvals,
      predict(
              lm(NEI_Baltimore_by_year$Emissions ~ NEI_Baltimore_by_year$year),
              new.data = NEI_Baltimore_by_year$year
              ),
      col="blue",
      lwd=4)


## Close the device
dev.off()

## Clear the workspace
rm(list = ls())

## Conclusion is that total PM2.5 emissions in Baltimore have decreased 
## over the period from 1999 to 2008, but not monotonically. 2005 experienced
## almost as many emissions as 1999.