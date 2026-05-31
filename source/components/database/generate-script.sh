export PGPASSWORD=admin123

./pg-dump.sh --mode schema --dbname finance --username postgres --outdir ./schema

./pg-dump.sh --mode data --dbname finance --username postgres --outdir ./data --table finance_schema.appuser --table finance_schema.lkpassettype --table finance_schema.lkpconfig --table finance_schema.lkpindustry --table finance_schema.lkpoperation --table finance_schema.lkprole --table finance_schema.lkproleoperationmap --table finance_schema.mstasset --table finance_schema.mstuserrolemap



