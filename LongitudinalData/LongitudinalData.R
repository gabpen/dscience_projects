## Longitudinal Data Analysis

# Load required libraries
library(nlme)
library(ggplot2)
library(dplyr)

# Load the Orthodont dataset
data("Orthodont")

# Preview the dataset
head(Orthodont)

## Exploratory Analysis

# Plot individual growth profiles by subject and sex
ggplot(Orthodont, aes(x = age, y = distance, color = Sex)) +
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_wrap(~Subject) +
  labs(title = "Individual Craniofacial Growth Profiles by Subject and Gender",
       x = "Age", y = "Distance (mm)") +
  theme_minimal()

# Overlay growth trajectories by sex
ggplot(Orthodont, aes(x = age, y = distance, group = Subject, color = Sex)) +
  geom_line() + 
  labs(title = "Overlaid Craniofacial Growth Trajectories by Gender",
       x = "Age", y = "Distance (mm)") +
  theme_minimal()

## Model Estimation

# Model 1: Random intercept only
model1 <- lme(distance ~ age, random = ~ 1 | Subject, data = Orthodont)
summary(model1)

# Model 2: Random intercept and slope
model2 <- lme(distance ~ age, random = ~ age | Subject, data = Orthodont)
summary(model2)

## Gender-Specific Models

# Subset the dataset by sex
Orthodont_male <- Orthodont %>% filter(Sex == "Male")
Orthodont_female <- Orthodont %>% filter(Sex == "Female")

# Estimate model for males
model_male <- lme(distance ~ age, random = ~ age | Subject, data = Orthodont_male)
summary(model_male)

# Estimate model for females
model_female <- lme(distance ~ age, random = ~ age | Subject, data = Orthodont_female)
summary(model_female)

