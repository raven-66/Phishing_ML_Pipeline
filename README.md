# Phishing URL Detection – ML Pipeline

## Overview
This project builds an end-to-end machine learning pipeline to detect phishing URLs using Random Forest and Isolation Forest. The pipeline uses modern data tools: Snowflake for storage, dbt for transformations and Databricks for ML training and evaluation.

## Architecture
- **Snowflake**: Data warehouse – stores raw and transformed data
- **dbt**: Data transformations – cleans and prepares features
- **Databricks**: ML platform – trains and evaluates models
- **MLflow**: Experiment tracking – logs parameters and metrics
- **Slack**: Automatic reporting of model results
- **GitHub**: Version control and portfolio

## Dataset
- **Source**: Kaggle – Phishing URL Features Dataset
- **Samples**: 579,920 URLs
- **Features**: 74 pre-calculated features
- **Label**: 1 = phishing, 0 = legitimate

## Models
| Model | Accuracy | Precision | Recall | F1-score |
|-------|----------|-----------|--------|----------|
| Random Forest | 98.52% | 99.09% | 97.32% | 98.20% |
| Isolation Forest | 63.82% | - | - | - |
| Pipeline (IF → RF) | 98.81% | 99.22% | 99.10% | 99.16% |

## Key Results
- The **pipeline (Isolation Forest → Random Forest)** improved accuracy by 0.29% compared to Random Forest alone.
- Isolation Forest concentrated phishing from 40.32% to 70.66% among suspicious URLs.
- No significant overfitting detected (training vs test difference: 1.53% for Random Forest, 1.20% for Pipeline).

## Files
- `notebooks/phishing_ml_pipeline_final.ipynb` – Full Databricks notebook
- `dbt_models/` – dbt transformation models
- `images/` – Visualizations and screenshots

## How to Run
1. Set up Snowflake and load the dataset
2. Run dbt models to transform data
3. Connect Databricks to Snowflake
4. Run the notebook cells in order

## Tech Stack
- Python (Pandas, Scikit-learn, Matplotlib, Seaborn)
- Snowflake (Data Warehouse)
- dbt (Data Transformations)
- Databricks (ML Platform)
- MLflow (Experiment Tracking)
- Slack (Reporting)

## Author
Fanny Graven