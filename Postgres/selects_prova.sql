
-- COPY TABLES

COPY hashtags FROM '/tmp/hashtags.csv' DELIMITER ',' CSV HEADER;
COPY usuaris FROM '/tmp/usuaris.csv' DELIMITER ',' CSV HEADER;
COPY tweets(id_tweet,text_tweet,id_usuari,data_tweet) FROM '/tmp/tweets.csv' DELIMITER ',' CSV HEADER;
COPY fotos(id_foto,text_foto,id_tweet,data_foto) FROM '/tmp/fotos.csv' DELIMITER ',' CSV HEADER;
COPY likes(id_like,data_like,id_usuari_like,id_tweet) FROM '/tmp/likes.csv' DELIMITER ',' CSV HEADER;
COPY seguidors FROM '/tmp/seguidors.csv' DELIMITER ',' CSV HEADER;
COPY retweets(id_retweet,data_retweet,text_retweet,id_usuari_retweet,id_tweet) FROM '/tmp/retweets.csv' DELIMITER ',' CSV HEADER;
COPY comentaris(id_comentari,data_comentari,text_comentari,id_usuari_comentari,id_tweet) FROM '/tmp/comentaris.csv' DELIMITER ',' CSV HEADER;
COPY hashtagstweets FROM '/tmp/hashtagstweets.csv' DELIMITER ',' CSV HEADER;
COPY usuarislikescomentaris FROM '/tmp/usuarislikescomentaris.csv' DELIMITER ',' CSV HEADER;


-- SELECTS AMB JOIN

twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;

twitter=# EXPLAIN SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;
twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;
twitter=# SELECT * FROM tweets WHERE text_tweet LIKE '% 500%';

twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' AND usuaris.id_usuari=93177 ORDER BY usuaris.telefon;

twitter=# UPDATE tweets SET text_tweet = text_tweet || ' que la seva ocupacio ha de ser com a maxim 280 caracters per comparar Mongo amb Postgres.';

twitter=# SELECT tweets.text_tweet FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet LIKE '%#chip%' ORDER BY usuaris.telefon
SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' AND usuaris.id_usuari=93177 ORDER BY usuaris.telefon;;
twitter=# SELECT tweets.text_tweet FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet LIKE '%maxim%' ORDER BY usuaris.telefon;


-- SELECTS psql

psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c "SELECT * FROM comentaris JOIN tweets ON tweets.id_tweet=comentaris.id_tweet JOIN usuarislikescomentaris ON comentaris.id_comentari=usuarislikescomentaris.id_comentari WHERE comentaris.id_tweet=3;"

psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT retweets.id_retweet,retweets.id_usuari_retweet,retweets.data_retweet,retweets.text_retweet FROM tweets JOIN retweets ON tweets.id_tweet=retweets.id_tweet JOIN usuaris ON usuaris.id_usuari=retweets.id_usuari_retweet WHERE tweets.id_tweet=3;'

psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT * FROM tweets JOIN retweets ON tweets.id_tweet=retweets.id_tweet JOIN usuaris ON usuaris.id_usuari=retweets.id_usuari_retweet WHERE tweets.id_tweet=3;'

psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT comentaris.id_usuari_comentari AS "id user", comentaris.text_comentari AS "text", usuarislikescomentaris.id_usuari AS "usuari likecomentari", usuarislikescomentaris.id_comentari AS "comid" FROM comentaris JOIN tweets ON tweets.id_tweet=comentaris.id_tweet JOIN usuarislikescomentaris ON usuarislikescomentaris.id_comentari=comentaris.id_comentari WHERE comentaris.id_tweet=3;'



-- EXPLAIN SELECT

twitter=# EXPLAIN SELECT tweets.text_tweet FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet LIKE '%maxim%' ORDER BY usuaris.telefon;
                                               QUERY PLAN                                                
---------------------------------------------------------------------------------------------------------
 Sort  (cost=431843.91..433093.79 rows=499949 width=213)
   Sort Key: usuaris.telefon
   ->  Merge Join  (cost=62353.91..281991.19 rows=499949 width=213)
         Merge Cond: (tweets.id_tweet = hashtagstweets.id_tweet)
         ->  Nested Loop  (cost=0.85..1299973.15 rows=379429 width=221)
               ->  Index Scan using tweets_pkey on tweets  (cost=0.42..1011553.53 rows=379429 width=219)
                     Filter: ((text_tweet)::text ~~ '%maxim%'::text)
               ->  Index Scan using usuaris_pkey on usuaris  (cost=0.42..0.75 rows=1 width=18)
                     Index Cond: (id_usuari = tweets.id_usuari)
         ->  Materialize  (cost=62352.81..64852.80 rows=499999 width=8)
               ->  Sort  (cost=62352.81..63602.81 rows=499999 width=8)
                     Sort Key: hashtagstweets.id_tweet
                     ->  Seq Scan on hashtagstweets  (cost=0.00..8184.99 rows=499999 width=8)
(13 rows)


twitterindexs=# EXPLAIN SELECT tweets.text_tweet FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet LIKE '%maxim%' ORDER BY usuaris.telefon;
                                               QUERY PLAN                                               
--------------------------------------------------------------------------------------------------------
 Sort  (cost=437338.14..438588.01 rows=499949 width=213)
   Sort Key: usuaris.telefon
   ->  Hash Join  (cost=117150.47..287485.41 rows=499949 width=213)
         Hash Cond: (tweets.id_usuari = usuaris.id_usuari)
         ->  Merge Join  (cost=62353.49..190660.14 rows=499949 width=211)
               Merge Cond: (tweets.id_tweet = hashtagstweets.id_tweet)
               ->  Index Scan using tweets_idx on tweets  (cost=0.43..699763.00 rows=5999400 width=219)
                     Filter: ((text_tweet)::text ~~ '%maxim%'::text)
               ->  Materialize  (cost=62352.81..64852.80 rows=499999 width=8)
                     ->  Sort  (cost=62352.81..63602.81 rows=499999 width=8)
                           Sort Key: hashtagstweets.id_tweet
                           ->  Seq Scan on hashtagstweets  (cost=0.00..8184.99 rows=499999 width=8)
         ->  Hash  (cost=36436.99..36436.99 rows=999999 width=18)
               ->  Seq Scan on usuaris  (cost=0.00..36436.99 rows=999999 width=18)
(14 rows)



--- POSTGRES TO JSON
-- COLLECTION USERS

SELECT row_to_json(users) FROM 
    (SELECT id_usuari,nom,cognoms,password,username,telefon,data_alta,descripcio,ciutat,url,idioma,email,
        (SELECT array_to_json(array_agg(row_to_json(followers))) FROM 
            (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE id_usuari=id_usuari_seguit) followers) as seguidors FROM usuaris) 
        users ORDER BY users.id_usuari;


psql -p 5432 -U postgres -d twitter -c 'SELECT row_to_json(users) FROM (SELECT id_usuari,nom,cognoms,password,username,telefon,data_alta,descripcio,ciutat,url,idioma,email,(SELECT array_to_json(array_agg(row_to_json(followers))) FROM (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE id_usuari=id_usuari_seguit) followers) as seguidors FROM usuaris) users ORDER BY users.id_usuari LIMIT 1000;' > users.json


-- COLLECTION TWEETS
SELECT row_to_json(tweets) FROM 
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
FROM tweets) tweets;
