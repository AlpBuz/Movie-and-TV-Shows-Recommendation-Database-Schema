-- ============================================================
-- indexes.sql
-- Movie & TV Shows Recommendation Database
-- ============================================================

-- Speeds up filtering by titleType (e.g. WHERE titleType = 'movie')
CREATE INDEX idx_titles_type ON Titles(titleType);

-- Speeds up sorting by averageRating in descending order
CREATE INDEX idx_ratings_avg ON Ratings(averageRating DESC);

-- Speeds up filtering by genre (e.g. WHERE genre = 'Drama')
CREATE INDEX idx_genre_genre ON Genre(genre);

-- Speeds up looking up people by name (e.g. WHERE name = 'Johnny Depp')
CREATE INDEX idx_people_name ON People(name);

-- Speeds up filtering titles by year (e.g. WHERE startYear = 2024)
CREATE INDEX idx_titles_year ON Titles(startYear);

-- Speeds up joining Actors to People by person ID (nconst)
CREATE INDEX idx_actors_nconst ON Actors(nconst);

-- Speeds up joining Directors to People by person ID (nconst)
CREATE INDEX idx_directors_nconst ON Directors(nconst);