# RDBMS vs NoSQL databases

---

## Objectius

* Donar a conèixer les bases de dades no relacionals.

* Diferències d'ús entre les BBDD relacionals i les no relacionals.

* Mostrar la sintaxi utilitzada en ambdues interfícies.

* Exemples d'ús en entorn "real".

---


## Introducció a MongoDB i PostgreSQL

* Postgres

PostgreSQL és una eina _open source_ que permet gestionar bases de dades relacionals.


* MongoDB

MongoDB també és una eina _opensource_ però gestiona bases de dades no relacionals.

---


##  Construcció de la BBDD

* Estructura en PostgreSQL.

![Postgres Twitter Structure](https://raw.githubusercontent.com/isx45128227/MongoVsPostgres/master/Postgres/imatges/twitter.png)
 
* Estructura en MongoDB.

![Mongo tweets Twitter Structure](https://raw.githubusercontent.com/isx45128227/MongoVsPostgres/master/MongoDB/imatges/tweets1.png)
![Mongo tweets Twitter Structure](https://raw.githubusercontent.com/isx45128227/MongoVsPostgres/master/MongoDB/imatges/tweets2.png)
![Mongo tweets Twitter Structure](https://raw.githubusercontent.com/isx45128227/MongoVsPostgres/master/MongoDB/imatges/users.png)
 
---


## Proves de queries lents

* Construcció de queries lents.

* Prova in situ de query lent a Twittersenseindexs.

    * Postgres

        * Prova buscant directament a taula tweets.
        
            ```
             EXPLAIN ANALYZE SELECT tweets.id_tweet AS "id_tweet", tweets.text_tweet AS "text_tweet", 
            tweets.id_usuari AS "user_tweet", usuaris.nom AS "nom_user" ,usuaris.username AS "username" ,
            hashtags.hashtag AS "hashtag_used" ,count(likes.id_usuari_like) AS "user_like", 
            count(comentaris.id_usuari_comentari) AS "user_comment", count(seguidors.id_usuari_seguidor) 
            FROM tweets 
            JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
            LEFT JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
            LEFT JOIN seguidors ON usuaris.id_usuari=seguidors.id_usuari_seguit
            LEFT JOIN hashtags ON hashtagstweets.id_hashtag=hashtags.id_hashtag
            LEFT JOIN likes ON tweets.id_tweet=likes.id_tweet
            LEFT JOIN comentaris ON tweets.id_tweet=comentaris.id_tweet 
            WHERE text_tweet LIKE '%#chip%' GROUP BY tweets.id_tweet,usuaris.id_usuari,hashtags.id_hashtag ORDER BY 1;
            ```
	    
        * Prova buscant a taula hashtags (solució 1).
	    
            ```
            SELECT tweets.id_tweet AS "id_tweet", tweets.text_tweet AS "text_tweet", 
            tweets.id_usuari AS "user_tweet", count(likes.id_usuari_like) AS "user_like", 
            count(comentaris.id_usuari_comentari) AS "user_comment", count(seguidors.id_usuari_seguidor) 
            FROM tweets 
            JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
            JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
            LEFT JOIN seguidors ON usuaris.id_usuari=seguidors.id_usuari_seguit
            JOIN hashtags ON hashtagstweets.id_hashtag=hashtags.id_hashtag
            LEFT JOIN likes ON tweets.id_tweet=likes.id_tweet
            LEFT JOIN comentaris ON tweets.id_tweet=comentaris.id_tweet 
            WHERE hashtags.hashtag='chip' GROUP BY tweets.id_tweet;
            ```
            
        * Prova in situ de query lent a Twitter amb index (solució 2).
        
            ```
             EXPLAIN ANALYZE SELECT tweets.id_tweet AS "id_tweet", tweets.text_tweet AS "text_tweet", 
            tweets.id_usuari AS "user_tweet", usuaris.nom AS "nom_user" ,usuaris.username AS "username" ,
            hashtags.hashtag AS "hashtag_used" ,count(likes.id_usuari_like) AS "user_like", 
            count(comentaris.id_usuari_comentari) AS "user_comment", count(seguidors.id_usuari_seguidor) 
            FROM tweets 
            JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
            LEFT JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
            LEFT JOIN seguidors ON usuaris.id_usuari=seguidors.id_usuari_seguit
            LEFT JOIN hashtags ON hashtagstweets.id_hashtag=hashtags.id_hashtag
            LEFT JOIN likes ON tweets.id_tweet=likes.id_tweet
            LEFT JOIN comentaris ON tweets.id_tweet=comentaris.id_tweet 
            WHERE text_tweet LIKE '%#chip%' GROUP BY tweets.id_tweet,usuaris.id_usuari,hashtags.id_hashtag ORDER BY 1;
            ```
            
            
    * MongoDB
    
        * Prova in situ de query lent a Twitter sense index.
        
          `db.tweets.find({ "text_tweet":/#chip/},{"text_tweet":1,"_id":0}).explain("executionStats")`
        
        
        * Prova in situ de query lent a Twitter amb index.
    
          `db.tweets.find({$text:{$search:"/#chip/"}},{"text_tweet":1,"_id":0}).explain("executionStats")`
    
    
* Comentar resultats.
    

---


## Simulació d'ús en entorn real

* Construcció de queries atac.

* Prova in situ.

    * Postgres
    
        `./atac.sh`
    
    
    * MongoDB
    
        `./atac.sh`


* Comentar resultats.

---


## Manteniment de la base de dades

* Postgres.

* MongoDB.


---


## Conclusions

* Quina és més adient?

* Es pot utilitzar MongoDB en tots els casos?

* Hi ha coherència de dades en ambdues?

---


## Gràcies per la vostra atenció.
