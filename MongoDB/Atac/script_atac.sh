#! /bin/bash
# Roger Ferran @edt
# Curs 2017-2018
# Projecte MongoVsPostgres
# Script per atacar a la BBDD de MongoDB cada 5 segons
# ----------------------------------------------------------------------------------

mongo localhost:27017/twitter funcio_atac.js >> /tmp/MongoDB.log
sleep 5
 
