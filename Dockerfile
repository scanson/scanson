#��������� ������� ����� Ubuntu 18.04
FROM ubuntu:18.04

#�������� ����������� ����������� Ubuntu
RUN apt-get update

#���������� nginx, php-fpm � supervisord
RUN apt-get install -y nginx php7.2-fpm supervisor && \
rm -rf /var/lib/apt/lists/*

#����������� ���������� �����
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/7.2/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf

#������������ ������������ ����� nginx ��� ������ � php-fpm
COPY default ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
echo "\ndaemon off;" >> ${nginx_conf}

#����������� ������������ supervisor
COPY supervisord.conf ${supervisor_conf}

RUN mkdir -p /run/php && \
chown -R www-data:www-data /var/www/html && \
chown -R www-data:www-data /run/php

#������������ ����
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

#��������� �������� � ������
COPY start.sh /start.sh
CMD ["./start.sh"]

#����� ��� nginx
EXPOSE 80 443