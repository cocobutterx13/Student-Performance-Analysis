# Student Performance Factors - Statistical Analysis in R

## Overview
This project explores the factors influencing student academic performance using a dataset sourced from Kaggle. The goal is to identify key variables that impact exam score and demonstrate applied statistical analysis skills in R. This project was completed as a first data analysis portfolio piece and demonstrates core statistical techniques: data exploration and visualisation, regression, one-way and two-way ANOVA, bootstrap methods and hypothesis testing.

---

## Tools Used
- **R**
- **tidyverse** (dplyr, tidyr, ggplot2)

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


