# Zammad Docker

Docker images for the [Zammad](https://zammad.org) open source helpdesk/customer support system. Inspired by the [official images](https://github.com/zammad/zammad-docker-compose).

## Contents

This repository contains the build contexts for 6 images:

* [base](https://hub.docker.com/computersciencehouse/zammad-base) - Base image for the Zammad application images
* [elasticsearch](https://hub.docker.com/computersciencehouse/zammad-elasticsearch) - Customized Elasticsearch image
* [proxy](https://hub.docker.com/computersciencehouse/zammad-proxy) - Configured Nginx proxy
* [scheduler](https://hub.docker.com/computersciencehouse/zammad-scheduler) - Zammad Scheduler
* [websockets](https://hub.docker.com/computersciencehouse/zammad-websockets) - Zammad Websockets server
* [zammad](https://hub.docker.com/computersciencehouse/zammad) - Zammad main application

The included `docker-compose.yml` will orchestrate these containers into a fully functioning instance of Zammad.

## Usage

#### elasticsearch

See [Elastic's documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html). Changes: removed X-Pack, added mapper-attachments.

Exposes Elasticsearch on port `9200`.

#### proxy

The `proxy` container can be configured with the following environment variables:

| Variable              | Description                            | Required |
|-----------------------|----------------------------------------|----------|
| `ZAMMAD_HOSTNAME`     | Hostname of the `zammad` container     | Yes      |
| `WEBSOCKETS_HOSTNAME` | Hostname of the `websockets` container | Yes      |

Exposes Nginx on port `8080`.

This container must share the `/opt/zammad/public` folder via a shared volume with the `zammad` container in order for it to serve the compiled static assets. See `docker-compose.yml` for an example.

#### Common

The `zammad`, `scheduler`, and `websockets` containers can be configured with the following environment variables:

| Variable      | Description                                                          | Required |
|---------------|----------------------------------------------------------------------|----------|
| `DB_ADAPTER`  | Database adapter to use (options: `postgresql`, `mysql2`)            | Yes      |
| `DB_HOSTNAME` | Hostname of the database container or server                         | Yes      |
| `DB_PORT`     | Port of the database server (defaults to the adapter's default port) | No       |
| `DB_NAME`     | Name of the database                                                 | Yes      |
| `DB_USERNAME` | Username for the database user                                       | Yes      |
| `DB_PASSWORD` | Password for the database user                                       | No       |

#### scheduler

The `scheduler` container can be configured with the following environment variables, in addition to the above:

| Variable              | Description                            | Required |
|-----------------------|----------------------------------------|----------|
| `ZAMMAD_HOSTNAME`     | Hostname of the `zammad` container     | Yes      |

#### websockets

The `websockets` container can be configured with the following environment variables, in addition to the above:

| Variable              | Description                            | Required |
|-----------------------|----------------------------------------|----------|
| `ZAMMAD_HOSTNAME`     | Hostname of the `zammad` container     | Yes      |

Exposes the Websockets server on port `6042`.

#### zammad

The `zammad` container can be configured with the following environment variables, in addition to the above:

| Variable      | Description                                                  | Required |
|---------------|--------------------------------------------------------------|----------|
| `ES_HOSTNAME` | Hostname of the `elasticsearch` container or external server | Yes      |
| `ES_PORT`     | Port number of the Elasticsearch server (default: `9200`)    | Yes      |

Exposes the Rails server (Puma, by default) on port `3000`.

This container must share the `/opt/zammad/public` folder via a shared volume with the `proxy` container in order for the proxy to serve the compiled static assets. See `docker-compose.yml` for an example.


## Differences

This repository is different from the [official images](https://github.com/zammad/zammad-docker-compose) in the following ways:

* Hostnames and database/Elasticsearch connections are configured through environment variables (which also makes using external services easy)
* Both MySQL and PostgreSQL are supported
* The application is not tied to a local volume and is only updated when the `base` container is rebuilt
* Only the relevant data (i.e. the `/public` folder) is shared between the necessary containers
* Containers run as nonroot users off the bat instead of invoking gosu
* Permissions are handled for PaaS environments