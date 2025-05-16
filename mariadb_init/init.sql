-- Inizializzazione del database cinematografico

-- Creazione del database (se non esiste)
DROP DATABASE IF EXISTS cinema_db;
CREATE DATABASE cinema_db;
USE cinema_db;

-- Tabella directors
CREATE TABLE IF NOT EXISTS directors (
    id_director INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    eta INT NOT NULL
);

-- Tabella movies
CREATE TABLE IF NOT EXISTS movies (
    id_movie INT AUTO_INCREMENT PRIMARY KEY,
    titolo VARCHAR(100) NOT NULL,
    anno INT NOT NULL,
    genere VARCHAR(30) NOT NULL,
    id_director INT NOT NULL,
    FOREIGN KEY (id_director) REFERENCES directors(id_director)
);

-- Tabella piattaforme
CREATE TABLE IF NOT EXISTS piattaforme (
    id_piattaforma INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL UNIQUE
);

-- Tabella distribuzioni (relazione molti-a-molti)
CREATE TABLE IF NOT EXISTS distribuzioni (
    id_movie INT NOT NULL,
    id_piattaforma INT NOT NULL,
    PRIMARY KEY (id_movie, id_piattaforma),
    FOREIGN KEY (id_movie) REFERENCES movies(id_movie) ON DELETE CASCADE,
    FOREIGN KEY (id_piattaforma) REFERENCES piattaforme(id_piattaforma) ON DELETE CASCADE
);

-- Inserimento directors
INSERT INTO directors (nome, eta) VALUES
('Christopher Nolan', 54),
('Bong Joon-ho', 55),
('David Fincher', 62),
('Ridley Scott', 87),
('Martin Scorsese', 82),
('George Lucas', 80),
('Quentin Tarantino', 62),
('Frank Darabont', 66),
('Robert Zemeckis', 72),
('Francis Ford Coppola', 86),
('Lana Wachowski', 59),
('Hayao Miyazaki', 84),
('Steven Spielberg', 78),
('Peter Jackson', 63),
('Damien Chazelle', 40),
('Todd Phillips', 54),
('George Miller', 80),
('Denis Villeneuve', 57);

-- Inserimento piattaforme
INSERT INTO piattaforme (nome) VALUES
('Amazon Prime Video'),
('NOW'),
('Netflix'),
('Paramount+'),
('Disney+');

-- Inserimento movies con directors
INSERT INTO movies (titolo, anno, genere, id_director) VALUES
('Inception', 2010, 'Fantascienza', (SELECT id_director FROM directors WHERE nome = 'Christopher Nolan')),
('Parasite', 2019, 'Dramma', (SELECT id_director FROM directors WHERE nome = 'Bong Joon-ho')),
('Interstellar', 2014, 'Fantascienza', (SELECT id_director FROM directors WHERE nome = 'Christopher Nolan')),
('The Dark Knight', 2008, 'Azione', (SELECT id_director FROM directors WHERE nome = 'Christopher Nolan')),
('Fight Club', 1999, 'Dramma', (SELECT id_director FROM directors WHERE nome = 'David Fincher')),
('Seven', 1995, 'Crime', (SELECT id_director FROM directors WHERE nome = 'David Fincher')),
('Gladiator', 2000, 'Azione', (SELECT id_director FROM directors WHERE nome = 'Ridley Scott')),
('Shutter Island', 2010, 'Thriller', (SELECT id_director FROM directors WHERE nome = 'Martin Scorsese')),
('Star Wars: A New Hope', 1977, 'Fantascienza', (SELECT id_director FROM directors WHERE nome = 'George Lucas')),
('Pulp Fiction', 1994, 'Crime', (SELECT id_director FROM directors WHERE nome = 'Quentin Tarantino')),
('The Shawshank Redemption', 1994, 'Dramma', (SELECT id_director FROM directors WHERE nome = 'Frank Darabont')),
('Forrest Gump', 1994, 'Dramma', (SELECT id_director FROM directors WHERE nome = 'Robert Zemeckis')),
('The Godfather', 1972, 'Crime', (SELECT id_director FROM directors WHERE nome = 'Francis Ford Coppola')),
('The Matrix', 1999, 'Fantascienza', (SELECT id_director FROM directors WHERE nome = 'Lana Wachowski')),
('Goodfellas', 1990, 'Crime', (SELECT id_director FROM directors WHERE nome = 'Martin Scorsese')),
('Spirited Away', 2001, 'Animazione', (SELECT id_director FROM directors WHERE nome = 'Hayao Miyazaki')),
('Saving Private Ryan', 1998, 'Guerra', (SELECT id_director FROM directors WHERE nome = 'Steven Spielberg')),
('Back to the Future', 1985, 'Fantascienza', (SELECT id_director FROM directors WHERE nome = 'Robert Zemeckis')),
('The Lord of the Rings: The Fellowship of the Ring', 2001, 'Fantasy', (SELECT id_director FROM directors WHERE nome = 'Peter Jackson')),
('The Lord of the Rings: The Return of the King', 2003, 'Fantasy', (SELECT id_director FROM directors WHERE nome = 'Peter Jackson')),
('Schindler''s List', 1993, 'Dramma', (SELECT id_director FROM directors WHERE nome = 'Steven Spielberg')),
('Inglourious Basterds', 2009, 'Guerra', (SELECT id_director FROM directors WHERE nome = 'Quentin Tarantino')),
('Whiplash', 2014, 'Dramma', (SELECT id_director FROM directors WHERE nome = 'Damien Chazelle')),
('Joker', 2019, 'Dramma', (SELECT id_director FROM directors WHERE nome = 'Todd Phillips')),
('Mad Max: Fury Road', 2015, 'Azione', (SELECT id_director FROM directors WHERE nome = 'George Miller')),
('Blade Runner 2049', 2017, 'Fantascienza', (SELECT id_director FROM directors WHERE nome = 'Denis Villeneuve')),
('Arrival', 2016, 'Fantascienza', (SELECT id_director FROM directors WHERE nome = 'Denis Villeneuve')),
('Django Unchained', 2012, 'Western', (SELECT id_director FROM directors WHERE nome = 'Quentin Tarantino')),
('The Wolf of Wall Street', 2013, 'Biografico', (SELECT id_director FROM directors WHERE nome = 'Martin Scorsese')),
('Once Upon a Time in Hollywood', 2019, 'Commedia', (SELECT id_director FROM directors WHERE nome = 'Quentin Tarantino'));

