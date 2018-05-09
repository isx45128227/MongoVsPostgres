function atac(query) {

  var result = db.tweets.find(query)
  var usuari = tojson( result.next().id_usuari); 

  printjson( usuari );
  
  var id = db.users.find({"id_usuari":parseInt(usuari)})
  
  printjson( id );
  
  var data_ara = Date();
  var hora_ara = data_ara.split(' ')[4];
  
  
  printjson(hora_ara);//+":"+res.millis);
  
  printjson('fet');
}

atac({"text_tweet":/#chi/},{"id_usuari":1});


// guardem aquest codi a /tmp/funcio_atac.js
//crida desde shell : mongo localhost:27017/twitter /tmp/funcio_atac.js
