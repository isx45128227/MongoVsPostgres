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


### Installing MongoDB

