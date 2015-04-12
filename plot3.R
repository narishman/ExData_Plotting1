library(dplyr)
library(lubridate)
fileName <- "household_power_consumption.txt"

## Read in the data set
df <- read.table(fileName, 
                 header = TRUE, 
                 sep=";", 
                 na.strings = "?"
                 )

## merge date and time and convert it to a date object
fdate <- strptime(paste(df$Date,df$Time), 
                  "%d/%m/%Y %H:%M:%S", 
                  tz="UTC"
                  )

ndf <- cbind(Date=fdate, 
             df[,-(1:2)] 
             )

## Select dataset for the time interval requested.
int <- new_interval(ymd_hms("2007-02-01 00:00:01", tz='UTC'),
                    ymd_hms("2007-02-03 00:00:00",tz='UTC')
                    )

ndf <- ndf %>% 
    filter( Date %within% int)

## Convert Global_active_power as numeric for plotting
ndf$Global_active_power <- as.numeric (ndf$Global_active_power)

## plot 3
png("plot3.png", 
    width=480,
    height=480,
    units="px")

par(cex=0.8, 
    cex.axis=0.8,
    bg="transparent",
    mar=c(2.8, 4.1, 4.1, 3.1)
    )

plot(ndf$Date,
     ndf$Sub_metering_1,
     type = 'n', 
     ylab="Energy sub metering"
     )

with(ndf, 
     points(Date,
            Sub_metering_1,
            type="l",
            col="black"
            )
    )

with(ndf, 
     points(Date,
            Sub_metering_2,
            type="l",
            col="red"
            )
    )

with(ndf, 
     points(Date,
            Sub_metering_3,
            type="l",
            col="blue"
            )
    )

legend("topright",
       lwd = 1,
       col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       cex=0.8
       )

dev.off() 

rm(fdate)
rm(df)
rm(ndf)