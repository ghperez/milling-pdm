/*
 * Script #01 - DQA
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

-- List columns, data types and is_nullable condition
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'milling_pdm'
;

-- Search for duplicate values
SELECT COUNT(*)
FROM(
	SELECT
		register_id,
		product_id,
		product_type,
		air_temperature_kelvin,
		process_temperature_kelvin,
		rotational_speed_rpm,
		torque_nm,
		tool_wear_min,
		machine_failure,
		tool_wear_failure,
		heat_dissipation_failure,
		power_failure,
		overstrain_failure,
		random_failure,
		COUNT(*) AS records
	FROM milling_pdm
	GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
)
WHERE records > 1
; -- There are no duplicates in the data

-- Search for null values
SELECT
	SUM(CASE WHEN register_id IS NULL THEN 1 ELSE 0 END) AS nulls_register_id,
	SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS nulls_product_id,
	SUM(CASE WHEN product_type IS NULL THEN 1 ELSE 0 END) AS nulls_product_type,
	SUM(CASE WHEN air_temperature_kelvin IS NULL THEN 1 ELSE 0 END) AS nulls_airtemp,
	SUM(CASE WHEN process_temperature_kelvin IS NULL THEN 1 ELSE 0 END) AS nulls_processtemp,
	SUM(CASE WHEN rotational_speed_rpm IS NULL THEN 1 ELSE 0 END) AS nulls_rotspeed,
	SUM(CASE WHEN torque_nm IS NULL THEN 1 ELSE 0 END) AS nulls_torque,
	SUM(CASE WHEN tool_wear_min IS NULL THEN 1 ELSE 0 END) AS nulls_twmin,
	SUM(CASE WHEN machine_failure IS NULL THEN 1 ELSE 0 END) AS nulls_machfail,
	SUM(CASE WHEN tool_wear_failure IS NULL THEN 1 ELSE 0 END) AS nulls_twf,
	SUM(CASE WHEN heat_dissipation_failure IS NULL THEN 1 ELSE 0 END) AS nulls_hdf,
	SUM(CASE WHEN power_failure IS NULL THEN 1 ELSE 0 END) AS nulls_pwf,
	SUM(CASE WHEN overstrain_failure IS NULL THEN 1 ELSE 0 END) AS nulls_osf,
	SUM(CASE WHEN random_failure IS NULL THEN 1 ELSE 0 END) AS nulls_rdf
FROM milling_pdm
; 

-- Check 'product_id' for invalid values, it should be a letter L/H/M + 5digit integer
SELECT
	COUNT(CASE WHEN LENGTH(product_id) != 6 THEN 1 END) AS len_isnot_six,
	COUNT(CASE WHEN LEFT(product_id,1) NOT IN ('L', 'M', 'H') THEN 1 END) AS invalid_quality_char,
	COUNT(CASE WHEN NOT (RIGHT(product_id,5) ~ '^[0-9]{5}$') THEN 1 END) AS not_endswith_five_digits	
FROM milling_pdm
; -- Passes all criteria

-- Check 'product_type' for invalid values
SELECT
	COUNT(CASE WHEN product_type NOT IN ('L', 'M', 'H') THEN 1 END) AS invalid_quality_char,
	COUNT(CASE WHEN product_type != LEFT(product_id,1) THEN 1 END) AS correct_product_code
FROM milling_pdm
; -- Passes all criteria

-- Check 'air_temperature_kelvin' for invalid values
SELECT
	COUNT(CASE WHEN air_temperature_kelvin < 0 THEN 1 END) AS bellow_abs_zero
FROM milling_pdm
; -- Passes all criteria

-- Check 'air_temperature_kelvin' for invalid values
SELECT
	COUNT(CASE WHEN process_temperature_kelvin < 0 THEN 1 END) AS bellow_abs_zero
FROM milling_pdm
; -- Passes all criteria

-- Check 'rotational_speed_rpm' for invalid values
SELECT
	COUNT(CASE WHEN rotational_speed_rpm < 0 THEN 1 END) AS negative_rpm
FROM milling_pdm
; -- Passes all criteria

-- Check 'torque_nm' for invalid values
SELECT
	COUNT(CASE WHEN torque_nm < 0 THEN 1 END) AS negative_torque
FROM milling_pdm
; -- Passes all criteria

-- Check 'tool_wear_min' for invalid values
SELECT
	COUNT(CASE WHEN tool_wear_min < 0 THEN 1 END) AS negative_wear_min
FROM milling_pdm
; -- Passes all criteria

-- Check if all failure events where classified in the predefined categories
SELECT *
FROM milling_pdm
WHERE (machine_failure = TRUE)
	AND (tool_wear_failure=FALSE)
	AND (heat_dissipation_failure=FALSE)
	AND (power_failure=FALSE)
	AND (overstrain_failure=FALSE)
	AND (random_failure=FALSE)
; -- 9 machine failures without a failure mode label
