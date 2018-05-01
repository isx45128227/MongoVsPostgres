# Project documentation

The aim of this project is to let you know the great potential of NoSQL databases when we have to process big data volumes. 

Syntax used in MongoDB differs from Postgres, but it's really simple to understand. In this project you will see how to use syntax in MongoDB and Postgres.


## System specifications

This project has been made in Linux Fedora 24.
The main details of my Fedora machine:

* Processor: Intel Core (TM) i7-6700 CPU @ 3.40GHz
* RAM: 16 GB
* HDD: 105 GB
* Swap: 5 GB
* System type: 64 bits


## Environment preparation

First of all, before we start analyzing Postgres and Mongo we should prepare the environment where we are going to use both interfaces.

To do it we should install *Postgres* and *Mongo* in our system.


### Postgres installation

As a superuser we have to run different commands in ordrer to install Postgres in our system:

* Install postgres package.

`[root@host ]# dnf -y install postgresql-server`

* Init postgres.

`[root@host ]# postgresql-setup initdb`

* Start postgres service.

`[root@host ]# systemctl start postgresql`

* Enable postgres service.

`[root@host ]# systemctl enable postgresql`

* Set password to user postgres.

`[root@host ]# passwd postgres`


### MongoDB installation

As a superuser we have to run different commands in ordrer to install MongoDB in our system:

* Install mongodb package.

First of all we need to add Mongo's repository to our machine.

`[root@host ]# vim /etc/yum.repos.d/mongodb.repo`

And we add:
> [mongodb]

> name=MongoDB Repository

> baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/

> gpgcheck=0

> enabled=1


Later we install the package:

`[root@host ]# dnf -y install mongodb-org mongodb-org-server`

* Start mongo service.

`[root@host ]# systemctl start mongod`

* Enable mongo service.

`[root@host ]# systemctl enable mongod`


---


Once we have our system ready, we have to install the database on both interfaces.


### Database twitter on Postgres

* First of all we init session in postgres.

`[root@host ]# su - postgres`

* Later we init the database agent.

`-bash-4.3$ psql`

* Once we have entered to Postgres, we can import the database structure.

`postgres=# \i /tmp/twitterhashtags.sql;`

* Now we have the complete database structure. We can check it by using:

`twitter=# \d`

                        List of relations
                        
Schema |                 Name                  |   Type   |  Owner
-------|---------------------------------------|----------|---------
public | comentaris                            | table    | postgres
public | comentaris_id_comentari_seq           | sequence | postgres
public | fotos                                 | table    | postgres
public | fotos_id_foto_seq                     | sequence | postgres
public | hashtags                              | table    | postgres
public | hashtags_id_hashtag_seq               | sequence | postgres
public | hashtagstweets                        | table    | postgres
public | hashtagstweets_id_hashtagtweet_seq    | sequence | postgres
public | likes                                 | table    | postgres
public | likes_id_like_seq                     | sequence | postgres
public | retweets                              | table    | postgres
public | retweets_id_retweet_seq               | sequence | postgres
public | seguidors                             | table    | postgres
public | seguidors_id_seq                      | sequence | postgres
public | tweets                                | table    | postgres
public | tweets_id_tweet_seq                   | sequence | postgres
public | usuaris                               | table    | postgres
public | usuaris_id_usuari_seq                 | sequence | postgres
public | usuarislikescomentaris                | table    | postgres
public | usuarislikescomentaris_id_likecom_seq | sequence | postgres


* Finally we have to import all data in our tables so as to have a lot of information to process. 

    I have created _Python_ scripts which generate lots of data to add to twitter database. 
    They are placed in Postgres/Funcions populate. 
    There is one script for each table, and the only thing we have to do to obtain that big amount of data is to execute the program and redirect the output to a file.

    First we create information of hashtags table with our script and put it in /tmp directory:
    `[user@host ]$ python populate_hashtags.py > /tmp/hashtags.csv`

    Then we import data from /tmp to twitter database:
    `twitter=# COPY hashtags FROM '/tmp/hashtags.csv' DELIMITER ',' CSV HEADER;`

    That is the process we should follow for each table.
  
#### Here I show the script name and the table associated with
 
Table                  | Script
-----------------------|-------------------------------------------
comentaris             | populate_comentaris.py    
fotos                  | populate_fotos.py   
hashtags               | populate_hashtags.py    
hashtagstweets         | populate_hashtagstweets.py    
likes                  | populate_likes.py    
retweets               | populate_retweets.py   
seguidors              | populate_seguidors.py    
tweets                 | populate_tweets.py    
usuaris                | populate_usuaris.py   
usuarislikescomentaris | populate_usuarislikescomentaris.py    


##### In order to add the hashtag to the tweet, I have created a function in PLPGSQL that adds the hashtag to each tweet.
##### Once we have added all information to twitter database we should run this function. 

* First of all we import the function from /tmp.

