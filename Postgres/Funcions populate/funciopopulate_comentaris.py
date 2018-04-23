#! /usr/bin/python
#-*- coding: utf-8-*-

import random, datetime

now = datetime.datetime.now()

## Funció que crea hashtags
for i in range (0,1000000):
	data = now.strftime("%Y-%m-%d %H:%M")
	id_tweet = random.randrange(1,100000,1)
	id_usuari = random.randrange(1,100000,1)
	text = "Comentari %d del tweet %d." %(i,id_tweet)
	print "%d,%s,%s,%d,%d"%(i,data,text,id_usuari,id_tweet)


# python funciopopulate_comentaris.py > comentaris.csv
# COPY comentaris(id_comentari,data_comentari,text_comentari,id_usuari_comentari,id_tweet) FROM '/tmp/comentaris.csv' DELIMITER ',' CSV HEADER;
