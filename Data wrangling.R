# Sample Details with Analysis Merging

# Importing relevant excel sheets into R

library(readxl)
Sampledata_Kleb <- read_excel("C:/Users/sulsowe/Documents/WORKINGS/KLEBSIELLA DIVERSITY PROJECT/Sampledata_Kleb.xlsx")



Kleb_Analysis_Data <- read_excel("C:/Users/sulsowe/Documents/WORKINGS/KLEBSIELLA DIVERSITY PROJECT/Kleb_Analysis_Data.xlsx")



library(dplyr)
library(writexl)
KDProject <- right_join(Sampledata_Kleb, Kleb_Analysis_Data, by = "Barcode")
library(writexl)
write_xlsx(Kleb_Diversity_Project_Merged3, "Kleb_Diversity_Project_Merged3.xlsx")
View(Kleb_Diversity_Project_Merged)

# TROUBLESHOOTING

class(df_x$Barcode)
class(df_y$Barcode)

KDPP <- df_x %>%                       # Another way of merging datasets on right_join
  right_join(df_y, by = "Barcode")

class(Sampledata_Kleb$Barcode)
class(Kleb_Analysis_Data$Barcode)

df_x <- Sampledata_Kleb %>%
  mutate(Barcode = trimws(Barcode))

df_y <- Kleb_Analysis_Data %>%
  mutate(Barcode = trimws(Barcode))

df_x$Barcode <- gsub("[[:space:]]+", "", df_x$Barcode) 
df_y$Barcode <- gsub("[[:space:]]+", "", df_y$Barcode) 

setdiff(df_y$Barcode, df_x$Barcode) # This shows what exist in y but not x 
setdiff(df_x$Barcode, df_y$Barcode) # and vice versa; Problem spotted from here Alhamdulilaah....

# FULL CLEANING AND MERGE

df_x <- df_x %>%
  mutate(Barcode = gsub("^barcode", "", Barcode),
         Barcode = trimws(Barcode),
         Barcode = sprintf("%02d", as.numeric(Barcode))) # Removes "barcode" prefix in df_x

df_y <- df_y %>%
  mutate(Barcode = sprintf("%02d", as.numeric(Barcode)))

KDProject<- df_x %>% right_join(df_y, by = "Barcode")

#
# Export to excel 
library(writexl)  

write_xlsx(KDProject, "KDProject_data.xlsx") 
