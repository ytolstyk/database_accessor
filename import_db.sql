CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  FOREIGN KEY (author_id) REFERENCES users(id) NOT NULL
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  FOREIGN KEY (follower_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id) NOT NULL
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255),
  FOREIGN KEY (question_id) REFERENCES questions(id) NOT NULL,
  FOREIGN KEY (parent_id) REFERENCES replies(id), 
  FOREIGN KEY (reply_author_id) REFERENCES users(id) NOT NULL  
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  FOREIGN KEY (liker_id) REFERENCES user(id) NOT NULL,
  FOREIGN KEY (liked_question_id) REFERENCES questions(id) NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ('super', 'man'), ('Erich', 'Uher'), ('Yuriy', 'Tolstykh');

INSERT INTO 
  questions (title, body, author_id)
VALUES
  ('Woodchuck likes wood?', 'How much would they chuck?', 2),
  ('Weight of the world', 'How much does the world weigh?', 1);
  

  
  

