/*
 * Script #04 - Preliminary analysis of aggregations
*/

-- Show the first five rows
SELECT *
FROM milling_pdm
LIMIT 5
;

-- Count number of rows
SELECT COUNT(*)
FROM milling_pdm
; -- 10k aquisition points

-- Show the first and last five rows
(SELECT *
FROM milling_pdm
LIMIT 5)
UNION
(SELECT *
FROM milling_pdm
LIMIT 5 OFFSET 9995)
;

-- How 'air_temperature_celsius' statistical distribution is affected by failure mode?
(SELECT
	failure_mode,
	COUNT(air_temperature_celsius) AS COUNT,
	ROUND(AVG(air_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(air_temperature_celsius)::NUMERIC - MIN(air_temperature_celsius)::NUMERIC,2) AS "RANGE",
	ROUND(STDDEV(air_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(air_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(air_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY failure_mode)
UNION ALL
(SELECT
	'NORMAL OP' AS failure_mode,
	COUNT(air_temperature_celsius) AS COUNT,
	ROUND(AVG(air_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(air_temperature_celsius)::NUMERIC - MIN(air_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(air_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(air_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(air_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
)
;
-- HDF exhibits a median air temperature higher than the normal operation median and low variability metrics, which indicates that air temperature raises when HDF happens as expected
-- The same behaviour is not observed in PWF mode, so probably overheating is not a major cause of PWF or the temperature sensors aren't detecting such mechanism
-- Other failure modes, including PWF, doesn't exhibt major differencies of statistical metrics in relation to the normal operation condition


-- Does the product type affects the statistical behaviour of air temperature?
(SELECT
	'Failure Condition' AS status,
	product_type,
	COUNT(air_temperature_celsius) AS COUNT,
	ROUND(AVG(air_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(air_temperature_celsius)::NUMERIC - MIN(air_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(air_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(air_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(air_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY product_type)
UNION ALL
(SELECT
	'Normal Operation' AS status,
	product_type,
	COUNT(air_temperature_celsius) AS COUNT,
	ROUND(AVG(air_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(air_temperature_celsius)::NUMERIC - MIN(air_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(air_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(air_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(air_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
GROUP BY product_type)
; -- Little difference between medians and between IQRs indicate similar statistical behaviour

-- Does the product type affects the statistical behaviour of air temperature grouped by failure mode?
(SELECT
	failure_mode,
	product_type,
	COUNT(air_temperature_celsius) AS COUNT,
	ROUND(AVG(air_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(air_temperature_celsius)::NUMERIC - MIN(air_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(air_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(air_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(air_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY failure_mode, product_type)
UNION ALL
(SELECT
	'NORMAL OP' AS failure_mode,
	'' AS product_type,
	COUNT(air_temperature_celsius) AS COUNT,
	ROUND(AVG(air_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(air_temperature_celsius)::NUMERIC - MIN(air_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(air_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(air_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(air_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY air_temperature_celsius))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
)
; -- some differences in median and IQR can be observed between product types for some failure modes, but the number of samples is too much low for using this information


-- How 'process_temperature_celsius' statistical distribution is affected by failure mode?
(SELECT
	failure_mode,
	COUNT(process_temperature_celsius) AS COUNT,
	ROUND(AVG(process_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(process_temperature_celsius)::NUMERIC - MIN(process_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(process_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(process_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(process_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY failure_mode)
UNION ALL
(SELECT
	'NORMAL OP' AS failure_mode,
	COUNT(process_temperature_celsius) AS COUNT,
	ROUND(AVG(process_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(process_temperature_celsius)::NUMERIC - MIN(process_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(process_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(process_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(process_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
)
;
-- (1) HDF is associated with a very low variability (stddev, IQR) in comparison to the other modes and normal operation
-- (2) HDF has a mininum temperature considerably higher than the normal operation
-- (1) and (2) indicates that HDF is associated with a very narrow interval of process temperatures

-- Does the product type affects the statistical behaviour of process temperature?
(SELECT
	'Failure Condition' AS status,
	product_type,
	COUNT(process_temperature_celsius) AS COUNT,
	ROUND(AVG(process_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(process_temperature_celsius)::NUMERIC - MIN(process_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(process_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(process_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(process_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY product_type)
UNION ALL
(SELECT
	'Normal Operation' AS status,
	product_type,
	COUNT(process_temperature_celsius) AS COUNT,
	ROUND(AVG(process_temperature_celsius)::NUMERIC,2) AS AVG,
	ROUND(MAX(process_temperature_celsius)::NUMERIC - MIN(process_temperature_celsius)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(process_temperature_celsius)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(process_temperature_celsius)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC,2) AS P75,
	ROUND(MAX(process_temperature_celsius)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY process_temperature_celsius))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
GROUP BY product_type)
; -- Little difference between medians and between IQRs indicate similar statistical behaviour

-- How 'rotational_speed_rpm' statistical distribution is affected by failure mode?
(SELECT
	failure_mode,
	COUNT(rotational_speed_rpm) AS COUNT,
	ROUND(AVG(rotational_speed_rpm)::NUMERIC,2) AS AVG,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC - MIN(rotational_speed_rpm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(rotational_speed_rpm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(rotational_speed_rpm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P75,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY failure_mode)
UNION ALL
(SELECT
	'NORMAL OP' AS failure_mode,
	COUNT(rotational_speed_rpm) AS COUNT,
	ROUND(AVG(rotational_speed_rpm)::NUMERIC,2) AS AVG,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC - MIN(rotational_speed_rpm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(rotational_speed_rpm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(rotational_speed_rpm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P75,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
)
;
-- (1) Normal operation has considerable outliers above the upper limit
-- (2) PWF has a median considerably higher than normal operation
-- (3) TWF has some outliers above the upper limit
-- (4) PWF has a median very different from the average value as well as range and IQR very high
-- (5) PWF also has a heavy tail to the right as the distance between p75 and the median is considerably higher than the distance between p25 and the median
-- (6) PWF has no outliers
-- (7) OSF has outliers out of the lower and upper limits
-- Observations (2), (4), (5) and (6) indicates that further investigation of the rotational speed in PWF condition is necessary

-- Does the product type affects the statistical behaviour of rotational speed?
(SELECT
	'Failure Condition' AS status,
	product_type,
	COUNT(rotational_speed_rpm) AS COUNT,
	ROUND(AVG(rotational_speed_rpm)::NUMERIC,2) AS AVG,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC - MIN(rotational_speed_rpm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(rotational_speed_rpm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(rotational_speed_rpm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P75,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY product_type)
UNION ALL
(SELECT
	'Normal Operation' AS status,
	product_type,
	COUNT(rotational_speed_rpm) AS COUNT,
	ROUND(AVG(rotational_speed_rpm)::NUMERIC,2) AS AVG,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC - MIN(rotational_speed_rpm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(rotational_speed_rpm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(rotational_speed_rpm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC,2) AS P75,
	ROUND(MAX(rotational_speed_rpm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rotational_speed_rpm))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
GROUP BY product_type)
;
-- Both in failure and normal operation conditions the statistical behaviour for different product qualities is similar

-- How rotational speed in the failure by PWF condition is distributed?
SELECT
	FLOOR(rotational_speed_rpm/100)*100 AS start,
	(FLOOR(rotational_speed_rpm/100)*100) + 99.99 AS end,
	COUNT(*) AS total_registers
FROM failure_data_unpivoted
WHERE failure_mode = 'PWF'
GROUP BY FLOOR(rotational_speed_rpm/100)
ORDER BY start
;
-- (1) Most of the data points is between 1200 and 1500 rpm
-- (2) There are a considerable number of data points above 2500 rpm
-- Observations (1) and (2) indicates that rotational speed presents a bimodal distribution, with two upset conditions at low and high rotational speeds, being the low values the most common

-- How 'torque_nm' statistical distribution is affected by failure mode?
(SELECT
	failure_mode,
	COUNT(torque_nm) AS COUNT,
	ROUND(AVG(torque_nm)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm)::NUMERIC - MIN(torque_nm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY failure_mode)
UNION ALL
(SELECT
	'NORMAL OP' AS failure_mode,
	COUNT(torque_nm) AS COUNT,
	ROUND(AVG(torque_nm)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm)::NUMERIC - MIN(torque_nm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
)
;
-- (1) In general, failure condition shows higher torque values than the normal operation conditions, except for TWF
-- (2) RDF shows a heavier tail to the left as (p50 - p25) is higher than (p75 - p50)
-- (3) PWF has a median higher than the average
-- (4) PWF has (p50 - p25) >>> (p75 - p50) => heavy tail to the left
-- (5) PWF has a huge IQR (bimodal suspect)
-- Observations (2), (3), (4) and (5) indicates that further investigation of torque in PWF condition is necessary

-- Does the product type affects the statistical behaviour of torque?
(SELECT
	'Failure Condition' AS status,
	product_type,
	COUNT(torque_nm) AS COUNT,
	ROUND(AVG(torque_nm)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm)::NUMERIC - MIN(torque_nm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY product_type)
UNION ALL
(SELECT
	'Normal Operation' AS status,
	product_type,
	COUNT(torque_nm) AS COUNT,
	ROUND(AVG(torque_nm)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm)::NUMERIC - MIN(torque_nm)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
GROUP BY product_type)
;
-- Both in failure and normal operation conditions the statistical behaviour for different product qualities is similar

-- How torque in the failure by PWF condition is distributed?
SELECT
	FLOOR(torque_nm/5)*5 AS start,
	(FLOOR(torque_nm/5)*5) + 4.99 AS end,
	COUNT(*) AS total_registers
FROM failure_data_unpivoted
WHERE failure_mode = 'PWF'
GROUP BY FLOOR(torque_nm/5)
ORDER BY start
;
-- (1) Most of the data points is between 60 and 75 N.m
-- (2) There are a considerable number of data points bellow 15 N.m
-- Observations (1) and (2) indicates that torque presents a bimodal distribution, with two upset conditions at low and high torque, being the high values the most common
-- This is the oposite behaviour of the rotational speed and, as these features are phisically related to the mechanical power of the rotational motion, the power should be further investigated


-- How 'power' statistical distribution is affected by failure mode?
-- for simplification power will be considered as rotational_speed * torque without the proper unit conversion
(SELECT
	failure_mode,
	COUNT(torque_nm * rotational_speed_rpm / 1000) AS COUNT,
	ROUND(AVG(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC - MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY failure_mode)
UNION ALL
(SELECT
	'NORMAL OP' AS failure_mode,
	COUNT(torque_nm * rotational_speed_rpm / 1000) AS COUNT,
	ROUND(AVG(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC - MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
)
;
-- (1) Failure condition shows higher power values than the normal operation conditions
-- (2) PWF has median higher than the average
-- (3) PWF has a huge IQR
-- (4) PWF has (p50 - p25) >>> (p75 - p50) => assymetric distribution
-- Observations (1), (2), (3) and (4) demands further investigation of the power data at PWF condition

-- Does the product type affects the statistical behaviour of power?
(SELECT
	'Failure Condition' AS status,
	product_type,
	COUNT(torque_nm * rotational_speed_rpm / 1000) AS COUNT,
	ROUND(AVG(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC - MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC, 2) AS IQR
FROM failure_data_unpivoted
GROUP BY product_type)
UNION ALL
(SELECT
	'Normal Operation' AS status,
	product_type,
	COUNT(torque_nm * rotational_speed_rpm / 1000) AS COUNT,
	ROUND(AVG(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS AVG,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC - MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC,2) AS P75,
	ROUND(MAX(torque_nm * rotational_speed_rpm / 1000)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY torque_nm * rotational_speed_rpm / 1000))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius
WHERE (tool_wear_failure::INT + heat_dissipation_failure::INT + power_failure::INT + overstrain_failure::INT + random_failure::INT + machine_failure::INT) = 0
GROUP BY product_type)
;
-- Both in failure and normal operation conditions the statistical behaviour for different product qualities is similar

-- How power in the failure by PWF condition is distributed?
SELECT
	FLOOR(torque_nm * rotational_speed_rpm / 1000/5)*5 AS start,
	(FLOOR(torque_nm * rotational_speed_rpm / 1000/5)*5) + 4.99 AS end,
	COUNT(*) AS total_registers
FROM failure_data_unpivoted
WHERE failure_mode = 'PWF'
GROUP BY FLOOR(torque_nm * rotational_speed_rpm / 1000/5)
ORDER BY start
;
-- (1) Most values between 30 and 95
-- (2) Few values between 10 and 30
-- Observations (1) and (2) indicates a highly assymetrical distribution with a long tail to the left
-- The combination of 2 features distributed in bimodal fashion resulted in one feature with unimodal behaviour
-- This could indicate that PWF is associated with a specific range of values that can be achieved
-- by the combination of low rotational speed and high torque or high rotational speed and low torque
-- this behaviour should be further investigated with a scatter plot visualization speed x torque
-- with a color map of power

