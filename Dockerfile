FROM ubuntu:trusty
#steps refer to https://www.linode.com/docs/email/email-with-postfix-dovecot-and-mysql

#vars to redo at init:
#- mysql password your_password
#- mailname your.hostname.com
#- dovecot cert
#- contents of mysql db
# /etc/postfix
# /etc/dovecot
# /var/mysql/data
# /etc/ssl/*/dovecot.*

#Installing packages
ENV DEBIAN_FRONTEND noninteractive
RUN echo "mysql-server mysql-server/root_password password your_password" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password your_password" | debconf-set-selections
RUN echo "postfix postfix/mailname string your.hostname.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
RUN apt-get update
RUN apt-get install -y postfix
RUN apt-get install -y postfix-mysql
RUN apt-get install -y dovecot-core
RUN apt-get install -y dovecot-imapd
RUN apt-get install -y dovecot-pop3d
RUN apt-get install -y dovecot-lmtpd
RUN apt-get install -y dovecot-mysql
RUN apt-get install -y mysql-server

#MySQL
RUN /etc/init.d/mysql start && mysqladmin -pyour_password create mailserver
ADD ./init.mysql /init.mysql
RUN /etc/init.d/mysql start && cat init.mysql | mysql -pyour_password mailserver

#Postfix
ADD ./postfix/main.cf /etc/postfix/main.cf
ADD ./postfix/mysql-virtual-mailbox-domains.cf /etc/postfix/mysql-virtual-mailbox-domains.cf
ADD ./postfix/mysql-virtual-mailbox-maps.cf /etc/postfix/mysql-virtual-mailbox-maps.cf
ADD ./postfix/mysql-virtual-alias-maps.cf /etc/postfix/mysql-virtual-alias-maps.cf
ADD ./postfix/master.cf /etc/postfix/master.cf

#Dovecot
ADD ./dovecot/dovecot.conf /etc/dovecot/dovecot.conf
ADD ./dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
RUN mkdir -p /var/mail/vhosts/example.com
RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /var/mail
RUN chown -R vmail:vmail /var/mail
ADD ./dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
ADD ./dovecot/conf.d/auth-sql.conf.ext /etc/dovecot/conf.d/auth-sql.conf.ext
ADD ./dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext
RUN chown -R vmail:dovecot /etc/dovecot
RUN chmod -R o-rwx /etc/dovecot
ADD ./dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf
ADD ./dovecot/mkcert.sh /mkcert.sh
ADD ./dovecot/dovecot-openssl.cnf /dovecot-openssl.cnf
RUN sh /mkcert.sh
ADD ./dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

CMD service mysql start && service postfix start && service dovecot start

# the image should be built and published with 'your.hostname.com' and 'your_password' in there.
# then there should be an init script that updates these values, and which you run once after docker pull.
# in fact, there should be one init script for the entire party-package. this can be interactive. you give it:
#  - a party name (e.g. green-elehpant)
#  - a *.3pp.io cert.
# and it will:
#  - create the data folder
#  - pull in necessary images
#  - start the necessary containers
# and then there should be an addSite script which you give:
#  - domain name
#  - cert (if not *.3pp.io)
# and it will
#  - create the data folder for that domain
#  - add the domain to the mailserver and the jabber server
#  - set up data folders for all applications
#  - echo the admin password
