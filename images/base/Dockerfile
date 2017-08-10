FROM ruby:2.3.1-slim
MAINTAINER Computer Science House

ENV ZAMMAD_DIR /opt/zammad
ENV ZAMMAD_USER zammad
ENV RAILS_ENV production
ENV RAILS_SERVER puma
ENV GIT_URL https://github.com/zammad/zammad.git
ENV GIT_BRANCH stable

RUN BUILD_DEPENDENCIES="git build-essential libffi-dev libpq5 libpq-dev libmysqlclient-dev" \
    set -ex \
  	  && apt-get update \
      && apt-get install -y --force-yes --no-install-recommends ${BUILD_DEPENDENCIES} \
      && apt-get clean \
      && useradd -M -d ${ZAMMAD_DIR} ${ZAMMAD_USER} \
      && cd $(dirname ${ZAMMAD_DIR}) \
      && git clone --depth 1 -b "${GIT_BRANCH}" "${GIT_URL}" \
      && cd ${ZAMMAD_DIR} \
      && bundle install --without test development \
      && contrib/packager.io/fetch_locales.rb \
      && sed -e 's#.*adapter: postgresql#  adapter: nulldb#g' -e 's#.*username:.*#  username: postgres#g' -e 's#.*password:.*#  password: \n  host: zammad-postgresql\n#g' < config/database.yml.pkgr > config/database.yml \
      && bundle exec rake assets:precompile \
      && rm -f config/database.yml \
      && rm -rf tmp/cache \
      && chown -R ${ZAMMAD_USER}:${ZAMMAD_USER} ${ZAMMAD_DIR}

COPY database.yml ${ZAMMAD_DIR}/config/
WORKDIR ${ZAMMAD_DIR}
