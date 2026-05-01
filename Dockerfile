FROM php:8-apache

# Install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libonig-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        msmtp \
        libmagickwand-dev \
        locales \
        fonts-ipafont-gothic && \
    sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# Apache modules
RUN a2enmod expires headers rewrite && \
    a2dismod status

# PHP extensions
RUN pecl install imagick && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install intl exif gd && \
    docker-php-ext-enable imagick

# Apache settings
RUN { \
    echo "ServerName localhost"; \
    echo "ErrorLog /tmp/error.log"; \
} >> /etc/apache2/apache2.conf

RUN echo "DirectoryIndex index.html index.php" > /etc/apache2/mods-available/dir.conf

RUN { \
    echo "ErrorLog /tmp/error.log"; \
    echo "#CustomLog /tmp/access.log combined"; \
} > /etc/apache2/sites-available/000-default.conf

RUN { \
    echo "ServerTokens Prod"; \
    echo "ServerSignature Off"; \
    echo "TraceEnable Off"; \
    echo "Header always append X-Frame-Options SAMEORIGIN"; \
    echo "Header set X-XSS-Protection \"1; mode=block\""; \
    echo "Header set X-Content-Type-Options nosniff"; \
} > /etc/apache2/conf-available/security.conf

RUN { \
    echo "expose_php = Off"; \
    echo "session.cookie_httponly = 1"; \
    echo "session.cookie_secure = 1"; \
} > /usr/local/etc/php/conf.d/security.ini

# ImageMagick security
RUN mkdir -p /etc/ImageMagick-6/policy.d && \
    echo "<policy domain=\"coder\" rights=\"none\" pattern=\"EPHEMERAL\" />" \
    "<policy domain=\"coder\" rights=\"none\" pattern=\"URL\" />" \
    "<policy domain=\"coder\" rights=\"none\" pattern=\"HTTPS\" />" \
    "<policy domain=\"coder\" rights=\"none\" pattern=\"MVG\" />" \
    > /etc/ImageMagick-6/policy.d/disable-dangerous-coders.xml

# Change user at the end
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
