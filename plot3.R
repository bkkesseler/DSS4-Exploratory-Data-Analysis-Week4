## Week 4 Project for Exploratory Data Analysis (Data Science Specialization 
## Course 4) - Question 3

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

## Of the four types of sources indicated by the type (point, nonpoint, onroad,
## nonroad) variable, which of these four sources have seen decreases in 
## emissions from 1999-2008 for Baltimore City? Which have seen increases in 
## emissions from 1999-2008? Use the ggplot2 plotting system to make a plot 
## answer this question.

## Subset to Baltimore (fips == "24510") data
Baltimore <- NEI$fips == "24510"
NEI_Baltimore <- NEI[Baltimore,]

## Aggregate by year and type
NEI_Baltimore_by_year_by_type <- aggregate(Emissions ~ year + type,
                                           NEI_Baltimore, sum)

## Set up the png device
png(filename="plot3.png",width=960,height=960,units="px")

## Plot the data
base_plot <- ggplot(NEI_Baltimore_by_year_by_type,
                    aes(x=year,y=Emissions,color=type,fill=type))

plot3 <- base_plot + geom_bar(stat="identity")

plot3 <- plot3 + geom_smooth(method="lm",aes(group=type),se=FALSE,col="black",
                             lwd=2)

plot3 <- plot3 + theme_bw() + xlab('Year') + ylab('PM2.5 Emissions (in tons)')

plot3 <- plot3 + scale_x_continuous(breaks=c(1999,2002,2005,2008))

plot3 <- plot3 + ggtitle("PM2.5 Emissions in Baltimore, by Type")

plot3 <- plot3 + theme(legend.position="none")

plot3 <- plot3 + facet_wrap(~type,scales='free',nrow=2)

plot3 

## Close the device
dev.off()

## Clear the workspace
rm(list = ls())

## Conclusion is that PM2.5 emissions by source type in Baltimore have 
## decreased each year, from 1999 to 2008, for the years available 
## (1999, 2002, 2005, 2008), for Non-Road, On-Road, and NonPoint types. For 
## Point sources, PM2.5 emissions have increased each year, for the same time
## period.