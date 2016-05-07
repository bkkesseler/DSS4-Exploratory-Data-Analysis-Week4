## Week 4 Project for Exploratory Data Analysis (Data Science Specialization 
## Course 4) - Question 4

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

## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999-2008?

## Subset to coal combustion-related data
coal_SCC_id <- grep(".*comb.*coal",SCC$Short.Name,ignore.case=TRUE)
coal_SCC <- SCC[coal_SCC_id,]
NEI_coal_combustion_related <- NEI[NEI$SCC %in% coal_SCC$SCC,]

## Aggregate by year
NEI_coal_combustion_related_by_year <- aggregate(Emissions ~ year,
                                                 NEI_coal_combustion_related,
                                                 sum)

## Set up the png device
png(filename="plot4.png",width=480,height=480,units="px")

## Plot the data
base_plot <- ggplot(NEI_coal_combustion_related_by_year,
                    aes(x=year,y=Emissions))

plot4 <- base_plot + geom_bar(stat="identity")

plot4 <- plot4 + geom_smooth(method="lm",se=FALSE,col="blue",
                             lwd=2)

plot4 <- plot4 + theme_bw() + xlab('Year') + ylab('PM2.5 Emissions (in tons)')

plot4 <- plot4 + scale_x_continuous(breaks=c(1999,2002,2005,2008))

plot4 <- plot4 + ggtitle("Total US PM2.5 Emissions from Coal-Combustion Related Sources")

plot4 <- plot4 + theme(legend.position="none")

plot4 

## Close the device
dev.off()

## Clear the workspace
rm(list = ls())

## Conclusion is that total PM2.5 emissions from coal-combustion related 
## sources have decreased from 1999 to 2008, but from 1999 to 2005, they were 
## mostly flat, and the real decrease was only from 2005 to 2008.