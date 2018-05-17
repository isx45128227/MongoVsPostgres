function join_tweets_usuaris(query) {

  var data_inicial = new Date();
  var hora_inicial = data_inicial;
  
  var result = db.tweets.find(query);
  var sortida;
  
  while ( result.hasNext()) {
    
     var usuari = tojson (result.next().id_usuari);
     
     var info_usuari = db.users.find({"id_usuari":parseInt(usuari)});
     
     var dades_usuari = info_usuari.next();
     
     
     if (dades_usuari.seguidors){
     
        sortida = sortida + " | " + usuari+" "+dades_usuari.nom + " " + dades_usuari.seguidors.length;
     }
     else
     {
		 sortida = sortida + " | " + usuari+" "+dades_usuari.nom + "  0";
	}
    
     }
     var data_final = new Date();
     var hora_final = data_final;
     
     var total = data_final.getTime()-data_inicial.getTime();
  
  printjson(data_inicial+' Total: '+total + " " + sortida);

}

join_tweets_usuaris({"text_tweet":/#chip/});
