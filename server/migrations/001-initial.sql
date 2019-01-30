
--------------------------------------------------------------------------------
-- Up
--------------------------------------------------------------------------------
CREATE TABLE users (id varchar(256), token varchar(4096));
CREATE TABLE stories (id varchar(16), title varchar(128), description varchar(1024), body varchar(65536));
CREATE TABLE active (user_id varchar(256), story_id varchar(16), step_id varchar(16));

--------------------------------------------------------------------------------
-- Down
--------------------------------------------------------------------------------
DROP TABLE users;
DROP TABLE stories;
DROP TABLE active;