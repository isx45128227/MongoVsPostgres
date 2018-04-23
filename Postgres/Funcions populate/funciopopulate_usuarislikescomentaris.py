#! /usr/bin/python
#-*- coding: utf-8-*-

import random

## Funció que crea likes comentaris
for i in range (0,200000):
	id_usuari = random.randrange(1,999999,1)
	id_comentari = random.randrange(1,999999,1)
	print "%d,%d,%d"%(i,id_usuari,id_comentari)


# python funciopopulate_usuarislikescomentaris.py > usuarislikescomentaris.csv
# COPY usuarislikescomentaris FROM '/tmp/usuarislikescomentaris.csv' DELIMITER ',' CSV HEADER;
