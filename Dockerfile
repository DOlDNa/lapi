FROM php:8.3-apache-bookworm

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales locales-all \
    libonig-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libc-client-dev \
    libkrb5-dev \
    msmtp \
    libmagickwand-dev && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod expires headers rewrite

# Install PECL extensions
RUN pecl install imap imagick

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install intl exif gd && \
    docker-php-ext-enable imap imagick

# Ensure PHP uses OpenSSL
ENV PHP_OPENSSL=yes

# Update www-data user and group
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "ErrorLog /tmp/error.log" >> /etc/apache2/apache2.conf
RUN echo "DirectoryIndex index.html index.php" >> /etc/apache2/mods-available/dir.conf
RUN echo "ErrorLog /tmp/error.log\n#CustomLog /tmp/access.log combined" >> /etc/apache2/sites-available/000-default.conf
RUN echo "[system_default_sect]\nMinProtocol = None\nCipherString = DEFAULT" >> /etc/ssl/openssl.cnf

# Clean up source files
RUN docker-php-source delete

# Remove unnecessary packages
RUN apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

