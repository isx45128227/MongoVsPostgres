#! /bin/bash
# Roger Ferran @edt
# Curs 2017-2018
# Projecte MongoVsPostgres
# Script per atacar a la BBDD de Postgres
# ----------------------------------------------------------------------

TOTAL=10

i=0

while [ $i -lt $TOTAL ] 
do
    ./script_atac.sh
    i=$((i+1))
done

 
