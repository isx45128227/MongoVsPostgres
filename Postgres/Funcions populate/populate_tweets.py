#! /usr/bin/python
#-*- coding: utf-8-*-

import random, datetime

now = datetime.datetime.now()


## Funció que crea tweets
for i in range (0,6000001):
	id_usuari = random.randrange(1,100000,1)
	text = "Tweet %d de prova d'un usuari que ha d'ocupar com a maxim 280 caracters per comparar Mongo amb Postgres." %(i)
	data = now.strftime("%Y-%m-%d %H:%M")
	print "%d,%s,%d,%s"%(i,text,id_usuari,data)


# python funciopopulate_tweets.py > tweets.csv
# COPY tweets(id_tweet,text_tweet,id_usuari,data_tweet) FROM '/tmp/tweets.csv' DELIMITER ',' CSV HEADER;

