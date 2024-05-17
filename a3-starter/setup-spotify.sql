-- CS 121
-- Assignment 3: Correlated Queries and SQL DDL
-- Setup file for defining and loading spotify data.

-- clean up old tables:
-- drop tables with foreign keys first due to 
-- referential integrity constraints.
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS playlists;

-- Defines a table for an artist with their uri and name.
CREATE TABLE artists(
    -- All track, artist, album, and playlist uri (not 'url')
    -- are exactly 22 characters (a Spotify standardization 
    -- for identifiers)
    -- Primary Key not null by default
    artist_uri  CHAR(22),
    artist_name VARCHAR(250) NOT NULL, -- name elnghts can vary.
    PRIMARY KEY (artist_uri)
);

-- Defines a table for albums with its name, uri, and release date.
CREATE TABLE albums(
    -- Primary keys not null by deafult
    album_uri       CHAR(22), -- fixed lenght always.
    album_name      VARCHAR(250) NOT NULL, -- max name lenght allowed
    release_date    DATE NOT NULL, -- only date not time
    PRIMARY KEY (album_uri)
);

-- Defines a table for playlists using their uri and name.
CREATE TABLE playlists(
    -- Primary keys not null by deafult
    playlist_uri    CHAR(22),-- fixed always
    playlist_name   VARCHAR(250) NOT NULL, -- max name length allowed
    PRIMARY KEY (playlist_uri)
);

-- Define a table for tacks people listen to including
-- uri's, name, url, duration, popularity, date added
-- and the one who added it 
CREATE TABLE tracks(
    -- All track, artist, album, and playlist uri 
    -- (not 'url') are exactly 22 characters (a Spotify 
    -- standardization for identifiers)
    -- Primary keys not null by deafult
    track_uri       CHAR(22),
    playlist_uri    CHAR(22), 
    track_name      VARCHAR(250) NOT NULL, 
    artist_uri      CHAR(22) NOT NULL, 
    album_uri       CHAR(22) NOT NULL, 
    duration_ms     INT NOT NULL,  
    preview_url     TEXT(600), -- can be null
    popularity      INT NOT NULL, 
    added_at        TIMESTAMP NOT NULL, 
    added_by        VARCHAR(250), -- can be null
    PRIMARY KEY(track_uri, playlist_uri),
    -- The tracks table should support both cascaded 
    -- updates and cascaded deletes, when any referenced 
    -- relation is modified in the corresponding way.
    FOREIGN KEY (playlist_uri) REFERENCES playlists(playlist_uri)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (artist_uri) REFERENCES artists(artist_uri)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (album_uri) REFERENCES albums(album_uri)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);