############################################################
# Dockerfile to build Catchall HTTP container images
# Based on php:7.2
############################################################

# Set the base image to php:7.0
FROM php:7.2-apache

MAINTAINER Fabwice.com

#Set the work directory  
WORKDIR /var/www/html

# Install a sweet ass profile
COPY bashrc ~/.bashrc

# Update the repository sources list
RUN apt update --fix-missing

# Install essentials
RUN apt install -y git curl wget zip unzip

# Install Composer
RUN mkdir -p ~/.composer/vendor/bin
RUN curl -o installer.php https://getcomposer.org/installer && php installer.php --install-dir ~/.composer/vendor/bin && rm installer.php

# Clean up
RUN rm -rf /var/www/*

# Configure apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod status rewrite

# Copy in required files
COPY app/ /var/www/html/

# Make composer work globally ;)
RUN mv ~/.composer/vendor/bin/composer.phar ~/.composer/vendor/bin/composer

# Expose ports
EXPOSE 80

RUN service apache2 start
