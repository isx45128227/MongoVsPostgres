twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;

twitter=# EXPLAIN SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;
twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;
twitter=# SELECT * FROM tweets WHERE text_tweet LIKE '% 500%';

twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' AND usuaris.id_usuari=93177 ORDER BY usuaris.telefon;


twitter=# UPDATE tweets SET text_tweet = text_tweet || ' que la seva ocupacio ha de ser com a maxim 280 caracters per comparar Mongo amb Postgres.';
