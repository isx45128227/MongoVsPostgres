#! /usr/bin/python
#-*- coding: utf-8-*-

import random, datetime

now = datetime.datetime.now()

## Funció que crea retweets
for i in range (0,200000):
	data = now.strftime("%Y-%m-%d %H:%M")
	id_tweet = random.randrange(1,100000,1)
	text = "Comentari retweet del tweet %d." %(id_tweet)
	id_usuari = random.randrange(1,999999,1)
	print "%d,%s,%s,%d,%d"%(i,data,text,id_usuari,id_tweet)


# python funciopopulate_retweets.py > retweets.csv
# COPY retweets(id_retweet,data_retweet,text_retweet,id_usuari_retweet,id_tweet) FROM '/tmp/retweets.csv' DELIMITER ',' CSV HEADER;
