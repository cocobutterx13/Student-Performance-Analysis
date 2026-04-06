# ==============================================================================
# Comprehensive Statistical Analysis on Student Performance Factors
# ==============================================================================
# Dataset: StudentPerformanceFactors.csv (6 607 observations, 20 variables)
# Author: Caylin Manuel
# Date: 2026-04-06

# This script demonstrates:
#   1. Data Exploration & Cleaning
#   2. Data Visualisation
#   3. Multiple Regression
#   4. One-Way & Two-Way ANOVA
#   5. Bootstrap Confidence Intervals 
# ==============================================================================


# ------------------------------------------------------------------------------
# 0. SETUP
# ------------------------------------------------------------------------------

install.packages("tidyverse")
library(tidyverse)
library(dplyr)
library(tidyr)
library(ggplot2)


# ------------------------------------------------------------------------------
# 1. DATA EXPLORATION & CLEANING
# ------------------------------------------------------------------------------

# Read the dataset
student_data <- read.csv("StudentPerformanceFactors.csv")

# Check data structure and summary statistics
head(student_data)
str(student_data)
summary(student_data)

# Convert columns to factors
# Ordered factors preserve rank formation in variables with natural ranking
student_data$Parental_Involvement <- factor(student_data$Parental_Involvement,
                                           levels = c("Low", "Medium", "High"), 
                                           ordered = TRUE)
student_data$Access_to_Resources <- factor(student_data$Access_to_Resources,
                                          levels = c("Low", "Medium", "High"), 
                                          ordered = TRUE)
student_data$Motivation_Level <- factor(student_data$Motivation_Level,
                                       levels = c("Low", "Medium", "High"), 
                                       ordered = TRUE)
student_data$Family_Income <- factor(student_data$Family_Income,
                                    levels = c("Low", "Medium", "High"), 
                                    ordered = TRUE)
student_data$Teacher_Quality <- factor(student_data$Teacher_Quality,
                                      levels = c("Low", "Medium", "High"), 
                                      ordered = TRUE)
student_data$Distance_from_Home <- factor(student_data$Distance_from_Home,
                                         levels = c("Near", "Moderate", "Far"), 
                                         ordered = TRUE)
student_data$Parental_Education_Level <- factor(student_data$Parental_Education_Level,
                                               levels = c("High School", "College", "Postgraduate"), 
                                               ordered = TRUE)

# Nominal (unordered) factors - no natural ranking between categories
student_data$Extracurricular_Activities <- as.factor(student_data$Extracurricular_Activities)
student_data$Internet_Access <- as.factor(student_data$Internet_Access)
student_data$School_Type <- as.factor(student_data$School_Type)
student_data$Peer_Influence <- as.factor(student_data$Peer_Influence)
student_data$Learning_Disabilities <- as.factor(student_data$Learning_Disabilities)
student_data$Gender <- as.factor(student_data$Gender)

# Check how much data will be lost when removing missing values
# and analyse where the missing values are
missing_col <- sum(!complete.cases(student_data))
cat("There are", missing_col, "rows with missing values.")
colSums(is.na(student_data))

missing_prop <- sum(!complete.cases(student_data))/nrow(student_data)
cat("Proportion of rows with missing values:",
    round(missing_prop * 100, 2), "%\n")

if (missing_prop < 0.05) {
  student_data <- student_data[complete.cases(student_data), ]
  cat("Removed rows with missing values.\n")
} else {
  cat("Missing data retained - consider imputation.\n")
}

# Quick snapshot of cleaned data
glimpse(student_data)
summary(student_data)

# ------------------------------------------------------------------------------
# 2. DATA VISUALISATION
# ------------------------------------------------------------------------------

# Goal: understand distribution, relationship and group differences
# before fitting any models.

### 2a. Distribution of the independent variable - Exam_Score ###

ggplot(student_data, aes(x = Exam_Score)) +
  geom_histogram(binwidth = 2, fill = "pink", colour = "white") +
  geom_vline(aes(xintercept = mean(Exam_Score)),
             colour = "green", linewidth = 1, linetype = "dashed") +
  labs(
    title = "Distribution of Exam Scores",
    subtitle = "Dashed line = mean score",
    x = "Exam Score",
    y = "Count"
  )


### 2b. Correlation heatmap of all numeric variables ###
# Pearson correlations give a first look at linear relationships.

num_cols <- select(student_data, where(is.numeric))

# Use "complete.obs" instead of "everything" to ignore rows with missing data
cor_matrix <- cor(num_cols, use = "complete.obs")

# Convert the matrix to a tidy long format: Var1, Var2, value
cor_long <- as.data.frame(cor_matrix)
cor_long <- rownames_to_column(cor_long, "Var1")
cor_long <- pivot_longer(cor_long, cols = -Var1, names_to = "Var2", values_to = "value")
cor_long <- filter(cor_long, as.integer(factor(Var1)) >= as.integer(factor(Var2)))

