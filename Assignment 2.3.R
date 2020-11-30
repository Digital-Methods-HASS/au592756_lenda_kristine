dir.create("scripts")
dir.create("data")

# Assignment w48: Scrape the Web.
# Chose assignment 2.3: produce data visualizations 
# that shed light on another interesting aspect of the police killing data.

# First I install R Packages and their libraries:

# For data scraping, data wrangling, data transformation and string manipulation: 
'rvest'
'dplyr'
'tidyr'
'stringr'
'janitor'

# Libraries

library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
library(janitor)
library(tidyverse)

# Problem with library(janitor), needs package installed.
install.packages("janitor")

# Scraping the content of website and extracting HTML table:
url <- "https://killedbypolice.net/kbp2020"

# To scrape the website:
url_html <- read_html(url)

# Using <table> tag to extract the whole HTML table: 
whole_table <- url_html %>% 
  html_nodes("table") %>%
  html_table()

head(whole_table)

# Unlisting whole_table and combining individual elements as columns.

new_table <- do.call(cbind, unlist(whole_table, recursive = FALSE)) 
head(new_table)

# Automating the scraping

# First: Single function to scrape a table from one annual page.
scrape_police_kill <- function(website){
  url <- read_html(website)
  annual_table <- url %>% 
    html_nodes("table") %>%
    html_table()  # result is a list
  annual_table <- do.call(cbind,unlist(annual_table, recursive = FALSE))
}

# Testing function works
table2018 <- scrape_police_kill("https://killedbypolice.net/kbp2018")

table2018 %>% 
  head()

mastertable=NULL

# Writing a loop
for (year in 2013:2020){  # here we create a loop to iterate over the years
  print(year)
  url <- "https://killedbypolice.net/kbp"   # the annual URLs end with "kbp2017" ,etc.
  website <- paste0(url,year)  # here we bind the year to the website to form the URL
  annual_table <- scrape_police_kill(website) # here we apply the function
  mastertable <- rbind(mastertable, annual_table) # we add the scraped results from the given year to our master dataset
}

head(mastertable,2)

tail(mastertable)

# Cleaning the scraped data

mastertable <- as_tibble(mastertable)

str(mastertable)

# Make Age column numeric and relabel the '*' column to Method

data <- mastertable %>% 
  mutate(Age = as.numeric(Age)) %>% 
  rename(Method = "*")

# Cleanup the dates with 'lubridate' package and 'grepl()'

mastertable$Date[c(70:80, 160:170)]

tail(unique(mastertable$Date))

# Changing date format

library(lubridate)
data <- data %>% 
  mutate(Date =
           case_when(
             grepl("201[34]",Date) ~ mdy(Date),  
             # convert dates that contain 2013 or 2014 into mdy format 
             !grepl("201[34]",Date)~ ymd(Date)))

data <- data %>% 
  mutate(Year = year(Date))

tail(data$Year)

class(data$Date)

length(which(is.na(data$Date)))

# Write result to file 

write.csv2(data,"data/policekillings202010.csv")

# Exercise 2.3

data %>% 
  ggplot(aes(x=Age))+geom_bar(aes(fill=Gender))

data %>% 
  ggplot(aes(x=Race))+geom_bar(aes(fill=State))

data %>% 
  ggplot(aes(x=Race,y=Age))+geom_boxplot(aes(fill=Gender))
