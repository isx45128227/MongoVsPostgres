# Project documentation

The aim of this project is to let you know the great potential of NoSQL 
databases when we have to process big data volumes.

Syntax used in MongoDB differs from Postgres, but it's really simple to understand. 
In this project you will see how to use syntax in MongoDB and Postgres.


## A little bit of information

MongoDB is an open source database. It’s designed to be agile and scalable, 
and it uses dynamic schemas so that you can create records without defining the structure first. 
It also supports hierarchical documentation of data.

PostgreSQL is also open source, but it’s a relational database, 
that means it is much more concerned about how we store data. 
It's really important defining an ordered structure so that we can create coherent information.

Over the past decade, many of the assumptions that drove the development of relational databases have changed:

* Demands for higher developer productivity and faster time to market.

* The need to manage massive increases in new, rapidly changing data types.

* Exploit on-demand, highly scalable compute and storage infrastructure, with the ability to serve audiences any place they work.
  
As a result, non-relational or “NoSQL” databases, like MongoDB, have appeared in order to address the requirements of new applications such as:

* High scalability

* Availability

* Developer productivity


### Concepts

   Many concepts in PostgreSQL have analogs in MongoDB. The table below shows the common concepts.


   PostgreSQL    |    MongoDB
   --------------|------------------------
   Table         |   Collection
   Row           |   Document
   Column        |   Field
   JOIN          |   Embedded documents
   GROUP_BY      |   Aggregation Pipeline


---

## Installation

Now it is explained how can we test both databases with more or less the same configuration.

## System specifications

This project has been made in Linux Fedora 24.
The main details of my Fedora machine:

* Processor: Intel Core (TM) i7-6700 CPU @ 3.40GHz
* RAM: 16 GB
* HDD: 225 GB
* Swap: 5 GB
* System type: 64 bits


## Environment preparation

First of all, before we start analyzing Postgres and MongoDB we should prepare 
the environment where we are going to use both interfaces.

To do it we should first install **Postgres** and **MongoDB** in our system.


### Postgres installation

As a superuser we have to run different commands in ordrer to install 
**Postgres** in our system:

* Install Postgres package.

    `[root@host ]# dnf -y install postgresql-server`

* Init Postgres.

    `[root@host ]# postgresql-setup initdb`

* Start service.

    `[root@host ]# systemctl start postgresql`

* Enable service.

    `[root@host ]# systemctl enable postgresql`

* Set password to user postgres (we could use **jupiter** for example).

    `[root@host ]# passwd postgres`
    
    
