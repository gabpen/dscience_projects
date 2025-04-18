## Survival Analysis

### Step 1: Exploratory Analysis

# Load required libraries
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(survival)
library(survminer)
library(dplyr)

# Load dataset
# getwd()
# setwd("your/path/here")  # Set your working directory if needed
rossi <- read.table("Rossi.txt", header = TRUE)

# Convert categorical variables to factors
str(rossi)
rossi <- rossi %>%
  mutate(
    fin = factor(fin, levels = c("no", "yes")),
    race = factor(race),
    wexp = factor(wexp, levels = c("no", "yes")),
    mar = factor(mar, levels = c("not married", "married")),
    paro = factor(paro, levels = c("no", "yes")),
    educ = factor(educ)
  )

# Define a pastel color palette for plotting
pastel_palette <- c("#A3C4F3", "#F3A3B5", "#A3F3CB", "#F3E6A3", "#D4A3F3", "#A3F3F3")

# Create a dictionary for translating variable names
nombre_vars <- c(
  fin = "Financial aid",
  race = "Race",
  wexp = "Work experience",
  mar = "Marital status",
  paro = "Parole",
  educ = "Education level"
)

# Reshape the data to long format
vars_cat <- c("fin", "race", "wexp", "mar", "paro", "educ")

rossi_long <- rossi %>%
  pivot_longer(cols = all_of(vars_cat), names_to = "variable", values_to = "value")

# Boxplots: Time to recidivism by each categorical variable
ggplot(rossi_long, aes(x = value, y = week, fill = value)) +
  geom_boxplot(outlier.colour = "black", outlier.shape = 16, outlier.size = 1.5, color = "black") +
  facet_wrap(~ variable, scales = "free_x", labeller = labeller(variable = nombre_vars)) +
  scale_fill_brewer(palette = "Pastel1") +
  theme_minimal(base_size = 13) +
  labs(title = "Time to Recidivism by Individual Characteristics",
       x = "", y = "Weeks") +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold", size = 12))

# Summary statistics (per group)
for (var in vars_cat) {
  cat("\n\n==========", var, "==========\n")
  print(
    rossi %>%
      group_by(.data[[var]]) %>%
      summarise(
        n = n(),
        min = min(week, na.rm = TRUE),
        q1 = quantile(week, 0.25, na.rm = TRUE),
        median = median(week, na.rm = TRUE),
        q3 = quantile(week, 0.75, na.rm = TRUE),
        max = max(week, na.rm = TRUE),
        mean = mean(week, na.rm = TRUE),
        sd = sd(week, na.rm = TRUE)
      )
  )
}

# Scatterplot: prior convictions vs. time to recidivism
ggplot(rossi, aes(x = prio, y = week)) +
  geom_point(color = "#F3A3B5", size = 2, alpha = 0.6) +
  geom_smooth(method = "loess", color = "#A3C4F3", fill = "#A3C4F3", alpha = 0.3, se = TRUE) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Relationship between Prior Convictions and Time to Recidivism",
    x = "Number of Prior Convictions",
    y = "Weeks until Recidivism"
  )

# Scatterplot: colored by financial aid
ggplot(rossi, aes(x = prio, y = week, color = fin)) +
  geom_point(size = 2, alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, size = 1.2, alpha = 0.4) +
  scale_color_manual(values = c("#A3C4F3", "#F3A3B5")) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Recidivism by Prior Convictions and Financial Aid",
    x = "Number of Prior Convictions",
    y = "Weeks until Recidivism",
    color = "Financial aid"
  )

# Scatterplot by marital status
ggplot(rossi, aes(x = prio, y = week)) +
  geom_point(color = "#A3F3CB", alpha = 0.6, size = 2) +
  geom_smooth(method = "loess", color = "#D4A3F3", fill = "#D4A3F3", alpha = 0.3) +
  facet_wrap(~ mar) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Recidivism by Prior Convictions and Marital Status",
    x = "Number of Prior Convictions",
    y = "Weeks until Recidivism"
  )

