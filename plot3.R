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

#Convert the Time column to Time format
household_PC_filt<-mutate(household_PC_filt, 
                          Time = hms(Time))

#Create the DateTime column = Date+Time
household_PC_filt<-mutate(household_PC_filt, 
                          DateTime = Date+Time)

#Convert the Sub_metering columns to numeric
household_PC_filt<-mutate(household_PC_filt, 
                          Sub_metering_1=as.numeric(Sub_metering_1),
                          Sub_metering_2=as.numeric(Sub_metering_2),
                          Sub_metering_3=as.numeric(Sub_metering_3))

#----------------------------------------------------------------------------------
#3. plotting
#----------------------------------------------------------------------------------

#Open the graphic device
png(file="plot3.png", width = 480, height=480)

#Create the plot
with(household_PC_filt, 
     
     plot(DateTime,Sub_metering_1, 
          type = "n",
          xlab = "",
          ylab = "Energy sub metering")
     
     )

#Add points
with(household_PC_filt, points(DateTime,Sub_metering_1, type = "l", col = "black"))
with(household_PC_filt, points(DateTime,Sub_metering_2, type = "l", col = "red"))
with(household_PC_filt, points(DateTime,Sub_metering_3, type = "l", col = "blue"))

#Create the legend
legend("topright", 
       lty = 1,
       col = c("black","red","blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Save the plot
dev.off()
