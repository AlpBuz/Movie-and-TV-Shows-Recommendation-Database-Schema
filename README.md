# Movie & TV Show Recommendation Database

A fully normalized relational database built on a real-world IMDb dataset, designed to support movie and TV show discovery, recommendations, and analytics. Built with PostgreSQL with a focus on schema design, query optimization, and data integrity.

## Features

- **BCNF-normalized schema** across 8 tables covering titles, genres, ratings, episodes, people, actors, directors, and writers
- **Query optimization** — analyzed execution plans, eliminated full table scans, and improved join efficiency, reducing query latency by up to 50%
- **Stored procedures** for transactional inserts and deletes, ensuring atomicity across related tables
- **Indexing strategy** to efficiently handle large-scale IMDb dataset queries
- **Data integrity** enforced via primary keys, foreign keys, cascading constraints, and triggers

## Tech Stack

- **Database:** PostgreSQL
- **Dataset:** IMDb (titles, ratings, people, episodes)
- **Tools:** pgAdmin, psql

## Schema Overview

```
Titles ──── Genre
  │
  ├──── Ratings
  ├──── Episodes
  ├──── Directors ──── People
  ├──── Writers  ──── People
  └──── Actors   ──── People
```

| Table | Description |
|-------|-------------|
| `Titles` | Movies and TV shows with type, year, runtime |
| `Genre` | Genre tags per title (composite PK) |
| `Ratings` | IMDb average rating and vote count |
| `Episodes` | Season/episode data linked to parent titles |
| `People` | Actors, directors, and writers |
| `Directors` | Many-to-many: titles ↔ people |
| `Writers` | Many-to-many: titles ↔ people |
| `Actors` | Many-to-many: titles ↔ people |

## Sample Queries

**Top 10 movies by rating**
```sql
SELECT t.titleName, r.averageRating
FROM Titles t
JOIN Ratings r ON t.tconst = r.tconst
WHERE t.titleType = 'movie'
ORDER BY r.averageRating DESC
LIMIT 10;
```

**All movies from a specific actor**
```sql
SELECT t.titleName, t.startYear, t.runTimeMinutes
FROM People p
JOIN Actors a ON p.nconst = a.nconst
JOIN Titles t ON a.tconst = t.tconst
WHERE p.name = 'Johnny Depp' AND t.titleType = 'movie';
```

**Actors who also directed**
```sql
SELECT DISTINCT p.name
FROM People p
JOIN Actors a ON p.nconst = a.nconst
JOIN Directors d ON p.nconst = d.nconst;
```

## Setup

### Prerequisites
- PostgreSQL installed
- pgAdmin (optional but recommended)

### 1. Create the schema
```bash
psql -U your_username -d your_database -f create.sql
```

Or via pgAdmin: open `create.sql` in the query tool and run it.

### 2. Load the data

**Via psql:**
```bash
# Navigate to the project folder first
\cd 'path/to/project'
\i load.sql
```

**Via pgAdmin:** Right-click each table → Import/Export Data. Enable the Header option, set NULL Strings to `\N`, and select the matching CSV file.

### 3. Run queries
```bash
psql -U your_username -d your_database -f queries.sql
```

## Stored Procedures

**Insert a movie with full metadata (title, genre, rating) atomically:**
```sql
CALL insert_movie_with_metadata(
  'tt99999999', 'My Movie', 2025, 120, 'Action', 8.5, 10000
);
```

**Delete a movie and all related records via cascade:**
```sql
CALL delete_movie_by_title('tt99999999');
```

## Key Design Decisions

- **BCNF normalization** — eliminated all partial and transitive dependencies across all 8 tables
- **Composite primary keys** on junction tables (Directors, Writers, Actors, Genre) to enforce uniqueness without surrogate keys
- **Cascading deletes** — removing a title automatically cleans up all related genres, ratings, episode, and cast records
- **Execution plan analysis** — used `EXPLAIN ANALYZE` to identify and eliminate sequential scans on large tables, adding targeted indexes to reduce latency by up to 50%