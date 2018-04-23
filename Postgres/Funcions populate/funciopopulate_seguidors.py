#! /usr/bin/python
#-*- coding: utf-8-*-

import random, datetime

now = datetime.datetime.now()

## Funció que crea seguidors
for i in range (1,500000):
	data = now.strftime("%Y-%m-%d %H:%M")
	id_usuari1 = random.randrange(1,100000,2)
	id_usuari2 = random.randrange(1,100000,1)
	print "%d,%s,%d,%d"%(i,data,id_usuari1,id_usuari2)


# python funciopopulate_seguidors.py > seguidors.csv
# COPY seguidors FROM '/tmp/seguidors.csv' DELIMITER ',' CSV HEADER;
