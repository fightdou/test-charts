Listen 0.0.0.0:5000
Listen 0.0.0.0:35357

ServerSignature Off
ServerTokens Prod
TraceEnable off

ErrorLog "/var/log/kolla/keystone/apache-error.log"
<IfModule log_config_module>
    CustomLog "/var/log/kolla/keystone/apache-access.log" common
</IfModule>

<Directory "/usr/bin/">
    <FilesMatch "^keystone-wsgi-(public|admin)$">
        AllowOverride None
        Options None
        Require all granted
    </FilesMatch>
</Directory>

<VirtualHost *:5000>
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP} python-path=/usr/lib/python3/dist-packages
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /usr/bin/keystone-wsgi-public
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    <IfVersion >= 2.4>
        ErrorLogFormat "%{cu}t %M"
    </IfVersion>
    ErrorLog "/var/log/kolla/keystone/keystone-apache-public-error.log"
    LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b %D \"%{Referer}i\" \"%{User-Agent}i\"" logformat
    CustomLog "/var/log/kolla/keystone/keystone-apache-public-access.log" logformat

</VirtualHost>

<VirtualHost *:35357>
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP} python-path=/usr/lib/python3/dist-packages
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    <IfVersion >= 2.4>
        ErrorLogFormat "%{cu}t %M"
    </IfVersion>
    ErrorLog "/var/log/kolla/keystone/keystone-apache-admin-error.log"
    LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b %D \"%{Referer}i\" \"%{User-Agent}i\"" logformat
    CustomLog "/var/log/kolla/keystone/keystone-apache-admin-access.log" logformat

</VirtualHost>
