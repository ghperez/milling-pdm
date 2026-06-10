/*
 * Analysis of a milling machine predictive maintenance data (script #2)
 * Scripts for evaluating statistical properties of the numerical columns
 */

-- What are the average,median, maximum and minimum air temperature recorded in the dataset? (CENTRAL TENDENCY)
select
	AVG(mill.air_temperature_kelvin)-273.15 as avg_air_temperature_degC,
	MAX(mill.air_temperature_kelvin)-273.15 as max_air_temperature_degC,
	MIN(mill.air_temperature_kelvin)-273.15 as min_air_temperature_degC,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mill.air_temperature_kelvin)-273.15 AS median_air_temperature_degC,
	COUNT(mill.air_temperature_kelvin) as num_of_records
from milling_failure_table as mill
; -- Extreme values are within the expected range so there is no sign of problems with the sensors

-- How is air temperature spread along the data points? (VARIABILITY ANALYSIS)
select
	MAX(mill.air_temperature_kelvin)-MIN(mill.air_temperature_kelvin) as range_air_temperature_degC,
	STDDEV_POP(mill.air_temperature_kelvin) as stddev_air_temperature_degC
from milling_failure_table as mill
; -- Range (or thermal amplitude) is within the expected to a month period of records

-- What are the average,median, maximum and minimum process temperature recorded in the dataset? (CENTRAL TENDENCY)
select
	AVG(mill.process_temperature_kelvin)-273.15 as avg_process_temperature_degC,
	MAX(mill.process_temperature_kelvin)-273.15 as max_process_temperature_degC,
	MIN(mill.process_temperature_kelvin)-273.15 as min_process_temperature_degC,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mill.process_temperature_kelvin)-273.15 AS median_process_temperature_degC,
	COUNT(mill.process_temperature_kelvin) as num_of_records
from milling_failure_table as mill
; -- Values are lower than expected from a milling operation, but it should be investigated where the sensors are installed

-- How is process temperature spread along the data points? (VARIABILITY ANALYSIS)
select
	MAX(mill.process_temperature_kelvin)-MIN(mill.process_temperature_kelvin) as range_process_temperature_degC,
	STDDEV_POP(mill.process_temperature_kelvin) as stddev_process_temperature_degC
from milling_failure_table as mill
; -- Low range, also not expected to milling operations

-- What are the average,median, maximum and minimum rotational speed recorded in the dataset? (CENTRAL TENDENCY)
select
	product_type,
	AVG(mill.rotational_speed_rpm) as avg_rotational_speed_rpm,
	MAX(mill.rotational_speed_rpm) as max_rotational_speed_rpm,
	MIN(mill.rotational_speed_rpm) as min_rotational_speed_rpm,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mill.rotational_speed_rpm) AS median_rotational_speed_rpm,
	COUNT(mill.rotational_speed_rpm) as num_of_records
from milling_failure_table as mill
group by product_type
; -- Low RPM values that should depend on the product type (material) and operation but this variation is not observed with respect to product quality, as expected.

-- How is rotational speed spread along the data points? (VARIABILITY ANALYSIS)
select
	product_type,
	MAX(mill.rotational_speed_rpm)-MIN(mill.rotational_speed_rpm) as range_rotational_speed_rpm,
	STDDEV_POP(mill.rotational_speed_rpm) as stddev_rotational_speed_rpm
from milling_failure_table as mill
group by product_type
; -- Low range and standard deviation, indicanting that sensor response is consistent

-- What are the average,median, maximum and minimum torque recorded in the dataset? (CENTRAL TENDENCY)
select
	product_type,
	AVG(mill.torque_nm) as avg_torque_nm,
	MAX(mill.torque_nm) as max_torque_nm,
	MIN(mill.torque_nm) as min_torque_nm,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mill.torque_nm) AS median_torque_nm,
	COUNT(mill.torque_nm) as num_of_records
from milling_failure_table as mill
group by product_type
; -- Torque should be a process variable that varies a lot depending on the product and operation, but this is not observed in the database

-- How is torque spread along the data points? (VARIABILITY ANALYSIS)
select
	product_type,
	MAX(mill.torque_nm)-MIN(mill.torque_nm) as range_torque_nm,
	STDDEV_POP(mill.torque_nm) as stddev_torque_nm
from milling_failure_table as mill
group by product_type
; -- High standard deviation with respect to the mean value, but the distribution between different qualities of product seems to be same

-- What are the average,median, maximum and minimum tool_wear recorded in the dataset? (CENTRAL TENDENCY)
select
	product_type,
	AVG(mill.tool_wear_min) as avg_tool_wear_min,
	MAX(mill.tool_wear_min) as max_tool_wear_min,
	MIN(mill.tool_wear_min) as min_tool_wear_min,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mill.tool_wear_min) AS median_tool_wear_min,
	COUNT(mill.tool_wear_min) as num_of_records
from milling_failure_table as mill
group by product_type
;

-- How is tool_wear spread along the data points? (VARIABILITY ANALYSIS)
select
	product_type,
	MAX(mill.tool_wear_min)-MIN(mill.tool_wear_min) as range_tool_wear_min,
	STDDEV_POP(mill.tool_wear_min) as stddev_tool_wear_min
from milling_failure_table as mill
group by product_type
; -- As tool_wear_min actually reflects time periodos between failures central tendency and variability analysis doesn't give much information
