-- Function to update table tweets

CREATE OR REPLACE FUNCTION update_tweets()
RETURNS text AS
$$
DECLARE
	command_tweets_hashtags varchar;

	resultat record;

BEGIN

	command_tweets_hashtags:='SELECT hashtags.hashtag,tweets.id_tweet FROM hashtags JOIN hashtagstweets ON hashtags.id_hashtag=hashtagstweets.id_hashtag JOIN tweets ON hashtagstweets.id_tweet=tweets.id_tweet';
	-- Busquem el hashtag

	FOR resultat IN EXECUTE command_tweets_hashtags LOOP

		UPDATE tweets SET text_tweet = text_tweet || ' #' || resultat.hashtag WHERE id_tweet=resultat.id_tweet;
		-- Per cada tweet afegim el text del hastag.
		
	END LOOP;

RETURN '1';
--EXCEPTION 
	--WHEN unique_violation THEN return 'CLAU UNICA DUPLICADA'
	--WHEN foreign_key_violation THEN return 'CLAU FORANA INEXISTENT'
	--WHEN not_null_violation THEN return 'NOT NULL VIOLATION'
	--WHEN others THEN return 'OTHERS VIOLATION'
END;
$$
LANGUAGE 'plpgsql' ;

-- SELECT update_tweets();
