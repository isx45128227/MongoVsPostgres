twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;

twitter=# EXPLAIN SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;
twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' ORDER BY usuaris.telefon;
twitter=# SELECT * FROM tweets WHERE text_tweet LIKE '% 500%';

twitter=# SELECT * FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet JOIN seguidors a ON usuaris.id_usuari=a.id_usuari_seguit JOIN usuaris b ON b.id_usuari=a.id_usuari_seguit WHERE text_tweet LIKE '%500%' AND usuaris.id_usuari=93177 ORDER BY usuaris.telefon;


twitter=# UPDATE tweets SET text_tweet = text_tweet || ' que la seva ocupacio ha de ser com a maxim 280 caracters per comparar Mongo amb Postgres.';


twitter=# SELECT tweets.text_tweet FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet LIKE '%#chip%' ORDER BY usuaris.telefon;
twitter=# SELECT tweets.text_tweet FROM tweets JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet WHERE text_tweet LIKE '%maxim%' ORDER BY usuaris.telefon;




psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c "SELECT * FROM comentaris JOIN tweets ON tweets.id_tweet=comentaris.id_tweet JOIN usuarislikescomentaris ON comentaris.id_comentari=usuarislikescomentaris.id_comentari WHERE comentaris.id_tweet=3;"

psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT retweets.id_retweet,retweets.id_usuari_retweet,retweets.data_retweet,retweets.text_retweet FROM tweets JOIN retweets ON tweets.id_tweet=retweets.id_tweet JOIN usuaris ON usuaris.id_usuari=retweets.id_usuari_retweet WHERE tweets.id_tweet=3;'

psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT * FROM tweets JOIN retweets ON tweets.id_tweet=retweets.id_tweet JOIN usuaris ON usuaris.id_usuari=retweets.id_usuari_retweet WHERE tweets.id_tweet=3;'

psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT comentaris.id_usuari_comentari AS "id user", comentaris.text_comentari AS "text", usuarislikescomentaris.id_usuari AS "usuari likecomentari", usuarislikescomentaris.id_comentari AS "comid" FROM comentaris JOIN tweets ON tweets.id_tweet=comentaris.id_tweet JOIN usuarislikescomentaris ON usuarislikescomentaris.id_comentari=comentaris.id_comentari WHERE comentaris.id_tweet=3;'


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

