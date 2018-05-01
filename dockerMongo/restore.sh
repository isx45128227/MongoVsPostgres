#! /bin/bash

# Mongorestore

mkdir /dump/

cp /tmp/twitter/users.bson /dump/

mongorestore --collection users --db twitter /dump/

rm -rf /dump/users.bson

cp /tmp/twitter/tweets.bson /dump/

mongorestore --collection tweets --db twitter /dump/

rm -rf /dump/tweets.bson