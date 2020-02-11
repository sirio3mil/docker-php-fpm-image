FROM centos:8
ENV container docker
MAINTAINER "Reynier de la Rosa" <reynier.delarosa@outlook.es>

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf -y install yum-utils
RUN dnf module reset php
RUN dnf module -y install php:remi-7.4
RUN curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/mssql-release.repo
ENV ACCEPT_EULA=Y
ENV PATH=${PATH}:/opt/mssql/bin:/opt/mssql-tools/bin
RUN dnf --enablerepo=remi-modular-test -y install msodbcsql \
               msodbcsql17 \
               mssql-tools \
               unixODBC-devel \
               gettext \
               mediainfo \
               openldap-clients \
               freetds \
               php-fpm \ 
               php-cli \
               php-common \
               php-gd \
               php-intl \
               php-json \
               php-ldap \
               php-mbstring \
               php-mcrypt \
               php-opcache \
               php-pdo \
               php-pdo-dblib \
               php-soap \
               php-xml \
               php-mysqlnd \
               php-gmp \
               php-bcmath \
               php-mhash \
               php-xsl \
               php-pear \
               php-soap \
               php-sqlsrv \
               php-tidy \
               php-pecl-uuid \
               php-pecl-zip \
               php-pecl-mongodb \
               php-pecl-couchbase \
               php-pecl-apcu \
               php-pecl-memcached \
               php-pecl-gearman \
               php-pecl-mailparse \
               php-pecl-imagick \
               php-pecl-xdebug \
               unzip
 
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN ln -sf /dev/stderr /var/log/php-fpm/error.log
 
EXPOSE 9050

ADD container-files/script/* /tmp/script/
RUN chmod +x /tmp/script/bootstrap.sh

# put customized config and code files to /data

ENTRYPOINT ["/tmp/script/bootstrap.sh"]
