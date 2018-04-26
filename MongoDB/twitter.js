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
    "text": {
      "type": "string"
    }
    
    "usuari": {
          "type": "number"
    }
    
    "data": {
          "type": "number"
    }
    
    "foto":{
          "type": "array",
          "items": [
              "data_foto":{ "type": "string"},
              "text_foto":{ "type": "string"}
          ]
    }
    
    "geo": { "type": "object" }
    "hashtags": {
          "type": "array",
          "items": [
              "text":{ "type": "string"},
              "data_creacio":{ "type": "string"}
          ]
    }
    
    "likes": {
          "type": "array",
          "items": [
              "usuari_like":{ "type": "number"},
              "data_like":{ "type": "string"},
              "esborrat": {"type": "boolean"}
          ]
    }
    
    "comentaris": {
          "type": "array",
          "items": [
              "usuari_comentari":{ "type": "number"},
              "data_comentari":{ "type": "string"},
              "text_comentari":{ "type": "string"},
              "likes_comentari":{ 
              "type": "array"
              "items": [
                  "usuari_like_comentari":{ "type": "number"},
                      "data_like_comentari":{ "type": "string"}
                  ]
           },
           "esborrat": {"type": "boolean"}
          ]
    }
    
    "num_likes": { "type": "number"}
    "num_retweets": { "type": "number"}
    "num_comments": { "type": "number"}
    
    "retweets": { 
        "type": "array",
        "items" : [
            "id_retweet": {"type": "number"},
            "id_usuari": {"type": "number"},
            "id_tweet": {"type": "number"},
            "data_retweet": {"type": "string"},
            "text_retweet": {"type": "string"},
            "esborrat": {"type": "boolean"}
        ]
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
