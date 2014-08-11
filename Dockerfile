FROM ubuntu:trusty
RUN apt-get update
RUN apt-get install -y pwgen
ADD ./install /install

EXPORT 25
EXPORT 465
EXPORT 993
EXPORT 995

# Now run:
# docker run -i -t -h blue-turtle.3pp.io michielbdejong/mail /bin/bash /install/init.sh
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
