FROM computersciencehouse/zammad-base
MAINTAINER Computer Science House

# Install Nginx and Foreman
RUN DEPENDENCIES="nginx gettext-base" \
    set -ex \
      && apt-get update \
      && apt-get install -y --force-yes --no-install-recommends ${DEPENDENCIES} \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
      && sed -i "s/^user.*$/daemon off;/" /etc/nginx/nginx.conf \
      && rm -f /etc/nginx/conf.d/* /etc/nginx/sites-*/* \
      && ln -sf /dev/stdout /var/log/nginx/access.log \
      && ln -sf /dev/stderr /var/log/nginx/error.log \
      && mkdir -p /var/cache/nginx /var/lib/nginx \
      && chmod -R og+rwx /etc/nginx/conf.d /var/*/nginx \
      && chmod og+rwx /var/run \
      && gem install foreman

# Add Nginx config
COPY zammad.conf.template /etc/nginx/conf.d/zammad.conf.template

# Add Procfile
COPY Procfile* ${ZAMMAD_DIR}/

# Add entrypoint
COPY entrypoint.sh /
RUN chown ${ZAMMAD_USER}:${ZAMMAD_USER} /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    && ln -sf /dev/stdout ${ZAMMAD_DIR}/log/unicorn_access.log \
    && ln -sf /dev/stderr ${ZAMMAD_DIR}/log/unicorn_error.log

# Expose ports
EXPOSE 3000 8080

# Drop privileges
USER ${ZAMMAD_USER}

CMD ["/entrypoint.sh"]
