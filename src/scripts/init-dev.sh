#! /bin/sh

# base things
test -L /usr/share/publik/themes/imio || mv /usr/share/publik/themes/imio /usr/share/publik/themes/imio-orig
rm -f /etc/nginx/sites-enabled/default
cp /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# imio-publik-themes
if [ -d /opt/publik/imio-publik-themes ]
then
	rm -f /usr/share/publik/themes/imio
	ln -s /opt/publik/imio-publik-themes /usr/share/publik/themes/imio
else
	rm -f /usr/share/publik/themes/imio
	ln -s imio-orig /usr/share/publik/themes/imio
fi

# combo
if [ -d /opt/publik/combo ]
then
	sed -i 's/proxy_pass.*combo.*/proxy_pass http:\/\/127.0.0.1:8010;/' /etc/nginx/sites-enabled/default
fi

# authentic
if [ -d /opt/publik/authentic ]
then
	sed -i 's/proxy_pass.*authentic.*/proxy_pass http:\/\/127.0.0.1:8012;/' /etc/nginx/sites-enabled/default
fi

# authentic2-auth-fedict
if [ -d /opt/publik/authentic2-auth-fedict ]
then
	(cd /opt/publik/authentic2-auth-fedict && python setup.py develop --no-deps)
fi

service nginx reload
