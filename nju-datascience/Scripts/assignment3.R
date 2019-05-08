library(tidyverse)
# create the function to deal with each line in the original data file
processLine = function(x){	
    # split the line based on three division symbol ; = , 
    tokens <- strsplit(x,"[;=,]")[[1]]
    # delete the record without any signal
	if(length(tokens)==10) return(NULL)
	tmp <- matrix(tokens[-(1:10)], ncol=4, byrow = TRUE)
	mat <- cbind(matrix(tokens[c(2,4,6:8,10)], nrow = nrow(tmp), ncol=6, byrow = TRUE), tmp)
	return(mat)
}
# create the function to group the orientation by 8 different angles
roundOrientation = function(angels)
{
  refs <- seq(0,by=45,length=9)
  q <- sapply(angels,function(o) which.min(abs(o-refs)))
  c(refs[1:8],0)[q]
}

# read the raw data files line by line
txt <- readLines("./offline.final.trace.txt")
# delete the annotation lines
lines <- txt[substr(txt,1,1)!="#"]
# deal each line in the raw data file using function processLine
tmp <- lapply(lines, processLine)
# create the dataframe to store all the data
offline <- as.data.frame(do.call("rbind",tmp), stringsAsFactors=FALSE)
# rename the cols
names(offline) <- c("time","scanMac","posX","posY","posZ","orientation","mac","signal","channel","type")
# choose the names of the columns needed to be changed to numeric
numVars <- c("time","posX","posY","posZ","orientation","signal")
# change str to numeric
offline[numVars] <- lapply(offline[numVars], as.numeric)
# practical useful manipulation to filter the type 
offline <- offline[offline$type == "3",]
offline <- offline[,"type"!=names(offline)]
# change the time data into sepcific data structure
offline$rawTime <- offline$time
offline$time <- offline$time/1000
class(offline$time) <- c("POSIXt","POSIXct")
# delete two columns
offline <- offline[ , !(names(offline) %in% c("scanMac","posZ"))]

# group_by work about the orientation using function roundOrientation
offline$angle = roundOrientation(offline$orientation)
# choose the most 7 devices for further analysis
subMacs = names(sort(table(offline$mac),decreasing=TRUE))[1:7]
offline = offline[offline$mac %in% subMacs,]

task1 <- offline %>% 
  # choose the specific position
  filter(posX == 2, posY == 12) %>% 
  # filter out the noisy device
  filter(mac != "00:0f:a3:39:dd:cd") %>% 
  ggplot() +
  # basic boxplot
  geom_boxplot(aes(x = factor(angle), y = signal)) + 
  # create the sub figures by the devices
  facet_wrap(~mac)

task1
ggsave("./basic_boxplot.png", dpi = "print")

task2 <- offline %>% 
  # choose the specific position
  filter(posX == 24, posY == 4) %>% 
  # filter out the noisy device
  filter(mac != "00:0f:a3:39:dd:cd") %>% 
  ggplot() +
  # basic density plot about the signal value
  geom_density(aes(signal)) +
  # create subfigures based on angle and devive categories
  facet_grid(rows = vars(angle), cols = vars(mac))

task2
ggsave("./basic_densityplot.png", dpi = "print")

task3 <- offline %>% 
  # choose the specific position
  filter(posX == 2, posY == 12) %>% 
  # filter out the noisy device
  filter(mac != "00:0f:a3:39:dd:cd") %>% 
  ggplot() +
  # basic violin plot
  geom_violin(aes(x = factor(angle), y = signal, fill = factor(angle))) + 
  # create subfigures 
  facet_wrap(~mac)

task3
ggsave("./basic_violinplot.png", dpi = "print")
#function implementation
# boxplot
boxplot_pos <- function(posX, posY){
    offline %>%
    # choose the specific position
    filter(posX == posX, posY == posY) %>% 
    # filter out the noisy device
    filter(mac != "00:0f:a3:39:dd:cd") %>% 
    ggplot() +
    # basic boxplot
    geom_boxplot(aes(x = factor(angle), y = signal)) + 
    # create the sub figures by the devices
    facet_wrap(~mac)
}

# density plot
density_pos <- function(posX, posY){
    offline %>% 
    # choose the specific position
    filter(posX == 24, posY == 4) %>% 
    # filter out the noisy device
    filter(mac != "00:0f:a3:39:dd:cd") %>% 
    ggplot() +
    # basic density plot about the signal value
    geom_density(aes(signal)) +
    # create subfigures based on angle and devive categories
    facet_grid(rows = vars(angle), cols = vars(mac))
}