#Data downloading and reading
library(RCurl);
library(data.table)

temp <- tempfile()
download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', temp,method='curl')
data <- read.table(unz(temp,'household_power_consumption.txt'),sep=';',header=TRUE)

#Subsetting and data cleansing
alfa <-as.Date(c('01/02/2007','02/02/2007'),format="%d/%m/%Y")
index<-as.Date(as.character(data$Date),format="%d/%m/%Y")==alfa[1]
index2<-as.Date(as.character(data$Date),format="%d/%m/%Y")==alfa[2]
indices = index+index2
datos<-data[as.logical(indices),]


datos$DateTime <- paste(datos$Date,datos$Time,sep=' ')
datos$DateTime <- strptime(datos$DateTime, "%d/%m/%Y %H:%M:%S")
datos$Global_active_power<-as.numeric(as.character(datos$Global_active_power))


#Plot generation
png(filename = "plot3.png",width = 480, height = 480,bg = "transparent")
with(datos,{
  plot(DateTime,as.numeric(as.character(datos$Sub_metering_1)),type="l",ylab='Energy sub metering',yaxp = c(0,30,3))
  lines(DateTime,as.numeric(as.character(datos$Sub_metering_3)),col='blue')
  lines(DateTime,as.numeric(as.character(datos$Sub_metering_2)),col='red')
  legend("topright",lty=1,col=c('black','red','blue'),legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'))})
dev.off()