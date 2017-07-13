FROM ubuntu:17.04

RUN apt-get -y update && apt-get install -y \
   apache2 \
   cron \
   curl \
   less \
   libapache2-mod-php \
   mysql-client \
   nano \
   p7zip \
   php \
   php-curl \
   php-gd \
   php-mbstring \
   php-mcrypt \
   php-mysql \
   php-xml \
   php-xmlrpc \
   wget

RUN cp /etc/apache2/conf-available/security.conf /etc/apache2/conf-available/security_old.conf; \
   cat /etc/apache2/conf-available/security.conf | sed -e 's#ServerTokens OS#ServerTokens Prod#g' -e 's#ServerSignature On#ServerSignature Off#g' > security.conf; \
   cat /etc/apache2/apache2.conf | sed "s#Timeout 300#Timeout 30#g" > apache2.conf; \
   mv apache2.conf /etc/apache2/apache2.conf; \
   mv security.conf /etc/apache2/conf-available/security.conf

WORKDIR /setup
RUN wget https://wordpress.org/latest.tar.gz; \
   tar xzvf latest.tar.gz; \
   touch /setup/wordpress/.htaccess; \
   chmod 660 /setup/wordpress/.htaccess; \
   cp /setup/wordpress/wp-config-sample.php /setup/wordpress/wp-config.php; \
   mkdir /setup/wordpress/wp-content/upgrade

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
   chmod +x wp-cli.phar; \
   mv wp-cli.phar /usr/local/bin/wp; \
   echo "alias wpc='wp --allow-root'" > /root/.bash_aliases

COPY helper/wordpress-* /usr/bin/

RUN chmod 700 /usr/bin/wordpress-*

ENTRYPOINT ["wordpress-configure"]

   




