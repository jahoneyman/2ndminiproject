library(lubridate)

## Get data from 'specdata'
dat <- read.table("specdata/household_power_consumption.txt", sep=";", header = TRUE)

## Converting data
dat$Date <- as.Date(dat$Date, "%d/%m/%Y")

## 'sub_dat' stores dat and its data with the date of "2007-02-01" and "2007-02-02"
sub_dat <- dat[dat$Date == "2007-02-01" | dat$Date == "2007-02-02", ]


# =======================================
# Plot 1
## histograms, plots, and lines will be stored in 'png' with their respective file name
## 'hist' returns a histogram with the data values of 'sub_dat$Global_active_power'
## as.numeric converts the data values into numeric values since 'sub_dat$Global_active_power'
## creates an error. 'col' for color, 'main' for title of histogram, 'xlab' for label of x-axis
## 'dev.off()' closes the png file 
png("plot1.png")
hist(as.numeric(sub_dat$Global_active_power), 
     col = "red", 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()

# =======================================
# Plot 2
## 'xaxt = "n" ' removes the plots of the x-axis
## 'type = "l" ' change the type of plot into line
## 'axis' changes the bottom values to the corresponding labels
png("plot2.png")
plot(as.numeric(sub_dat$Global_active_power),
     ylab = "Global Active Power (kilowatts)",
     xlab = "",
     xaxt = "n",
     type = "l")
axis(side = 1, 
     at = c(0, 1440, 2800), 
     labels = c("Thu", "Fri", "Sat"))
dev.off()

# =======================================
# Plot 3
## 'line' adds connected line segments to the plot with the values 'Sub_metering_2'
## and 'Sub_metering_3'
## 'legend' displays the legend of the plot displayed at the top-right
png("plot3.png")
plot(sub_dat$Sub_metering_1,
     ylab = "Energy sub metering",
     xlab = "",
     xaxt = "n",
     type = "l")
lines(sub_dat$Sub_metering_2,
      col = "red")
lines(sub_dat$Sub_metering_3,
      col = "blue")
legend("topright", 
       col=c("black","red","blue"), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1)
axis(side = 1, 
     at = c(0, 1440, 2800), 
     labels = c("Thu", "Fri", "Sat"))
dev.off()

# =======================================
# Plot 4
## the functions used here are similar to plots 1, 2, and 3
## 'par' is used to display the graphs below in a 2by2 manner
png("plot4.png")
par(mfrow=c(2,2))

plot(as.numeric(sub_dat$Global_active_power),
     ylab = "Global Active Power (kilowatts)",
     xlab = "",
     xaxt = "n",
     type = "l")
axis(side = 1, 
     at = c(0, 1440, 2800), 
     labels = c("Thu", "Fri", "Sat"))

plot(sub_dat$Voltage,
     ylab = "Voltage",
     xlab = "datetime",
     xaxt = "n",
     type = "l")
axis(side = 1, 
     at = c(0, 1440, 2800), 
     labels = c("Thu", "Fri", "Sat"))

plot(sub_dat$Sub_metering_1,
     ylab = "Energy sub metering",
     xlab = "",
     xaxt = "n",
     type = "l")
lines(sub_dat$Sub_metering_2,
      col = "red")
lines(sub_dat$Sub_metering_3,
      col = "blue")
legend("topright", 
       col=c("black","red","blue"), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n",
       lty=1)
axis(side = 1, 
     at = c(0, 1440, 2800), 
     labels = c("Thu", "Fri", "Sat"))

plot(sub_dat$Global_reactive_power,
     ylab = "Global_reactive_power",
     xlab = "datetime",
     xaxt = "n",
     type = "l")
axis(side = 1, 
     at = c(0, 1440, 2800), 
     labels = c("Thu", "Fri", "Sat"))

dev.off()
