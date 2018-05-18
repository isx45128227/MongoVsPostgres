-- SCRIPT DATABASE phpMyAdmin
-- Used to create the pdf and jpg schema.

DROP DATABASE IF EXISTS twitter;

CREATE DATABASE twitter;


CREATE TABLE usuaris
(
    id_usuari bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom varchar(20) NOT NULL,
    cognoms varchar(50) NOT NULL,
    password varchar(25) NOT NULL,
    username varchar(25) NOT NULL,
    telefon varchar(9),
    data_alta timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcio varchar(100),
    ciutat varchar(50) NOT NULL,
    url varchar(150) NOT NULL,
    idioma varchar(20) NOT NULL,
    email varchar(100) NOT NULL
);


CREATE TABLE tweets
(
    id_tweet bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    text_tweet varchar(280),
    id_usuari bigint UNSIGNED NOT NULL,
    data_tweet timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lat float,
    lon float,
    foto bigint UNSIGNED NOT NULL,
    esborrat boolean NOT NULL DEFAULT false
);


CREATE TABLE fotos
(
    id_foto bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    text_foto varchar(280),
    id_tweet bigint UNSIGNED NOT NULL,
    data_foto timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    esborrat boolean NOT NULL DEFAULT false
);


CREATE TABLE hashtags
(
    id_hashtag bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    hashtag varchar(50),
    data_creacio_hashtag timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE hashtagstweets
(
    id_hashtagtweet bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_hashtag bigint UNSIGNED NOT NULL,
    id_tweet bigint UNSIGNED NOT NULL
);


CREATE TABLE seguidors
(
    id bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    data_seguidor timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    id_usuari_seguit bigint UNSIGNED NOT NULL,
    id_usuari_seguidor bigint UNSIGNED NOT NULL
);


CREATE TABLE comentaris
(
    id_comentari bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    data_comentari timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    text_comentari varchar(50),
    id_usuari_comentari bigint UNSIGNED NOT NULL,
    id_tweet bigint UNSIGNED NOT NULL,    
    esborrat boolean NOT NULL DEFAULT false
);


CREATE TABLE usuarislikescomentaris
(
    id_likecom bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuari bigint UNSIGNED NOT NULL,
    id_comentari bigint UNSIGNED NOT NULL,
    UNIQUE(id_usuari,id_comentari)
);


CREATE TABLE retweets
(
    id_retweet bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    data_retweet timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    text_retweet varchar(50),
    id_usuari_retweet bigint UNSIGNED NOT NULL,
    id_tweet bigint UNSIGNED NOT NULL,
    esborrat boolean NOT NULL DEFAULT false,
    UNIQUE(id_usuari_retweet,id_tweet)
);


CREATE TABLE likes
(
    id_like bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    data_like timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuari_like bigint UNSIGNED NOT NULL,
    id_tweet bigint UNSIGNED NOT NULL,
    esborrat boolean NOT NULL DEFAULT false,
    UNIQUE(id_usuari_like,id_tweet)
);




-- ALTER TABLES

ALTER TABLE tweets 
ADD CONSTRAINT fk_usuari
FOREIGN KEY (id_usuari) REFERENCES usuaris(id_usuari);

ALTER TABLE tweets 
ADD CONSTRAINT fk_foto
FOREIGN KEY (foto) REFERENCES fotos(id_foto);



ALTER TABLE hashtagstweets 
ADD CONSTRAINT fk_tweet
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);

ALTER TABLE hashtagstweets 
ADD CONSTRAINT fk_hashtag
FOREIGN KEY (id_hashtag) REFERENCES hashtags(id_hashtag);



ALTER TABLE seguidors 
ADD CONSTRAINT fk_usuari_seguit
FOREIGN KEY (id_usuari_seguit) REFERENCES usuaris(id_usuari);

ALTER TABLE seguidors 
ADD CONSTRAINT fk_usuari_seguidor
FOREIGN KEY (id_usuari_seguidor) REFERENCES usuaris(id_usuari);



ALTER TABLE comentaris 
ADD CONSTRAINT fk_usuari_1
FOREIGN KEY (id_usuari_comentari) REFERENCES usuaris(id_usuari);

ALTER TABLE comentaris 
ADD CONSTRAINT fk_tweet_1
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);



ALTER TABLE usuarislikescomentaris
ADD CONSTRAINT fk_usuari_2
FOREIGN KEY (id_usuari) REFERENCES usuaris(id_usuari);

ALTER TABLE usuarislikescomentaris
ADD CONSTRAINT fk_comentari_1
FOREIGN KEY (id_comentari) REFERENCES comentaris(id_comentari);



ALTER TABLE retweets 
ADD CONSTRAINT fk_usuari_3
FOREIGN KEY (id_usuari_retweet) REFERENCES usuaris(id_usuari);

ALTER TABLE retweets 
ADD CONSTRAINT fk_tweet_3
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);



ALTER TABLE likes 
ADD CONSTRAINT fk_usuari_4
FOREIGN KEY (id_usuari_like) REFERENCES usuaris(id_usuari);

ALTER TABLE likes 
ADD CONSTRAINT fk_tweet_4
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);



ALTER TABLE fotos 
ADD CONSTRAINT fk_tweet_5
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);
