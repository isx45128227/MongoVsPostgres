# Project documentation

The aim of this project is to let you know the great potential of NonSQL databases when we have to process big data volumes. 

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



### Database twitter 

Then we have to add the twitter database to postgres:

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
##### I have created scripts that generate lots of data to add to twitter database. 
##### They are placed in Postgres/Funcions populate. 
##### There is one script for each table, and the only thing we have to do to obtain that big amount of data is to execute and redirect the output to a file.

  First we create information of hashtags table with our script and put it in /tmp directory:
`[user@host ]$ python funciopopulate_hashtags.py > /tmp/hashtags.csv`

  Then we import data from /tmp to twitter database:
 `twitter=# COPY hashtags FROM '/tmp/hashtags.csv' DELIMITER ',' CSV HEADER;`

  That is the process we should follow for each table.
  
##### Here I show the script name and the table associated with
 
Table                  | Script
-----------------------|-------------------------------------------
comentaris             | funciopopulate_comentaris.py    
fotos                  | funciopopulate_fotos.py   
hashtags               | funciopopulate_hashtags.py    
hashtagstweets         | funciopopulate_hashtagstweets.py    
likes                  | funciopopulate_likes.py    
retweets               | funciopopulate_retweets.py   
seguidors              | funciopopulate_seguidors.py    
tweets                 | funciopopulate_tweets.py    
usuaris                | funciopopulate_usuaris.py   
usuarislikescomentaris | funciopopulate_usuarislikescomentaris.py    


##### In order to add the hashtag to the tweet, I have created a function in PLPGSQL that adds the hashtag to each tweet.
##### Once we have added all information to twitter database we should run this function. 

* First of all we import the function from /tmp.

`twitter=# \i /tmp/funcio_plpgsql.sql;`

* Then we run the function

`twitter=# SELECT update_tweets();`


##### Now we have finished creating twitter database on Postgres. 

---

### MongoDB installation

As a superuser we have to run different commands in ordrer to install MongoDB in our system:

* Install postgres package.

First of all we need to add Mongo's repository to our machine.

`[root@host ]# vim /etc/yum.repos.d/mongodb.repo`

And we add:
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1

Later we install the package:

`[root@host ]# dnf -y install mongodb-org mongodb-org-server`

* Start mongo service.

`[root@host ]# systemctl start mongod`

* Enable mongo service.

`[root@host ]# systemctl enable mongod`



### Database twitter 

Then we have to add the twitter database to mongo. In this case is not necessary to run the interface. We can directly import database from _json_ or _csv_ file.

In this case we have **two** json files, the first one includes **tweets collection** and the second one includes **users collection**.

* First we import users.

`mongoimport --db twitter --collection users --file /tmp/users.json --jsonArray`

* Then we import tweets.

`mongoimport --db twitter --collection tweets --file /tmp/tweets.json --jsonArray`


##### Once we have added all information to twitter database we can start using our twitter database. 

* First of all we enter to mongo interface.

`[root@host ]# mongo`


* Once we have entered to Mongo, we have to choose our database.

`> use twitter`

* Later we can see our collections.
`> show collections`


* To select collections we want to work with we should specify in our find sentence.

   Working on users collection:
   `> db.users.find()`
    
    
   or working on tweets collection: 
   `> db.tweets.find()`


### Query Documents

As I said at the very beginning of this project syntax in MongoDB differs from Postgres.

Here I show you basic queries in Postgres and their translation into Mongo's syntax.


`db.users.update({ age: { $gt: 25 } },{ $set: { status: "C" } },{ multi: true })`     | `UPDATE users SET status = 'C' WHERE age > 25;`

PostgreSQL                                                                                                        | MongoDB
------------------------------------------------------------------------------------------------------------------|--------------
`CREATE TABLE tweets (id_tweet bigserial PRIMARY KEY,text_tweet varchar(280) NOT NULL,id_usuari bigint NOT NULL);`| Not Required
`INSERT INTO tweets(id_tweet,text_tweet,id_usuari)VALUES (DEFAULT,'Example tweet',1);`                            | `db.tweets.insert({ id_tweet: 1, text_tweet:'Example tweet', id_usuari: 1 })`
`SELECT * FROM tweets;`                                                                                           | `db.tweets.find()` 
`UPDATE tweets SET id_usuari = 2999 WHERE id_tweet=3000;`                                                         | `db.tweets.update({ id_usuari: 2999 },{ $set: { id_tweet: 3000 } },{ multi: true })`
