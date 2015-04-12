library(dplyr)
library(lubridate)
fileName <- "household_power_consumption.txt"

## Read in the data set
df <- read.table(fileName, 
                 header = TRUE, 
                 sep=";", 
                 na.strings = "?")

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

## plot 2
png("plot2.png", 
    width=480,
    height=480,
    units="px")

par(bg="transparent"
    )

plot(ndf$Date,
     ndf$Global_active_power,
     type = 'l',
     ylab='Global Active Power (kilowatts)', 
     xlab=''
     )

#dev.copy (png, "plot2.png" ,width=480,height=480,units="px")
dev.off()

rm(fdate)
rm(df)
rm(ndf)