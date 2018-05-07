# @edt ASIX  Curs 2017-2018
# Projecte MongoDB vs Postgres
# postgres:base 
# servidor postgres amb BBDD twitter
# ----------------------------------

FROM postgres:9.3
MAINTAINER @isx45128227 "Roger Ferran @edt Curs 2017-2018"
ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD jupiter
ENV POSTGRES_DB twitter
EXPOSE 5432
ADD dumptwitter.sql /docker-entrypoint-initdb.d/
ADD pg_hba.conf /var/lib/postgresql/data/

# Create image --> docker build -t "postgrestwitter" -f Dockerfile .
# Init docker  --> docker run --name postgrestwitter -h postgrestwitter -d postgrestwitter
# Query        --> psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT * FROM usuaris;'
