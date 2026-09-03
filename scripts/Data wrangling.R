# Merging Sample Metadata with Sequencing Analysis

# Importing relevant excel sheets into R

library(readxl)

Sample_metadata_Kleb <- read_excel("C:/Users/sulsowe/Documents/WORKINGS/R DOCUMENTATIONS/KLEBSIELLA DIVERSITY PROJECT/data/Sample_matadata_Kleb.xlsx")

Kleb_Sequencing_Analysis_Data <- read_excel("C:/Users/sulsowe/Documents/WORKINGS/R DOCUMENTATIONS/KLEBSIELLA DIVERSITY PROJECT/data/Kleb_Sequencing_Analysis_Data.xlsx")


library(dplyr)

KDProject <- right_join(Sample_metadata_Kleb, Kleb_Sequencing_Analysis_Data, by = "Barcode")
             
# TROUBLESHOOTING ---Because of failed attempt Merging above


class(Sample_metadata_Kleb$Barcode)
class(Kleb_Sequencing_Analysis_Data$Barcode)

df_x <- Sample_metadata_Kleb %>%
  mutate(Barcode = trimws(Barcode))

df_y <- Kleb_Sequencing_Analysis_Data %>%
  mutate(Barcode = trimws(Barcode))

df_x$Barcode <- gsub("[[:space:]]+", "", df_x$Barcode) 
df_y$Barcode <- gsub("[[:space:]]+", "", df_y$Barcode) 

setdiff(df_y$Barcode, df_x$Barcode) # This shows what exist in y but not x 
setdiff(df_x$Barcode, df_y$Barcode) # and vice versa; Problem spotted from here Alhamdulilaah....

# ACTUAL FULL CLEANING AND MERGE

df_x <- df_x %>%
  mutate(Barcode = gsub("^barcode", "", Barcode),
         Barcode = trimws(Barcode),
         Barcode = sprintf("%02d", as.numeric(Barcode))) # Removes "barcode" prefix in df_x

df_y <- df_y %>%
  mutate(Barcode = sprintf("%02d", as.numeric(Barcode)))

Kleb_Diversity_Project_Merged3 <- df_x %>% right_join(df_y, by = "Barcode")  # ---Merge step after resolving error


# Export to excel 
library(writexl)  

write_xlsx(Kleb_Diversity_Project_Merged3, "Kleb_Diversity_Project_Merged3.xlsx") 
