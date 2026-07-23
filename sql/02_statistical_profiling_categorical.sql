/*
 * Script #02 - Statistical Profiling (categorical)
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

-- Basic statistcs - 'product_type' (categorical ordinal data)
SELECT
	product_type,
	COUNT(product_type) AS num_of_cycles,
	(COUNT(product_type) / SUM(COUNT(*)) OVER())*100 AS pct_of_total_cycles
FROM milling_pdm_celsius
GROUP BY product_type
ORDER BY product_type
;

-- Basic statistcs - 'machine failure' (binary data)
SELECT
	machine_failure,
	COUNT(machine_failure) AS num_of_cycles,
	(COUNT(machine_failure) / SUM(COUNT(*)) OVER())*100 AS pct_of_total_cycles
FROM milling_pdm_celsius
GROUP BY machine_failure
ORDER BY machine_failure
; -- Global failure rate is 3.4% wich implies in a MTBF of 29.4 cycles

-- Basic statistcs - failure modes (binary data)
SELECT
	machine_failure AS MF,
	tool_wear_failure AS TWF,
	heat_dissipation_failure AS HDF,
	power_failure AS PWF,
	overstrain_failure AS OSF,
	random_failure AS RDF,
	COUNT(*),
	ROUND(COUNT(*) / (SUM(COUNT(*)) OVER()) * 100,2) AS pct
FROM milling_pdm_celsius
WHERE -- where failure labels where applied
	(machine_failure = TRUE) OR
	(tool_wear_failure = TRUE) OR
	(heat_dissipation_failure = TRUE) OR
	(power_failure = TRUE) OR
	(overstrain_failure = TRUE) OR
	(random_failure = TRUE)
GROUP BY machine_failure, tool_wear_failure, heat_dissipation_failure, power_failure, overstrain_failure, random_failure
ORDER BY 7 DESC
;
-- The isolated failure mechanisms make up approx. 90% of the failures (combinations are rare)
-- The most commom combination of modes is PWF + OSF which represents 3% of the failures
-- The most frequent failure mode is HDF with 32.2% of representation, including its combinations
-- Tool failure represents only 12.9% of the failure data, including its combinations (more commonly associated with OSF)

SELECT
	failure_mode,
	ROUND(COUNT(*) / (SUM(COUNT(*)) OVER()) * 100,2) AS pct
FROM failure_data_unpivoted
GROUP BY failure_mode
ORDER BY 2 DESC
;