-- Inserimento distribuzioni
INSERT INTO distribuzioni (id_movie, id_piattaforma) VALUES
-- Inception: Amazon Prime Video, NOW
((SELECT id_movie FROM movies WHERE titolo = 'Inception'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),
((SELECT id_movie FROM movies WHERE titolo = 'Inception'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- Parasite: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Parasite'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- Interstellar: Paramount+, Amazon Prime Video
((SELECT id_movie FROM movies WHERE titolo = 'Interstellar'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),
((SELECT id_movie FROM movies WHERE titolo = 'Interstellar'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),

-- The Dark Knight: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'The Dark Knight'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- Seven: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Seven'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- Gladiator: Netflix, Paramount+
((SELECT id_movie FROM movies WHERE titolo = 'Gladiator'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Gladiator'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),

-- Shutter Island: Netflix, Paramount+
((SELECT id_movie FROM movies WHERE titolo = 'Shutter Island'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Shutter Island'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),

-- Star Wars: A New Hope: Disney+
((SELECT id_movie FROM movies WHERE titolo = 'Star Wars: A New Hope'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Disney+')),

-- Pulp Fiction: NOW, Paramount+
((SELECT id_movie FROM movies WHERE titolo = 'Pulp Fiction'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),
((SELECT id_movie FROM movies WHERE titolo = 'Pulp Fiction'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),

-- The Shawshank Redemption: NOW
((SELECT id_movie FROM movies WHERE titolo = 'The Shawshank Redemption'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- Forrest Gump: Netflix, Paramount+
((SELECT id_movie FROM movies WHERE titolo = 'Forrest Gump'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Forrest Gump'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),

-- The Godfather: Paramount+, Netflix
((SELECT id_movie FROM movies WHERE titolo = 'The Godfather'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),
((SELECT id_movie FROM movies WHERE titolo = 'The Godfather'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- The Matrix: Netflix, Amazon Prime Video
((SELECT id_movie FROM movies WHERE titolo = 'The Matrix'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'The Matrix'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),

-- Goodfellas: Netflix, NOW
((SELECT id_movie FROM movies WHERE titolo = 'Goodfellas'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Goodfellas'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- Spirited Away: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Spirited Away'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- Saving Private Ryan: Paramount+, NOW
((SELECT id_movie FROM movies WHERE titolo = 'Saving Private Ryan'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),
((SELECT id_movie FROM movies WHERE titolo = 'Saving Private Ryan'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- Back to the Future: Netflix, Amazon Prime Video
((SELECT id_movie FROM movies WHERE titolo = 'Back to the Future'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Back to the Future'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),

-- The Lord of the Rings: The Fellowship of the Ring: Amazon Prime Video, NOW
((SELECT id_movie FROM movies WHERE titolo = 'The Lord of the Rings: The Fellowship of the Ring'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),
((SELECT id_movie FROM movies WHERE titolo = 'The Lord of the Rings: The Fellowship of the Ring'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- The Lord of the Rings: The Return of the King: Amazon Prime Video, NOW
((SELECT id_movie FROM movies WHERE titolo = 'The Lord of the Rings: The Return of the King'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),
((SELECT id_movie FROM movies WHERE titolo = 'The Lord of the Rings: The Return of the King'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- Schindler's List: Amazon Prime Video, NOW
((SELECT id_movie FROM movies WHERE titolo = 'Schindler''s List'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),
((SELECT id_movie FROM movies WHERE titolo = 'Schindler''s List'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- Inglourious Basterds: Amazon Prime Video, Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Inglourious Basterds'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),
((SELECT id_movie FROM movies WHERE titolo = 'Inglourious Basterds'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- Whiplash: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Whiplash'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- Joker: Netflix, Amazon Prime Video
((SELECT id_movie FROM movies WHERE titolo = 'Joker'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Joker'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),

-- Mad Max: Fury Road: Netflix, NOW
((SELECT id_movie FROM movies WHERE titolo = 'Mad Max: Fury Road'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Mad Max: Fury Road'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'NOW')),

-- Blade Runner 2049: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Blade Runner 2049'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- Arrival: Netflix, Paramount+
((SELECT id_movie FROM movies WHERE titolo = 'Arrival'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'Arrival'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Paramount+')),

-- Django Unchained: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Django Unchained'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),

-- The Wolf of Wall Street: Netflix, Amazon Prime Video
((SELECT id_movie FROM movies WHERE titolo = 'The Wolf of Wall Street'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix')),
((SELECT id_movie FROM movies WHERE titolo = 'The Wolf of Wall Street'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Amazon Prime Video')),

-- Once Upon a Time in Hollywood: Netflix
((SELECT id_movie FROM movies WHERE titolo = 'Once Upon a Time in Hollywood'), (SELECT id_piattaforma FROM piattaforme WHERE nome = 'Netflix'));

