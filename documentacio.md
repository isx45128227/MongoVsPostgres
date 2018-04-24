# Project documentation


## Environment preparation

First of all, before we start analyzing Postgres and Mongo we should prepare the environment where we are going to use both interfaces.

To do it we should install *Postgres* and *Mongo* in our system.


### Postgres installation

As a superuser we have to run different commands in ordrer to install Postgres in our system:

#### Install postgres package.

> `dnf -y install postgresql-server`

#### Init postgres.

`postgresql-setup initdb`

#### Start postgres service.

`systemctl start postgresql`

#### Enable postgres service.

`systemctl enable postgresql`

#### Set password to user postgres.

`passwd postgres`


Then we have to add the twitter database to postgres:

#### First of all we init session in postgres.

`su - postgres`

#### Later we init the database agent.

`-bash-4.3$ psql`

#### Once we have entered to Postgres, we can import the database structure.

`postgres=# \i /tmp/twitterhashtags.sql;`

#### Now we have the complete database structure. We can check it by using:

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


#### Finally we have to import all data in our tables so as to have a lot of information to process. I have created scripts that generate lots of data to add to twitter database. They are placed in Postgres/Funcions populate. There is one script for each table, and the only thing we have to do to obtain that big amount of data is to execute and redirect the output to a file.

  First we create information of hashtags table with our script and put it in /tmp directory:
`[user@host ]$ python funciopopulate_hashtags.py > /tmp/hashtags.csv`

  Then we import data into twitter database:
 `twitter=# COPY hashtags FROM '/tmp/hashtags.csv' DELIMITER ',' CSV HEADER;`

  That is the process we should follow for each table.
  
#### Here I show the script name and the table associate
 
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





### MongoDB installation

