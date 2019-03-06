# Dockerfile
FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
RUN echo "Europe/Brussels" > /etc/timezone
RUN dpkg-reconfigure tzdata

#Update Packages List
RUN echo "APT::Install-Suggests \"false\";\nAPT::Install-Recommends \"false\";" >> /etc/apt/apt.conf
# Don't allow services to start when building the image
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d
RUN sed -i "s%httpredir.debian.org%debian.mirrors.ovh.net%g" /etc/apt/sources.list
RUN apt-get update && apt-get install -y nginx wget gnupg debian-archive-keyring rsyslog python-dns gettext vim.nox bash-completion libjs-jquery cron procps
RUN wget -O - http://deb.entrouvert.org/entrouvert.gpg | apt-key add -
RUN echo "deb http://http.debian.net/debian stretch-backports main"> /etc/apt/sources.list.d/backports.list
RUN echo "deb http://deb.entrouvert.org/ stretch main\ndeb http://deb.entrouvert.org/ stretch-eobuilder main\ndeb http://deb.entrouvert.org/ stretch-testing main\n" > /etc/apt/sources.list.d/entrouvert.list
RUN echo "Package: *\nPin: release a=stretch-eobuilder\nPin-Priority: 900" > /etc/apt/preferences.d/stretch-eobuilder.pref
RUN apt-get update
RUN apt install -y -t stretch-backports python-django python-django-common
RUN apt-get install -y -t stretch combo hobo libjs-leaflet publik-base-theme python-suds python-django-filters imio-publik-themes python-authentic2-auth-fedict
RUN apt install -y -t stretch-eobuilder authentic2-multitenant python-authentic2

# Allow services to start, this is necessary as hobo-agent postinst will fail
# if supervisord is not running
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN apt-get install -y -t stretch hobo-agent

# authentic
RUN ln -s /usr/lib/python2.7/dist-packages/authentic2/static/authentic2 /var/lib/authentic2-multitenant/static/
RUN ln -s /usr/lib/python2.7/dist-packages/authentic2/static/jquery /var/lib/authentic2-multitenant/static/
RUN ln -s /usr/lib/python2.7/dist-packages/authentic2/static/ulx /var/lib/authentic2-multitenant/static/
RUN chown -R www-data:www-data /var/lib/authentic2-multitenant/static

#cleanup
RUN rm -f /etc/default/authentic2-multitenant
RUN apt-get -y remove python-dev && apt-get -y autoremove && apt-get clean
COPY fix-permissions.sh /etc/hobo/fix-permissions.sh
ADD bash-vim.tar.gz /

COPY run.sh /
CMD ["/run.sh"]
