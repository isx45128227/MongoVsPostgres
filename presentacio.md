## PRESENTACIO

Portada

Objectius

Introducció Mongo i Postgres (diferències)

Explicació construcció BBDD

* Explicació estructura en Postgres (FOTO) explicar hashtagstweets.
 
* Explicació estructura en MongoDB (FOTO)
 
* Explicació populació de dades
 
* Explicació pas dades de Postgres a MongoDB (funció row_to_json) 
  (explicar problema amb temps i creació necessària d'indexs). (AMB EXEMPLE)
 
* Explicació diferència queries (La manera en com es fan db.find vs SELECT).


Proves de queries lents

* Construcció de queries lents.

* Prova in situ de query lent.

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
 
    * Prova buscant a taula hashtags.

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
  
