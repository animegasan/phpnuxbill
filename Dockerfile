# Startup from alpine
FROM alpine:latest
LABEL Maintainer = "Hilman Maulana, Ibnu Maksum"
LABEL Description = "PHPNuxBill (PHP Mikrotik Billing) is a web-based application (MikroTik API PHP class) Voucher management for MikroTik Hotspot."

# Setup document root
WORKDIR /var/www/html

# Expose the port nginx is reachable on
EXPOSE 80
EXPOSE 3306

# Install packages
RUN apk add --no-cache \
    nginx \
    php81 \
    php81-fpm \
    php81-gd \
    php81-mbstring \
    php81-mysqli \
    php81-session \
    php81-pdo \
    php81-pdo_mysql \
    mysql \
    mysql-client \
    supervisor

# Configure nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Configure MySQL
COPY conf/my.cnf /etc/mysql/my.cnf
COPY conf/mysql.sh /app/mysql.sh

# Configure PHP-FPM
COPY conf/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY conf/php.ini /etc/php81/conf.d/custom.ini

# Configure supervisord
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
COPY --chown=nginx src /var/www/html/

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
