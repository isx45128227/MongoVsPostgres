# Project documentation


## Environment preparation

First of all, before we start comparing Postgres and Mongo we should prepare the environment where we are going to use both interfaces.

To do it we should install *Postgres* and *Mongo* in our system.


### Installing Postgres

As a superuser we have to run:

#### Install package

> `dnf -y install postgresql-server`

#### Init postgres

> `postgresql-setup initdb`

#### Start postgres service

> `systemctl start postgresql`

#### Enable postgres service

> `systemctl enable postgresql`

#### Set password to user postgres 

> `passwd postgres`


Then we have to add the twitter database to postgres:

#### First of all we init session in postgres

> `su - postgres`

#### Later we init the database agent

> `-bash-4.3$ psql`

#### Once we have entered to Postgres, we can create the twitter database

> `postgres=# CREATE DATABASE twitter;`

#### We enter database twitter to import the structure

> `postgres=# \c twitter;`







### Installing MongoDB

