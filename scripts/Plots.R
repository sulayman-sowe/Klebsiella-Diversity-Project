# Importing relevant dataset into R

library(readxl)

KDProject_Final_Data <- read_excel("C:/Users/sulsowe/Documents/WORKINGS/R DOCUMENTATIONS/KLEBSIELLA DIVERSITY PROJECT/data/KDProject_Final_Data.xlsx")


# FIGURES

# 1. Overall Species Distribution

library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)


ggplot(KDProject_Final_Data, aes(x = Species)) +
  geom_bar() +
  labs(
    x = "Species",
    y = "Number of Isolates"
  ) +
  theme_minimal(base_size = 14)

ggsave("overall_species_distribution.png", width = 10, height = 7)



# 2. Species Distribution per patient

ggplot(KDProject_Final_Data, aes(x = Species)) +
  geom_bar() +
  facet_wrap(~ Sample_ID, scales = "free_y") +
  coord_flip() +
  labs(
    x = "species",
    y = "Count"
  ) +
  theme_minimal(base_size = 8)

ggplot(Kleb__Final_Analysis_Data, aes(x = Species)) +
  geom_bar() +
  # FIX: Changed free_y to free_x so individual panels drop absent species
  facet_wrap(~ Sample_ID, scales = "free_x") + 
  coord_flip() +
  labs(
    title = "Species Distribution per Patient", # FIX: Added the missing title
    x = "species",
    y = "Count"
  ) +
  theme_minimal(base_size = 8)

ggsave("Species distribution per patient.png", height = 7, width = 10)



# 3. ST Distribution per patient (kleb only)

kleb <- KDProject_Final_Data%>% 
  filter(grepl("K. pneumoniae", Species, ignore.case = TRUE))

ggplot(kleb, aes(x = ST)) +
  geom_bar() +
  facet_wrap(~ Sample_ID, scales = "free_y") +
  labs(
    title = "ST Distribution per Patient (Klebsiella Only)",
    x = "Sequence Type (ST)",
    y = "Count"
  ) +
  theme_minimal(base_size = 8)

ggsave("Species distribution per patient.png", height = 7, width = 10)


# ST Distribution per Patient

def <- KDProject %>% 
  filter(ST != "Undefined")

ggplot(def, aes(x = ST)) +
  geom_bar() +
  facet_wrap(~ Sample_IDs, scales = "free_y") +
  labs(
    title = "ST Distribution per Patient",
    x = "Sequence Type (ST)",
    y = "Count"
  ) +
  theme_minimal(base_size = 4)

# Create "Patient" Column Based on Sample_ID Rules 

library(dplyr)
library(stringr)

Kleb__Final_Analysis_Data <- Kleb__Final_Analysis_Data %>%
  mutate(
    Patient = case_when(
      # Environmental samples (exact matches)
      Sample_ID %in% c("13", "16") ~ "Environmental",
      
      # Invasive sample (exact match)
      Sample_ID == "5045/18" ~ "Invasive",
      
      # Baby samples (begin with "N")
      str_starts(Sample_ID, "N") ~ "Baby",
      
      # Caregiver samples (begin with "CG")
      str_starts(Sample_ID, "CG") ~ "Care Giver",
    )
  )


# Species Distribution by Patient Type

library(ggplot2)
library(dplyr)

# Ensure Patient is a factor for consistent ordering
Kleb__Final_Analysis_Data$Patient <- factor(
  KDProject$Patient,
  levels = c("Baby", "Care Giver", "Environmental", "Invasive")
)

# Plot: Species Distribution by Patient Type

ggplot(Kleb__Final_Analysis_Data, aes(x = Species, fill = Patient)) +
  geom_bar(position = "dodge") +
  labs(
    x = "Species",
    y = "Count",
    fill = "Patient Type"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 0.5)
  )

ggsave("Species Distribution by Patient Type.png", height = 7, width = 12)

#  Replace NA Sample_ID with “CG282RVD0-2”

KDProject <- KDProject %>%
  mutate(
    Sample_ID = ifelse(is.na(Sample_ID), "CG282RVD0-2", Sample_ID)
  ) 

