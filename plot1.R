#----------------------------------------------------------------------------------
#1. Download and extract the data
#----------------------------------------------------------------------------------

#Set the locale language
Sys.setlocale(category = "LC_ALL", locale = "english")

#Create the data directory
if(!file.exists("./data")){
    dir.create("./data")
}

#Set the url
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#Set the destination path
path<-"./data/household_power_consumption.zip"

#Download the data
download.file(url, destfile = path)

#Extract/unzip the data
if(!file.exists("./data/household_power_consumption.txt")){
    unzip(path,exdir = "./data")
}

#Remove the .zip file
file.remove(path)


#----------------------------------------------------------------------------------
#2. Read, filter and clean the data
#----------------------------------------------------------------------------------

#Load the necessary packages
library(dplyr)
library(lubridate)

#Read the data
household_PC<-read.table("./data/household_power_consumption.txt", 
                         sep = ";", header = TRUE, dec = ".")

#Convert the Date column to date format
household_PC<-mutate(household_PC, 
                     Date = dmy(Date))

#Filter the data
household_PC_filt<-filter(household_PC, 
                          Date == "2007-02-01"|Date == "2007-02-02")

#----------------------------------------------------------------------------------
#3. plotting
#----------------------------------------------------------------------------------

#Create the histogram
hist(as.numeric(household_PC_filt$Global_active_power),
     xlab = "Global Active Power (kilowatts)", 
     col = "Red",
     main = "Global Active Power")


#Save the plot
dev.copy(png, file="plot1.png", width = 480, height=480)
dev.off()