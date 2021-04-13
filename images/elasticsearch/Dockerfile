FROM docker.elastic.co/elasticsearch/elasticsearch:7.12.0
MAINTAINER Computer Science House

RUN set -ex \
      && echo vm.max_map_count=262144 >> /etc/sysctl.conf \
      && /usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack --purge \
      && yes | /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-attachments \
      && find /usr/share/elasticsearch -type d -exec chmod og+rwx {} \; \
      && find /usr/share/elasticsearch -type f -exec chmod +r {} \; \
      && chmod +x /usr/share/elasticsearch/bin/*