ggplot(cor_long, aes(x = Var2, y = Var1, fill = value)) +
  geom_tile(colour = "white") +
  geom_text(aes(label = round(value, 2)), size = 2.8) +
  scale_fill_gradient2(
    low      = "green",
    mid      = "orange",
    high     = "red",
    midpoint = 0,
    limits   = c(-1, 1),
    name     = "Pearson r"
  ) +
  labs(
    title = "Pearson Correlation",
    subtitle = "Numeric Values",
    x     = NULL,
    y     = NULL
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


### 2c. Scatter plots - continuous variables vs. Exam_Score ###

# Combine 2 of the continuous variables in a long data frame
scatter_data <- select(student_data, Hours_Studied, Attendance, Exam_Score)
scatter_data <- pivot_longer(scatter_data,
                             cols      = c(Hours_Studied, Attendance),
                             names_to  = "Predictor",
                             values_to = "Value")

# Rename predictors for readability
scatter_data$Predictor <- recode(scatter_data$Predictor,
                                 Hours_Studied = "Hours Studied per Week",
                                 Attendance = "Attendance (%)")

ggplot(scatter_data, aes(x = Value, y = Exam_Score)) +
  geom_point(alpha = 0.2, colour = "hotpink") +
  geom_smooth(method = "lm", colour = "green", se = TRUE) +
  facet_wrap(~ Predictor, scales = "free_x") +
  labs(
    title = "Continuous Variables vs. Exam Score",
    x = NULL,
    y = "Exam Score"
  )


### 2d. Motivation level & school type - grouped box plots ###

# Combine both grouping variables into one long data frame
box_data <- select(student_data, Motivation_Level, School_Type, Exam_Score)
box_data$Motivation_Level <- as.character(box_data$Motivation_Level)
box_data$School_Type      <- as.character(box_data$School_Type)
box_data <- pivot_longer(box_data,
                         cols      = c(Motivation_Level, School_Type),
                         names_to  = "Group_Var",
                         values_to = "Group_Val")

# Rename variables for readability
box_data$Group_Var <- recode(box_data$Group_Var,
                             Motivation_Level = "Motivation Level",
                             School_Type = "School Type")

ggplot(box_data, aes(x = Group_Val, y = Exam_Score, fill = Group_Val)) +
  geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
  facet_wrap(~ Group_Var, scales = "free_x") +
  labs(
    title = "Motivation Level and School Type vs. Exam Score",
    x = NULL,
    y = "Exam Score"
  )


### 2e. Bar chart

bar_data <- group_by(student_data, Family_Income, Parental_Involvement)
bar_data <- summarise(bar_data, Mean_Score = mean(Exam_Score), .groups = "drop")

ggplot(bar_data, aes(x = Parental_Involvement, y = Mean_Score, fill = Family_Income)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("pink", "green", "orange")) +
  labs(
    x = "Parental Involvement",
    y = "Mean Exam Score",
    fill = "Family Income"
  )


# ------------------------------------------------------------------------------
# 3. MULITPLE LINEAR REGRESSION
#------------------------------------------------------------------------------

# Create a regression model on all variables
model_full <- lm(Exam_Score ~ ., data = student_data)
summary(model_full)

# Extract exact values to check model performance
summary(model_full)$r.squared
summary(model_full)$adj.r.squared

# Residual Analysis
residuals <- resid(model_full)
fitted <- fitted(model_full)
plot(fitted, residuals)
abline(h = 0, col = "red")

########Incomplete

### 3b. Train/test split

#set.seed(123)

#train_index <- sample(1:nrow(student_data), 0.7 * nrow(student_data))
#train <- student_data[train_index, ]
#test  <- student_data[-train_index, ]

#model_train <- lm(Exam_Score ~ ..., data = train)

#pred <- predict(model_train, newdata = test)

#mean((test$Exam_Score - pred)^2)  # MSE


# ------------------------------------------------------------------------------
# 4. ANOVA
#------------------------------------------------------------------------------

### 4a. One-Way ANOVA ###

############INCOMPLETE

### 4b. Two-Way ANOVA ###

# Create an ANOVA model with interaction
school_model <- aov(Exam_Score ~ School_Type * Teacher_Quality,
                    data = student_data)

# Generate table of treatment means and treatment effects
model.tables(school_model, type = "means", se = TRUE)
model.tables(school_model, type = "effects", se = TRUE)

# Generate ANOVA table for hypothesis testing
summary(school_model)

# Combine School_Type and Teacher_Quality to generate an interaction plot
interact_data <- group_by(student_data, School_Type, Teacher_Quality)
interact_data <- summarise(interact_data, Mean_Score = mean(Exam_Score),
                           .groups = "drop")

ggplot(interact_data, aes(x = Teacher_Quality, y = Mean_Score,
                          fill = School_Type, group = School_Type)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  labs(
    title = "School Type x Teacher Quality",
    x = "Teacher Quality",
    y = "Mean Exam Score",
    fill = "School Type"
  )


# ------------------------------------------------------------------------------
# 5. BOOTSTRAPPING
#------------------------------------------------------------------------------

set.seed(42)
B <- 2000
n = nrow(student_data)

########INCOMPLETE

