FROM computersciencehouse/zammad-base
MAINTAINER Computer Science House

# Expose ports
EXPOSE 6042

# Add entrypoint
COPY entrypoint.sh /
RUN chown ${ZAMMAD_USER}:${ZAMMAD_USER} /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    && ln -sf /dev/stdout ${ZAMMAD_DIR}/log/websocket-server_out.log \
    && ln -sf /dev/stderr ${ZAMMAD_DIR}/log/websocket-server_err.log

# Drop privileges
USER ${ZAMMAD_USER}

CMD ["/entrypoint.sh"]
