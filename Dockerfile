FROM centos:latest
ENV container docker
MAINTAINER "Reynier de la Rosa" <reynier.delarosa@outlook.es>

RUN yum -y update
RUN yum -y install epel-release \
                   wget \
                   yum-utils
RUN wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm
RUN yum-config-manager --enable remi-php73
RUN yum-config-manager --enable remi-php73-test
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN ACCEPT_EULA=Y yum install -y msodbcsql msodbcsql17 mssql-tools unixODBC-devel
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc
RUN yum install -y gettext \ 
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
RUN yum clean all 
 
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN ln -sf /dev/stderr /var/log/php-fpm/error.log
 
EXPOSE 9050

ADD container-files/script/* /tmp/script/
RUN chmod +x /tmp/script/bootstrap.sh

# put customized config and code files to /data

ENTRYPOINT ["/tmp/script/bootstrap.sh"]
