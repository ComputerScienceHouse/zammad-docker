FROM nginx
MAINTAINER Computer Science House

# Remove the default config file
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy our config template into the container
COPY zammad.tpl /etc/nginx/conf.d/zammad.tpl

# Expose ports
EXPOSE 8080

# At runtime, process the template and start Nginx with the resulting config
CMD envsubst '${ZAMMAD_HOSTNAME} ${WEBSOCKETS_HOSTNAME}' < /etc/nginx/conf.d/zammad.tpl > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"
