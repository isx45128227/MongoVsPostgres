-- TEST QUERIES POSTGRESQL

-- Mostrar informació usuari
SELECT id_usuari,nom,cognoms,descripcio,ciutat,email
FROM usuaris;


-- Tweet que tingui el text 5000
SELECT *
FROM tweets
WHERE text_tweet LIKE '%5000%';


-- Tweet que acabi amb el text 5000
SELECT *
FROM tweets
WHERE text_tweet LIKE '5000%';


-- Tweet que comenci amb el text 5000
SELECT *
FROM tweets
WHERE text_tweet LIKE '%5000';

------------------------------------------------------------------------

-- SELECTS JOIN

-- Tots els camps dels tweets, els usuaris i hashtagstweets que contenen
-- el text 500 i ordenat per el nom de l'usuari.
SELECT * 
FROM tweets 
 JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
 JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
 WHERE text_tweet 
 LIKE '%500%' 
 ORDER BY usuaris.nom;


-- Tots els camps dels tweets que contenen el text _500_.
SELECT * FROM tweets WHERE text_tweet LIKE '% 500%';


-- Actualitza la taula tweets i afegeix el text "que la seva ocupacio ha
-- de ser com a maxim 280 caracters per comparar Mongo amb Postgres." 
-- al text del tweet. 
UPDATE tweets 
 SET text_tweet = text_tweet || ' que la seva ocupacio ha de ser com a maxim 280 caracters per comparar Mongo amb Postgres.';


-- Text dels tweets que contenen el hashtag #chip i ciutat de l'usuari, 
-- ordenat per la ciutat dels usuaris.
SELECT tweets.text_tweet,usuaris.ciutat
FROM tweets 
 JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
 JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
 WHERE text_tweet 
 LIKE '%#chip%' 
 ORDER BY usuaris.ciutat;


-- Text dels tweets que contenen la paraula maxim i nom de l'usuari, 
-- ordenar per el nom descendentment.
SELECT tweets.text_tweet 
FROM tweets 
 JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
 JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
 WHERE text_tweet 
 LIKE '%maxim%' 
 ORDER BY usuaris.nom DESC;
 
------------------------------------------------------------------------

-- Queries docker

-- Comentaris i usuaris que han donat like als comentaris del tweet 3.
psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c "SELECT comentaris.text_comentari, usuarislikescomentaris.id_usuari,usuaris.nom
FROM comentaris 
 JOIN tweets ON tweets.id_tweet=comentaris.id_tweet 
 JOIN usuarislikescomentaris ON comentaris.id_comentari=usuarislikescomentaris.id_comentari 
 JOIN usuaris ON usuarislikescomentaris.id_usuari=usuaris.id_usuari
 WHERE comentaris.id_tweet=3;"


-- Retweets del tweet 7.
psql -h 172.17.0.2 -p 5432 -U docker -d twitter -c 'SELECT retweets.id_retweet,retweets.id_usuari_retweet,retweets.data_retweet,retweets.text_retweet,usuaris.nom
FROM tweets 
 JOIN retweets ON tweets.id_tweet=retweets.id_tweet 
 JOIN usuaris ON usuaris.id_usuari=retweets.id_usuari_retweet 
 WHERE tweets.id_tweet=7;'



-- EXPLAIN SELECT

EXPLAIN SELECT tweets.text_tweet 
FROM tweets 
 JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
 JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
 WHERE text_tweet 
 LIKE '%maxim%' 
 ORDER BY usuaris.nom;
                                                                 QUERY PLAN                                         
-------------------------------------------------------------------------------------------
 Sort  (cost=1177594.96..1178582.74 rows=395109 width=208)
   Sort Key: usuaris.nom
   ->  Hash Join  (cost=857982.48..1101700.85 rows=395109 width=208)
         Hash Cond: (tweets.id_usuari = usuaris.id_usuari)
         ->  Hash Join  (cost=804162.50..1007877.97 rows=499949 width=211)
               Hash Cond: (hashtagstweets.id_tweet = tweets.id_tweet)
               ->  Seq Scan on hashtagstweets  (cost=0.00..8184.99 rows=499999 width=8)
               ->  Hash  (cost=547547.00..547547.00 rows=5999400 width=219)
                     ->  Seq Scan on tweets  (cost=0.00..547547.00 rows=5999400 width=219)
                           Filter: ((text_tweet)::text ~~ '%maxim%'::text)
         ->  Hash  (cost=36436.99..36436.99 rows=999999 width=13)
               ->  Seq Scan on usuaris  (cost=0.00..36436.99 rows=999999 width=13)
(12 rows)
  
                           
EXPLAIN SELECT tweets.text_tweet 
FROM tweets 
 JOIN usuaris ON tweets.id_usuari=usuaris.id_usuari 
 JOIN hashtagstweets ON tweets.id_tweet=hashtagstweets.id_tweet 
 WHERE text_tweet 
 LIKE '%maxim%';

                                              QUERY PLAN                                      
-------------------------------------------------------------------------------------
 Hash Join  (cost=857006.48..1099748.85 rows=395109 width=203)
   Hash Cond: (tweets.id_usuari = usuaris.id_usuari)
   ->  Hash Join  (cost=804162.50..1007877.97 rows=499949 width=211)
         Hash Cond: (hashtagstweets.id_tweet = tweets.id_tweet)
         ->  Seq Scan on hashtagstweets  (cost=0.00..8184.99 rows=499999 width=8)
         ->  Hash  (cost=547547.00..547547.00 rows=5999400 width=219)
               ->  Seq Scan on tweets  (cost=0.00..547547.00 rows=5999400 width=219)
                     Filter: ((text_tweet)::text ~~ '%maxim%'::text)
   ->  Hash  (cost=36436.99..36436.99 rows=999999 width=8)
         ->  Seq Scan on usuaris  (cost=0.00..36436.99 rows=999999 width=8)
