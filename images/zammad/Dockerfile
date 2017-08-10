FROM computersciencehouse/zammad-base
MAINTAINER Computer Science House

# Expose ports
EXPOSE 3000

# Add entrypoint
COPY entrypoint.sh /
RUN chown ${ZAMMAD_USER}:${ZAMMAD_USER} /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    && ln -sf /dev/stdout ${ZAMMAD_DIR}/log/unicorn_access.log \
    && ln -sf /dev/stderr ${ZAMMAD_DIR}/log/unicorn_error.log

# Drop privileges
USER ${ZAMMAD_USER}

CMD ["/entrypoint.sh"]
