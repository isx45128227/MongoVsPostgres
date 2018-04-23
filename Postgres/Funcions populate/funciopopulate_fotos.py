#! /usr/bin/python
#-*- coding: utf-8-*-

import random, datetime

now = datetime.datetime.now()

## Funció que crea moltes fotos
for i in range (0,50000):
	id_foto = random.randrange(1,49000,1)
	id_tweet = random.randrange(1,100000,1)
	text = "Foto %d molt xula!" %(i)
	data = now.strftime("%Y-%m-%d %H:%M")
	print "%d,%s,%d,%s"%(i,text,id_tweet,data)


# python funciopopulate_fotos.py > fotos.csv
# COPY fotos(id_foto,text_foto,id_tweet,data_foto) FROM '/tmp/fotos.csv' DELIMITER ',' CSV HEADER;
