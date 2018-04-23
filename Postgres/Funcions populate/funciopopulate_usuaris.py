#! /usr/bin/python
#-*- coding: utf-8-*-

import random, datetime

now = datetime.datetime.now()

noms = [
    'marta',
    'pere',
    'pau',
    'berta',
    'jordi',
    'marc',
    'cesc',
    'quique',
    'roger',
    'montserrat',
    'anna',
    'fran',
    'adrià',
    'sara',
    'gemma',
    'blanca',
    'rosa',
    'paula',
    'paco',
]

cognoms = [
    'ferran',
    'marti',
    'garcia',
    'serrat',
    'remar',
    'serra',
    'aranguren',
    'cifuentes',
    'goñi',
    'petit',
    'lopez',
    'dominguez',
    'hernandez',
    'suarez',
]

ciutats = [
    'barcelona',
    'madrid',
    'roma',
    'caceres',
    'badajoz',
    'valencia',
    'saragossa',
    'berga',
    'manresa',
    'sitges',
    'albacete',
    'vigo',
    'heidelberg',
    'colonia',
    'praga',
    'frankfurt',
    'girona',
    'viladecavalls',
]

## Funció que crea usuaris
for i in range (0,1000000):
	usuari = random.choice(noms)
	cognom = random.choice(cognoms)
	ciutat = random.choice(ciutats)
	url = "https://www.twitter.com/"+usuari+"_"+cognom+str(i)
	mail = usuari+cognom+str(i)+"@gmail.com"
	print "%d,%s,%s,pass%s,%s,698543568,%s,usuari %s,%s,%s,castella,%s"%(i,usuari,cognom,i,usuari+'_'+cognom+'_'+str(i),now.strftime("%Y-%m-%d %H:%M"),usuari+cognom,ciutat,url,mail)


# python funciopopulate_usuaris.py > usuaris.csv
# COPY usuaris FROM '/tmp/usuaris.csv' DELIMITER ',' CSV HEADER;

