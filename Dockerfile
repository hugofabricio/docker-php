FROM php:7.4-fpm
LABEL maintainer="me@hugofabricio.com"

# Installing dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-mysql-client \
    wget \
    fontconfig \
    libxrender1 \
    xfonts-75dpi \
    xfonts-base \
    libxml2-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libmagickwand-dev \
    libzip-dev \
    libonig-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    && pecl install imagick

# Install wkhtmltopdf
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb && \
    dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb && \
    apt-get install -f && \
    ln -s /usr/local/bin/wkhtmltopdf /usr/bin && \
    ln -s /usr/local/bin/wkhtmltoimage /usr/bin

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath opcache
RUN docker-php-ext-enable imagick

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Update timezone
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Recife /etc/localtime

# Setting locales
RUN echo pt_BR.UTF-8 UTF-8 > /etc/locale.gen && locale-gen

# Changing Workdir
WORKDIR /application
