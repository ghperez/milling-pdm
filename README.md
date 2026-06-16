# Milling machine reliability data analysis

Repository for analysis of AI4I Predictive Maintenance dataset (Kaggle) to model milling machine failures.

## 🎯 Business Context & Problem Framing

- Core Issue: after increasing their portfolio of products to supply new clients, a milling shop is struggling with frequent tool replacements.

- The Impact: despite the increase in revenue after the portfolio expansion, their backlog accumulated too many work orders and the costs with maintenance increased exponentially, undermining their potential profits.

- Proposed Solution: in order to reduce the maintenance costs, the milling shop engineering staff proposed the implementation of a Predictive Maintenance (PdM) program that should start by leveraging simple failure data on one of their CNC machines (named CNC01).

- The Goal: in this first step reliability properties of CNC01 such as **failure rate**, **MTBF (Mean Time Between Failures)** and the **failure distribution** should give initial insights of the problems that came along with expanding their operations. The engineering staff is also concerned about what **maintenance strategies** are being adopted in the factory floor (corrective x preventive) and what are the most relevant parameters to evaluate CNC01's integrity.

- The Methodology: the engineering staff listed the most common failure modes detected on their CNC machines and also listed the main parameters related to each failure mode that should be monitored in their PdM program: temperature sensors to measure air and process temperatures, a tachometer measuring the rotational speed of the engine's axis and a torque sensor connected to the spindle drive system. Without a simple alternative for measuring the tool wear, they decided to classify the machined products in three qualities and attribute a wear time to each quality. They also installed a Programmable Logic Controller (PLC) connected to all the sensors that associates all the unplanned shutdowns to each of the initial failure modes listed.

- The challenge: with the collected data, the Industrial Data Scientist should perform a reliability study of the machine obtaining the desired indicators and creating useful visualizations to help the decision making of the engineering staff on the next steps of the PdM program. 