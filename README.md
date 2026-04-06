# Student Performance Factors - Statistical Analysis in R

## Overview
This project explores the factors influencing student academic performance using a dataset sourced from Kaggle. The goal is to identify key variables that impact exam score and demonstrate applied statistical analysis skills in R. This project was completed as a first data analysis portfolio piece and demonstrates core statistical techniques: data exploration and visualisation, regression, one-way and two-way ANOVA, bootstrap methods and hypothesis testing.

---

## Dataset
- **Source:** [Student Performance Factors](https://www.kaggle.com/datasets/lainguyn123/student-performance-factors) via Kaggle
- **File:** `StudentPerformanceFactors.csv`
- **Observations:** 6 607 students
- **Variables:** 20 (numeric and categorical)
  
| Variable | Type | Description |
|:---------|:-----|:------------|
| `Exam_Score` | Numeric | Final exam score (independent variable) |
| `Hours_Studied` | Numeric | Weekly hours studied |
| `Attendance` | Numeric | Attendance percentage |
| `Previous_Scores` | Numeric | Prior academic performance |
| `Sleep_Hours` | Numeric | Sessions attended per month |
| `Physical_Activity` | Numeric | Weekly hours of physical activity|
| `Motivation_Level` | Ordered factor | Low / Medium / High |
| `Parental_Involvement` | Ordered factor | Low / Medium / High |
| `Access_to_Resources` | Ordered factor | Low / Medium / High |
| `Family_Income` | Ordered factor | Low / Medium / High |
| `Teacher_Quality` | Ordered factor | Low / Medium / High |
| `Parental_Education_Level` | Ordered factor | High School / College / Postgraduate |
| `Distance_from_Home` | Ordered factor | Near / Moderate / Far |
| `School_Type` | Factor | Yes / No |
| `Peer_Influence` | Factor | Yes / No |
| `Internet_Access` | Factor | Yes / No |
| `Extracurricular_Activities` | Factor | Yes / No |
| `Learning_Disabilities` | Factor | Yes / No |
| `Gender` | Factor | Male / Female |

---

## Missing Data

The dataset originally contained 6,607 observations, of which 229 (approximately 3.5%) included at least one missing value. A complete-case analysis was used, removing these rows prior to analysis. This approach was preferred over imputation to avoid introducing bias from model-based estimates. Since over 96% of the data was retained, the impact on statistical power and representativeness was considered minimal, and all analyses are performed on a consistent set of 6 378 observations.

---

## Project Structure
```
Student-Performance-Analysis/
├── data/           # Raw dataset
├── outputs/        # Charts, reports, and model results
├── scripts/        # Data processing and analysis script
├── .gitignore
├── README.md
└── Student-Performance-Analysis.Rproj
```

---

## Analysis Overview
# 1. Data Exploration & Cleaning
  - Inspects data structure and summary statistics using `head()`, `str()`, and `summary()`
  - Converts categorical variables to ordered and unordered factors to preserve rank formation in models and plots
  - Porgrammatically checks the proportion of missing values and removes incomplete rows if missingness is below 5%
  
# 2. Data Visualisation
  - Histogram of `Exam_Score` with a mean reference line
  - Pearson correlation heatmap of all numeric variables
  - Scatter plots of `Hours_Studied` and `Attendance` vs. `Exam_Score` using `facte_wrap()`
  - Grouped box plots of `Exam_Score` by `Motivation_Level` and `School_Type`
  - Grouped bar chart of mean `Exam_Score` by `Family_Income` and `Parental_Involvement`
  
# 3. Multiple Linear Regression
  - Full model regressing `Exam_Score` on all variables
  - R^2 and adjusted R^2 extracted to evaluate model fit
  - Residual plot to check model assumptions
  - Train/test split with MSE evaluation - in progress
  
# 4. ANOVA - in progress
  - One-Way ANOVA
  - Two-Way ANOVA - tests the main effects of `School_Type` and `Teacher_Quality` and their interaction on `Exam_Score`, including a table of means, effects, and an interaction plot
  
# 5. Bootstrapping - in progress

---

## Requirements
**R version:** 4.1 or later
**Packages:**
```r
install.packages("tidyverse")
```

| Package | Purpose |
|:--------|:--------|
| `tidyverse` | Data wrangling and ggplot2 visualisations |

All statistical procedures (regression, ANOVA, bootstrapping) use base R only.

---

## Usage
1. Clone the repository and set it as your working directory in R.
2. Ensure `StudentPerformanceFactors.csv` is in the same folder as the script.
3. Install the required packages (see above) if not already installed.
4. Run the script:
```r
source("student_performance_analysis.R")
```
Or open `student_performance_analysis.R` in RStudio and run it section by section.

---

## Key Findings
*To be updated upon completion of all sections


