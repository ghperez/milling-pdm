/*
 * Analysis of a milling machine predictive maintenance data (script #1)
 * Scripts for Exploration and Profiling 
 */

-- SHOW THE FIRST FIVE ROWS
select *
from milling_failure_table as mill
limit 5
;

-- Is there a product that was processed more than once?
select
	count(*) as total_rows,
	count(distinct product_id) as num_of_different_product_ids
from milling_failure_table as mill
; -- There is no product processed more than one time

-- Does every product id is according to the expected pattern? Letter L/M/H -> 5 digit integer
select
	count(case when LENGTH(product_id) = 6 then 1 end) as has_six_characters,
	count(case when left(product_id,1) in ('L', 'M', 'H') then 1 end) as right_quality_char,
	count(case when right(product_id,5) ~ '^[0-9]{5}$' then 1 end) as endswith_five_digits	
from milling_failure_table as mill
; -- Passes all criteria

-- Which kinds of products were processed and how many instances were recorded for each kind?
select
	product_type,
	count(*) as num_of_products
from milling_failure_table as mill
group by product_type
;

