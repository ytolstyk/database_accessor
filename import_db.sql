CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (follower_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255),
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  reply_author_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id), 
  FOREIGN KEY (reply_author_id) REFERENCES users(id)  
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  liker_id INTEGER NOT NULL,
  liked_question_id INTEGER NOT NULL,
  FOREIGN KEY (liker_id) REFERENCES user(id),
  FOREIGN KEY (liked_question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('super', 'man'), ('Erich', 'Uher'), ('Yuriy', 'Tolstykh');

INSERT INTO 
  questions (title, body, author_id)
VALUES
  ('Woodchuck likes?', 'How much would they chuck?', (SELECT id FROM users WHERE lname = "Tolstykh")),
  ('Weight of the world', 'How much does the world weigh?', (SELECT id FROM users WHERE fname = "Erich"));
  
INSERT INTO
  question_followers (follower_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Yuriy"), (SELECT id FROM questions WHERE title = "Woodchuck likes?")),
  ((SELECT id FROM users WHERE fname = "Erich"), (SELECT id FROM questions WHERE title = 'Weight of the world'));
  
INSERT INTO
  replies (body, question_id, parent_id, reply_author_id)
VALUES
  ("What do you mean by 'world'?", (SELECT id FROM questions WHERE title = "Weight of the world"),
  NULL, (SELECT id FROM users WHERE fname = "super"));