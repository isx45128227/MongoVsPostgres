// DATABASE SCRIPT MONGODB
// TWITTER

// CREATE DATABASE AND COLLECTIONS
// COLLECTION USUARIS
// COLLECTION TWEETS

usuaris
seguidors

tweets
retweets


// COLLECTION TWEETS
tweets {
    text:
    usuari: {
					
		}
    
		data:
		foto:{ data_foto:
					 text_foto:
    }
    
    lat:
    lon:
    
    hashtags:[
        { text:
          data_creacio:    
        }
    ]
    
		likes:[
				{	data_like:
					usuari_like:
				}
		]
    
    comentaris:[
				{	data_comentari:
					usuari_comentari:
					text_comentari:
					likes_comentari:[
								{	data_like_comentari:
									usuari_like_comentari:
								}]
        }
		]
    
    num_likes:
    num_retweets:
    num_comments:
}
		


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



CREATE TABLE seguidors
(
    id bigserial PRIMARY KEY,
    data_seguidor timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    id_usuari_seguit bigint,
    id_usuari_seguidor bigint
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
