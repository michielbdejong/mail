mail
====

HOST_NAME=`echo red-dolphin.3pp.io`
sudo echo hostname is $HOST_NAME
sudo docker build -t michielbdejong/mail .
sudo docker run -i -t -h $HOST_NAME michielbdejong/mail /bin/bash /install/init.sh
sudo docker commit `sudo docker ps -lq` my-mailserver-with-passwords
sudo docker run -d -h $HOST_NAME -p 25:25 -p 465:465 -p 993:993 -p 995:995 my-mailserver-with-passwords sh /install/run.sh
