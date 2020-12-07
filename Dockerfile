#Загрузить базовый образ Ubuntu 18.04
FROM ubuntu:18.04

#Обновить программный репозиторий Ubuntu
RUN apt-get update

#Установить nginx, php-fpm и supervisord
RUN apt-get install -y nginx php7.2-fpm supervisor && \
rm -rf /var/lib/apt/lists/*

#Определение переменных среды
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/7.2/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf

#Конфигугация виртуального хоста nginx для работы с php-fpm
COPY default ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
echo "\ndaemon off;" >> ${nginx_conf}

#Копирование конфигурации supervisor
COPY supervisord.conf ${supervisor_conf}

RUN mkdir -p /run/php && \
chown -R www-data:www-data /var/www/html && \
chown -R www-data:www-data /run/php

#Конфигурация тома
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

#Настройка сервисов и портов
COPY start.sh /start.sh
CMD ["./start.sh"]

#Порты для nginx
EXPOSE 80 443