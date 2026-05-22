-- Create the Titles table
CREATE TABLE Titles (
    tconst VARCHAR(255) NOT NULL,  -- Primary key
    titleType VARCHAR(255) NOT NULL,
    titleName VARCHAR(255) NOT NULL,
    isAdult SMALLINT NOT NULL,
    startYear INT NOT NULL,
    endYear INT NULL,
    runTimeMinutes INT NULL,
    PRIMARY KEY (tconst)
);

-- Create the Genre table
CREATE TABLE Genre (
    tconst VARCHAR(255) NOT NULL,  -- Foreign key referencing Titles
    genre VARCHAR(255) NOT NULL,  -- Composite primary key
    PRIMARY KEY (tconst, genre),
    FOREIGN KEY (tconst) REFERENCES Titles(tconst) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the Episodes table
CREATE TABLE Episodes (
    epconst VARCHAR(255) NOT NULL,  -- Primary key
    parentTconst VARCHAR(255) NOT NULL,  -- Foreign key referencing Titles
    seasonNumber INT NOT NULL,
    episodeNumber INT NOT NULL,
    PRIMARY KEY (epconst),
    FOREIGN KEY (parentTconst) REFERENCES Titles(tconst) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the Ratings table
CREATE TABLE Ratings (
    tconst VARCHAR(255) NOT NULL,  -- Foreign key referencing Titles
    averageRating FLOAT NOT NULL,
    numVotes INT NOT NULL,
    PRIMARY KEY (tconst),
    FOREIGN KEY (tconst) REFERENCES Titles(tconst) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the People table
CREATE TABLE People (
    nconst VARCHAR(255) NOT NULL,  -- Primary key
    name VARCHAR(255) NOT NULL,
    birthYear INT NOT NULL,
    PRIMARY KEY (nconst)
);

-- Create the Directors table
CREATE TABLE Directors (
    tconst VARCHAR(255) NOT NULL,  -- Foreign key referencing Titles
    nconst VARCHAR(255) NOT NULL,  -- Foreign key referencing People
    PRIMARY KEY (tconst, nconst),
    FOREIGN KEY (tconst) REFERENCES Titles(tconst) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nconst) REFERENCES People(nconst) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the Writers table
CREATE TABLE Writers (
    tconst VARCHAR(255) NOT NULL,  -- Foreign key referencing Titles
    nconst VARCHAR(255) NOT NULL,  -- Foreign key referencing People
    PRIMARY KEY (tconst, nconst),
    FOREIGN KEY (tconst) REFERENCES Titles(tconst) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nconst) REFERENCES People(nconst) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the Actors table
CREATE TABLE Actors (
    tconst VARCHAR(255) NOT NULL,  -- Foreign key referencing Titles
    nconst VARCHAR(255) NOT NULL,  -- Foreign key referencing People
    PRIMARY KEY (tconst, nconst),
    FOREIGN KEY (tconst) REFERENCES Titles(tconst) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nconst) REFERENCES People(nconst) ON DELETE CASCADE ON UPDATE CASCADE
);
