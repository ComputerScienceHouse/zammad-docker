FROM computersciencehouse/zammad-base
MAINTAINER Computer Science House

# Add entrypoint
COPY entrypoint.sh /
RUN chown ${ZAMMAD_USER}:${ZAMMAD_USER} /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    && ln -sf /dev/stdout ${ZAMMAD_DIR}/log/scheduler_out.log \
    && ln -sf /dev/stderr ${ZAMMAD_DIR}/log/scheduler_err.log \
    && chmod -R og+rwx ${ZAMMAD_DIR}/log \
    && chmod -R og+rwx ${ZAMMAD_DIR}/tmp

ENTRYPOINT ["/entrypoint.sh"]
