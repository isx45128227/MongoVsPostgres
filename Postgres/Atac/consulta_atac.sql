-- Consulta que es realitzara amb script d'atac a Postgres

SELECT tweets.id_tweet AS "id_tweet", tweets.text_tweet AS "text_tweet", 
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
   WHERE text_tweet LIKE '%#chip%' GROUP BY tweets.id_tweet,usuaris.id_usuari,hashtags.id_hashtag;