`twitter=# \i /tmp/funcio_plpgsql.sql;`

* Then we run the function

`twitter=# SELECT update_tweets();`


##### Now we have finished creating twitter database on Postgres. 

---

### Postgres database to MongoDB

Once we have created our Postgres database we can export all data into _json_ format. Postgres has different functions that can convert from Postgres to _json_ files.
The only thing we have to do is to execute the function and see the result.

`twitter=# SELECT row_to_json(users) FROM (SELECT id_usuari,nom,cognoms,password,username,telefon,data_alta,descripcio,ciutat,url,idioma,email,(SELECT array_to_json(array_agg(row_to_json(followers))) FROM (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE id_usuari=id_usuari_seguit) followers) as seguidors FROM usuaris) users;`


Result: `{"id_usuari":12592,
          "nom":"pere",
          "cognoms":"goñi",
          "password":"pass12592",
          "username":"pere_goñi_12592",
          "telefon":"698543568",
          "data_alta":"2018-04-23T09:29:00",
          "descripcio":"usuari peregoñi",
          "ciutat":"colonia",
          "url":"https://www.twitter.com/pere_goñi12592",
          "idioma":"castella",
          "email":"peregoñi12592@gmail.com",
          "seguidors":null}`

Here we are creating an output in _json_ format with all information about users and their followers.

That's fine if we only want to see the output, but we need it to create our full database _json_ files.

Mongodb's organization is different from Postgres, so we are going to create **two** different collections for mongodb called **users** and **tweets**. 

Before we create the database in _json_ format, we must add indexes to Postgres database in order to reduce the number of accesses to each table. Every index is created in a field related to another table.

#### TWEETS
`CREATE INDEX id_usuari_tweets_idx ON tweets (id_usuari);`

`CREATE INDEX id_foto_tweets_idx ON tweets (foto);`

#### COMENTARIS 
`CREATE INDEX id_usuari_comentari_idx ON comentaris (id_usuari_comentari);`

`CREATE INDEX id_tweet_idx ON comentaris (id_tweet);`

#### LIKES
`CREATE INDEX id_usuari_comentari2_idx ON likes (id_usuari_like);`

`CREATE INDEX id_tweet2_idx ON likes (id_tweet);`

#### USUARISLIKESCOMENTARIS
`CREATE INDEX id_usuari2_idx ON usuarislikescomentaris(id_usuari);`

`CREATE INDEX id_comentari3_idx ON usuarislikescomentaris(id_comentari);`

#### FOTOS
`CREATE INDEX id_tweet3_idx ON fotos (id_tweet);`

#### RETWEETS
`CREATE INDEX id_usuari3_idx ON retweets(id_usuari_retweet);`

`CREATE INDEX id_tweet4_idx ON retweets (id_tweet);`

#### HASHTAGSTWEETS
`CREATE INDEX id_tweet5_idx ON hashtagstweets (id_tweet);`

`CREATE INDEX id_hashtag_idx ON hashtagstweets (id_hashtag);`

#### SEGUIDORS
`CREATE INDEX id_usuariseguit_idx ON seguidors(id_usuari_seguit);`

`CREATE INDEX id_usuariseguidor_idx ON seguidors(id_usuari_seguidor);`

After adding the indexes we are ready to create _json_ files. We just need to follow the next steps:

* Obtain users data and redirect the output to a file, so as to have all users information (user password is **jupiter**). 

`psql -p 5432 -U postgres -d twitter -c 'SELECT row_to_json(users) FROM (SELECT id_usuari,nom,cognoms,password,username,telefon,data_alta,descripcio,ciutat,url,idioma,email,(SELECT array_to_json(array_agg(row_to_json(followers))) FROM (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE id_usuari=id_usuari_seguit) followers) as seguidors FROM usuaris) users ORDER BY users.id_usuari;' > /tmp/users.json`

* Obtain tweets data and redirect the output to a file, in order2 to have all tweets information (user password is **jupiter**). 

