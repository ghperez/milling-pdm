/*
* Table setup script used for creating the database and table in pgadmin4
*/
CREATE TABLE IF NOT EXISTS public.milling_failure_table
(
    register_id integer NOT NULL DEFAULT nextval('machine_a_tool_wear_register_id_seq'::regclass),
    product_id character varying(6) COLLATE pg_catalog."default",
    product_type character(1) COLLATE pg_catalog."default",
    air_temperature_kelvin real,
    process_temperature_kelvin real,
    rotational_speed_rpm real,
    torque_nm real,
    tool_wear_min integer,
    machine_failure boolean,
    tool_wear_failure boolean,
    heat_dissipation_failure boolean,
    power_failure boolean,
    overstrain_failure boolean,
    random_failure boolean
)
