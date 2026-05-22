--TOP 10 MOVIES BY RATING
SELECT t.titleName, r.averageRating
FROM Titles t
JOIN Ratings r ON t.tconst = r.tconst
WHERE t.titleType = 'movie'
ORDER BY r.averageRating DESC
LIMIT 10;

--TOP 10 WORST RATED MOVIES

SELECT t.titleName, r.averageRating, r.numVotes
FROM Titles t
JOIN Ratings r ON t.tconst = r.tconst
WHERE t.titleType = 'movie'
ORDER BY r.averageRating ASC
LIMIT 10;

--MOVIES FROM A SPECIFIC ACTOR
SELECT t.titleName, t.startYear, t.runTimeMinutes
FROM People p
JOIN Actors a ON p.nconst = a.nconst
JOIN Titles t ON a.tconst = t.tconst
WHERE p.name = 'Johnny Depp' AND t.titleType = 'movie';

--MOVIES FROM A DIRECTOR
SELECT t.titleName, t.startYear, t.runTimeMinutes
FROM People p
JOIN Directors d ON p.nconst = d.nconst
JOIN Titles t ON d.tconst = t.tconst
WHERE p.name = 'Christopher Nolan' AND t.titleType = 'movie';



--ALL ACTORS/Directors FROM A MOVIE
-- The Dark Knight
SELECT 
    p.nconst,
    p.name,
    'Actor' AS role
FROM Actors a
INNER JOIN People p ON a.nconst = p.nconst
WHERE a.tconst = 'tt0468569'

UNION

SELECT 
    p.nconst,
    p.name,
    'Director' AS role
FROM Directors d
INNER JOIN People p ON d.nconst = p.nconst
WHERE d.tconst = 'tt0468569'
ORDER BY name;




--ALL MOVIES FROM A GENRE
SELECT t.titleName, t.startYear, t.runTimeMinutes
FROM Titles t
JOIN Genre g ON t.tconst = g.tconst
WHERE g.genre = 'Drama' AND t.titleType = 'movie';

--Actors who also directed a movie
SELECT DISTINCT p.name
FROM People p
JOIN Actors a ON p.nconst = a.nconst
JOIN Directors d ON p.nconst = d.nconst;



--Top 10 titles from a certain year
SELECT t.titleName, r.averageRating
FROM Titles t
JOIN Ratings r ON t.tconst = r.tconst
WHERE t.startYear = 2024
ORDER BY r.averageRating DESC
LIMIT 10;


CREATE OR REPLACE PROCEDURE insert_movie_with_metadata(
    tconst VARCHAR(255),
    titleName VARCHAR(255),
    startYear INT,
    runTime INT,
    genre VARCHAR(255),
    rating FLOAT,
    votes INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Titles (tconst, titleType, titleName, isAdult, startYear, endYear, runTimeMinutes)
    VALUES (tconst, 'movie', titleName, 0, startYear, NULL, runTime);

    INSERT INTO Genre (tconst, genre) VALUES (tconst, genre);

    INSERT INTO Ratings (tconst, averageRating, numVotes) VALUES (tconst, rating, votes);
END;
$$;

CALL insert_movie_with_metadata('tt00000000','A really Good Movie', 2025, 90, 'Action', 8.5, 10000);

SELECT * FROM titles
WHERE tconst = 'tt00000000';


CREATE OR REPLACE PROCEDURE delete_movie_by_title (movie_id VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM Titles WHERE tconst = movie_id;
END;
$$;


CALL delete_movie_by_title('tt00000000');
SELECT * FROM titles
WHERE tconst = 'tt00000000';
