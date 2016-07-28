

CREATE SCHEMA vacuum_utils;


SET search_path = vacuum_utils, pg_catalog;

--
-- TOC entry 594 (class 1247 OID 158377)
-- Name: datetext_and_int; Type: TYPE; Schema: vacuum_utils; Owner: -
--

CREATE TYPE datetext_and_int AS (
	last text,
	count bigint
);




CREATE FUNCTION diff_to_autovaccum(schema_name text, table_name text) RETURNS bigint
    LANGUAGE sql
    AS $_$

SELECT(select  current_setting('autovacuum_vacuum_threshold')::integer + 
(current_setting('autovacuum_vacuum_scale_factor')::numeric * ( SELECT reltuples::integer  FROM 
                pg_class pg JOIN pg_stat_user_tables psat ON (pg.relname = psat.relname)  
                join pg_namespace ns  on (pg.relnamespace = ns.oid) WHERE pg.relname=$2  and ns.nspname=$1  ))::integer)
-
 (SELECT  psat.n_dead_tup 
   FROM pg_class pg JOIN pg_stat_user_tables psat 
                ON (pg.relname = psat.relname)  join pg_namespace a on
                 ( pg.relnamespace = a.oid)  WHERE pg.relname=$2  and a.nspname=$1);




$_$;




COMMENT ON FUNCTION diff_to_autovaccum(schema_name text, table_name text) IS 'Get diff to autoanalyze of specific Table';



