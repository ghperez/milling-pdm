/*
 * Script #03 - Statistical Profiling (numerical)
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
UNION ALL
(SELECT *
FROM milling_pdm
LIMIT 5 OFFSET 9995)
;

-- Basic statistcs
(SELECT
	'air_temperature_celsius' AS feature,
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
FROM milling_pdm_celsius)
UNION ALL
(SELECT
	'process_temperature_celsius' AS feature,
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
FROM milling_pdm_celsius)
UNION ALL
(SELECT
	'rotational_speed_rpm' AS feature,
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
FROM milling_pdm_celsius)
UNION ALL
(SELECT
	'torque_nm' AS feature,
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
FROM milling_pdm_celsius)
UNION ALL
(SELECT
	'tool_wear_min' AS feature,
	COUNT(tool_wear_min) AS COUNT,
	ROUND(AVG(tool_wear_min)::NUMERIC,2) AS AVG,
	ROUND(MAX(tool_wear_min)::NUMERIC - MIN(tool_wear_min)::NUMERIC,2) AS RANGE,
	ROUND(STDDEV(tool_wear_min)::NUMERIC,2) AS STDDEV,
	ROUND(MIN(tool_wear_min)::NUMERIC,2) AS MIN,
	ROUND((PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY tool_wear_min))::NUMERIC,2) AS P25,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY tool_wear_min))::NUMERIC,2) AS P50,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY tool_wear_min))::NUMERIC,2) AS P75,
	ROUND(MAX(tool_wear_min)::NUMERIC,2) AS MAX,
	ROUND((PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY tool_wear_min))::NUMERIC - (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY tool_wear_min))::NUMERIC, 2) AS IQR
FROM milling_pdm_celsius)
;

-- Frequency table - air_temperature_celsius
SELECT
	FLOOR(air_temperature_celsius) AS "start",
	FLOOR(air_temperature_celsius) + 0.99 AS "end",
	COUNT(*)
FROM milling_pdm_celsius
GROUP BY FLOOR(air_temperature_celsius)
ORDER BY 1 ASC
;

-- Frequency table - process_temperature_celsius
SELECT
	FLOOR(process_temperature_celsius) AS "start",
	FLOOR(process_temperature_celsius) + 0.99 AS "end",
	COUNT(*)
FROM milling_pdm_celsius
GROUP BY FLOOR(process_temperature_celsius)
ORDER BY 1 ASC
;

-- Frequency table - rotational_speed_rpm
SELECT
	FLOOR(rotational_speed_rpm/300)*300 AS "start",
	FLOOR(rotational_speed_rpm/300)*300 + 299.99 AS "end",
	COUNT(*)
FROM milling_pdm_celsius
GROUP BY FLOOR(rotational_speed_rpm/300)
ORDER BY 1 ASC
;

-- Frequency table - torque_nm
SELECT
	FLOOR(torque_nm/7)*7 AS "start",
	FLOOR(torque_nm/7)*7 + 6.99 AS "end",
	COUNT(*)
FROM milling_pdm_celsius
GROUP BY FLOOR(torque_nm/7)
ORDER BY 1 ASC
;

-- Frequency table - tool_wear_min
SELECT
	FLOOR(tool_wear_min/30)*30 AS "start",
	FLOOR(tool_wear_min/30)*30 + 29.99 AS "end",
	COUNT(*)
FROM milling_pdm_celsius
GROUP BY FLOOR(tool_wear_min/30)
ORDER BY 1 ASC
;