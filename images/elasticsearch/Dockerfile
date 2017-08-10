FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.1
MAINTAINER Computer Science House

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack --purge \
    && yes | /usr/share/elasticsearch/bin/elasticsearch-plugin install mapper-attachments \
    && chmod -R og+rwx /usr/share/elasticsearch/data
