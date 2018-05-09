#! /bin/bash
# Roger Ferran @edt
# Curs 2017-2018
# Projecte MongoVsPostgres
# Script per atacar a la BBDD de Postgres cada 5 segons
# Abans d'executar aquest script es necessari afegir el fitxer .pgpass al directori
# personal per poder executar la ordre sense necessitat de posar la password.
# ----------------------------------------------------------------------------------

psql -h 172.17.0.3 -p 5432 -U docker -d twitter -f consulta_atac.sql >> /tmp/log.log
sleep 5

 
