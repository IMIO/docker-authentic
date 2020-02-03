# Dockerfile
FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
RUN echo "Europe/Brussels" > /etc/timezone
RUN dpkg-reconfigure tzdata

#Update Packages List
RUN echo "APT::Install-Suggests \"false\";\nAPT::Install-Recommends \"false\";" >> /etc/apt/apt.conf
# Don't allow services to start when building the image
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d
RUN sed -i "s%httpredir.debian.org%debian.mirrors.ovh.net%g" /etc/apt/sources.list
RUN apt update && apt install -y nginx wget gnupg debian-archive-keyring rsyslog python-dns gettext vim.nox bash-completion libjs-jquery cron procps curl


RUN echo "deb http://deb.entrouvert.org/ stretch main" > /etc/apt/sources.list.d/entrouvert-local.list
RUN echo "deb http://debian.mirrors.ovh.net/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list
RUN curl https://deb.entrouvert.org/entrouvert.gpg | apt-key add -

RUN apt update && apt install -y entrouvert-repository entrouvert-repository-hotfix entrouvert-repository-eobuilder && apt update
RUN echo "Package: *\nPin: release a=stretch-eobuilder\nPin-Priority: 400" > /etc/apt/preferences.d/entrouvert-eobuilder

RUN apt install -y combo hobo publik-base-theme imio-publik-themes
RUN apt install -y -t stretch-eobuilder authentic2-multitenant python-authentic2-auth-fedict python-authentic2-wallonie-connect

# Allow services to start, this is necessary as hobo-agent postinst will fail
# if supervisord is not running
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN apt install -y hobo-agent

#cleanup
RUN rm -f /etc/default/authentic2-multitenant
RUN apt -y remove python-dev && apt -y autoremove && apt clean
COPY fix-permissions.sh /etc/hobo/fix-permissions.sh
ADD bash-vim.tar.gz /

COPY update_oidc.sh /
COPY run.sh /
CMD ["/run.sh"]
