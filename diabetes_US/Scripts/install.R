#!usr/bin/Rscript

# This script is used to download the required package for the whole diabetes_US package
# Author: Jihong Tang
# Date: May 5, 2019

is_installed <- function(package) {
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0) return(FALSE)
    return(TRUE)
}

basic_packages <- c("tidyverse", "devtools")
graphics_packages <- c("gganimate", "tweenr", "viridis", "ggpubr", "reshape2")
map_packages <- c("maps", "sp", "maptools", "tmap", "cartogram", "broom")

for(package in c(basic_packages, graphics_packages, map_packages ) ) {
    if(!is_installed(package)) {
        install.packages(package, repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN")
    }
}