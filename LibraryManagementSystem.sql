-- Library Management System Database
-- Created for Week 8 Final Project

-- Create the database
CREATE DATABASE IF NOT EXISTS LibraryManagementSystem;
USE LibraryManagementSystem;

-- 1. Members table - Stores library member information
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    membership_date DATE NOT NULL,
    membership_type ENUM('Basic', 'Premium', 'Student') DEFAULT 'Basic',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Authors table - Stores book author information
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year INT,
    death_year INT,
    nationality VARCHAR(50),
    biography TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Publishers table - Stores publisher information
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) UNIQUE NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    established_year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Categories table - Stores book categories
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    parent_category_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- 5. Books table - Stores book information
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    edition VARCHAR(20),
    publication_year INT,
    publisher_id INT NOT NULL,
    category_id INT NOT NULL,
    total_pages INT,
    language VARCHAR(30) DEFAULT 'English',
    description TEXT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE RESTRICT
);

-- 6. Book_Authors junction table - Handles Many-to-Many relationship between Books and Authors
CREATE TABLE Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- 7. Loans table - Tracks book borrowing transactions
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    renewed_count INT DEFAULT 0,
    late_fee DECIMAL(8,2) DEFAULT 0.00,
    status ENUM('Active', 'Returned', 'Overdue') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE RESTRICT,
    INDEX idx_member_status (member_id, status)
);

-- 8. Reservations table - Tracks book reservations
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    UNIQUE KEY unique_active_reservation (book_id, member_id)
);

-- 9. Fines table - Tracks member fines and payments
CREATE TABLE Fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    loan_id INT NULL,
    amount DECIMAL(8,2) NOT NULL,
    reason VARCHAR(200) NOT NULL,
    fine_date DATE NOT NULL,
    paid_date DATE NULL,
    status ENUM('Unpaid', 'Paid') DEFAULT 'Unpaid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id) ON DELETE SET NULL
);

-- 10. Staff table - Library staff members
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO Categories (category_name, description) VALUES
('Fiction', 'Imaginative literature including novels and short stories'),
('Science Fiction', 'Fiction based on imagined future scientific or technological advances'),
('Mystery', 'Stories involving mysteries and detective work'),
('Biography', 'Accounts of peoples lives'),
('Science', 'Books about scientific topics and discoveries'),
('History', 'Historical accounts and analysis'),
('Technology', 'Books about technology and computing');

INSERT INTO Publishers (publisher_name, established_year) VALUES
('Penguin Random House', 2013),
('HarperCollins', 1817),
('Macmillan Publishers', 1843),
('Hachette Livre', 1826),
('Simon & Schuster', 1924);

INSERT INTO Authors (first_name, last_name, birth_year, nationality) VALUES
('George', 'Orwell', 1903, 'British'),
('J.K.', 'Rowling', 1965, 'British'),
('Isaac', 'Asimov', 1920, 'American'),
('Agatha', 'Christie', 1890, 'British'),
('Stephen', 'Hawking', 1942, 'British'),
('Walter', 'Isaacson', 1952, 'American');

INSERT INTO Books (isbn, title, publication_year, publisher_id, category_id, total_copies, available_copies) VALUES
('978-0451524935', '1984', 1949, 1, 1, 5, 5),
('978-0439708180', 'Harry Potter and the Sorcerers Stone', 1997, 2, 1, 3, 3),
('978-0553293357', 'Foundation', 1951, 3, 2, 4, 4),
('978-0062073501', 'Murder on the Orient Express', 1934, 2, 3, 2, 2),
('978-0553380163', 'A Brief History of Time', 1988, 4, 5, 3, 3),
('978-1501127625', 'Steve Jobs', 2011, 5, 4, 2, 2);

INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6);

INSERT INTO Members (first_name, last_name, email, phone, membership_date, membership_type) VALUES
('John', 'Smith', 'john.smith@email.com', '+1234567890', '2024-01-15', 'Premium'),
('Sarah', 'Johnson', 'sarah.j@email.com', '+1234567891', '2024-02-20', 'Student'),
('Michael', 'Brown', 'michael.b@email.com', '+1234567892', '2024-03-10', 'Basic'),
('Emily', 'Davis', 'emily.davis@email.com', '+1234567893', '2024-01-05', 'Premium');

INSERT INTO Staff (first_name, last_name, email, position, hire_date) VALUES
('Robert', 'Wilson', 'robert.wilson@library.com', 'Head Librarian', '2020-05-15'),
('Lisa', 'Garcia', 'lisa.garcia@library.com', 'Assistant Librarian', '2022-08-20');

