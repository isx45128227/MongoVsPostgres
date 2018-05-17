# Indexes in PostgreSQL

* First of all we create index in **tweets** table

    ```
      twitter=# CREATE INDEX id_usuari_tweets_idx ON tweets (id_usuari);
      twitter=# CREATE INDEX id_foto_tweets_idx ON tweets (foto);
    ```

* Secondly we create index in **comentaris** table

    ```
      twitter=# CREATE INDEX id_usuari_comentari_idx ON comentaris (id_usuari_comentari);
      twitter=# CREATE INDEX id_tweet_idx ON comentaris (id_tweet);
    ```

* Thirdly  we create index in **likes** table

    ```
      twitter=# CREATE INDEX id_usuari_comentari_likes_idx ON likes (id_usuari_like);
      twitter=# CREATE INDEX id_tweet_likes_idx ON likes (id_tweet);
    ```
    
* Fourthly we create index in **usuarislikescomentaris** table

    ```
      twitter=# CREATE INDEX id_usuari_usuarislikescomentaris_idx ON usuarislikescomentaris(id_usuari);
      twitter=# CREATE INDEX id_comentari_usuarislikescomentaris_idx ON usuarislikescomentaris(id_comentari);
    ```

* Fifthly we create index in **fotos** table

    ` twitter=# CREATE INDEX id_tweet_fotos_idx ON fotos (id_tweet);`

* Sixthly we create index in **retweets** table

    ```
      twitter=# CREATE INDEX id_usuari_retweets_idx ON retweets(id_usuari_retweet);
      twitter=# CREATE INDEX id_tweet_retweets_idx ON retweets (id_tweet);
    ```

* Seventhly we create index in **hashtagstweets** table

    ```
      twitter=# CREATE INDEX id_tweet_hashtagtweets_idx ON hashtagstweets (id_tweet);
      twitter=# CREATE INDEX id_hashtag_hashtagtweets_idx ON hashtagstweets (id_hashtag);
    ```

* Lastly we create index in **seguidors** table

    ```
      twitter=# CREATE INDEX id_usuariseguit_idx ON seguidors(id_usuari_seguit);
      twitter=# CREATE INDEX id_usuariseguidor_idx ON seguidors(id_usuari_seguidor);
    ```
