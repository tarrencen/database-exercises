DESCRIBE albums;
SELECT * FROM albums;
# 31 rows in albums table, primary key is "id"

SELECT DISTINCT artist FROM albums;
# 23 unique artists in albums

SELECT MIN(release_date) FROM albums;
# Oldest release date is 1967

SELECT MAX(release_date) FROM albums;
# Most recent release date is 2011


SELECT name FROM albums WHERE artist = 'Pink Floyd';
# The Dark Side of the Moon, The Wall ->

SELECT * FROM albums WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band';
# 1967

SELECT genre FROM albums WHERE name = 'Nevermind';
# Grunge, Alternative Rock is genre for album Nevermind

SELECT * FROM albums WHERE (release_date >= 1990 AND release_date < 2000);
# 11 albums in the 1990, see query results for further info!

SELECT * FROM albums WHERE sales < 20;
# 13 albums with less than 20 million certified in sales

SELECT * FROM albums WHERE genre = 'Rock';
# 5 albums, only from The Beatles, Bruce Springsteen, and Santana, excludes others because of operators used "WHERE ="

SELECT * FROM albums WHERE genre LIKE '%Rock%';
# This query now pulls all flovors of "Rock"