* There is a configuration file placed in _/var/lib/pgsql/data/_ that is 
  named [_pg_hba.conf_](https://www.postgresql.org/docs/9.3/static/auth-pg-hba-conf.html) 
  where we can change different parameters of the client 
  authentication (HBA stands for host-based authentication).
  
  The general format for this file is a set of records where each record 
  specifies:
      
   * A connection type, 
   
   * A client IP address range,
   
   * A database name,
   
   * A user name and
   
   * The authentication method to be used for connection matching this parameters.
  
  If one record is chosen and the authentication fails, subsequent records 
  are not considered.
  
  If no record matches, access is denied. 
  
  Before explaining the divergences between the options we use, we should 
  differenciate 4 different **types** of connection:
  
   * **Local**: This option matches connection attempts using Unix-domain sockets. 
   
   * **Host**: This option matches connection attempts using TCP/IP, the most commonly used.
   
   * **Hostssl**: This option matches connection attempts made using TCP/IP 
                  but only when the connection is made with SSL encryption.
                  
   * **Hostnossl**: This option has the opposite behaviour of hostssl. 
  
  Here we will see the most commonly used **options** and their meaning. 
  
  
  Option       |    Usage
  -------------|-------------------------------------------------------------------------------------------------------
  Database     | Specifies the db name. Value all specifies that it matches all databases.
  User         | Specifies which database user name this record matches. Value all specifies that it matches all users.
  Address      | Specifies the client machine address(es) that this record matches.
  Auth-method  | Specifies the authentication method to use when a connection matches this record.
  Auth-options | There can be field(s) of the form name=value that specify options for the authentication method. 
  
  
  For the **auth-method** there are possible choices to consider, here we see the ones used the most, but there are other [possibilities](https://www.postgresql.org/docs/9.1/static/auth-pg-hba-conf.html):
  
  
   Choice    |   Definition
   ----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   trust     | Allow the connection unconditionally.
   reject    | Reject the connection unconditionally.
   md5       | Require the client to supply an encrypted password for authentication. Is sent encrypted.
   password  | Require the client to supply an unencrypted password for authentication. Is sent in clear text.
   ident     | Obtain the operating system user name of the client by contacting the ident server on the client and check if it matches the requested database user name. When specified for local connections, peer authentication will be used instead.
   peer      | Obtain the client's operating system user name from the operating system and check if it matches the requested database user name.
   krb5      | Use Kerberos V5 to authenticate the user.
   ldap      | Authenticate using an LDAP server.
   pam       | Authenticate using the Pluggable Authentication Modules (PAM) service provided by the operating system. 
  
  
   There are lots of possible configurations, but here you will see simple examples we use the most.
   
   * Allow local users to enter without authentication
       
       `local   all             all                                     trust`
   
   * Allow any user from any host with IP address 192.168.93.x to connect
     to database "postgres" as the same user name that ident reports for
     the connection.
     
       `host    postgres        all             192.168.93.0/24         ident`
   
   * Allow any user from hosts in the example.com domain to connect to
     any database if the user's password is correctly supplied.
     
       `host    all             all             .example.com            md5`
  
  
  
### MongoDB installation

As a superuser we have to run different commands in ordrer to install 
**MongoDB** in the system:

* Install MongoDB package.

First of all we need to add Mongo's repository to the machine.

`[root@host ]# vim /etc/yum.repos.d/mongodb.repo`

And we add the following lines:
> [mongodb]

> name=MongoDB Repository

> baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/

> gpgcheck=0

> enabled=1


Later we install the package:

`[root@host ]# dnf -y install mongodb-org mongodb-org-server`

* Start MongoDB service.

    `[root@host ]# systemctl start mongod`

* Enable MongoDB service.

    `[root@host ]# systemctl enable mongod`
    
    
There is a possibility of creating a configuration file for mongod instance at startup.
That file contains settings that are equivalent to mongod command-line options. 
Using it, makes managing options easier. 

The general format for this file is in [_YAML_](https://en.wikipedia.org/wiki/YAML) language.

In this case, we can configure different options such as:

* SystemLog,
 
* processManagement, 

* net, 

* setParameter, 

* security, 

* operationProfiling, 

* storage, 

* replication and 

* auditLog options.

For this project is used the default configuration file because 
we use different functions to obtain extra data from queries. 
But if you are interested in knowing the different options to use,
you can visit the [official website](https://docs.mongodb.com/v2.6/reference/configuration-options/). 


#### Now we have both interfaces installed in our system so in order to have data to process, we should create a database.

---

### Starting up the database

In this project we are going to work with **Twitter** database.
We have to create two different structures, one used in Postgres and the 
other one used in MongoDB.
 
The structure I have chosen for **Postgres** is:

![Postgres Twitter Structure](Postgres/imatges/twitter.png)


This structure contains different tables and they are connected by using 
foreign keys (the _id_ of each table) in order to maintain the data coherence. 


The structure for **MongoDB** differs from Postgres because of the organization. 
MongoDB use collections instead of tables, there is no need to create one 
collection for each table used in Postgres so I've tried to maintain the same relations somehow.

* Users 

![Mongo users Twitter Structure](MongoDB/imatges/users.png)


* Tweets 

![Mongo tweets Twitter Structure](MongoDB/imatges/tweets1.png)
![Mongo tweets Twitter Structure](MongoDB/imatges/tweets2.png)


Once we have defined the structure we are going to use, we can start creating the database.


### Database Twitter on Postgres

It is created a script that includes Twitter database, so the only thing
we have to do is to import [that script](https://github.com/isx45128227/MongoVsPostgres/blob/master/Postgres/twitterhashtags.sql).


* First of all we init session in postgres.

    `[root@host ]# su - postgres`

* Later we init the database agent.

    `-bash-4.3$ psql`

* Once we have entered to Postgres, we can import the database structure using the [script](https://github.com/isx45128227/MongoVsPostgres/blob/master/Postgres/twitterhashtags.sql).

    `postgres=# \i /tmp/twitterhashtags.sql;`

* Now we have the complete database structure. We can check it by using:

    `twitter=# \d`

                          List of relations
                          
  Schema |                 Name                  |   Type   |  Owner
  -------|---------------------------------------|----------|-------------
  public | comentaris                            | table    | twitteradmin
  public | comentaris_id_comentari_seq           | sequence | twitteradmin
  public | fotos                                 | table    | twitteradmin
  public | fotos_id_foto_seq                     | sequence | twitteradmin
  public | hashtags                              | table    | twitteradmin
  public | hashtags_id_hashtag_seq               | sequence | twitteradmin
  public | hashtagstweets                        | table    | twitteradmin
  public | hashtagstweets_id_hashtagtweet_seq    | sequence | twitteradmin
  public | likes                                 | table    | twitteradmin
  public | likes_id_like_seq                     | sequence | twitteradmin
  public | retweets                              | table    | twitteradmin
  public | retweets_id_retweet_seq               | sequence | twitteradmin
  public | seguidors                             | table    | twitteradmin
  public | seguidors_id_seq                      | sequence | twitteradmin
  public | tweets                                | table    | twitteradmin
  public | tweets_id_tweet_seq                   | sequence | twitteradmin
  public | usuaris                               | table    | twitteradmin
  public | usuaris_id_usuari_seq                 | sequence | twitteradmin
  public | usuarislikescomentaris                | table    | twitteradmin
  public | usuarislikescomentaris_id_likecom_seq | sequence | twitteradmin


  Here we see that for each table it is created a sequence, that means that 
  each single table has an _id_ field that is bigserial and this serial is
  a sequence of numbers starting at 1. 
  We use this in order to maintain coherence on the database.


* Finally we have to import all data in our tables so as to have a lot of information to process. 

    I have created _Python_ scripts which generate lots of data to add to twitter database. 
    They are placed in [Postgres/Funcions populate](https://github.com/isx45128227/MongoVsPostgres/tree/master/Postgres/Funcions%20populate). 
    
    There is one script for each table, and the only thing we have to do to obtain 
    that big amount of data is to execute the script and redirect the output to a file.

    * First we create information of hashtags table with the script and put it in /tmp directory:
    
        `[user@host ]$ python populate_hashtags.py > /tmp/hashtags.csv`

    * Then we import data from /tmp to twitter database:
    
        `twitter=# COPY hashtags FROM '/tmp/hashtags.csv' DELIMITER ',' CSV HEADER;`

    * That is the process we should follow for each table. 
      Take into account that every script generates different data, and it is not necessary all table data.

        `twitter=# COPY usuaris FROM '/tmp/usuaris.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY tweets(id_tweet,text_tweet,id_usuari,data_tweet) FROM '/tmp/tweets.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY fotos(id_foto,text_foto,id_tweet,data_foto) FROM '/tmp/fotos.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY likes(id_like,data_like,id_usuari_like,id_tweet) FROM '/tmp/likes.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY seguidors FROM '/tmp/seguidors.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY retweets(id_retweet,data_retweet,text_retweet,id_usuari_retweet,id_tweet) FROM '/tmp/retweets.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY comentaris(id_comentari,data_comentari,text_comentari,id_usuari_comentari,id_tweet) FROM '/tmp/comentaris.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY hashtagstweets FROM '/tmp/hashtagstweets.csv' DELIMITER ',' CSV HEADER;`
        
        `twitter=# COPY usuarislikescomentaris FROM '/tmp/usuarislikescomentaris.csv' DELIMITER ',' CSV HEADER;`


        #### Script name and the table associated with
         
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


        There are other tools that can populate data into Postgres database. 
        The most commonly used is [*pg_loader*](http://pgloader.readthedocs.io/en/latest/tutorial/tutorial.html) 
        that works with lots of data, but in this case we use an easier method.


##### With the structure followed, in table tweets we don't have hashtags if they are used in. 
##### So in order to add the hashtag to the tweet, there is a function in PLPGSQL that adds the hashtag to each tweet.
##### Once we have added all information to twitter database we should run this function. 

* First of all we import the [function](https://github.com/isx45128227/MongoVsPostgres/blob/master/Postgres/funcio_plpgsql.sql) from /tmp.

    `twitter=# \i /tmp/funcio_plpgsql.sql;`

* Then we run the function

    `twitter=# SELECT update_tweets();`
    

In order to have access to the Postgres database with other users we need to add some roles.

* First we import the [script](https://github.com/isx45128227/MongoVsPostgres/blob/master/Postgres/privileges.sql) that grant access to our username.
  Before importing that script, we should make changes.
    
    * Everywhere it says **YourUsername** change it with your username.
    
    * Change password with the one you want to use.
  
    * Now you are ready to import it.

        `twitter=# \i /tmp/privileges.sql;`
    
* Then we run a different terminal and assure that it is true we can log into database with the **username** we put on the script by using:

    `[user@host]$ psql -p 5432 -U username -d twitter`


##### Now we have finished creating Twitter database on Postgres. 

---

### Postgres database to MongoDB

Once we have created the Postgres database we can export all data into _json_ format.
MongoDB use _json_ documents to order the information into collections.

Postgres has different functions that can convert from Postgres language to _json_ files.
The only thing we have to do is to execute that function and see the result.

`twitter=# SELECT row_to_json(users) FROM (SELECT id_usuari,nom,cognoms,
           password,username,telefon,data_alta,descripcio,ciutat,url,idioma,
           email,(SELECT array_to_json(array_agg(row_to_json(followers))) FROM 
           (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE 
           id_usuari=id_usuari_seguit) followers) as seguidors FROM usuaris) users;`


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
          "seguidors":null }`

Here we are creating an output in _json_ format with all information about users and their followers.

That's fine if we only want to see the output, but we have to create a full database _json_ files.

As said before, MongoDB's organization is different from Postgres, 
so we are going to create **two** different collections for MongoDB called **users** and **tweets**. 

As I have tested, two days after executing the function without having indexes in Postgres 
the results haven't appeared (we must take into account that there are more than 3 million rows).
 
To solve this, I added indexes to Postgres database in order to reduce the number 
of accesses to each table and to obtain the result faster (if we don't use indexes 
it will cost a lot of time to generate _json_ files).

Every index is created in a field that is linked to another table.

We just need to add indexes in Postgres:

* First of all we create index in **tweets** table

    `twitter=# CREATE INDEX id_usuari_tweets_idx ON tweets (id_usuari);`
    
    `twitter=# CREATE INDEX id_foto_tweets_idx ON tweets (foto);`

* Secondly we create index in **comentaris** table

    `twitter=# CREATE INDEX id_usuari_comentari_idx ON comentaris (id_usuari_comentari);`
    
    `twitter=# CREATE INDEX id_tweet_idx ON comentaris (id_tweet);`

* Thirdly  we create index in **likes** table

    `twitter=# CREATE INDEX id_usuari_comentari_likes_idx ON likes (id_usuari_like);`
    
    `twitter=# CREATE INDEX id_tweet_likes_idx ON likes (id_tweet);`
    
* Fourthly we create index in **usuarislikescomentaris** table

    `twitter=# CREATE INDEX id_usuari_usuarislikescomentaris_idx ON usuarislikescomentaris(id_usuari);`
    
    `twitter=# CREATE INDEX id_comentari_usuarislikescomentaris_idx ON usuarislikescomentaris(id_comentari);`

* Fifthly we create index in **fotos** table

    `twitter=# CREATE INDEX id_tweet_fotos_idx ON fotos (id_tweet);`

* Sixthly we create index in **retweets** table

    `twitter=# CREATE INDEX id_usuari_retweets_idx ON retweets(id_usuari_retweet);`
    
    `twitter=# CREATE INDEX id_tweet_retweets_idx ON retweets (id_tweet);`

* Seventhly we create index in **hashtagstweets** table

    `twitter=# CREATE INDEX id_tweet_hashtagtweets_idx ON hashtagstweets (id_tweet);`
    
    `twitter=# CREATE INDEX id_hashtag_hashtagtweets_idx ON hashtagstweets (id_hashtag);`

* Lastly we create index in **seguidors** table

    `twitter=# CREATE INDEX id_usuariseguit_idx ON seguidors(id_usuari_seguit);`
    
    `twitter=# CREATE INDEX id_usuariseguidor_idx ON seguidors(id_usuari_seguidor);`


After adding the indexes we are ready to create _json_ files. 
We just need to follow the next steps:

* Obtain users data and redirect the output to a file,
  so as to have all users information (user password is **jupiter**). 

    `[user@host ]$ psql -p 5432 -U postgres -d twitter -c 
    'SELECT row_to_json(users) FROM 
    (SELECT id_usuari,nom,cognoms,password,username,
       telefon,data_alta,descripcio,ciutat,url,idioma,email,
    (SELECT array_to_json(array_agg(row_to_json(followers))) FROM 
      (SELECT data_seguidor,id_usuari_seguidor 
       FROM seguidors WHERE id_usuari=id_usuari_seguit) 
      followers) as seguidors FROM usuaris) users 
    ORDER BY users.id_usuari;' > /tmp/users.json`

* Obtain tweets data and redirect the output to a file, in order to have all tweets information (user password is **jupiter**). 

    `[user@host ]$ psql -p 5432 -U postgres -d twitter -c 
        'SELECT row_to_json(tweets) FROM 
        (SELECT id_tweet AS "_id",
        text_tweet,
        id_usuari,
        data_tweet,
        (SELECT array_to_json(array_agg(row_to_json(fotos))) FROM 
          (SELECT data_foto,text_foto FROM fotos WHERE tweets.id_tweet=fotos.id_tweet) fotos) as fotos,
        (SELECT row_to_json(row(lat,lon))) AS "geo",
        (SELECT array_to_json(array_agg(row_to_json(hashtags))) FROM 
          (SELECT hashtag,data_creacio_hashtag FROM hashtags JOIN hashtagstweets 
          ON hashtags.id_hashtag=hashtagstweets.id_hashtag WHERE tweets.id_tweet=hashtagstweets.id_tweet) hashtags) as hashtags,
        (SELECT array_to_json(array_agg(row_to_json(likes))) FROM 
          (SELECT id_usuari_like,data_like,esborrat FROM likes WHERE tweets.id_tweet=likes.id_tweet) likes) as likes,
        (SELECT array_to_json(array_agg(row_to_json(comentaris))) FROM 
          (SELECT id_usuari_comentari,data_comentari,text_comentari,(SELECT array_to_json(array_agg(row_to_json(likescomentari))) FROM 
          (SELECT id_usuari FROM usuarislikescomentaris WHERE comentaris.id_comentari=usuarislikescomentaris.id_comentari) likescomentari) as "likes_comentari" 
          FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) comentaris) as comentaris,
        (SELECT count(*) FROM likes WHERE tweets.id_tweet=likes.id_tweet) AS "num_likes",
        (SELECT count(*) FROM retweets WHERE tweets.id_tweet=retweets.id_tweet) AS "num_retweets",
        (SELECT count(*) FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) AS "num_comments",
        (SELECT array_to_json(array_agg(row_to_json(retweets))) FROM (SELECT id_usuari_retweet,data_retweet,text_retweet,esborrat FROM 
          retweets WHERE tweets.id_tweet=retweets.id_tweet) retweets) as retweets
    FROM tweets) tweets;' > /tmp/tweets.json`


Function _row_to_json_ converts one row into _json_ document. 
That means that we can transform each row of our table in Postgres into 
different documents in _json_ format. 

Function _array_agg_ creates an array. In this case we use this function to 
create different arrays of objects.



### Database Twitter on MongoDB

Finally, we have to add Twitter database to MongoDB. 
In this case is not necessary to run the interface. 
We can directly import database from _json_ or _csv_ file to the interface.

In this case we have **two** json files, the first one includes 
**tweets collection** and the second one includes **users collection**.

* First we import users collection.

    `[user@host ]$ mongoimport --db twitter --collection users --file /tmp/users.json --jsonArray`

* Then we import tweets collection.

    `[user@host ]$ mongoimport --db twitter --collection tweets --file /tmp/tweets.json --jsonArray`


##### Now we have finished creating Twitter database on MongoDB. 

---

Once we have added all information to Twitter database we can start using it. 

* First of all we enter to MongoDB interface.

    `[root@host ]# mongo`

* Once we have entered to MongoDB, we have to choose the database we want to work with.

    `> use twitter`

* Later we can see the different collections by using
    
    `> show collections`

* To select collections we want to work with we should specify in the find sentence.

   Working on users collection:
       
   `> db.users.find()`
    
   or working on tweets collection: 
   
   `> db.tweets.find()`

---

### Query Documents

As I said at the very beginning of this project syntax in MongoDB differs from Postgres.

Here you can see basic queries in Postgres and their translation into MongoDB's syntax.


PostgreSQL                                                                                                        | MongoDB
------------------------------------------------------------------------------------------------------------------|--------------
`CREATE TABLE tweets (id_tweet bigserial PRIMARY KEY,text_tweet varchar(280) NOT NULL,id_usuari bigint NOT NULL);`| Not Required
`INSERT INTO tweets(id_tweet,text_tweet,id_usuari)VALUES (DEFAULT,'Example tweet',1);`                            | `db.tweets.insert({ id_tweet: 1, text_tweet:'Example tweet', id_usuari: 1 })`
`SELECT * FROM tweets;`                                                                                           | `db.tweets.find()` 
`UPDATE tweets SET id_usuari = 2999 WHERE id_tweet=3000;`                                                         | `db.tweets.update({ id_usuari: 2999 },{ $set: { id_tweet: 3000 } },{ multi: true })`
`DELETE FROM tweets WHERE id_tweet=3000;`                                                                         | `db.tweets.remove({ _id: 3000 })`

---


## Testing query performance

Once we have the system with both interfaces, we are able to start 
testing different queries to compare speed rates and the number of accesses.


* First of all we are going to test both databases without indexes.


* To begin with we should remove indexes we have created before on Postgres.

    There is a script we can use to DROP all indexes. It is placed in [Postgres/delete_indexs.sql](https://github.com/isx45128227/MongoVsPostgres/blob/master/Postgres/delete_indexs.sql).
    We enter to Twitter database and import the script.
    
    `twitter=# \i /tmp/delete_indexs.sql` 


* Now we are ready to execute different queries on both interfaces and see the result.

    * First we are going to find tweets that contains the hashtag _#chip_.
    
        #### Postgres

        `twitter=# SELECT tweets.text_tweet FROM tweets JOIN usuaris ON 
        tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON 
        tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet 
        LIKE '%#chip%' ORDER BY usuaris.telefon;`
        
        Result (only the first one): `Tweet 4947 de prova d'un usuari que
        ha d'ocupar com a maxim 280 caracters per comparar Mongo amb Postgres. 
        que la seva ocupacio ha de ser com a maxim 280 caracters per 
        comparar Mongo amb Postgres. #chip #variation`
        
        
        #### MongoDB
        
        `> db.tweets.find({ "text_tweet":/#chip/},{"text_tweet":1,"_id":0})`
        
        Result (only the first one): `"text_tweet" : "Tweet 4947 de prova
        d'un usuari que ha d'ocupar com a maxim 280 caracters per comparar Mongo 
        amb Postgres. que la seva ocupacio ha de ser com a maxim 280 caracters 
        per comparar Mongo amb Postgres. #chip #variation"`
        
        
    * We can obtain the cost by doing:
        
        #### Postgres
        
        `twitter=# EXPLAIN ANALYZE SELECT tweets.text_tweet FROM tweets .
        JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets
        ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet 
        LIKE '%#chip%' ORDER BY usuaris.telefon;`
            
        ![Postgres query1 Twitter](Postgres/imatges/query1.png)


        #### MongoDB

        `> db.tweets.find({ "text_tweet":/#chip/},{"text_tweet":1,"_id":0}).explain("executionStats")`

        ![Mongo query1 Twitter](MongoDB/imatges/query1.png)
            
            
    * Now we are ready to analyze what it happened.
       
        #### Postgres
        
        As we see on the result, Postgres builds a tree structure representing 
        the different actions taken, with the root and each -> pointing to one of them. 
        Each tree’s branches represent sub-actions, and you’d work inside-out to determine what’s happening first.
        
        We can see that is using _id_usuari_ to join both tables. 
        

        
        
        #### MongoDB
    
        On the other hand, MongoDB represents the execution plan into 
        a _json_ document. We can focus on three different parts of the result:
        
        * The most important is the _cursor_. When _BasicCursor_ is displayed, 
          it means that a collection scan has been made, 
          so mongo had to scan the entire collection document by document to identify the results. 
          This is generally an expensive operation and can result in slow queries.
        
        * _n_ displays the matches made with the query.
        
        
        * Now we focus on _nscanned_ and _nscannedObjects_, that is 6000000, 
          this is the number of documents scanned to match the _n_ results.
          That happens when we don't use Indexs to reduce the number of accesses.
        
        The difference between the number of matching documents and the 
        number documents scanned may suggest that, to improve efficiency, 
        the query might benefit from the use of an index.
          

    * How can we solve this? Just adding Indexs on both interfaces and 
      seeing if they improve their performance.
    
        #### Postgres
        
        * As we did before, we need to add indexes to every single field 
          that is related to another table. 
          Here it is shown the different tables and the fields that are joined to other tables.
          
        
          Table                   |        Field           |  Relation           
          ------------------------|------------------------|-------------------
          Tweets                  | id_usuari              | Table usuaris 
          Tweets                  | foto                   | Table fotos 
          Comentaris              | id_usuari_comentari    | Table usuaris 
          Comentaris              | id_tweet               | Table tweets 
          Likes                   | id_usuari_like         | Table usuaris
          Likes                   | id_tweet               | Table tweets
          Usuarislikescomentaris  | id_usuari              | Table usuaris 
          Usuarislikescomentaris  | id_comentari           | Table comentaris 
          Fotos                   | id_tweet               | Table tweets
          Retweets                | id_usuari_retweet      | Table usuaris 
          Retweets                | id_tweet               | Table tweets
          Hashtagstweets          | id_tweet               | Table tweets
          Hashtagstweets          | id_hashtag             | Table hashtags
          Seguidors               | id_usuari_seguit       | Table usuaris 
          Seguidors               | id_usuari_seguidor     | Table usuaris 
        

        * Now we create the indexs.
        
            #### TWEETS

            `twitter=# CREATE INDEX id_usuari_tweets_idx ON tweets (id_usuari);`
            
            `twitter=# CREATE INDEX id_foto_tweets_idx ON tweets (foto);`
            
            #### COMENTARIS 
            
            `twitter=# CREATE INDEX id_usuari_comentari_idx ON comentaris (id_usuari_comentari);`
            
            `twitter=# CREATE INDEX id_tweet_idx ON comentaris (id_tweet);`
            
            #### LIKES
            
            `twitter=# CREATE INDEX id_usuari_comentari_likes_idx ON likes (id_usuari_like);`
            
            `twitter=# CREATE INDEX id_tweet_likes_idx ON likes (id_tweet);`
            
            #### USUARISLIKESCOMENTARIS
            
            `twitter=# CREATE INDEX id_usuari_usuarislikescomentaris_idx ON usuarislikescomentaris(id_usuari);`
            
            `twitter=# CREATE INDEX id_comentari_usuarislikescomentaris_idx ON usuarislikescomentaris(id_comentari);`
            
            #### FOTOS
            
            `twitter=# CREATE INDEX id_tweet_fotos_idx ON fotos (id_tweet);`
            
            #### RETWEETS
            
            `twitter=# CREATE INDEX id_usuari_retweets_idx ON retweets(id_usuari_retweet);`
            
            `twitter=# CREATE INDEX id_tweet_retweets_idx ON retweets (id_tweet);`
            
            #### HASHTAGSTWEETS
            
            `twitter=# CREATE INDEX id_tweet_hashtagtweets_idx ON hashtagstweets (id_tweet);`
            
            `twitter=# CREATE INDEX id_hashtag_hashtagtweets_idx ON hashtagstweets (id_hashtag);`
            
            #### SEGUIDORS
            
            `twitter=# CREATE INDEX id_usuariseguit_idx ON seguidors(id_usuari_seguit);`
            
            `twitter=# CREATE INDEX id_usuariseguidor_idx ON seguidors(id_usuari_seguidor);`
        
        
        #### MongoDB
        
           Now we add the Index in MongoDB. The syntax and their creation
           differs from Postgres, but it has the same effect. 
           
           That index can search in MongoDB as it was Google Search.
           To do it we should follow this step:

           `> db.tweets.createIndex({text_tweet:"text"},{"name":"cerca_paraules_tweet"})`
           
           
    * Once we have created the indexes on both interfaces we can repeat 
      the previous process to see what has changed.
    
        #### Postgres
        
        We repeat the query to see the execution process.
        
        `twitter=# EXPLAIN ANALYZE SELECT tweets.text_tweet FROM tweets 
        JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets 
        ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet 
        LIKE '%#chip%' ORDER BY usuaris.telefon;`
         
        ![Postgres query2 Twitter](Postgres/imatges/query2.png)
        
        
        
        
        

       
        
        #### MongoDB
        
        Having created the index as if it was Google Search, we should use another way to search the previous query.

        `> db.tweets.find({$text:{$search:"/#chip/"}},{"text_tweet":1,"_id":0}).explain("executionStats")`
        
        ![Mongo query2 Twitter](MongoDB/imatges/query2.png)
        
        This time we see that the result has changed. We must focus on four different parts:
        
        * _cursor_ this time displays _TextCursor_ to indicate index used and its name. 
        
        * _n_ displays the number of matches made with the query.
        
        * _nscanned_ displays 296 to indicate that MongoDB scanned 296 index entries. 
          So we have reduced the number of objects scanned from 6 million to 296.

        * _nscannedObjects_ displays 296 to indicate that MongoDB scanned 296 documents. 
          Again we reduced the number of objects scanned from 6 million to 296.




## Query attack 

Once we have tested the query performance with only one query at the same 
time and having dedicated all machine, we must try what would 
happen if multiple queries are sent at the same time.
























## Docker interface

To test queries in Postgres and MongoDB interfaces I have created two different Dockers. 
Both of them include the entire twitter database.


### Postgres docker

* First of all we download and run Postgres docker from [DockerHub](https://hub.docker.com/r/isx45128227/postgrestwitter/), 
  where I have the image already created. 

    `[user@host ]$ docker run --name postgrestwitter -h postgrestwitter -d isx45128227/postgrestwitter`


* Later we run our queries using psql and user docker (user password is **jupiter**). 
  Check first the ip address of your docker, it could not be the same.
  You should wait a little bit until twitter database is ready (about 1 minute).

    `[user@host ]$ psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT * FROM usuaris;'`
    
    `[user@host ]$ psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c "SELECT count(*) FROM tweets WHERE text_tweet LIKE '%#sale%';"`
    
    `[user@host ]$ psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c "SELECT * FROM tweets WHERE text_tweet LIKE '%#%';"`
    
  
  If we want to override the password prompt, we must add into our home a file named **.pgpass** that contains the following line:
  
    `172.17.0.2:5432:twitter:docker:jupiter`
    
  And then change permissions to that file:
   
    `chmod 0600 .pgpass`
    
  Now we can execute queries without entering the password.


* It is also created a [Dockerfile](https://github.com/isx45128227/MongoVsPostgres/blob/master/dockerPostgres/Dockerfile) 
  with the specifications, but the main problem is that the dump database is about 2GB and GitHub doesn't allow me to upload this file.


### MongoDB docker

* First of all we download and run MongoDB docker from [DockerHub](https://hub.docker.com/r/isx45128227/mongotwitter/), 
  where I also have the image already created. 

    `[user@host ]$ docker run --name mongotwitter -h mongotwitter -d isx45128227/mongotwitter`

* There is a problem with Docker and MongoDB. Docker interface does not 
  allow Mongo to keep database data, so before we start using our 
  docker mongo we have to restore database information.

* First of all we enter into the docker.

    `[user@host ]$ docker exec -it mongotwitter /bin/bash`

* Then we run a script that regenerates all twitter database.
    
    `./tmp/restore.sh`

* Later we run our queries using mongo. We can run this command inside 
  the docker or if we have MongoDB installed in our machine we can run it outside. 
  Check first the ip address of your docker, it could not be the same.

    `[user@host ]$ mongo --host 172.17.0.3:27017 twitter`


* When we are inside mongo shell we can start running different queries.

    `> db.users.find()`
     
    `> db.tweets.find({"text_tweet":/#sale/i}).count()`
    
    `> db.tweets.find({"text_tweet":/#/i})`


* It is also created a [Dockerfile](https://github.com/isx45128227/MongoVsPostgres/blob/master/dockerMongo/Dockerfile) 
  with the specifications, but the main problem is that the dump database is about 3GB and GitHub doesn't allow me to upload this file.
