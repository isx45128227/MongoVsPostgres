#! /usr/bin/python
#-*- coding: utf-8-*-

import random, datetime

now = datetime.datetime.now()

## Funció que crea likes
for i in range (0,200000):
	id_usuari = random.randrange(1,999999,1)
	id_tweet = random.randrange(1,999999,1)
	data = now.strftime("%Y-%m-%d %H:%M")
	print "%d,%s,%d,%d"%(i,data,id_usuari,id_tweet)


# python funciopopulate_likes.py > likes.csv
# COPY likes(id_like,data_like,id_usuari_like,id_tweet) FROM '/tmp/likes.csv' DELIMITER ',' CSV HEADER;
