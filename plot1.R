#plot1.R for question 1

# check if data directory exists, if not create
if (!dir.exists("./data")){
  dir.create("./data")
}

# dowmload and unzip file and delete zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/power_consumption.zip")
unzip("./data/power_consumption.zip",exdir = "./data")
dir("./data")
unlink("./data/power_consumption.zip")


#read file with na.strings so you don't have integers from the start
test <- read.table(file ="./data/household_power_consumption.txt",header=TRUE,sep=";",nrows=100000
                   ,na.strings = "?" )

#load lubridate for parse_date_time function
#date not fixed - convert test$Time to date time by combining with Date and Date to Date
library(lubridate)
test$Time<-parse_date_time(paste(test$Date,test$Time),"%d/%m/%y %H:%M:%S")
test$Date<- as.Date(test$Date, "%d/%m/%Y")

#filter for date range Feb 1, 2007 tp Feb 2, 2007 and delete test to conserve memory
begindate <- ISOdate(2007,02,01,0,0,00,tz="UTC")
enddate <- ISOdate(2007,02,03,0,0,00,tz="UTC")
dataset <-subset(test,test$Time>=begindate& test$Time< enddate)  ## seems to work
rm(test)


# plot to .png file. Make the plotting region square with par/pty.
png("plot1.png",height=480,width = 480)
par(pty="s")
hist(dataset$Global_active_power,col="red",xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power")
dev.off()

