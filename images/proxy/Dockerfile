FROM nginx
MAINTAINER Computer Science House

# Remove the default config file and set permissions
RUN rm -f /etc/nginx/conf.d/default.conf \
    && chmod -R og+rwx /etc/nginx/conf.d \
    && mkdir -p /var/cache/nginx \
    && chmod -R og+rwx /var/cache/nginx \
    && chmod og+rwx /var/run

# Copy our config template into the container
COPY zammad.conf.template /etc/nginx/conf.d/zammad.conf.template

# Expose ports
EXPOSE 8080

# Drop privileges
USER nginx

# At runtime, process the template and start Nginx with the resulting config
CMD envsubst '${ZAMMAD_HOSTNAME} ${WEBSOCKETS_HOSTNAME}' < /etc/nginx/conf.d/zammad.conf.template > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"
