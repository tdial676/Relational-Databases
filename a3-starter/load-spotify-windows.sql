-- Script for Windows systems (the only difference is '\r\n' vs. '\n')

-- Instructions:
-- This script will load the 4 CSV files you broke down from playlist_data.csv
-- into the tables you created in setup-spotify.sql.
-- Intended for use with the command-line MySQL, otherwise unnecessary for
-- phpMyAdmin (just import each CSV file in the GUI).

-- Make sure this file is in the same directory as your 4 CSV files and
-- setup-spotify.sql. Then run the following in the mysql> prompt (assuming
-- you have a spotifydb created with CREATE DATABASE spotifydb;):
-- USE DATABASE spotifydb; 
-- source setup-spotify.sql; (make sure no warnings appear)
-- source load-spotify-windows.sql; (make sure there are 0 skipped/warnings)

-- [Problem 1]
LOAD DATA LOCAL INFILE 'artists.csv' INTO TABLE artists
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- [Problem 2]
LOAD DATA LOCAL INFILE 'albums.csv' INTO TABLE albums
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- [Problem 3]
LOAD DATA LOCAL INFILE 'playlists.csv' INTO TABLE playlists
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- [Problem 4]
LOAD DATA LOCAL INFILE 'tracks.csv' INTO TABLE tracks
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;


