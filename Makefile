EXTENSION = vacuum_utils
DATA = vacuum_utils--0.1.0.sql
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

