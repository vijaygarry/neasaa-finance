export PGPASSWORD=admin123

./pg-dump.sh --mode schema --dbname finance --username postgres --outdir ./schema

./pg-dump.sh --mode data --dbname finance --username postgres --outdir ./data
