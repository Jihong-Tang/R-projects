[TOC levels=1-3]: #

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Name](#name)
- [Assignment one: web crawler in R](#assignment-one-web-crawler-in-r)
- [Assignment two: basic data manipulation](#assignment-two-basic-data-manipulation)
- [Assignment three: basic statiscal plotting](#assignment-three-basic-statiscal-plotting)
- [Author](#author)

# Name
Nju-datascience - recombination of the assignments in the course `Data Science and Innovation`, instruted by Terman Huang.

# Assignment one: web crawler in R

# Assignment two: basic data manipulation
The requirement of assignment could be found in the sub-directory [`assign-requirements/`](#assign-requirements/). This assignment is all about the simple manipulation skills to import and prepare the given data.

```r
library(tidyverse)

data_process <- function(filepath){
    # import data and delete the first column and the first row
    raw_data <- read_csv(filepath) %>% .[-1, -1] %>% 
    # set the new colnames
    setNames(c("id", "name", "salary", "start_date", "dept")) %>%
    # change the data structure of the salary and the start_date
    mutate(salary = as.numeric(salary), start_date = as.Date(start_date)) %>% 
    # create a new column to store some information
    mutate(comment = paste(name, "entered", dept, "on", start_data)) %>% 
    # create a new column named flag to store the information that whether the row has N/A value; bool str
    mutate(flag = is.na(id) + is.na(name) + is.na(salary) + is.na(start_data) + is.na(dept)) %>% 
    mutate(flag = as.logical(flag))
}
# call the function twice
df1 <- data_process("./input1.csv")
df2 <- data_process("./input2.csv")
# combine the two dataframe by rows
dfall <- rbind(df1, df2) %>% unique(.)
```

# Assignment three: basic statiscal plotting
The requirement of assignment could be found in the sub-directory [`assign-requirements/`](#assign-requirements/). The assignment is based on one practical case to use the data manipulation skills, and after we got the required data, the plotting procedure would become easier.

```r
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


roundOrientation = function(angels)
{
  refs = seq(0,by=45,length=9)
  q = sapply(angels,function(o) which.min(abs(o-refs)))
  c(refs[1:8],0)[q]
}

txt = readLines("offline.final.trace.txt")

lines = txt[substr(txt,1,1)!="#"]

tmp = lapply(lines, processLine)

offline = as.data.frame(do.call("rbind",tmp), stringsAsFactors=FALSE)

names(offline)= c("time","scanMac","posX","posY","posZ","orientation","mac","signal","channel","type")

numVars = c("time","posX","posY","posZ","orientation","signal")

offline[numVars] = lapply(offline[numVars], as.numeric)

offline = offline[offline$type == "3",]
offline = offline[,"type"!=names(offline)]

offline$rawTime = offline$time
offline$time = offline$time/1000
class(offline$time) = c("POSIXt","POSIXct")

offline = offline[,!(names(offline) %in% c("scanMac","posZ"))]


offline$angle = roundOrientation(offline$orientation)

c(length(unique(offline$mac)),length(unique(offline$channel)))
table(offline$mac)


subMacs = names(sort(table(offline$mac),decreasing=TRUE))[1:7]
offline = offline[offline$mac %in% subMacs,]

task1 <- offline %>% 
  filter(posX == 2, posY == 12) %>% 
  filter(mac != "00:0f:a3:39:dd:cd") %>% 
  ggplot() +
  geom_boxplot(aes(x = factor(angle), y = signal)) + 
  facet_wrap(~mac)

task2 <- offline %>% 
  filter(posX == 24, posY == 4) %>% 
  filter(mac != "00:0f:a3:39:dd:cd") %>% 
  ggplot() +
  geom_density(aes(signal)) +
  facet_grid(rows = vars(angle), cols = vars(mac))


task3 <- offline %>% 
  filter(posX == 2, posY == 12) %>% 
  filter(mac != "00:0f:a3:39:dd:cd") %>% 
  ggplot() +
  geom_violin(aes(x = factor(angle), y = signal, fill = factor(angle))) + 
  facet_wrap(~mac)

task3df <- offline %>% 
  filter(posX == 2, posY == 12) %>% 
  filter(mac != "00:0f:a3:39:dd:cd") %>% 
  select(mac, angle, signal)

q <- task3df %>% 
  ggplot(aes(x= angle, y= mac))+
  geom_tile(aes(fill = signal)) 
```


# Author
Jihong Tang &lt;njutangjihong@gmail.com&gt;