# @edt ASIX  Curs 2017-2018
# Projecte MongoDB vs Postgres
# servidor MongoDB amb BBDD twitter
# ----------------------------------
FROM fedora:24
MAINTAINER @isx45128227 "Roger Ferran @edt Curs 2017-2018"
ADD mongodb.repo /etc/yum.repos.d/
ADD users.json /tmp/
ADD tweets.json /tmp/

RUN dnf -y install mongodb-org mongodb-org-server
VOLUME ["/data/db"]
RUN /usr/bin/mongod --fork --logpath /var/log/mongod.log

RUN /usr/bin/mongoimport --db twitter --collection users --file /tmp/users.json --jsonArray
RUN /usr/bin/mongoimport --db twitter --collection tweets --file /tmp/tweets.json --jsonArray

EXPOSE 27017

CMD ["/usr/bin/mongod"]

# Create image --> docker build -t "mongotwitter" -f Dockerfile .
# Init docker  --> docker run --name mongotwitter -h mongotwitter -d mongotwitter
# Query        --> mongo --host 172.17.0.3

