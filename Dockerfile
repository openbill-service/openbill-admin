FROM brandymint/teamcity-agent
MAINTAINER danil@brandymint.ru

ENV PATH $HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
ENV RUBY_VERSION 2.2.5
WORKDIR /opt/openbill
ADD . /opt/openbill/openbill-admin
RUN set -x && \
  cd /opt/openbill/openbill-admin && \
  echo "gem: --no-document" | tee /root/.gemrc && \
  gem install bundler && \
  bundle install 
  # bundle exec rake assets:precompile && \

RUN set -x && \
  mkdir -pv tmp/pids && \
  mkdir -pv tmp/cache && \
  mkdir -pv log && \
  mkdir -pv tmp/sockets && \
  mkdir -pv config/settings && \
  chown openbill:openbill -R /opt/openbill && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer && \
  echo 'git clone OK'

RUN ln -sf /dev/stderr /opt/openbill/openbill-admin/log/unicorn.stderr.log; \
    ln -sf /dev/stdout /opt/openbill/openbill-admin/log/production.log; \
    ln -sf /dev/stdout /opt/openbill/openbill-admin/log/unicorn.stdout.log

# USER wwwkiiiosk
# EXPOSE 3031
# CMD ["bundle", "exec puma -t 1:2 -p 3031"]
