# @edt ASIX  Curs 2017-2018
# Projecte MongoDB vs Postgres
# servidor MongoDB amb BBDD twitter
# ----------------------------------

FROM fedora:24
MAINTAINER @isx45128227 "Roger Ferran @edt Curs 2017-2018"

ADD mongodb.repo /etc/yum.repos.d/

RUN mkdir /tmp/twitter

ADD twitter/users/users.bson /tmp/twitter/
ADD twitter/users/users.metadata.json /tmp/twitter/
ADD twitter/tweets/tweets.bson /tmp/twitter/
ADD twitter/tweets/tweets.metadata.json /tmp/twitter/
ADD restore.sh /tmp/

RUN chmod +x /tmp/restore.sh
RUN dnf -y install mongodb-org mongodb-org-server

VOLUME ["/data/db"]

RUN /usr/bin/mongod --fork --logpath /var/log/mongod.log

EXPOSE 27017

CMD ["/usr/bin/mongod"]


# Create image --> docker build -t "mongotwitter" -f Dockerfile .
# Init docker  --> docker run --name mongotwitter -h mongotwitter -d mongotwitter
# Query        --> mongo --host 172.17.0.3
