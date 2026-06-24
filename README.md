# Milling machine reliability data analysis

Repository for analysis of AI4I Predictive Maintenance dataset (Kaggle) to model milling machine failures.

## 🎯 Business Context & Problem Framing

- Core Issue: after increasing their portfolio of products to supply new clients, a milling shop is struggling with frequent tool replacements.

- The Impact: despite the increase in revenue after the portfolio expansion, their backlog accumulated too many work orders and the costs with maintenance increased exponentially, undermining their potential profits.

- Proposed Solution: in order to reduce the maintenance costs, the milling shop engineering staff proposed the implementation of a Predictive Maintenance (PdM) program that should start by leveraging simple failure data on one of their CNC machines (named CNC01).

- The Goal: in this first step, the primary objective is to characterize the reliability behavior of CNC01 through key indicators such as **failure rate**, **MTBF (Mean Time Between Failures)**, and **failure distribution**, providing initial insights into operational issues associated with the recent expansion of production. As a secondary objective, the analysis investigates whether **process variables** exhibit distinct statistical behavior under failure and non-failure conditions, using these differences as a starting point for identifying relevant parameters for equipment integrity assessment in subsequent stages of the project.

- The Methodology: the engineering staff listed the most common failure modes detected on their CNC machines and also listed the main parameters related to each failure mode that should be monitored in their PdM program: temperature sensors to measure air and process temperatures, a tachometer measuring the rotational speed of the engine's axis and a torque sensor connected to the spindle drive system. Without a simple alternative for measuring the tool wear, they decided to classify the machined products in three qualities and attribute a wear time to each quality. They also installed a Programmable Logic Controller (PLC) connected to all the sensors that associates all the unplanned shutdowns to each of the initial failure modes listed.

- The challenge: with the collected data, the Industrial Data Scientist should perform a reliability study of the machine obtaining the desired indicators and creating useful visualizations to help the decision making of the engineering staff on the next steps of the PdM program. 