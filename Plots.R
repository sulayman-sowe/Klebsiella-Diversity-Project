# PLOTS 


# Overall Species Distribution

library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)

library(readxl)
Kleb_Diversity_Project_Merged <- read_excel("WORKINGS/KLEBSIELLA DIVERSITY PROJECT/Kleb_Diversity_Project_Merged.xlsx")
View(Kleb_Diversity_Project_Merged)

ggplot(KDProject, aes(x = Species)) +
  geom_bar() +
  coord_flip() +
  labs(
    title = "Overall Species Distribution",
    x = "Species",
    y = "Number of Isolates"
  ) +
  theme_minimal(base_size = 14)


# Species Distribution per patient

ggplot(KDProject, aes(x = Species)) +
  geom_bar() +
  facet_wrap(~ Sample_IDs, scales = "free_y") +
  coord_flip() +
  labs(
    title = "Species Distribution per Patient",
    x = "species",
    y = "Count"
  ) +
  theme_minimal(base_size = 4)


# ST Distribution per patient (kleb only)

kleb <- KDProject %>% 
  filter(grepl("Klebsiella pneumoniae", Species, ignore.case = TRUE))

ggplot(kleb, aes(x = ST)) +
  geom_bar() +
  facet_wrap(~ Sample_IDs, scales = "free_y") +
  labs(
    title = "ST Distribution per Patient (Klebsiella Only)",
    x = "Sequence Type (ST)",
    y = "Count"
  ) +
  theme_minimal(base_size = 8)

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

KDProject <- KDProject %>%
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
KDProject$Patient <- factor(
  KDProject$Patient,
  levels = c("Baby", "Care Giver", "Environmental", "Invasive")
)

# Plot: Species Distribution by Patient Type
ggplot(KDProject, aes(x = Species, fill = Patient)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Species Distribution by Patient Type",
    x = "Species",
    y = "Count",
    fill = "Patient Type"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

#  Replace NA Sample_ID with “CG282RVD0-2”

KDProject <- KDProject %>%
  mutate(
    Sample_ID = ifelse(is.na(Sample_ID), "CG282RVD0-2", Sample_ID)
  ) 

