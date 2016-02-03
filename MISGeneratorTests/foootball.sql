BEGIN TRANSACTION;

CREATE TABLE keys (
    nextID INTEGER PRIMARY KEY NOT NULL,
    name TEXT
);
INSERT INTO keys (nextID, name) VALUES (0, 'global');


CREATE TABLE team
(
    objectID INTEGER PRIMARY KEY NOT NULL,
    name TEXT,
    players INTEGER
);

CREATE TABLE player
(
    objectID INTEGER PRIMARY KEY NOT NULL,
    firstName TEXT,
    lastName TEXT,
    team INTEGER
);


END TRANSACTION;