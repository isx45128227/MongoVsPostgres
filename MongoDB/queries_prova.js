// QUERIES PROVA MONGODB

// Mostrar informació d'un usuari

var usuari = 1;
db.users.find({"id_usuari": usuari},{"_id":0,"id_usuari":1,"nom":1,"cognoms":1,"descripcio":1,"ciutat":1,"email":1})


// Tweet que tingui el text 5000
db.tweets.find({"text_tweet":/5000/})


// Tweet que acabi amb el text 5000
db.tweets.find({"text_tweet":/5000$/})


// Tweet que comenci amb el text 5000
db.tweets.find({"text_tweet":/5000$/})


// Usuaris a qui segueix
var usuari = 1;
db.users.find({"seguidors.id_usuari_seguidor": usuari},{"_id":0,"id_usuari":1})


// Número usuaris que segueix
var usuari = 1;
db.users.find({"seguidors.id_usuari_seguidor": usuari},{"_id":0,"id_usuari":1}).count()


// Número usuaris que segueixen a cada usuari (GROUP BY)
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


// id_usuari que ha escrit un tweet que conté #chip
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


// Número màxim, mínim i mitjana de likes de cada usuari
db.tweets.aggregate([
					  {
						  "$group": {
							   "_id": "$id_usuari",
							   "max_num_likes": {"$max": "$num_likes"},
							   "min_num_likes": {"$min": "$num_likes"},
							   "avg_num_likes": {"$avg": "$num_likes"}
						   }
					  },
					  {
						  "$project": {
							   "_id":false,
							   "id_usuari": "$_id",
							   "max_num_likes":"$max_num_likes",
							   "min_num_likes":"$min_num_likes",
							   "avg_num_likes":"$avg_num_likes"
						   }
					  },
					  {
						  "$sort": { "id_usuari": 1}
					  }
])


// Comentaris que té cada usuari 
db.tweets.aggregate([
					  {$unwind:"$comentaris"},
					  {
						  "$group": {
							   "_id": "$id_usuari",
							   "text_comentaris":{$push:"$comentaris.text_comentari"}
						   }
					  },
					  {
						  "$project": {
							   "_id":false,
							   "id_usuari": "$_id",
							   "text_comentaris": "$text_comentaris"
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
							   "text_retweets":{$push:"$retweets.text_retweet"}
						   }
					  },
					  {
						  "$project": {
							   "_id":false,
							   "id_usuari": "$_id",
							   "text_retweets": "$text_retweets"
						   }
					  },
					  {
						  "$sort": { "id_usuari": 1}
					  }
])


// Anàlisi execució
db.tweets.find({"text_tweet":/500/i},{"_id":1,"text_tweet":1,"id_usuari":1,"hashtags.text":1,"likes.usuari_like":1,"comentaris.usuari_comentari":1,"comentaris.text_comentari":1}).explain("executionStats")
{
	"cursor" : "BasicCursor",
	"isMultiKey" : false,
	"n" : 33974,
	"nscannedObjects" : 6000000,
	"nscanned" : 6000000,
	"nscannedObjectsAllPlans" : 6000000,
	"nscannedAllPlans" : 6000000,
	"scanAndOrder" : false,
	"indexOnly" : false,
	"nYields" : 68050,
	"nChunkSkips" : 0,
	"millis" : 8207,
	"allPlans" : [
		{
			"cursor" : "BasicCursor",
			"isMultiKey" : false,
			"n" : 33974,
			"nscannedObjects" : 6000000,
			"nscanned" : 6000000,
			"scanAndOrder" : false,
			"indexOnly" : false,
			"nChunkSkips" : 0
		}
	],
	"server" : "mongotwitter:27017",
	"filterSet" : false,
	"stats" : {
		"type" : "PROJECTION",
		"works" : 6024447,
		"yields" : 68050,
		"unyields" : 68050,
		"invalidates" : 0,
		"advanced" : 33974,
		"needTime" : 0,
		"needFetch" : 24445,
		"isEOF" : 1,
		"children" : [
			{
				"type" : "COLLSCAN",
				"works" : 6024447,
				"yields" : 68050,
				"unyields" : 68050,
				"invalidates" : 0,
				"advanced" : 33974,
				"needTime" : 5966027,
				"needFetch" : 0,
				"isEOF" : 1,
				"docsTested" : 6000000,
				"children" : [ ]
			}
		]
	}
}
