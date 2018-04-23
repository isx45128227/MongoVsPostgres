#! /usr/bin/python
#-*- coding: utf-8-*-

import random

## Funció que crea hashtagstweets
for i in range (0,500000):
	id_hashtag = random.randrange(1,1522,1)
	id_tweet = random.randrange(1,1000000,1)
	print "%d,%s,%s"%(i,id_hashtag,id_tweet)


# python funciopopulate_hashtagstweets.py > hashtagstweets.csv
# COPY hashtagstweets FROM '/tmp/hashtagstweets.csv' DELIMITER ',' CSV HEADER;
