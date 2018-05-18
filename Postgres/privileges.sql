-- Privileges into twitter database in order to allow queries using different users: psql -p 5432 -U username -d twitter

CREATE USER YourUsername WITH PASSWORD 'password';

GRANT ALL ON DATABASE twitter TO YourUsername;

GRANT ALL ON usuaris TO YourUsername;
GRANT ALL ON tweets TO YourUsername;
GRANT ALL ON retweets TO YourUsername;
GRANT ALL ON hashtagstweets TO YourUsername;
GRANT ALL ON hashtags TO YourUsername;
GRANT ALL ON likes TO YourUsername;
GRANT ALL ON comentaris TO YourUsername;
GRANT ALL ON seguidors TO YourUsername;
GRANT ALL ON usuarislikescomentaris TO YourUsername;
GRANT ALL ON fotos TO YourUsername;
