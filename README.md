Functions to get information and execute statements about maintenance 

IMPORTANT: There're bugs in the existing version. I'm working on it and will
be releasing another version very soon.


Building and install
--------

run `make install` 

In postgresql execute: `CREATE EXTENSION vacuum_utils;`


Example
-------
```sql
SELECT vacuum_utils.diff_to_autovaccum('public','customers');--Get diff to autovacuum of specific Table
SELECT vacuum_utils.get_table_vacuum_threshold ('public','customers');--Get vacuum threshold of specific Table
SELECT vacuum_utils.get_table_analyze_threshold ('public','customers');--Get analyze threshold of specific Table
SELECT vacuum_utils.disable_autovacuum('public','customers'); --Disable autovacumm  of specific Table
SELECT vacuum_utils.enable_autovacuum ('public','customers');--Enable autovacumm  of specific Table
SELECT vacuum_utils.execute_analyze('public','customers');--EXECUTE analyze  of specific Table
SELECT vacuum_utils.last_analyze_count ('public','customers');--Get timestamp of last analyze and analyze count of a table
SELECT vacuum_utils.last_autoanalyze_count ('public','customers');--Get timestamp of last autoanalyze and autoanalyze count of a table
SELECT vacuum_utils.last_autovacuum_count  ('public','customers'); --Get timestamp of last autovacuum and autovacuum count of a table
SELECT vacuum_utils.last_vacuum_count ('public','customers'); --Get timestamp of last vacuum and vacuum count of a table
```






------ 
Anthony  Sotolongo leon

asotolongo@gmail.com

