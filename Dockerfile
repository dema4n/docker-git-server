FROM debian:9.8
MAINTAINER Dmitry Krakhmalev

# Install system apps
RUN apt-get update && apt-get install -y \
    git=1:2.11.0-3+deb9u4 \
    gitweb=1:2.11.0-3+deb9u4 \
    apache2=2.4.25-3+deb9u6 \
    apache2-utils=2.4.25-3+deb9u6 \
    openssh-server=1:7.4p1-10+deb9u6 \
    gosu=1.10-1+b2 \
    sudo=1.8.19p1-2.1

# Create and configure httpd user
RUN useradd -m httpd
RUN echo "httpd ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Prepare folders for ssh keys and git repositories
USER httpd
RUN mkdir -p /home/httpd/.ssh && mkdir -p /home/httpd/git/repos
USER root

# Activate Apache modules
RUN a2enmod ssl cgid alias env

# Change Apache settings
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed "s|export APACHE_RUN_USER=www-data|export APACHE_RUN_USER=httpd|g" -i /etc/apache2/envvars

# Apache configuration
COPY configs/000-default.conf        /etc/apache2/sites-available/000-default.conf
COPY configs/default-ssl.conf        /etc/apache2/sites-available/default-ssl.conf
COPY configs/gitweb.conf             /etc/gitweb.conf
COPY ssl                             /etc/gitdata

# Create authentication file for https connection
RUN htpasswd -c -b /etc/gitdata/gitusers.passwd httpd httpd

# Enable site in Apache server
RUN a2ensite default-ssl

EXPOSE 22 443

COPY root-entrypoint.sh       /usr/local/bin/root-entrypoint.sh
COPY httpd-entrypoint.sh      /usr/local/bin/httpd-entrypoint.sh

ENTRYPOINT ["root-entrypoint.sh"]

# Start Apache server
CMD ["sudo", "apachectl", "-D", "FOREGROUND"]