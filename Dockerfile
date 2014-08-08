FROM ubuntu:trusty

ADD ./install /install
# Now run:
# docker run -i -t michielbdejong/mail /bin/bash /install/init.sh
#
# (it will ask you to specify the hostname, e.g. blue-snake.3pp.io)
#
# and then:
# docker run -i -t michielbdejong/mail /bin/bash /install/addDomain.sh
#
# (it will ask you to specify the domain to add, e.g. michielbdejong.com)
#
# and then:
# docker run -i -t michielbdejong/mail /bin/bash /install/run.sh
#
# (this will then run the mailserver)