CREATE FUNCTION disable_autovacuum(schema_name text, table_name text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
command text;
 men text;   
     mendeta text;
     sqlerror text;
BEGIN

command := 'ALTER TABLE ' ||$1||'.'||$2 ||' SET (autovacuum_enabled = false);'; 
BEGIN
       RAISE NOTICE 'Executing disable ';
       EXECUTE command;
	       EXCEPTION
	       WHEN syntax_error THEN
		GET STACKED DIAGNOSTICS men = MESSAGE_TEXT,mendeta = PG_EXCEPTION_DETAIL,sqlerror=RETURNED_SQLSTATE;
                RAISE EXCEPTION 'Error %, %,% ',sqlerror,men,mendeta;
	       WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS  men = MESSAGE_TEXT,mendeta = PG_EXCEPTION_DETAIL,sqlerror=RETURNED_SQLSTATE;
                RAISE EXCEPTION 'Error %, %,% ',sqlerror,men,mendeta;

      END;
    RETURN 'OK';
     

END;
$_$;
COMMENT ON FUNCTION disable_autovacuum(schema_name text, table_name text) IS 'disable autovacumm  of specific Table';



CREATE FUNCTION enable_autovacuum(schema_name text, table_name text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
command text;
 men text;   
     mendeta text;
     sqlerror text;
BEGIN

command := 'ALTER TABLE ' ||$1||'.'||$2 ||' SET (autovacuum_enabled = true);'; 
BEGIN
       RAISE NOTICE 'Executing disable ';
       EXECUTE command;
	       EXCEPTION
	       WHEN syntax_error THEN
		GET STACKED DIAGNOSTICS men = MESSAGE_TEXT,mendeta = PG_EXCEPTION_DETAIL,sqlerror=RETURNED_SQLSTATE;
                RAISE EXCEPTION 'Error %, %,% ',sqlerror,men,mendeta;
	       WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS  men = MESSAGE_TEXT,mendeta = PG_EXCEPTION_DETAIL,sqlerror=RETURNED_SQLSTATE;
                RAISE EXCEPTION 'Error %, %,% ',sqlerror,men,mendeta;

      END;
    RETURN 'OK';
     

END;
$_$;
COMMENT ON FUNCTION enable_autovacuum(schema_name text, table_name text) IS 'Enable autovacumm  of specific Table';


CREATE FUNCTION execute_analyze(schema_name text, table_name text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
command text;
 men text;   
     mendeta text;
     sqlerror text;
BEGIN

command := 'ANALYZE  ' ||$1||'.'||$2 ||' ;'; 
BEGIN
       RAISE NOTICE 'Executing ANALYZE ';
       EXECUTE command;
	       EXCEPTION
	       WHEN syntax_error THEN
		GET STACKED DIAGNOSTICS men = MESSAGE_TEXT,mendeta = PG_EXCEPTION_DETAIL,sqlerror=RETURNED_SQLSTATE;
                RAISE EXCEPTION 'Error %, %,% ',sqlerror,men,mendeta;
	       WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS  men = MESSAGE_TEXT,mendeta = PG_EXCEPTION_DETAIL,sqlerror=RETURNED_SQLSTATE;
                RAISE EXCEPTION 'Error %, %,% ',sqlerror,men,mendeta;

      END;
    RETURN 'OK';
     

END;



$_$;

COMMENT ON FUNCTION execute_analyze(schema_name text, table_name text) IS 'EXECUTE analyze  of specific Table';


CREATE FUNCTION get_table_analyze_threshold(schema_name text, table_name text) RETURNS bigint
    LANGUAGE sql
    AS $_$

select  current_setting('autovacuum_analyze_threshold')::bigint + 
(current_setting('autovacuum_analyze_scale_factor')::numeric * ( SELECT reltuples::integer  FROM 
                pg_class pg JOIN pg_stat_user_tables psat ON (pg.relname = psat.relname)  
                join pg_namespace ns  on (pg.relnamespace = ns.oid) WHERE pg.relname=$2  and ns.nspname=$1  ))::bigint




$_$;




COMMENT ON FUNCTION get_table_analyze_threshold(schema_name text, table_name text) IS 'Get analyze threshold of specific Table';


--
-- TOC entry 216 (class 1255 OID 158363)
-- Name: get_table_vacuum_threshold(text, text); Type: FUNCTION; Schema: vacuum_utils; Owner: -
--

CREATE FUNCTION get_table_vacuum_threshold(schema_name text, table_name text) RETURNS integer
    LANGUAGE sql
    AS $_$

select (current_setting('autovacuum_vacuum_threshold')::integer + 
(current_setting('autovacuum_vacuum_scale_factor')::numeric * ( SELECT reltuples::integer  FROM 
                pg_class pg JOIN pg_stat_user_tables psat ON (pg.relname = psat.relname)  
                join pg_namespace ns  on (pg.relnamespace = ns.oid) WHERE pg.relname=$2  and ns.nspname=$1  )))::integer




$_$;




COMMENT ON FUNCTION get_table_vacuum_threshold(schema_name text, table_name text) IS 'Get vacuum threshold of specific Table';


--
-- TOC entry 217 (class 1255 OID 158384)
-- Name: last_analyze_count(text, text); Type: FUNCTION; Schema: vacuum_utils; Owner: -
--

CREATE FUNCTION last_analyze_count(schema_name text, table_name text) RETURNS datetext_and_int
    LANGUAGE sql
    AS $_$
 SELECT  COALESCE( last_analyze::text,'-')::text as date_last_analzye, analyze_count
 FROM pg_class pg JOIN pg_stat_user_tables psat 
                ON (pg.relname = psat.relname)  join pg_namespace a on
                 ( pg.relnamespace = a.oid) WHERE pg.relname=$2  and a.nspname=$1 ;


$_$;



COMMENT ON FUNCTION last_analyze_count(schema_name text, table_name text) IS 'Get timestamp of last analyze and analyze count of a table';


CREATE FUNCTION last_autoanalyze_count(schema_name text, table_name text) RETURNS datetext_and_int
    LANGUAGE sql
    AS $_$
 SELECT  COALESCE( last_autoanalyze::text,'-')::text as date_last_autoanalzye, autoanalyze_count
 FROM pg_class pg JOIN pg_stat_user_tables psat 
                ON (pg.relname = psat.relname)  join pg_namespace a on
                 ( pg.relnamespace = a.oid) WHERE pg.relname=$2  and a.nspname=$1 ;


$_$;




COMMENT ON FUNCTION last_autoanalyze_count(schema_name text, table_name text) IS 'Get timestamp of last autoanalyze and autoanalyze count of a table';




CREATE FUNCTION last_autovacuum_count(schema_name text, table_name text) RETURNS datetext_and_int
    LANGUAGE sql
    AS $_$
 SELECT  COALESCE( last_autovacuum::text,'-')::text as date_last_autovacuum, autovacuum_count
 FROM pg_class pg JOIN pg_stat_user_tables psat 
                ON (pg.relname = psat.relname)  join pg_namespace a on
                 ( pg.relnamespace = a.oid) WHERE pg.relname=$2  and a.nspname=$1 ;


$_$;


COMMENT ON FUNCTION last_autovacuum_count(schema_name text, table_name text) IS 'Get timestamp of last autovacuum and autovacuum count of a table';



CREATE FUNCTION last_vacuum_count(schema_name text, table_name text) RETURNS datetext_and_int
    LANGUAGE sql
    AS $_$
 SELECT  COALESCE( last_vacuum::text,'-')::text as date_last_vacuum, vacuum_count
 FROM pg_class pg JOIN pg_stat_user_tables psat 
                ON (pg.relname = psat.relname)  join pg_namespace a on
                 ( pg.relnamespace = a.oid) WHERE pg.relname=$2  and a.nspname=$1 ;


$_$;




COMMENT ON FUNCTION last_vacuum_count(schema_name text, table_name text) IS 'Get timestamp of last vacuum and vacuum count of a table';




