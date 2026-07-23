# Milling machine reliability data analysis

Repository for analysis of AI4I Predictive Maintenance dataset (Kaggle) to model milling machine failures.

## 🗃️ Repository structure



## 🎯 Business Context & Problem Framing

- Core Issue: after increasing their portfolio of products to supply new clients, a milling shop is struggling with frequent tool replacements.

- The Impact: despite the increase in revenue after the portfolio expansion, their backlog accumulated too many work orders and the costs with maintenance increased exponentially, undermining their potential profits.

- Proposed Solution: in order to reduce the maintenance costs, the milling shop engineering staff proposed the implementation of a Predictive Maintenance (PdM) program that should start by leveraging simple failure data on one of their CNC machines (named CNC01).

- The Goal: in this first step, the primary objective is to characterize the reliability behavior of CNC01 through key indicators such as **failure rate**, **MTBF (Mean Time Between Failures)**, and **failure distribution**, providing initial insights into operational issues associated with the recent expansion of production. As a secondary objective, the analysis investigates whether **process variables** exhibit distinct statistical behavior under failure and non-failure conditions, using these differences as a starting point for identifying relevant parameters for equipment integrity assessment in subsequent stages of the project.

- The Methodology: the engineering staff listed the most common failure modes detected on their CNC machines and also listed the main parameters related to each failure mode that should be monitored in their PdM program: temperature sensors to measure air and process temperatures, a tachometer measuring the rotational speed of the engine's axis and a torque sensor connected to the spindle drive system. Without a simple alternative for measuring the tool wear, they decided to classify the machined products in three qualities and attribute a wear time to each quality. Whenever an unplanned shutdown occurs, the maintenance team investigates the event and classifies it according to the predefined failure modes. The resulting failure records are then consolidated into the dataset for further analysis.

- The challenge: with the collected data, the Industrial Data Scientist should perform a reliability study of the machine obtaining the desired indicators and creating useful visualizations to help the decision making of the engineering staff on the next steps of the PdM program.

## 🎯 Key Results

✔ MTBF estimated:

✔ Failure distributions analyzed:

✔ Operating envelopes identified:

✔ Candidate predictive features selected:

## 💻 Data Analysis Framework & Architecture

(1) All the data collected by the engineering staff was organized in their local PostgreSQL server and named as 'milling_shop_db'

(2) The database connection was stablished using DBeaver as the management tool and SQL development environment

(3) Preliminary information about the database such as schema organization, name of the collumns and data types were investigated with the help of DBeaver interface and the findings were organized in the '🗂️ Column data types, sizes and constraints' session

(4) Data inconsistencies such as duplicates, nulls and invalid values were investigated using the SQL code written in the script '01_quality_analysis'

(5) Basic statistical metrics were evaluated for both categorical and numerical features using the SQL code written in the scripts '02_statistical_profiling_categorical' and '03_statistical_profiling_numerical'

(6) Preliminary investigation of relevant aggregations was done using the SQL queries written in the script '04_analysis_of_aggregations', some other auxiliary scripts can be found at '/sql' folder

(7) Further investigation of the statistical behaviour of the data using visualization tools (boxplots, histograms and scatter plots) was performed using Python libraries such as Pandas, Matplolib and Seaborn and the code was organized in the jupyter notebook '01_exploration_and_profiling'. The key findings from data quality checks and basic profiling done in the previous steps were documented in the same jupyter notebook.

(9) All information extracted in the previous stages was used to update the collumn dictionary presented in the '📖 Column Dictionary' session

(10) Process variables analysis was performed in order to find potential trigger values for predicting failure modes.

(11*) Um estudo básico de confiabilidade das ferramentas foi realizado a fim de otimizar o plano de inspeção preventiva já implementado pela empresa.

(12*) Gerar uma síntese visual dos principais resultados em um dashboard (PowerBI / Looker)

[TO-DO: ao final da escrita desta sessão resumir as etapas em um fluxograma e anexar]
[TO-DO: colocar links nas referências aos arquivos]

## 🗂️ Column data types, sizes and constraints

| Column | Data Type | Size (bytes) | Constraint
| --- | --- | --- | --- |
| register_id | SERIAL | 4 | PK |
| product_id | VARCHAR(6) | 6 | DISTINCT |
| product_type | CHAR | 1 | Either 'L', 'M' or 'H' |
| air_temperature_kelvin | REAL | 4 | - |
| process_temperature_kelvin | REAL | 4 | - |
| rotational_speed | REAL | 4 | - |
| torque_nm | REAL | 4 | - | - |
| tool_wear_min | SMALLINT | 2 | - |
| machine_failure | BOOL | 1 | - |
| tool_wear_failure | BOOL | 1 | - |
| heat_dissipation_failure | BOOL | 1 | - |
| power_failure | BOOL | 1 | - |
| overstrain_failure | BOOL | 1 | - |
| random_failure | BOOL | 1 | - |

## 📖 Column Dictionary

1. 'register_id': primary key that identifies each data aquisition point, i.e. each milling operation (SERIAL).

2. 'product_id': unique code that identifies which product was being processed at that cycle. It's a unique 6 characters string that starts with L/M/H indicating the product quality and ends with a 5 digit integer.

3. 'product_type': character that relates to the product quality.

    - 'L' which stands for low quality products that adds 2 minutes of wear time;
    - 'M' which stands for medium quality products that adds 3 minutes of wear time;
    - 'H' which stands for high quality products that adds 5 minutes of wear time.
 
3. 'air_temperature_kelvin': mean measured room temperature measured during each milling operation in Kelvin.

4. 'process_temperature_kelvin': mean measured tool temperature measured during each milling operation in Kelvin.

5. 'rotational_speed_rpm': mean tool rotational speed measured at the machine's engine axis during each milling operation in rotations per minute.

6. 'torque_nm': mean torque measured at the machine's spindle drive system during each milling operation in N.m.

7. 'tool_wear_min': accumulated wear indicator in minutes, refer to product qualities to know how much wear time each product adds to the tool.

8. 'machine_failure': equals TRUE when machine's global failure was detected, i.e. a failure caused an unplanned shutdown and maintenance activities where performed as well as a root cause analysis for classifying the failure into the predetermined list of most common failure modes.

9. 'tool_wear_failure': indicates if the failure cause was due to tool wear.

10. 'heat_dissipation_failure': indicates if the failure cause was heat dissipation.

11. 'power_failure': indicates if the failure cause was over power.

12. 'overstrain_failure': indicates if the failure cause was overstrain.

13. 'random_failure': indicates if the failure cause was unknown or can be related to a local failure that didn't cause a shutdown.

## 🧭 Exploratory Data Analysis key findings

## 🌡️ Process variables as predictors for failure

## ⚙️ Reliabillity indicators

## 📝 Recomendations & Future Implementations




