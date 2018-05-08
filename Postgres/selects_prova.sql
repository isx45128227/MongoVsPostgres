
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


psql -p 5432 -U postgres -d twitter -c 'SELECT row_to_json(users) FROM 
    (SELECT id_usuari,nom,cognoms,password,username,telefon,data_alta,descripcio,ciutat,url,idioma,email,
    (SELECT array_to_json(array_agg(row_to_json(followers))) FROM 
    (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE id_usuari=id_usuari_seguit) followers) as seguidors
    FROM usuaris) users ORDER BY users.id_usuari LIMIT 1000;' > users.json


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


psql -p 5432 -U postgres -d twitter -c 'SELECT row_to_json(tweets) FROM (SELECT id_tweet AS "_id",text_tweet,id_usuari,data_tweet,(SELECT array_to_json(array_agg(row_to_json(fotos))) FROM (SELECT data_foto,text_foto FROM fotos WHERE tweets.id_tweet=fotos.id_tweet) fotos) as fotos,(SELECT row_to_json(row(lat,lon))) AS "geo",(SELECT array_to_json(array_agg(row_to_json(hashtags))) FROM (SELECT hashtag,data_creacio_hashtag FROM hashtags JOIN hashtagstweets ON hashtags.id_hashtag=hashtagstweets.id_hashtag WHERE tweets.id_tweet=hashtagstweets.id_tweet) hashtags) as hashtags,(SELECT array_to_json(array_agg(row_to_json(likes))) FROM (SELECT id_usuari_like,data_like,esborrat FROM likes WHERE tweets.id_tweet=likes.id_tweet) likes) as likes,(SELECT array_to_json(array_agg(row_to_json(comentaris))) FROM (SELECT id_usuari_comentari,data_comentari,text_comentari,(SELECT array_to_json(array_agg(row_to_json(likescomentari))) FROM (SELECT id_usuari FROM usuarislikescomentaris WHERE comentaris.id_comentari=usuarislikescomentaris.id_comentari) likescomentari) as "likes_comentari" FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) comentaris) as comentaris,(SELECT count(*) FROM likes WHERE tweets.id_tweet=likes.id_tweet) AS "num_likes",(SELECT count(*) FROM retweets WHERE tweets.id_tweet=retweets.id_tweet) AS "num_retweets",(SELECT count(*) FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) AS "num_comments",(SELECT array_to_json(array_agg(row_to_json(retweets))) FROM (SELECT id_usuari_retweet,data_retweet,text_retweet,esborrat FROM retweets WHERE tweets.id_tweet=retweets.id_tweet) retweets) as retweets FROM tweets) tweets;' > tweets.json


-- OBTENIR VISTES I TAULES DE BBDD A POSTGRES


psql -h 172.17.0.3 -p 5432 -U docker -d twitter -c 'SELECT t1.TABLE_NAME AS nom_taula, PG_CATALOG.OBJ_DESCRIPTION(t2.OID) AS descripcio_taula FROM INFORMATION_SCHEMA.TABLES t1 INNER JOIN PG_CLASS t2 ON (t2.relname=t1.table_name) ORDER BY t1.TABLE_NAME;'



psql -h 172.17.0.3 -p 5432 -U docker -d twitter -c 'SELECT tablename,tableowner FROM pg_tables;'

        tablename        | tableowner 
