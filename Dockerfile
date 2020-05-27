FROM centos:8
ENV container docker
MAINTAINER "Reynier de la Rosa" <reynier.delarosa@outlook.es>

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf module reset php
RUN dnf module -y install php:remi-7.4
RUN dnf -y install dnf-plugins-core
RUN dnf config-manager --add-repo https://packages.microsoft.com/config/rhel/8/prod.repo
ENV ACCEPT_EULA=Y
ENV PATH=${PATH}:/opt/mssql/bin:/opt/mssql-tools/bin
RUN dnf --enablerepo=PowerTools -y install tinyxml2
RUN dnf -y install msodbcsql17 \
               mssql-tools \
               unixODBC-devel \
               gettext \
               unzip \
               git
RUN dnf --enablerepo=remi-modular-test -y install php-fpm \
               php-cli \
               php-common \
               php-gd \
               php-intl \
               php-json \
               php-mbstring \
               php-mcrypt \
               php-opcache \
               php-pdo \
               php-xml \
               php-sqlsrv \
               php-bcmath \
               php-pecl-uuid \
               php-pecl-zip \
               php-pecl-memcached \
               php-pecl-imagick \
               php-pecl-xdebug
 
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN ln -sf /dev/stderr /var/log/php-fpm/error.log
 
EXPOSE 9050

ADD container-files/script/* /tmp/script/
RUN chmod +x /tmp/script/bootstrap.sh
RUN mkdir -p /run/php-fpm

# put customized config and code files to /data

ENTRYPOINT ["/tmp/script/bootstrap.sh"]
