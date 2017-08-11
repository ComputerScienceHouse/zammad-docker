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

nginx_not_configured() {
  echo "ERROR: You must configure the hostname of the websockets server with the WEBSOCKETS_HOSTNAME environment variable"
  exit 1
}

invalid_rails_server() {
  echo "ERROR: Invalid RAILS_SERVER '${RAILS_SERVER}' specified"
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

echo "--> Migrating database..."
if ! bundle exec rake db:migrate; then
  echo "--> Initializing database..."
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake db:seed
fi

echo "--> Setting up Elasticsearch..."
bundle exec rails r "Setting.set('es_url', 'http://${ES_HOSTNAME}:${ES_PORT}')"
bundle exec rake searchindex:rebuild

echo "--> Configuring Nginx..."
if [ -z "$WEBSOCKETS_HOSTNAME" ]; then nginx_not_configured; fi
# shellcheck disable=SC2016
envsubst '${WEBSOCKETS_HOSTNAME} ${ZAMMAD_DIR}' < /etc/nginx/conf.d/zammad.conf.template > /etc/nginx/conf.d/default.conf

echo "--> Starting application..."
case "${RAILS_SERVER}" in
  "puma") foreman start -f Procfile.puma ;;
  "unicorn") foreman start -f Procfile.unicorn ;;
  *) invalid_rails_server ;;
esac
