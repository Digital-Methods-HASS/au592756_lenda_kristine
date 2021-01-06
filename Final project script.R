#Script for Final Project, "The monarchy and danish stability"

#I start by creating four folders for my directory in RStudio
dir.create("scripts") 
dir.create("data") 
dir.create("figures") 
dir.create("Data_output")
#for my script, my data set and my figures.

#I open the preinstalled packages needed
library(tidyverse)
library(readxl)
library(janitor)

#I manually uploaded my spreadsheet "Monarchs_spreadsheet.xlsx" to RStudio through "Import Dataset" and "From Excel".
dataset <- read_excel(NULL, range = "A1:F57", 
                      na = "NULL")

#I inspect the data.
View(Monarchs_spreadsheet_xlsx)

#Found issue with empty columns. I decide to open spreadsheet "Monarchs_spreadsheet.xlsx" into OpenRefine.
#Created a new project.
#I edit cells "Year_of_Birth", "Year_of_Death", "Instated_on_Throne", "Number_of_Years_on_Throne" and "Years_Alive" using "Common transforms" and "To Number" to make the data numerical.
#I use "Facet" and "Numeric facet" and find the three blank lines. Under "All" and "Edit Rows" choose "Remove matching rows". Blank lines removed from spreadsheet.

#Exported file from OpenRefine
#Re-uploading spreadsheet manually to RStudio.
monarchs_spreadsheet<-read.csv("Data_output/spreadsheet.csv")

#I inspect the spreadsheet

View(monarchs_spreadsheet)

#Issues with empty columns resolved.

#I extract the columns "Year_of_Birth", "Year of Death", "Instated_on_Throne" and "Number_of_Years_on_Trone", "Years_Alive" and "Name_of_Monarch" from the data set frame.
#I also want to make sure, the needed columns are numerical.

Name_of_Monarch<-monarchs_spreadsheet[,1]
class(Name_of_Monarch) #Column will remain "character"

Year_of_Birth<-monarchs_spreadsheet[,2]
class(Year_of_Birth)
Year_of_Birth<-as.numeric(Year_of_Birth) #Column is now "numeric"

Year_of_Death<-monarchs_spreadsheet[,3]
class(Year_of_Death)
Year_of_Death<-as.numeric(Year_of_Death) #Column is now "numeric"

Instated_on_Throne<-monarchs_spreadsheet[,4]
class(Instated_on_Throne)
Instated_on_Throne<-as.numeric(Instated_on_Throne) #Column is now "numeric"

Number_of_years_on_throne<-monarchs_spreadsheet[,5]
class(Number_of_years_on_throne)
Number_of_years_on_throne<-as.numeric(Number_of_years_on_throne) #Column is now "numeric"

Years_alive<-monarchs_spreadsheet[,6]
class(Years_alive)
Years_alive<-as.numeric(Years_alive) #Column is now "numeric"

#As I otherwise created and cleaned my spreadsheet manually in Excel, I can now begin to create jitter plots.

monarchs_spreadsheet %>% 
  ggplot(aes(x=Year_of_Birth,y=Number_of_years_on_throne))+
  geom_jitter(aes(color=Years_alive))

#First plot has "Year_of_Birth" on x-axis and "Number_of_years_on_throne" on y-axis. The aes indicate "Years_alive".

monarchs_spreadsheet %>% 
  ggplot(aes(x=Number_of_years_on_throne,y=Instated_on_Throne))+
  geom_jitter(aes(color=Name_of_Monarch))

#Second plot has "Number_of_years_on_throne" on x-axis and "Instated_on_Throne" on y-axis. The aes indicate "Name_of_Monarch".

monarchs_spreadsheet %>% 
  ggplot(aes(x=Number_of_years_on_throne,y=Name_of_Monarch))+
  geom_jitter(aes(color=Years_alive))

#Third plot has "Number_of_years_on_throne" on x-axis and "Name_of_monarch" on y-axis. The aes indicate "Years_alive".

#I have now produced three plots, which will help determine the results of my thesis. 