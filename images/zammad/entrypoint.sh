#!/bin/bash
# Zammad Application Entrypoint
set -e

db_not_configured() {
  echo "ERROR: You must configure the database connection with the DB_* environment variables"
  exit 1
}

db_invalid_adapter() {
  echo "ERROR: Invalid DB_ADAPTER '${DB_ADAPTER}' specified"
  exit 1
}

es_not_configured() {
  echo "ERROR: You must configure the Elasticsearch connection with the ES_* environment variables"
  exit 1
}

# Make sure the database was configured
if [ -z "$DB_HOSTNAME" ] || [ -z "$DB_NAME" ]; then db_not_configured; fi

# Use the default port for the database adapter if one was not defined
case "$DB_ADAPTER" in
  "postgresql") export DB_PORT=${DB_PORT:-5432} ;;
  "mysql2") export DB_PORT=${DB_PORT:-3306} ;;
  *) db_not_configured ;;
esac

# Make sure Elasticsearch was configured
if [ -z "$ES_HOSTNAME" ]; then es_not_configured; fi
export ES_PORT=${ES_PORT:-9200}

# Wait for the DB server
until (echo > "/dev/tcp/${DB_HOSTNAME}/${DB_PORT}") &> /dev/null; do
  echo "--> Waiting for the database server to be reachable..."
  sleep 2
done

# Make sure the database exists
if ! rails r 'ActiveRecord::Base.connection' &> /dev/null; then
  echo "--> Creating database..."
  bundle exec rake db:create
fi

# Check to see if the database needs to be seeded
EXISTING_DB=$(rails r 'puts ActiveRecord::Base.connection.tables.include? "schema_migrations"')

echo "--> Migrating database..."
bundle exec rake db:migrate

if [ "${EXISTING_DB}" == "false" ]; then
  echo "--> Seeding database..."
  bundle exec rake db:seed
fi

echo "--> Setting up Elasticsearch..."
bundle exec rails r "Setting.set('es_url', 'http://${ES_HOSTNAME}:${ES_PORT}')"
bundle exec rake searchindex:rebuild

echo "--> Starting application..."
exec foreman start -f Procfile
