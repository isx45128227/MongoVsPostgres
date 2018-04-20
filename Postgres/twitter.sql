-- DATABASE SCRIPT POSTGRES
-- TWITTER SENSE HASHTAGS-TWEETS

-- CREATE DATABASE
DROP DATABASE IF EXISTS twitter;

CREATE DATABASE twitter;

\c twitter

-- CREATE TABLES

CREATE TABLE usuaris
(
    id_usuari bigserial PRIMARY KEY,
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
    id_tweet bigserial PRIMARY KEY,
    text_tweet varchar(280),
    id_usuari bigint,
    data_tweet timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lat float,
    lon float,
    foto bigint,
    esborrat boolean NOT NULL DEFAULT false
);


CREATE TABLE fotos
(
    id_foto bigserial PRIMARY KEY,
    text_foto varchar(280),
    id_tweet bigint,
    data_foto timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    esborrat boolean NOT NULL DEFAULT false
);


CREATE TABLE hashtags
(
    id_hashtag bigserial PRIMARY KEY,
    hashtag varchar(50),
    data_creacio_hashtag timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE seguidors
(
    id bigserial PRIMARY KEY,
    data_seguidor timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    id_usuari_seguit bigint,
    id_usuari_seguidor bigint
);


CREATE TABLE comentaris
(
    id_comentari bigserial PRIMARY KEY,
    data_comentari timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    text_comentari varchar(50),
    id_usuari_comentari bigint,
    id_tweet bigint,    
    esborrat boolean NOT NULL DEFAULT 'f'
);


CREATE TABLE usuarislikescomentaris
(
    id_likecom bigserial PRIMARY KEY,
    id_usuari bigint NOT NULL,
    id_comentari bigint NOT NULL,
    UNIQUE(id_usuari,id_comentari)
);


CREATE TABLE retweets
(
    id_retweet bigserial PRIMARY KEY,
    data_retweet timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    text_retweet varchar(50),
    id_usuari_retweet bigint,
    id_tweet bigint,
    esborrat boolean NOT NULL DEFAULT 'f',
    UNIQUE(id_usuari_retweet,id_tweet)
);


CREATE TABLE likes
(
    id_like bigserial PRIMARY KEY,
    data_like timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuari_like bigint,
    id_tweet bigint,
    esborrat boolean NOT NULL DEFAULT 'f',
    UNIQUE(id_usuari_like,id_tweet)
);



-- ALTER TABLES

ALTER TABLE tweets 
ADD CONSTRAINT fk_usuari
FOREIGN KEY (id_usuari) REFERENCES usuaris(id_usuari);

ALTER TABLE tweets 
ADD CONSTRAINT fk_foto
FOREIGN KEY (id_foto) REFERENCES fotos(id_foto);

ALTER TABLE seguidors 
ADD CONSTRAINT fk_usuari_seguit
FOREIGN KEY (id_usuari_seguit) REFERENCES usuaris(id_usuari);

ALTER TABLE seguidors 
ADD CONSTRAINT fk_usuari_seguidor
FOREIGN KEY (id_usuari_seguidor) REFERENCES usuaris(id_usuari);


ALTER TABLE comentaris 
ADD CONSTRAINT fk_usuari
FOREIGN KEY (id_usuari_comentari) REFERENCES usuaris(id_usuari);

ALTER TABLE comentaris 
ADD CONSTRAINT fk_tweet
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);


ALTER TABLE usuarislikescomentaris
ADD CONSTRAINT fk_usuari
FOREIGN KEY (id_usuari) REFERENCES usuaris(id_usuari);

ALTER TABLE usuarislikescomentaris
ADD CONSTRAINT fk_comentari
FOREIGN KEY (id_comentari) REFERENCES comentaris(id_comentari);


ALTER TABLE retweets 
ADD CONSTRAINT fk_usuari
FOREIGN KEY (id_usuari_retweet) REFERENCES usuaris(id_usuari);

ALTER TABLE retweets 
ADD CONSTRAINT fk_tweet
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);


ALTER TABLE likes 
ADD CONSTRAINT fk_usuari
FOREIGN KEY (id_usuari_like) REFERENCES usuaris(id_usuari);

ALTER TABLE likes 
ADD CONSTRAINT fk_tweet
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);


ALTER TABLE fotos 
ADD CONSTRAINT fk_tweet
FOREIGN KEY (id_tweet) REFERENCES tweets(id_tweet);
