#! /bin/bash
# Roger Ferran @edt
# Curs 2017-2018
# Projecte MongoVsPostgres
# Script per atacar a la BBDD de MongoDB
# ----------------------------------------------------------------------

TOTAL=500

i=0

while [ $i -lt $TOTAL ] 
do
    ./execucio_script_atac.sh & 2> /dev/null
    i=$((i+1))
done
