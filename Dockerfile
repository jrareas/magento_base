FROM php:7.2-apache
COPY . /app
WORKDIR  /app

ARG MAGENTO_PUB_KEY
ARG MAGENTO_PRIV_KEY

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libicu-dev \
        libxml2-dev \
        libxslt-dev \
        cron \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install intl \
    && docker-php-ext-install soap \
    && docker-php-ext-install xsl \
    && docker-php-ext-install sockets \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer global config http-basic.repo.magento.com ${MAGENTO_PUB_KEY} ${MAGENTO_PRIV_KEY}

RUN if [ -f composer.json ]; then composer install; fi
RUN a2enmod rewrite