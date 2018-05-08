## Diccionari de dades de PostgreSQL

pg_tables: aporta informació sobre cada taula de la base de dades. Les columnes que la componen són les següents:

 * schemaname: nom de l’esquema que conté la taula
 * tablename: nom de la taula
 * tableowner: nom del propietari de la taula
 * tablespace: nom de l’espai virtual que conté la taula
 * hasindexes: indica si la taula té índexs
 * hasrules: indica si la taula té normes.
 * hastriggers: indica si la taula té disparadors

pg_indexes: aporta informació sobre cada índex de la base de dades. Les columnes que el componen són les següents:

 * schemaname: nom de l’esquema que conté la taula
 * tablename: nom de la taula
 * indexname: nom de l’índex
 * tablespace: nom de l’espai virtual que conté l’índex
 * indexdef: definició de l’índex

pg_user: aporta informació sobre els usuaris de la base de dades. Les columnes que el componen són les següents:

 * usename: nom de l’usuari
 * usesysid: identificador d’usuari
 * usecreatedb: indica si l’usuari pot crear bases de dades
 * usesuper: indica si l’usuari es superusuari
 * usecatupd: indica si l’usuari pot actualitzar el catàleg del sistema
 * passwd: paraula clau
 * valuntil: data en que caduca la paraula clau
 * useconfig: variables per defecte de la sessió

pg_views: aporta informació sobre cada vista de la base de dades. Les columnes que el componen són les següents:

 * schemaname: nom de l’esquema que conté la vista
 * viewname: nom de la vista
 * viewowner: nom del propietari de la vista
 * definition: definició de la vista

pg_database: guarda la informació sobre les bases de dades disponibles. Les columnes que el componen són les següents:

 * datname: nom de la base de dades
 * datdba: propietari de la base de dades
 * encoding: sistema de codificació de la base de dades
 * datcollate: contingut de LC_COLLATE
 * datctype: contingut de LC_CTYPE
 * datistemplate: indica si la base de dades es pot utilitzar per crear-ne una de nova com a clon
 * datallowconn: indica si la connexió amb la base de dades es troba disponible
 * datconnlimit: estableix el nombre màxim de connexions concurrents amb la base de dades. El valor -1 indica que no hi ha límit
 * datlastsysoid: indica l’últim OID creat a la base de dades
 * datfrozenxid: indica l’identificador de límit superior fins on es congelaran les transaccions
 * dattablespace: indica l’espai virtual per defecte per a aquesta base de dades
 * datacl: privilegis d’accés a la base de dades