-------------------------+------------
 pg_statistic            | postgres
 pg_type                 | postgres
 fotos                   | postgres
 pg_authid               | postgres
 pg_attribute            | postgres
 pg_proc                 | postgres
 pg_class                | postgres
 pg_user_mapping         | postgres
 pg_constraint           | postgres
 pg_inherits             | postgres
 pg_index                | postgres
 pg_operator             | postgres
 pg_opfamily             | postgres
 pg_opclass              | postgres
 pg_am                   | postgres
 pg_amop                 | postgres
 pg_amproc               | postgres
 pg_language             | postgres
 pg_largeobject_metadata | postgres
 pg_database             | postgres
 pg_rewrite              | postgres
 pg_trigger              | postgres
 pg_event_trigger        | postgres
 pg_description          | postgres
 pg_cast                 | postgres
 pg_enum                 | postgres
 pg_namespace            | postgres
 pg_conversion           | postgres
 pg_depend               | postgres
 pg_db_role_setting      | postgres
 pg_tablespace           | postgres
 pg_pltemplate           | postgres
 pg_auth_members         | postgres
 pg_shdepend             | postgres
 pg_shdescription        | postgres
 pg_ts_config            | postgres
 pg_ts_config_map        | postgres
 pg_ts_dict              | postgres
 pg_ts_parser            | postgres
 pg_ts_template          | postgres
 pg_extension            | postgres
 pg_foreign_data_wrapper | postgres
 pg_foreign_server       | postgres
 pg_foreign_table        | postgres
 pg_default_acl          | postgres
 pg_seclabel             | postgres
 pg_shseclabel           | postgres
 pg_range                | postgres
 pg_largeobject          | postgres
 sql_implementation_info | postgres
 sql_languages           | postgres
 sql_packages            | postgres
 sql_sizing              | postgres
 sql_sizing_profiles     | postgres
 pg_attrdef              | postgres
 pg_aggregate            | postgres
 usuaris                 | postgres
 sql_features            | postgres
 pg_collation            | postgres
 sql_parts               | postgres
 hashtags                | postgres
 hashtagstweets          | postgres
 tweets                  | postgres
 comentaris              | postgres
 usuarislikescomentaris  | postgres
 retweets                | postgres
 likes                   | postgres
 seguidors               | postgres
(68 rows)



-- ANALISI


SELECT DISTINCT tweets.id_tweet AS "id_tweet", tweets.text_tweet AS "text_tweet", tweets.id_usuari AS "user_tweet", usuaris.nom AS "nom_user" ,usuaris.username AS "username" ,hashtags.hashtag AS "hashtag_used" ,likes.id_usuari_like AS "user_like", comentaris.id_usuari_comentari AS "user_comment", comentaris.text_comentari 
FROM tweets 
   JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
   JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
   JOIN seguidors ON usuaris.id_usuari=seguidors.id_usuari_seguit
   JOIN hashtags ON hashtagstweets.id_hashtag=hashtags.id_hashtag
   JOIN likes ON tweets.id_tweet=likes.id_tweet
   JOIN comentaris ON tweets.id_tweet=comentaris.id_tweet 
   WHERE text_tweet LIKE '%500%';

                                                                                             QUERY PLAN                                                                                              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=19945.05..19945.14 rows=9 width=300) (actual time=741.551..741.572 rows=116 loops=1)
   Group Key: tweets.id_tweet, tweets.text_tweet, tweets.id_usuari, usuaris.nom, usuaris.username, hashtags.hashtag, likes.id_usuari_like, comentaris.id_usuari_comentari, comentaris.text_comentari
   ->  Nested Loop  (cost=34.40..19944.85 rows=9 width=300) (actual time=369.968..740.984 rows=1076 loops=1)
         ->  Nested Loop  (cost=34.12..19942.10 rows=9 width=301) (actual time=369.960..739.934 rows=1076 loops=1)
               Join Filter: (tweets.id_usuari = usuaris.id_usuari)
               ->  Nested Loop  (cost=33.69..19934.53 rows=11 width=284) (actual time=369.947..738.608 rows=1076 loops=1)
                     ->  Merge Join  (cost=33.27..19904.89 rows=28 width=276) (actual time=120.370..737.680 rows=303 loops=1)
                           Merge Cond: (tweets.id_tweet = likes.id_tweet)
                           ->  Merge Join  (cost=32.29..46463.59 rows=842 width=284) (actual time=37.862..707.679 rows=1583 loops=1)
                                 Merge Cond: (tweets.id_tweet = hashtagstweets.id_tweet)
                                 ->  Merge Join  (cost=30.85..119945.96 rows=10101 width=268) (actual time=3.767..635.730 rows=2997 loops=1)
                                       Merge Cond: (tweets.id_tweet = comentaris.id_tweet)
                                       ->  Index Scan using tweets_pkey on tweets  (cost=0.43..2387285.81 rows=60606 width=219) (actual time=0.633..117.475 rows=301 loops=1)
                                             Filter: ((text_tweet)::text ~~ '%500%'::text)
                                             Rows Removed by Filter: 100199
                                       ->  Index Scan using id_tweet_idx on comentaris  (cost=0.42..79212.34 rows=999999 width=49) (actual time=0.002..460.730 rows=999999 loops=1)
                                 ->  Index Scan using id_tweet_hashtagtweets_idx on hashtagstweets  (cost=0.42..25736.41 rows=499999 width=16) (actual time=0.003..69.010 rows=51316 loops=1)
                           ->  Index Scan using id_tweet_likes_idx on likes  (cost=0.42..11872.39 rows=199999 width=16) (actual time=0.005..28.817 rows=19846 loops=1)
                     ->  Index Only Scan using id_usuariseguit_idx on seguidors  (cost=0.42..0.95 rows=11 width=8) (actual time=0.001..0.003 rows=4 loops=303)
                           Index Cond: (id_usuari_seguit = tweets.id_usuari)
                           Heap Fetches: 1076
               ->  Index Scan using usuaris_pkey on usuaris  (cost=0.42..0.68 rows=1 width=33) (actual time=0.001..0.001 rows=1 loops=1076)
                     Index Cond: (id_usuari = seguidors.id_usuari_seguit)
         ->  Index Scan using hashtags_pkey on hashtags  (cost=0.28..0.30 rows=1 width=15) (actual time=0.001..0.001 rows=1 loops=1076)
               Index Cond: (id_hashtag = hashtagstweets.id_hashtag)
 Planning time: 5.527 ms
 Execution time: 741.640 ms
