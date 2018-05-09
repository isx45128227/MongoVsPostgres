#! /bin/bash

# Mongorestore

cp /tmp/twitter/users.bson /dump/
cp /tmp/twitter/users.metadata.json /dump/

mongorestore --collection users --db twitter /dump/

rm -rf /dump/*

cp /tmp/twitter/tweets.bson /dump/
cp /tmp/twitter/tweets.metadata.json /dump/

mongorestore --collection tweets --db twitter /dump/

rm -rf /dump/*