(10 rows)



--- POSTGRES TO JSON

-- COLLECTION USERS
-- Funció que converteix la taula usuaris a format json (Per passar de Postgres a MongoDB).
SELECT row_to_json(users) FROM 
    (SELECT id_usuari,nom,cognoms,password,username,telefon,data_alta,descripcio,ciutat,url,idioma,email,
        (SELECT array_to_json(array_agg(row_to_json(followers))) FROM 
            (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE id_usuari=id_usuari_seguit) followers) as seguidors FROM usuaris) 
        users ORDER BY users.id_usuari;

-- Connexió amb Postgres per convertir la taula usuaris a format json (Per passar de Postgres a MongoDB).
psql -p 5432 -U postgres -d twitter -c 'SELECT row_to_json(users) FROM 
    (SELECT id_usuari,nom,cognoms,password,username,telefon,data_alta,descripcio,ciutat,url,idioma,email,
    (SELECT array_to_json(array_agg(row_to_json(followers))) FROM 
    (SELECT data_seguidor,id_usuari_seguidor FROM seguidors WHERE id_usuari=id_usuari_seguit) followers) as seguidors
    FROM usuaris) users ORDER BY users.id_usuari LIMIT 1000;' > users.json


-- COLLECTION TWEETS
-- Funció que converteix la taula tweets a format json (Per passar de Postgres a MongoDB).
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


-- Connexió amb Postgres per convertir la taula tweets a format json (Per passar de Postgres a MongoDB).
psql -p 5432 -U postgres -d twitter -c 'SELECT row_to_json(tweets) 
FROM (SELECT id_tweet AS "_id",text_tweet,id_usuari,data_tweet,(SELECT array_to_json(array_agg(row_to_json(fotos))) 
FROM (SELECT data_foto,text_foto FROM fotos WHERE tweets.id_tweet=fotos.id_tweet) fotos) as fotos,
(SELECT row_to_json(row(lat,lon))) AS "geo",(SELECT array_to_json(array_agg(row_to_json(hashtags))) 
FROM (SELECT hashtag,data_creacio_hashtag FROM hashtags JOIN hashtagstweets ON hashtags.id_hashtag=hashtagstweets.id_hashtag
WHERE tweets.id_tweet=hashtagstweets.id_tweet) hashtags) as hashtags,
(SELECT array_to_json(array_agg(row_to_json(likes))) FROM (SELECT id_usuari_like,data_like,esborrat FROM likes WHERE tweets.id_tweet=likes.id_tweet) likes) as likes,
(SELECT array_to_json(array_agg(row_to_json(comentaris))) FROM (SELECT id_usuari_comentari,data_comentari,text_comentari,
(SELECT array_to_json(array_agg(row_to_json(likescomentari))) 
FROM (SELECT id_usuari FROM usuarislikescomentaris WHERE comentaris.id_comentari=usuarislikescomentaris.id_comentari) likescomentari) as "likes_comentari" 
FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) comentaris) as comentaris,
(SELECT count(*) FROM likes WHERE tweets.id_tweet=likes.id_tweet) AS "num_likes",
(SELECT count(*) FROM retweets WHERE tweets.id_tweet=retweets.id_tweet) AS "num_retweets",
(SELECT count(*) FROM comentaris WHERE tweets.id_tweet=comentaris.id_tweet) AS "num_comments",
(SELECT array_to_json(array_agg(row_to_json(retweets))) 
FROM (SELECT id_usuari_retweet,data_retweet,text_retweet,esborrat FROM retweets WHERE tweets.id_tweet=retweets.id_tweet) retweets) as retweets FROM tweets) tweets;' > tweets.json



-- Vistes i taules de BBDD Postgres

SELECT t1.TABLE_NAME AS nom_taula, 
   PG_CATALOG.OBJ_DESCRIPTION(t2.OID) AS descripcio_taula 
FROM INFORMATION_SCHEMA.TABLES t1 
INNER JOIN PG_CLASS t2 ON (t2.relname=t1.table_name) 
ORDER BY t1.TABLE_NAME;


SELECT tablename,tableowner FROM pg_tables;


        tablename        |  tableowner  
-------------------------+--------------
 pg_statistic            | postgres
 pg_type                 | postgres
 hashtags                | twitteradmin
 seguidors               | twitteradmin
 usuaris                 | twitteradmin
 tweets                  | twitteradmin
 usuarislikescomentaris  | twitteradmin
 likes                   | twitteradmin
 hashtagstweets          | twitteradmin
 pg_authid               | postgres
 retweets                | twitteradmin
 comentaris              | twitteradmin
 fotos                   | twitteradmin
 pg_user_mapping         | postgres
 pg_largeobject          | postgres
 pg_attribute            | postgres
 pg_proc                 | postgres
 pg_class                | postgres
 pg_attrdef              | postgres
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
 pg_aggregate            | postgres
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
 pg_policy               | postgres
 pg_replication_origin   | postgres
 pg_default_acl          | postgres
 pg_seclabel             | postgres
 pg_shseclabel           | postgres
 pg_collation            | postgres
 pg_range                | postgres
 pg_transform            | postgres
 pg_database             | postgres
 sql_features            | postgres
 sql_implementation_info | postgres
 sql_languages           | postgres
 sql_packages            | postgres
 sql_parts               | postgres
 sql_sizing              | postgres
 sql_sizing_profiles     | postgres
(71 rows)


-- ANALYZE

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
 


-- ALTERNATIVE (Search in hashtags)

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
   WHERE hashtags.hashtag='chip' GROUP BY tweets.id_tweet ORDER BY 1;





