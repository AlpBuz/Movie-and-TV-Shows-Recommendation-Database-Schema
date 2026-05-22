
--this trigger checks the ratings inserts
CREATE OR REPLACE FUNCTION check_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.averageRating IS NULL OR NEW.averageRating < 0 OR NEW.averageRating > 10 THEN
        RAISE EXCEPTION 'Invalid averageRating: must be between 0 and 10 and not NULL.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_ratings_insert
BEFORE INSERT ON Ratings
FOR EACH ROW
EXECUTE FUNCTION check_rating();




CREATE OR REPLACE FUNCTION check_birthYear()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.birthYear IS NULL OR NEW.birthYear > EXTRACT(YEAR FROM CURRENT_DATE)::INT THEN
        RAISE EXCEPTION 'Invalid birthYear: must be the current year or below and not NULL.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_birthYear_insert
BEFORE INSERT ON People
FOR EACH ROW
EXECUTE FUNCTION check_birthYear();







CREATE OR REPLACE FUNCTION check_titleYears()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.startYear IS NULL OR NEW.startYear > EXTRACT(YEAR FROM CURRENT_DATE)::INT THEN
        RAISE EXCEPTION 'Invalid startYear: must be the current year or below and cant be NULL.';
    END IF;

	IF NEW.endYear IS NOT NULL AND NEW.startYear > NEW.endYear THEN
        RAISE EXCEPTION 'Invalid startYear: can not be greater than the given endYear';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_titleYears_insert
BEFORE INSERT ON titles
FOR EACH ROW
EXECUTE FUNCTION check_titleYears();



-- A sucessful transaction
BEGIN TRANSACTION;
    --Insert the new title
    INSERT INTO titles (tconst,titleType,titleName,isAdult,startYear,endYear,runtimeMinutes) VALUES
    ('tt00000000', 'movie', 'A really Good Movie', 1, 2025, NULL, 90);

    --INSERT the data of the title for genres and ratings
    INSERT INTO genre (tconst, genre) VALUES
    ('tt00000000', 'Action'),
    ('tt00000000', 'Comedy');

    INSERT INTO Ratings (tconst,averageRating,numVotes) VALUES
    ('tt00000000', 8.9, 200000);

	INSERT INTO People (nconst, "name", birthYear) 
	VALUES ('nm00000000', 'John Doe', 2025);

	-- Insert into Directors
	INSERT INTO Directors (tconst, nconst) 
	VALUES ('tt00000000', 'nm00000000');
COMMIT;



--Failed Transaction
DO $$
BEGIN
    BEGIN
        -- Start transaction
        INSERT INTO titles (tconst,titleType,titleName,isAdult,startYear,endYear,runtimeMinutes) VALUES
        ('tt00000000', 'movie', 'A really Good Movie', 1, 2025, NULL, 90);
        INSERT INTO genre (tconst, genre) VALUES
        ('tt00000000', 'Action'),
        ('tt00000000', 'Comedy');
        -- This will cause a failure
        INSERT INTO Ratings (tconst,averageRating,numVotes) VALUES
        ('tt00000000', -2.5, 200000);
        INSERT INTO People (nconst, name, birthYear) 
        VALUES ('nm00000000', 'John Doe', 1975);
        INSERT INTO Directors (tconst, nconst) 
        VALUES ('tt00000000', 'nm00000000');
    EXCEPTION WHEN OTHERS THEN
		ROLLBACK;
        RAISE NOTICE 'Transaction failed: %', SQLERRM;
    END;
END$$;




-- DELETE AFTER
SELECT *
FROM titles
WHERE tconst = 'tt00000000';

SELECT *
FROM people
WHERE nconst = 'nm00000000';

DELETE FROM titles
WHERE tconst = 'tt00000000';

DELETE FROM people
WHERE nconst = 'nm00000000';

