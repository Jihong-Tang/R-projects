# This script is used to import the data and output the boxplot result based on given command line arguments

# Argument: command line argument:[1] The path of the file; [2] The path to save file;

args <- commandArgs(T)
file_path <- args[1]
result_save_path <- args[2]

AAL_input <- read.csv(file_path, header = F, nrows = 1, skip = 0)
ABR_input <- read.csv(file_path, header = F, nrows = 1, skip = 1)
ACR_input <- read.csv(file_path, header = F, nrows = 1, skip = 2)

# t() is used to transverse the row to column in a dataframe
AAL <- c(t(AAL_input))
ABR <- c(t(ABR_input))
ACR <- c(t(ACR_input))

# the way to save a .png file or .pdf 
png(paste(result_save_path, "boxplot.png", sep = ""))
boxplot(AAL,ACR,ABR,names=c('AAL','ACR','ABR'),col=c("green","blue","yellow"))
dev.off()