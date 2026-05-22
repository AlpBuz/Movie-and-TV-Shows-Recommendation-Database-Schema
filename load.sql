SET client_encoding = 'UTF8';
\COPY Titles(tconst, titleType, titleName, isAdult, startYear, endYear, runTimeMinutes) FROM 'titles.csv' DELIMITER ',' CSV HEADER NULL '\N';
\COPY Genre(tconst, genre) FROM 'genres.csv' DELIMITER ',' CSV HEADER;
\COPY Ratings(tconst, averageRating, numVotes) FROM 'ratings.csv' DELIMITER ',' CSV HEADER;
\COPY People(nconst, name, birthYear) FROM 'people.csv' DELIMITER ',' CSV HEADER;
\COPY Actors(tconst, nconst) FROM 'actors.csv' DELIMITER ',' CSV HEADER;
\COPY Writers(tconst, nconst) FROM 'writers.csv' DELIMITER ',' CSV HEADER;
\COPY Directors(tconst, nconst) FROM 'directors.csv' DELIMITER ',' CSV HEADER;
\COPY Episodes(epconst, parentTconst, seasonNumber, episodeNumber) FROM 'episodes.csv' DELIMITER ',' CSV HEADER;