(27 rows)


SELECT DISTINCT usuaris.nom AS "nom_user" ,usuaris.username AS "username" , 
FROM tweets 
   JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
   WHERE text_tweet LIKE '%500%';
   
   
db.tweets.find({"text_tweet":/500/i},{"_id":1,"text_tweet":1,"id_usuari":1,"hashtags.text":1,"likes.usuari_like":1,"comentaris.usuari_comentari":1,"comentaris.text_comentari":1}).explain("executionStats")
{
	"cursor" : "BasicCursor",
	"isMultiKey" : false,
	"n" : 33974,
	"nscannedObjects" : 6000000,
	"nscanned" : 6000000,
	"nscannedObjectsAllPlans" : 6000000,
	"nscannedAllPlans" : 6000000,
	"scanAndOrder" : false,
	"indexOnly" : false,
	"nYields" : 68050,
	"nChunkSkips" : 0,
	"millis" : 8207,
	"allPlans" : [
		{
			"cursor" : "BasicCursor",
			"isMultiKey" : false,
			"n" : 33974,
			"nscannedObjects" : 6000000,
			"nscanned" : 6000000,
			"scanAndOrder" : false,
			"indexOnly" : false,
			"nChunkSkips" : 0
		}
	],
	"server" : "mongotwitter:27017",
	"filterSet" : false,
	"stats" : {
		"type" : "PROJECTION",
		"works" : 6024447,
		"yields" : 68050,
		"unyields" : 68050,
		"invalidates" : 0,
		"advanced" : 33974,
		"needTime" : 0,
		"needFetch" : 24445,
		"isEOF" : 1,
		"children" : [
			{
				"type" : "COLLSCAN",
				"works" : 6024447,
				"yields" : 68050,
				"unyields" : 68050,
				"invalidates" : 0,
				"advanced" : 33974,
				"needTime" : 5966027,
				"needFetch" : 0,
				"isEOF" : 1,
				"docsTested" : 6000000,
				"children" : [ ]
			}
		]
	}
}


db.tweets.find({$text:{$search:"\"500\""}},{"_id":1,"text_tweet":1,"id_usuari":1,"hashtags.text":1,"likes.usuari_like":1,"comentaris.usuari_comentari":1,"comentaris.text_comentari":1}).explain("executionStats")


