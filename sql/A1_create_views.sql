/*
 * Script #A1 - Create custom views for analysis
*/

-- Convert temperatures to degrees celsius
CREATE VIEW milling_pdm_celsius AS
SELECT
	register_id,
	product_id,
	product_type,
	air_temperature_kelvin - 273.15 AS air_temperature_celsius,
	process_temperature_kelvin - 273.15 AS process_temperature_celsius,
	rotational_speed_rpm,
	torque_nm,
	tool_wear_min,
	machine_failure,
	tool_wear_failure,
	heat_dissipation_failure,
	power_failure,
	overstrain_failure,
	random_failure
FROM milling_pdm
;

-- Failure data (unpivot the original table)
CREATE VIEW failure_data_unpivoted AS
SELECT
	register_id,
	product_type,
	air_temperature_celsius,
	process_temperature_celsius,
	rotational_speed_rpm,
	torque_nm,
	machine_failure,
	failure_mode
FROM (
SELECT
	register_id,
	product_type,
	air_temperature_celsius,
	process_temperature_celsius,
	rotational_speed_rpm,
	torque_nm,
	machine_failure,
	UNNEST(ARRAY['TWF', 'HDF', 'PWF', 'OSF', 'RDF']) AS failure_mode,
	UNNEST(ARRAY[tool_wear_failure, heat_dissipation_failure, power_failure, overstrain_failure, random_failure]) AS boolean	
FROM milling_pdm_celsius
)
WHERE boolean = TRUE
;



