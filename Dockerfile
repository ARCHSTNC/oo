FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

#RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade

RUN apt-get update \
  && apt-get install -y tzdata locales \
  && rm -rf /var/lib/apt/lists/* \
  && echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && locale-gen en_US.UTF-8 ja_JP.UTF-8 \
  && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update
RUN apt-get install -y git gitweb highlight
RUN rm -rf /usr/share/gitweb/static
RUN git clone https://github.com/kogakure/gitweb-theme.git /usr/share/gitweb/static
  
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
RUN a2enconf fqdn
RUN a2enmod cgid

COPY apache2/000-default.conf /etc/apache2/sites-available/
COPY apache2/gitweb.conf /etc/apache2/conf-available/
#RUN sed -e "s%/var/www/html%/usr/share/gitweb%g" /etc/apache2/sites-available/000-default.conf
#RUN sed -e "/Alias/s/^/#/g" /etc/apache2/conf-available/gitweb.conf

COPY gitweb/gitweb.conf /etc/gitweb.conf
#RUN sed -e '$a $highlight_bin = "/usr/bin/highlight";\n$feature{'highlight'}{'default'} = [1];' /etc/gitweb.conf

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]