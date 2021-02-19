FROM centos:8
ENV container docker
MAINTAINER "Reynier de la Rosa" <reynier.delarosa@outlook.es>
RUN dnf -y install epel-release
RUN dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf module -y enable nginx:mainline
RUN dnf module -y install php:remi-8.0
RUN dnf -y install dnf-plugins-core
RUN dnf config-manager --add-repo https://packages.microsoft.com/config/rhel/8/prod.repo
ENV ACCEPT_EULA=Y
ENV PATH=${PATH}:/opt/mssql/bin:/opt/mssql-tools/bin
RUN dnf --enablerepo=powertools -y install tinyxml2
RUN dnf -y install msodbcsql17 \
               mssql-tools \
               unixODBC-devel \
               gettext \
               unzip \
               git \
               nginx \
               supervisor
RUN dnf --enablerepo=remi-modular-test -y install php-gd \
               php-intl \
               php-json \
               php-opcache \
               php-pdo \
               php-sqlsrv \
               php-bcmath \
               php-pecl-uuid \
               php-pecl-zip \
               php-pecl-memcached \
               php-pecl-imagick
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN ln -sf /dev/stderr /var/log/php-fpm/error.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stderr /var/log/php-fpm/www-error.log
EXPOSE 443 80
WORKDIR /usr/share/nginx/html/api
RUN mkdir -p /run/php-fpm
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
