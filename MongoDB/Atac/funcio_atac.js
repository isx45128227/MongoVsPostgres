function atac(query) {

  var data_inicial = new Date();
  var hora_inicial = data_inicial;
  
  var result = db.tweets.find(query);
  
  // Aixo dins bucle
  var usuari = tojson( result.next().id_usuari); 

  printjson( usuari);
  
  var info_usuari = db.users.find({"id_usuari":parseInt(usuari)});
  
  //printjson( info_usuari );

  var data_final = new Date();
  var hora_final = data_final;
  
  var total = data_final.getTime()-data_inicial.getTime();
  
  
  printjson(data_inicial+' Total: '+total);

}

atac({"text_tweet":/#chip/},{"id_usuari":1});


// Guardem aquest codi a /tmp/funcio_atac.js
// Crida desde shell : mongo localhost:27017/twitter /tmp/funcio_atac.js
