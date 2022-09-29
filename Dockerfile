FROM  php:5.6.31-apache

# Installed required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends --force-yes locales libpng-dev libldap-dev libjpeg62-turbo-dev libfreetype6-dev libedit-dev libcurl4-openssl-dev libc-client-dev libkrb5-dev libreadline-dev librecode-dev libpq-dev libicu-dev libssl-dev libxml2-dev libsqlite3-dev libsqlite3-0 libtidy-dev libldap2-dev locales zip unzip telnet openssl fonts-liberation bash gettext-base curl
RUN rm -rf /var/lib/apt/lists/*

# Install php modules
RUN docker-php-ext-install iconv mysqli pdo pdo_mysql mysql
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install gd ldap
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install soap curl json mbstring zip intl dom bcmath ctype fileinfo pgsql session tokenizer xml xmlwriter recode xmlrpc imap tidy pdo pdo_pgsql

# Install Locales
RUN locale-gen fr_FR ISO-8859-1
RUN locale-gen fr_FR.UTF-8
RUN locale-gen en_US.UTF-8

RUN chmod 777 /var/run/apache2

#Config Apache
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN chgrp -R www-data /var/www
RUN find /var/www -type d -exec chmod 775 {} +
RUN find /var/www -type f -exec chmod 664 {} +
RUN service apache2 restart

EXPOSE 80
