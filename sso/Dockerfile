# Dockerfile
FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Brussels
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
RUN echo "Europe/Brussels" > /etc/timezone

#Update Packages List
RUN echo "APT::Install-Suggests \"false\";\nAPT::Install-Recommends \"false\";" >> /etc/apt/apt.conf
# Don't allow services to start when building the image
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d
RUN sed -i "s%httpredir.debian.org%debian.mirrors.ovh.net%g" /etc/apt/sources.list
RUN apt update && apt install -y \
  bash-completion \
  cron \
  curl \
  debian-archive-keyring \
  gettext \
  gnupg \
  libjs-jquery \
  netcat \
  nginx \
  procps \
  python-dns \
  rsyslog \
  vim.nox \
  wget

RUN echo "deb http://deb.entrouvert.org/ buster main" > /etc/apt/sources.list.d/entrouvert-local.list
RUN echo "deb http://debian.mirrors.ovh.net/debian buster-backports main" > /etc/apt/sources.list.d/backports.list
RUN curl https://deb.entrouvert.org/entrouvert.gpg | apt-key add -

RUN apt update && apt install -y \
  entrouvert-repository \
  entrouvert-repository-hotfix \
  entrouvert-repository-eobuilder \
  && apt update
# RUN apt -o Acquire::Check-Valid-Until=false update && apt install -y entrouvert-repository entrouvert-repository-hotfix entrouvert-repository-eobuilder && apt -o Acquire::Check-Valid-Until=false update
RUN echo "Package: *\nPin: release a=buster-eobuilder\nPin-Priority: 400" > /etc/apt/preferences.d/entrouvert-eobuilder

RUN apt install -y \
  combo \
  hobo \
  publik-base-theme \
  imio-publik-themes \
  authentic2-multitenant \
  prometheus-entrouvert-exporter
RUN apt install -y -t buster-eobuilder \
  python3-authentic2-auth-fedict \
  python3-authentic2-wallonie-connect \
  python3-pycryptodome

# Allow services to start, this is necessary as hobo-agent postinst will fail
# if supervisord is not running
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN apt install -y hobo-agent

#cleanup
RUN rm -f /etc/default/authentic2-multitenant
RUN apt -y remove python-dev && apt -y autoremove && apt clean
COPY fix-permissions.sh /etc/hobo/fix-permissions.sh
COPY mail-translation.py /var/lib/authentic2/locale/fr/LC_MESSAGES/
COPY custom_error.html /usr/share/nginx/html/custom_error.html
ADD bash-vim.tar.gz /

COPY update_oidc.sh /
COPY run.sh /
COPY prometheus_uwsgi_exporter.py /usr/bin/
RUN crontab -l | { cat; echo "* * * * * /usr/bin/prometheus_uwsgi_exporter.py"; } | crontab -
COPY prometheus_user_exporter.py /usr/bin/
RUN ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
CMD ["/run.sh"]
