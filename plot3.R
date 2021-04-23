#plot3.R for question 3

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

# plot to .png file.  Set to square with par/pty.  You can plot with type = "l" for line for the first and then do the rest as lines.
# legend is pretty hard since default legend is hard - had to shring with cex and draw a rectangle with trial and error.
# also used intersp to reduce the gap between lines.  Had to use isodate time for the x-co-ordinates.
png("plot3.png", height = 480, width = 480)
par(mfrow=c(1,1))
par(pty="s")
par(cex=0.9)
with(dataset, plot(Time,Sub_metering_1,type="l",xlab="", ylab = "Energy sub metering",lty=1,lwd=1))
with(dataset, lines(Time,Sub_metering_2,lty=1,lwd=1, col="red"))
with(dataset, lines(Time,Sub_metering_3,lty=1,lwd=1, col = "blue"))
with(dataset, legend(x=ISOdatetime(2007,2,2,0,0,0),y=40,legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty="n", lty=c(1,1,1),lwd=c(1,1,1),col = c("black","blue","red"),y.intersp = 1,cex=1))
with(dataset, rect(ISOdatetime(2007,2,2,1,0,0),34.,ISOdatetime(2007,2,3,0,0,0),40))   
dev.off()

