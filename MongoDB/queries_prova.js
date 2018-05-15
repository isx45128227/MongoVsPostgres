// QUERIES PROVA


// Find usuaris a qui segueix
var usuari = 1;

db.users.find({"seguidors.id_usuari_seguidor": usuari},{"_id":0,"id_usuari":1})


// Find num usuaris que segueix
var usuari = 1;
db.users.find({"seguidors.id_usuari_seguidor": usuari},{"_id":0,"id_usuari":1}).count()


// Find tweet que tingui el text 5000
db.tweets.find({$text:{$search:"5000"}})


// Find num usuaris que segueixen a cada usuari (GROUP BY)
db.users.aggregate([
					  {
						  "$group": {
							   "_id": "$id_usuari",
							   "num_seguidors": {"$sum": 1}
						   }
					  },
					  {
						  "$project": {
							   "_id":false,
							   "id_usuari": "$_id",
							   "num_seguidors":"$num_seguidors"
						   }
					  }
])



// Find id_usuari que ha escrit un tweet que conté #chip
function atac(query) {

  var data_inicial = new Date();
  var hora_inicial = data_inicial;
  
  var result = db.tweets.find(query);
  
  while ( result.hasNext()) {
    
     var usuari = tojson (result.next().id_usuari);
     printjson (usuari);
     var info_usuari = db.users.find({"id_usuari":parseInt(usuari)});
      
     var data_final = new Date();
     var hora_final = data_final;
     
     var total = data_final.getTime()-data_inicial.getTime();
     }
  
  printjson(data_inicial+' Total: '+total);

}

// Versió sense index, més lenta
atac({"text_tweet":/#chip/},{"id_usuari":1});

// Versio amb index, més ràpida
atac({$text:{$search:"#chip"}},{"id_usuari":1})



// Número de likes de cada usuari
db.tweets.aggregate([
					  {
						  "$group": {
							   "_id": "$id_usuari",
							   "num_likes": {"$sum": 1}
						   }
					  },
					  {
						  "$project": {
							   "_id":false,
							   "id_usuari": "$_id",
							   "num_likes":"$num_likes"
						   }
					  },
					  {
						  "$sort": { "id_usuari": 1}
					  }
])



// Retweets que té cada usuari 
db.tweets.aggregate([
					  {$unwind:"$retweets"},
					  {
						  "$group": {
							   "_id": "$id_usuari",
							   "retweets": {"$sum": 1}
						   }
					  },
					  {
						  "$project": {
							   "_id": false,
							   "usuari": "$_id",
							   "retweets": "$retweets"
						  }
					  },
					  {
						  "$sort":{"retweets":-1}
					  }
])

