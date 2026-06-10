/*
 * Analysis of a milling machine predictive maintenance data (script #3)
 * Scripts for investigating the relations between failure mechanisms
 */

-- How many failures occurred in the 10k data points?
select
	count(*) as num_of_failures
from milling_failure_table as mill
where mill.machine_failure = TRUE
; -- a total of 339 failures

-- Is there NULL values in the column machine_failure?
select
	count(*) as num_of_nulls
from milling_failure_table as mill
where mill.machine_failure is null
; -- no null values found

-- How much failures of each type occurred in the datapoints? does the sum of failures matches the number of rows that machine_failure is true?
select
	count(case when machine_failure = true then 1 end) as machine_failures,
	count(case when tool_wear_failure = true then 1 end) as twf_failures,
	count(case when heat_dissipation_failure = true then 1 end) as hdf_failures,
	count(case when power_failure = true then 1 end) as pwf_failures,
	count(case when overstrain_failure = true then 1 end) as osf_failures,
	count(case when random_failure = true then 1 end) as rdf_failures
from milling_failure_table as mill
; -- the total failures of each failure mechanism (twf, hdf, pwf, osf and rdf) is greater than the machine_failures, is that an error or not all failure mechanisms causes the machine to fail?

-- More than one failure can occur at each datapoint?
select
	COUNT(*) as num_of_combined_mechs
from milling_failure_table
where (tool_wear_failure::int + heat_dissipation_failure::int + power_failure::int + overstrain_failure::int + random_failure::int) > 1
; -- this query indicates that there are instances with 2 or 3 mechanisms reported, so it was not an error if two mechanisms are allowed to be the cause of a failure in the same aquisition point


-- Lets investigate if when a determined mechanism failure is reported a machine failure is also reported
select
	count(case when (tool_wear_failure = true) and (machine_failure = true) then 1 end) as twf_and_machine_failure,
	count(case when (heat_dissipation_failure = true) and (machine_failure = true) then 1 end) as hdf_and_machine_failure,
	count(case when (power_failure = true) and (machine_failure = true) then 1 end) as pwf_and_machine_failure,
	count(case when (overstrain_failure = true) and (machine_failure = true) then 1 end) as osf_and_machine_failure,
	count(case when (random_failure = true) and (machine_failure = true) then 1 end) as rdf_and_machine_failure
from milling_failure_table as mill
; -- It seems that only one time that a random failure was reported it counted as a machine failure, this indicate events when the PLC (programming logic controller) emits a false alert

select
	register_id,
	machine_failure,
	tool_wear_failure,
	heat_dissipation_failure,
	power_failure,
	overstrain_failure,
	random_failure
from milling_failure_table as mill
where (random_failure = true) and (machine_failure = false)
;

-- How many tool exchanges happened during the aquisition?
select
	count(*)
from milling_failure_table mft
where mft.tool_wear_min = 0 and mft.register_id > 1
; -- 119 events of tool exchange

-- Which failure mechanisms are associated to a reset in tool wear time (i.e. causes a tool failure)?
with FailureMechCounts as (
	select *,
		(tool_wear_failure::int + heat_dissipation_failure::int + power_failure::int + overstrain_failure::int + random_failure::int) as mech_counts
	from milling_failure_table
),

ToolExchange as (
	select
		register_id,
		tool_wear_min,
		LAG(register_id) over (order by register_id) as previous_id,
		LAG(machine_failure) over (order by register_id) as previous_machine_failure,
		LAG(tool_wear_failure) over (order by register_id) as previous_twf,
		LAG(heat_dissipation_failure) over (order by register_id) as previous_hdf,
		LAG(power_failure) over (order by register_id) as previous_pwf,
		LAG(overstrain_failure) over (order by register_id) as previous_osf,
		LAG(random_failure) over (order by register_id) as previous_rdf,
		LAG(mech_counts) over (order by register_id) as previous_mech_counts
	from FailureMechCounts
)

-- Check the number of each failure mechanism associated with tool exchanges
select
	count(*) as num_of_exchanges,
	COUNT(case when previous_machine_failure=true then 1 end) as num_of_machine_failures,
	-- How many times each time of failure appears before a tool exchange?
	COUNT(case when previous_twf=true then 1 end) as num_of_twf,
	COUNT(case when previous_hdf=true then 1 end) as num_of_hdf,
	COUNT(case when previous_pwf=true then 1 end) as num_of_pwf,
	COUNT(case when previous_osf=true then 1 end) as num_of_osf,
	COUNT(case when previous_rdf=true then 1 end) as num_of_rdf,
	-- How many times each failure mechanism appers alone previously to a tool exchange?
	COUNT(case when previous_twf=true and previous_mech_counts = 1 then 1 end) as num_of_twf_alone,
	COUNT(case when previous_hdf=true and previous_mech_counts = 1 then 1 end) as num_of_hdf_alone,
	COUNT(case when previous_pwf=true and previous_mech_counts = 1 then 1 end) as num_of_pwf_alone,
	COUNT(case when previous_osf=true and previous_mech_counts = 1 then 1 end) as num_of_osf_alone,
	COUNT(case when previous_rdf=true and previous_mech_counts = 1 then 1 end) as num_of_rdf_alone
from ToolExchange
where tool_wear_min = 0 and register_id > 1
;
