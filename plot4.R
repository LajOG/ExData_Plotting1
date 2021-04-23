#plot4.R for question 4

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

#date not fixed - convert test$Time to date time by combining with Date and Date to Date
# load lubridate for parse_date_time function
library(lubridate)
test$Time<-parse_date_time(paste(test$Date,test$Time),"%d/%m/%y %H:%M:%S")
test$Date<- as.Date(test$Date, "%d/%m/%Y")

#filter for date range Feb 1, 2007 tp Feb 2, 2007 and delete test to conserve memory
begindate <- ISOdate(2007,02,01,0,0,00,tz="UTC")
enddate <- ISOdate(2007,02,03,0,0,00,tz="UTC")
dataset <-subset(test,test$Time>=begindate& test$Time< enddate)  ## seems to work
rm(test)

# going to plot 4 charts and we already have two of them from past plots so I will plot those first and in the col
# fill order.  Set screen to max plotting area with par and pty to allow for all plots to be comfortably spaced.
dev.off()
png("plot4.png",height = 480, width = 480)
par(mfcol=c(2,2))
par(pty ="m" )

# from q2
plot(x=dataset$Time,y=dataset$Global_active_power, type = "n",
     xlab = "", ylab = "Global Active Power (kilowatts)")
lines(x=dataset$Time,y=dataset$Global_active_power,
      xlab = "",ylab = "Global Active Power (kilowatts)")

# from q3 but without the rectangle - had to play around to get a good legend placement
with(dataset, plot(Time,Sub_metering_1,type="l",xlab="", ylab = "Energy sub metering",lty=1,lwd=1))
with(dataset, lines(Time,Sub_metering_2,lty=1,lwd=1, col="red"))
with(dataset, lines(Time,Sub_metering_3,lty=1,lwd=1, col = "blue"))
with(dataset, legend(x=ISOdatetime(2007,2,1,16,0,0),y=40,legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n", lty=c(1,1,1),lwd=c(1,1,1),col = c("black","blue","red"),cex=.8,y.intersp=1))
  

# simple plot placed in the first row second column
with(dataset, plot(Time,Voltage,type="l",xlab="datetime", ylab = "Voltage",lty=1,lwd=1))

# simple plot placed in the second row second column
with(dataset, plot(Time,Global_reactive_power,type="l",xlab="datetime",lty=1,lwd=1))

dev.off()

