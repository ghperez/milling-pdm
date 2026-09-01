# Milling Machine Failure Prediction

Repository for exploratory analysis of AI4I Predictive Maintenance dataset (Kaggle) and classification of failures.

## 🎯 Business Context & Problem Framing

- Core Issue: after increasing their portfolio of products to supply new clients, a milling shop is struggling with frequent tool replacements.

- The Impact: despite the increase in revenue after the portfolio expansion, their backlog accumulated too many work orders and the costs with maintenance increased exponentially, undermining their potential profits.

- Proposed Solution: in order to reduce the maintenance costs, the milling shop engineering staff proposed the implementation of a Predictive Maintenance (PdM) program that should start by leveraging simple failure data on one of their CNC machines (named CNC01).

- The Goal: in this first step, the primary objective is to investigate the correlation between **process variables** and failure conditions and develop a classification system to identify operations at higher risk of failure and support preventive inspection decisions.

- The Methodology: failure modes and relevant process variables were identified, including temperature, rotational speed, torque and tool wear. Unplanned shutdowns were investigated and classified according to the predefined failure modes.

- The challenge: with the collected failure data, the Industrial Data Scientist should perform an exploratory analysis and deploy a classification system that could predict machine failures.

## 🎯 Key Results

✔ Process variables failure thresholds identified:

✔ Candidate predictive features selected:

✔ Process operating regions associated with increased failure rates were identified.

✔ [X] variables were selected as candidate predictors for failure classification.

✔ The best-performing model achieved a recall of XX% on the test set.

✔ Model interpretation showed that [features] were the main contributors to failure predictions.

✔ A Streamlit dashboard was developed to simulate failure-risk assessment for individual operations.


## 🗂️ Dataset and data dictionary

| Column | Data Type | Constraint
| --- | --- | --- |
| register_id | SERIAL | PK |
| product_id | VARCHAR(6) | DISTINCT |
| product_type | CHAR | Either 'L', 'M' or 'H' |
| air_temperature_kelvin | REAL | - |
| process_temperature_kelvin | REAL | - |
| rotational_speed_rpm | REAL | - |
| torque_nm | REAL | - | - |
| tool_wear_min | SMALLINT | - |
| machine_failure | BOOL | - |
| tool_wear_failure | BOOL | - |
| heat_dissipation_failure | BOOL | - |
| power_failure | BOOL | - |
| overstrain_failure | BOOL | - |
| random_failure | BOOL | - |

**Data dictionary**:

1. 'register_id': primary key that identifies each data acquisition point, i.e. each milling operation (SERIAL).

2. 'product_id': unique code that identifies which product was being processed at that cycle. It's a unique 6 characters string that starts with L/M/H indicating the product quality and ends with a 5 digit integer.

3. 'product_type': character that relates to the product quality.

    - 'L' which stands for low quality products that adds 2 minutes of tool wear time;
    - 'M' which stands for medium quality products that adds 3 minutes of tool wear time;
    - 'H' which stands for high quality products that adds 5 minutes of tool wear time.
 
3. 'air_temperature_kelvin': mean measured room temperature measured during each milling operation in Kelvin.

4. 'process_temperature_kelvin': mean measured tool temperature measured during each milling operation in Kelvin.

5. 'rotational_speed_rpm': mean tool rotational speed measured at the machine's engine axis during each milling operation in rotations per minute.

6. 'torque_nm': mean torque measured at the machine's spindle drive system during each milling operation in N.m.

7. 'tool_wear_min': accumulated wear indicator in minutes, refer to product qualities to know how much wear time each product adds to the tool.

8. 'machine_failure': equals TRUE when machine's global failure was detected, i.e. a failure caused an unplanned shutdown and maintenance activities were performed as well as a root cause analysis for classifying the failure into the predetermined list of most common failure modes.

9. 'tool_wear_failure': indicates if the failure cause was due to tool wear.

10. 'heat_dissipation_failure': indicates if the failure cause was heat dissipation.

11. 'power_failure': indicates if the failure cause was power-related.

12. 'overstrain_failure': indicates if the failure cause was overstrain.

13. 'random_failure': indicates whether the observed machine failure was classified as a random failure according to the predefined failure-mode classification.

## 🧭 Exploratory Data Analysis key findings

## 🤖 Failure Classification

### Model comparison

| Model | Recall | Precision | ROC-AUC |
|---|---:|---:|---:|
| Logistic Regression | XX | XX | XX |
| Decision Tree | XX | XX | XX |
| Random Forest | XX | XX | XX |

### Model selection

The selected model was [MODEL] based primarily on its ability to detect failure conditions while maintaining an acceptable false-positive rate.

### Model interpretation

The main features associated with failure predictions were:

1. ...
2. ...
3. ...

Local explanations were also used to investigate why individual operations were classified as potential fa

## 📊 Streamlit Dashboard

## 📝 Recomendations & Future Implementations

- Establish an operational decision threshold based on the acceptable false-positive rate and the cost of preventive inspection.

- Integrate real-time sensor measurements into the prediction pipeline.

- Collect additional failure observations to improve model robustness.

- Monitor model performance after deployment to detect changes in machine operating conditions.

- Investigate whether individual failure modes can be predicted separately.

## 💻 Data Analysis Framework & Architecture

(1) All the data collected by the engineering staff was organized in their local PostgreSQL server and named as 'milling_shop_db'

(2) The database connection was established using DBeaver as the management tool and SQL development environment

(3) Preliminary information about the database such as schema organization, name of the columns and data types were investigated with the help of DBeaver interface and the findings were organized in the '🗂️ Column data types, sizes and constraints' session

(4) Data inconsistencies such as duplicates, nulls and invalid values were investigated using the SQL code written in the script '01_quality_analysis'

(5) Basic statistical metrics were evaluated for both categorical and numerical features using the SQL code written in the scripts '02_statistical_profiling_categorical' and '03_statistical_profiling_numerical'

(6) Preliminary investigation of relevant aggregations was done using the SQL queries written in the script '04_analysis_of_aggregations', some other auxiliary scripts can be found at '/sql' folder

(7) Further investigation of the statistical behaviour of the data using visualization tools (boxplots, histograms and scatter plots) was performed using Python libraries such as Pandas, Matplolib and Seaborn and the code was organized in the jupyter notebook '01_exploration_and_profiling'. The key findings from data quality checks and basic profiling done in the previous steps were documented in the same jupyter notebook.

(9) All information extracted in the previous stages was used to update the column dictionary presented in the '📖 Column Dictionary' session

(10) Process variables analysis was performed in order to find potential trigger values for predicting failure modes.

EDA -> TREINAMENTO DE UM ALGORITMO DE CLASSIFICAÇÃO -> DASHBOARD EM STREAMLIT -> APRESENTAÇÃO DE SLIDES

[TO-DO: ao final da escrita desta sessão resumir as etapas em um fluxograma e anexar]
[TO-DO: colocar links nas referências aos arquivos]



