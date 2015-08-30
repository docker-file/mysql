##
##   Copyright (c) 2015, Dmitry Kolesnikov
##   All Rights Reserved.
##
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
##
FROM centos:latest

##
## install dependencies
RUN \
   yum -y install \
      sudo        \
      tar         \
      unzip       \
      nc          \
      hostname    \
      libselinux-utils \
      device-mapper-libs

RUN \
   yum -y install \
      perl        \
      perl-Data-Dumper \
      openssl     \
      libaio

##
## config
WORKDIR /usr/local

RUN curl -k -L -O \
   https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.24-72.2/binary/tarball/Percona-Server-5.6.24-rel72.2-Linux.x86_64.ssl101.tar.gz
RUN tar -xvf Percona-Server-5.6.24-rel72.2-Linux.x86_64.ssl101.tar.gz
RUN ln -s Percona-Server-5.6.24-rel72.2-Linux.x86_64.ssl101 mysql

##
## mysql config
WORKDIR /usr/local/mysql
RUN \
   groupadd mysql   && \
   useradd -r -g mysql mysql && \
   chown -R mysql . && \
   chgrp -R mysql . && \
   scripts/mysql_install_db --user=mysql --basedir=. && \
   chown -R root .  && \
   chown -R mysql data

RUN cp support-files/mysql.server /etc/init.d/mysqld
ADD my.cnf  /etc/my.cnf

RUN \
   /etc/init.d/mysqld start && \
   ./bin/mysqladmin -u root password 'root' && \
   ./bin/mysql -uroot -proot -h127.0.0.1 \
         -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;" && \
   ./bin/mysql -uroot -proot -h127.0.0.1 \
         -e "install plugin handlersocket soname 'handlersocket.so';" && \
   /etc/init.d/mysqld stop

EXPOSE 3306

CMD /usr/local/mysql/bin/mysqld_safe

