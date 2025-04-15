-- Create Database
CREATE DATABASE book_library 
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE book_library;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('user', 'admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE books (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  author VARCHAR(100) NOT NULL,
  genre VARCHAR(50),
  available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE reservations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  book_id INT NOT NULL,
  reserved_on DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('active', 'completed', 'cancelled') DEFAULT 'active',
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);


CREATE TABLE borrow_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  book_id INT NOT NULL,
  reserved_on DATETIME,
  returned_on DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);


CREATE TABLE genres (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);


INSERT INTO users (name, email, password, role) 
VALUES ('Emma', 'ehmah@gmail.com', 'emm@', 'admin'),
       ('Brian', 'brian@gmail.com', '$rianr0nald0', 'user'),
       ('Jane', 'jane@gmail.com', 'j@netpuppy', 'user');

-- Insert Books
INSERT INTO books (title, author, genre, available) 
VALUES ('Clean Code', 'Robert C. Martin', 'Programming', TRUE),
       ('Atomic Habits', 'James Clear', 'Self-help', FALSE),
       ('The Pragmatic Programmer', 'Andrew Hunt', 'Programming', TRUE);

INSERT INTO reservations (user_id, book_id, reserved_on, status) 
VALUES (1, 2, '2025-04-01 10:00:00', 'active'),
       (2, 1, '2025-03-20 14:00:00', 'completed');

-- Insert Borrow History
INSERT INTO borrow_history (user_id, book_id, reserved_on, returned_on) 
VALUES (2, 1, '2025-03-20 14:00:00', '2025-03-27 11:00:00'),
       (1, 2, '2025-04-01 10:00:00', NULL);

CREATE VIEW active_reservations_view AS
SELECT 
  users.name AS user_name,
  books.title AS book_title,
  reservations.reserved_on,
  reservations.status
FROM reservations
JOIN users ON reservations.user_id = users.id
JOIN books ON reservations.book_id = books.id
WHERE reservations.status = 'active';


CREATE VIEW user_borrow_history AS
SELECT 
  users.name AS user_name,
  users.email AS user_email,
  books.title AS book_title,
  borrow_history.reserved_on,
  borrow_history.returned_on
FROM borrow_history
JOIN users ON borrow_history.user_id = users.id
JOIN books ON borrow_history.book_id = books.id;


CREATE VIEW available_books_view AS
SELECT 
  books.id,
  books.title,
  books.author,
  books.genre
FROM books
WHERE books.available = TRUE;


CREATE VIEW admin_dashboard_summary AS
SELECT 
  (SELECT COUNT(*) FROM users WHERE role = 'user') AS total_members,
  (SELECT COUNT(*) FROM users WHERE role = 'admin') AS total_admins,
  (SELECT COUNT(*) FROM books) AS total_books,
  (SELECT COUNT(*) FROM reservations WHERE status = 'active') AS active_reservations;