-- Views
CREATE VIEW Available_Books AS
SELECT 
    b.book_id,
    b.title,
    b.isbn,
    GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name)) AS authors,
    c.category_name,
    p.publisher_name,
    b.available_copies
FROM Books b
JOIN Book_Authors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
JOIN Categories c ON b.category_id = c.category_id
JOIN Publishers p ON b.publisher_id = p.publisher_id
WHERE b.available_copies > 0
GROUP BY b.book_id, b.title, b.isbn, c.category_name, p.publisher_name, b.available_copies;

CREATE VIEW Active_Loans_View AS
SELECT 
    l.loan_id,
    m.first_name,
    m.last_name,
    m.email,
    b.title,
    l.loan_date,
    l.due_date,
    l.status
FROM Loans l
JOIN Members m ON l.member_id = m.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.status = 'Active';

CREATE VIEW Member_Fines_Summary AS
SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    SUM(CASE WHEN f.status = 'Unpaid' THEN f.amount ELSE 0 END) AS total_unpaid_fines,
    SUM(CASE WHEN f.status = 'Paid' THEN f.amount ELSE 0 END) AS total_paid_fines
FROM Members m
LEFT JOIN Fines f ON m.member_id = f.member_id
GROUP BY m.member_id, member_name, m.email;

-- Procedures
DELIMITER //

CREATE PROCEDURE BorrowBook(
    IN p_member_id INT,
    IN p_book_id INT,
    IN p_loan_days INT
)
BEGIN
    DECLARE available_count INT;
    DECLARE existing_loans INT;

    SELECT available_copies INTO available_count FROM Books WHERE book_id = p_book_id;

    IF available_count IS NULL THEN
        SELECT 'ERROR' AS result, 'Book does not exist' AS message;
    ELSE
        SELECT COUNT(*) INTO existing_loans FROM Loans 
        WHERE member_id = p_member_id AND status = 'Active';

        IF available_count > 0 AND existing_loans < 5 THEN
            INSERT INTO Loans (book_id, member_id, loan_date, due_date)
            VALUES (p_book_id, p_member_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_loan_days DAY));

            UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = p_book_id;

            SELECT 'SUCCESS' AS result, 'Book borrowed successfully' AS message;
        ELSE
            IF available_count = 0 THEN
                SELECT 'ERROR' AS result, 'Book is not available' AS message;
            ELSE
                SELECT 'ERROR' AS result, 'Member has reached maximum active loans' AS message;
            END IF;
        END IF;
    END IF;
END//

CREATE PROCEDURE ReturnBook(
    IN p_loan_id INT
)
BEGIN
    DECLARE v_book_id INT;
    DECLARE v_due_date DATE;
    DECLARE v_late_fee DECIMAL(8,2);

    SELECT book_id, due_date INTO v_book_id, v_due_date FROM Loans WHERE loan_id = p_loan_id;

    IF v_book_id IS NULL THEN
        SELECT 'ERROR' AS result, 'Loan not found' AS message;
    ELSE
        IF CURDATE() > v_due_date THEN
            SET v_late_fee = DATEDIFF(CURDATE(), v_due_date) * 0.50;
        ELSE
            SET v_late_fee = 0.00;
        END IF;

        UPDATE Loans 
        SET return_date = CURDATE(), 
            status = 'Returned',
            late_fee = v_late_fee
        WHERE loan_id = p_loan_id;

        UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = v_book_id;

        IF v_late_fee > 0 THEN
            INSERT INTO Fines (member_id, loan_id, amount, reason, fine_date)
            SELECT member_id, p_loan_id, v_late_fee, 
                   CONCAT('Late return fee for loan #', p_loan_id), CURDATE()
            FROM Loans WHERE loan_id = p_loan_id;
        END IF;

        SELECT 'SUCCESS' AS result, CONCAT('Book returned. Late fee: $', v_late_fee) AS message;
    END IF;
END//

DELIMITER ;

-- Indexes
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_members_email ON Members(email);
CREATE INDEX idx_loans_dates ON Loans(loan_date, due_date, return_date);
CREATE INDEX idx_fines_status ON Fines(status, fine_date);
CREATE INDEX idx_books_category ON Books(category_id);
CREATE INDEX idx_books_publisher ON Books(publisher_id);

-- Summary
SELECT 
    'Database Created Successfully' AS message,
    (SELECT COUNT(*) FROM Books) AS total_books,
    (SELECT COUNT(*) FROM Members) AS total_members,
    (SELECT COUNT(*) FROM Authors) AS total_authors,
    (SELECT COUNT(*) FROM Categories) AS total_categories;
