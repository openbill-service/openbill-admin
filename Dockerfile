FROM ubuntu:14.04
MAINTAINER danil@brandymint.ru

RUN set -x && locale-gen en_US.UTF-8 && \
    groupadd openbill && \
    useradd -s /bin/sh -d /opt/openbill -g openbill openbill


ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


RUN set -x && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install curl git software-properties-common apt-transport-https && \
  curl http://deb.repo.brandymint.ru/pubkey.asc | apt-key add -; \
  curl https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -; \
  add-apt-repository -y "deb http://deb.repo.brandymint.ru/ trusty main" && \
  add-apt-repository -y "ppa:webupd8team/java" && \
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -; \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && echo 'apt-get OK' && \
  apt-get -y install ruby-2.2.5 libpq-dev oracle-java8-installer nodejs

WORKDIR /opt/openbill
ADD openbill-admin/ /opt/openbill/openbill-admin
RUN set -x && \
  cd /opt/openbill/openbill-admin && \
  echo "gem: --no-document" | tee /root/.gemrc && \
  gem install bundler && \
  bundle install && \
  bundle exec rake assets:precompile && \
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

USER openbill
EXPOSE 3031
CMD ["unicorn", "-c", "/opt/openbill/openbill-admin/config/unicorn.rb"]