`psql -p 5432 -U postgres -d twitter -c 'SELECT row_to_json(tweets) FROM 
    (SELECT id_tweet AS "_id",
    text_tweet,
    id_usuari,
    data_tweet,
    (SELECT array_to_json(array_agg(row_to_json(fotos))) FROM (SELECT data_foto,text_foto FROM fotos WHERE tweets.id_tweet=fotos.id_tweet) fotos) as fotos,
    (SELECT row_to_json(row(lat,lon))) AS "geo",
    (SELECT array_to_json(array_agg(row_to_json(hashtags))) FROM (SELECT hashtag,data_creacio_hashtag FROM hashtags JOIN hashtagstweets ON hashtags.id_hashtag=hashtagstweets.id_hashtag WHERE tweets.id_tweet=hashtagstweets.id_tweet) hashtags) as hashtags,
    (SELECT array_to_json(array_agg(row_to_json(likes))) FROM (SELECT id_usuari_like,data_like,esborrat FROM likes WHERE tweets.id_tweet=likes.id_tweet) likes) as likes,
    (SELECT array_to_json(array_agg(row_to_json(comentaris))) FROM (SELECT id_usuari_comentari,data_comentari,text_comentari,(SELECT array_to_json(array_agg(row_to_json(likescomentari))) FROM (SELECT id_usuari FROM usuarislikescomentaris WHERE comentaris.id_comentari=usuarislikescomentaris.id_comentari) likescomentari) as "likes_comentari" FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) comentaris) as comentaris,
    (SELECT count(*) FROM likes WHERE tweets.id_tweet=likes.id_tweet) AS "num_likes",
    (SELECT count(*) FROM retweets WHERE tweets.id_tweet=retweets.id_tweet) AS "num_retweets",
    (SELECT count(*) FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) AS "num_comments",
    (SELECT array_to_json(array_agg(row_to_json(retweets))) FROM (SELECT id_usuari_retweet,data_retweet,text_retweet,esborrat FROM retweets WHERE tweets.id_tweet=retweets.id_tweet) retweets) as retweets
FROM tweets) tweets;' > /tmp/tweets.json`

### Database twitter on MongoDB

Then we have to add the twitter database to mongo. In this case is not necessary to run the interface. We can directly import database from _json_ or _csv_ file.

In this case we have **two** json files, the first one includes **tweets collection** and the second one includes **users collection**.

* First we import users.

`mongoimport --db twitter --collection users --file /tmp/users.json --jsonArray`

* Then we import tweets.

`mongoimport --db twitter --collection tweets --file /tmp/tweets.json --jsonArray`


##### Now we have finished creating twitter database on MongoDB. 


##### Once we have added all information to twitter database we can start using the database. 

* First of all we enter to mongo interface.

`[root@host ]# mongo`

* Once we have entered to Mongo, we have to choose the database.

`> use twitter`

* Later we can see different collections.
`> show collections`

* To select collections we want to work with we should specify in the find sentence.

   Working on users collection:
   `> db.users.find()`
    
   or working on tweets collection: 
   `> db.tweets.find()`


---

### Query Documents

As I said at the very beginning of this project syntax in MongoDB differs from Postgres.

Here you can see basic queries in Postgres and their translation into Mongo's syntax.


PostgreSQL                                                                                                        | MongoDB
------------------------------------------------------------------------------------------------------------------|--------------
`CREATE TABLE tweets (id_tweet bigserial PRIMARY KEY,text_tweet varchar(280) NOT NULL,id_usuari bigint NOT NULL);`| Not Required
`INSERT INTO tweets(id_tweet,text_tweet,id_usuari)VALUES (DEFAULT,'Example tweet',1);`                            | `db.tweets.insert({ id_tweet: 1, text_tweet:'Example tweet', id_usuari: 1 })`
`SELECT * FROM tweets;`                                                                                           | `db.tweets.find()` 
`UPDATE tweets SET id_usuari = 2999 WHERE id_tweet=3000;`                                                         | `db.tweets.update({ id_usuari: 2999 },{ $set: { id_tweet: 3000 } },{ multi: true })`

---

## Docker interface

To test queries in Postgres and Mongo interfaces I have created two different Dockers. Both of them include the entire twitter database.


### Postgres docker

* First of all we download and run Postgres docker from DockerHub, where I have te image already created. 

`docker run --name postgrestwitter -h postgrestwitter -d isx45128227/postgrestwitter`

* Later we run our queries using psql (user password is **jupiter**). You should wait a little bit until twitter database is ready (about 1 minute).

`psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT * FROM usuaris;'`

`psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c "SELECT count(*) FROM tweets WHERE text_tweet LIKE '%#sale%';"`

`psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c "SELECT * FROM tweets WHERE text_tweet LIKE '%#%';"`


* It is also created a Dockerfile with the specifications, but the main problem is that the dump database is about 2GB and GitHub doesn't allow me to upload this file.


### MongoDB docker

* First of all we download and run MongoDB docker from DockerHub, where I also have te image already created. 

`docker run --name mongotwitter -h mongotwitter -d isx45128227/mongotwitter`

* There is a problem with Docker and MongoDB. Docker interface does not allow Mongo to keep database data, so before we start using our docker mongo we have to restore information.

* First of all we enter into the docker.

`docker exec -it mongotwitter /bin/bash`

* Then we run a script that regenerates all twitter database.
`./tmp/restore.sh`

* Later we run our queries using mongo.

`mongo --host 172.17.0.3:27017 twitter`

* When we are inside mongo shell we can start running different queries.

`> db.users.find()`
 
`> db.tweets.find({"text_tweet":/#sale/i}).count()`

`> db.tweets.find({"text_tweet":/#/i})`


* It is also created a Dockerfile with the specifications, but the main problem is that the dump database is about 3GB and GitHub doesn't allow me to upload this file.

