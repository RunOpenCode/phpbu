FROM php:7.1.1

ARG PHPBU_VERSION=5.2.10

#####################################################################################
#                                                                                   #
#                                 Setup PHP & Extensions                            #
#                                                                                   #
#####################################################################################

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		libedit2 \
		libsqlite3-0 \
		libxml2 \
		xz-utils \
		wget \
		zip \
		git \
		autoconf \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxslt-dev \
        libbz2-dev \
        make \
        unzip \
        bzip2 \
        libicu-dev \
        mysql-client \
      && echo "#Installing php extensions" \
      && docker-php-ext-install bcmath mcrypt zip bz2 mbstring pcntl xsl intl && \
         docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
         docker-php-ext-install gd && \
         docker-php-ext-install opcache && \
         docker-php-ext-install mbstring pdo pdo_mysql zip \
      && echo "PHP Parameters" \
        && echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
        && echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini \
      && echo "#Setup PHPBU" \
        && curl -L -o /usr/local/bin/phpbu.phar https://github.com/sebastianfeldmann/phpbu/releases/download/${PHPBU_VERSION}/phpbu-${PHPBU_VERSION}.phar \
        && ln -s /usr/local/bin/phpbu.phar /usr/local/bin/phpbu \
        && chmod +x /usr/local/bin/phpbu

####################################################################################
#                                                                                  #
#                               Setup workspace dir                                #
#                                                                                  #
####################################################################################

WORKDIR /workspace
VOLUME ["/workspace","/backups","/etc/phpbu"]

ENTRYPOINT ["/usr/local/bin/phpbu"]
CMD ["--configuration=/etc/phpbu/script.xml"]