# Scatterplot: Financial aid and marital status interaction
ggplot(rossi, aes(x = prio, y = week, color = fin)) +
  geom_point(size = 2, alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, size = 1, alpha = 0.5) +
  facet_wrap(~ mar) +
  scale_color_manual(values = c("#A3C4F3", "#F3A3B5")) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Recidivism, Financial Aid, and Marital Status",
    x = "Number of Prior Convictions",
    y = "Weeks until Recidivism",
    color = "Financial aid"
  ) +
  theme(
    strip.text = element_text(face = "bold", size = 13),
    legend.position = "bottom"
  )

## Step 2: Log-rank Test, Kaplan-Meier Curves, and Complementary Log-Log Plots

# Create a survival object
surv_obj <- Surv(rossi$week, rossi$arrest)

# Run log-rank tests
logrank_tests <- list(
  race = survdiff(surv_obj ~ race, data = rossi),
  mar = survdiff(surv_obj ~ mar, data = rossi),
  fin = survdiff(surv_obj ~ fin, data = rossi),
  paro = survdiff(surv_obj ~ paro, data = rossi),
  educ = survdiff(surv_obj ~ educ, data = rossi),
  wexp = survdiff(surv_obj ~ wexp, data = rossi)
)

# Extract p-values
sapply(logrank_tests, function(x) 1 - pchisq(x$chisq, length(x$n) - 1))

# Estimate Kaplan-Meier survival curves
km_mar   <- survfit(surv_obj ~ mar, data = rossi)
km_fin   <- survfit(surv_obj ~ fin, data = rossi)
km_educ  <- survfit(surv_obj ~ educ, data = rossi)
km_wexp  <- survfit(surv_obj ~ wexp, data = rossi)

# Kaplan-Meier Survival Curves
km_plot_mar   <- ggsurvplot(km_mar, data = rossi, palette = "Set2", pval = TRUE, title = "Marital Status")
km_plot_fin   <- ggsurvplot(km_fin, data = rossi, palette = "Set2", pval = TRUE, title = "Financial Aid")
km_plot_educ  <- ggsurvplot(km_educ, data = rossi, palette = "Set2", pval = TRUE, title = "Education Level")
km_plot_wexp  <- ggsurvplot(km_wexp, data = rossi, palette = "Set2", pval = TRUE, title = "Work Experience")

# Display KM curves
arrange_ggsurvplots(
  list(km_plot_mar, km_plot_fin, km_plot_educ, km_plot_wexp),
  ncol = 2, nrow = 2
)

# Complementary Log-Log Curves
cloglog_plot_mar   <- ggsurvplot(km_mar, data = rossi, fun = "cloglog", pval = TRUE, palette = "Set2", title = "Marital Status")
cloglog_plot_fin   <- ggsurvplot(km_fin, data = rossi, fun = "cloglog", pval = TRUE, palette = "Set2", title = "Financial Aid")
cloglog_plot_educ  <- ggsurvplot(km_educ, data = rossi, fun = "cloglog", pval = TRUE, palette = "Set2", title = "Education Level")
cloglog_plot_wexp  <- ggsurvplot(km_wexp, data = rossi, fun = "cloglog", pval = TRUE, palette = "Set2", title = "Work Experience")

# Display cloglog plots
arrange_ggsurvplots(
  list(cloglog_plot_mar, cloglog_plot_fin, cloglog_plot_educ, cloglog_plot_wexp),
  ncol = 2, nrow = 2
)

### Step 3: Cox Proportional Hazards Model (Full)

# Fit Cox model with all predictors
cox_full <- coxph(surv_obj ~ fin + race + wexp + mar + paro + prio + educ, data = rossi)
summary(cox_full)

# Fit Cox model with only significant predictors
cox <- coxph(surv_obj ~ fin + prio, data = rossi)
summary(cox)

### Step 4: Proportional Hazards Assumption Check

# Check proportional hazards assumption
cox.zph(cox)
