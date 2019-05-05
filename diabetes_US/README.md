[TOC levels=1-3]: #

# Table of Contents
- [Name](#name)
- [Purpose](#purpose)
- [Author](#author)

# Name
Data analysis about the diabetes in the US - independent study project during the stay in Duke University, instructed by Prof. Matthew Hirschey in [Hirschey Lab](https://github.com/hirscheylab).

# Purpose
* Learn the basic data analysis skills based on [R](https://www.r-project.org/)
* Learn different data visulization methods to analyze spatial and temporal data
* Visualize the data analysis result based on multiple methods
* Animate the data analysis result for better understanding 

# Directory organization

# Introduction to the project
With the development of biological science, the analysis of big data is playing a significant role in the process to gain unknown knowledge. This Independent Study project focuses on the question how to get new knowledge and insight from the existing data about diseases over different areas using data analysis skills including cleaning data and mapping data in meaningful ways. 

Two stages will be involved in this project, focusing on the diabetes, obesity and cartogram image respectively. 

Stage one will focus on diabetes and obesity, recognizing the seriousness of the disease in US. With the workflow of data searching and downloading, data cleaning, data visualization, the animation of increasing incidence of diabetes and obesity over time in US will be made. Afterwards, several changes will be applied into the original procedure to get more insight into the relationship between diseases and areas. More diseases besides diabetes and obesity will be considered as well as data from more countries will be covered in this project. 

Stage two will be based on the assumption that the increasing incidence of diabetes and obesity over time in US has relationship with some geographical factors. After putting some scales on the potential geographical factors when analyzing the data and making cartogram images, this project will try to find more information about the relationship.

Finally, the whole project will base on the [R](https://www.r-project.org/), a programming language statistical computing and graphics.

**Updating**: the whole project is firstly finished during the author's stay in Hirschey's Lab from August, 2018 to December, 2018. Afterwards, the author repeated the project work and update some small details utilizing the Linux server back in China in May, 2019. Here presents the recombination of the project work based on R and Linux environment. The original project work records could be found in [Data_analysis_about_the_diabetes_in_the_US.Rmd](./Data_analysis_about_the_diabetes_in_the_US.Rmd).

# Environment setup 
## R packages installation
To achieve the goal of the specific project, we need to take advantage of the R environment, as well as the various useful packages focusing on different specilized job. Below is the list of the R packages needed to be installed.

```bash
# basic command line method
R
```
```r
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
        install.packages(library, repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN")
    }
}
```
```bash
# Rscript method
Rscript $HOME/R_projects/diabetes_US/Scripts/install.R 
```
## Environment initilization

# Author
Jihong Tang &lt;njutangjihong@gmail.com&gt;

