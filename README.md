# 📚 Week 8 Assignment – Final Project  

## 📖 Description  
This repository contains my solution for the **Week 8 Final Project**.  
I selected **Question 1: Build a Complete Database Management System** and implemented a **Library Management System** using **MySQL**.  

---

## 📝 Assignment Guidelines  

- The assignment consists of two questions.  
- Students are required to **pick ONE (1)** question only.  
- Create a GitHub repository and upload the solution.  
- Submit the repository link for grading.  
- **Deadline:** Wednesday, 25th September 2025.  
- Late submissions will not be accepted unless prior approval is granted.  

---

## 🎯 Selected Question – **Question 1: Database Management System**  

### ✅ Objective  
Design and implement a **full-featured relational database** using MySQL.  

### ✅ Real-world Use Case  
**Library Management System** – handles books, members, loans, reservations, categories, publishers, and more.  

### ✅ Implementation Details  

- **Database:** `LibraryDB`  
- **Features:**  
  - Well-structured relational schema.  
  - Tables with **PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE** constraints.  
  - Relationships:  
    - One-to-Many (Authors → Books, Members → Loans).  
    - Many-to-Many (Books ↔ Authors).  
  - Stored Procedures for borrowing and returning books.  
  - Indexing for faster queries.  
  - Views for reporting.  

---

## 📂 Deliverables  

- `library_management.sql`  
  - `CREATE DATABASE` statement.  
  - `CREATE TABLE` statements with constraints.  
  - Relationship definitions.  
  - Stored procedures.  
  - Views & indexes.  

---

## ⚡ How to Run  

1. Clone this repository:
   ```bash
   git clone https://github.com/iiekezie/week8-final-project.git
   cd week8-final-project
````

2. Open MySQL and execute the SQL script:

   ```bash
   mysql -u root -p < library_management.sql
   ```

3. Verify the database:

   ```sql
   SHOW DATABASES;
   USE LibraryDB;
   SHOW TABLES;
   ```

---

## 📊 Database Schema Overview

* **Authors** – stores author details.
* **Categories** – groups books by genre.
* **Publishers** – stores publisher information.
* **Books** – contains book details & available copies.
* **Members** – stores library member records.
* **Loans** – tracks borrowed and returned books.
* **Reservations** – handles book reservations.

---

## 🚀 Bonus Features

* **Stored Procedures:**

  * `BorrowBook(member_id, book_id, due_date)`
  * `ReturnBook(loan_id, return_date)`

* **View:**

  * `Available_Books` – lists books that can still be borrowed.

* **Indexes:**

  * On commonly queried fields (`title`, `isbn`, `loan_date`, etc.).

---

## ✅ Status

Completed and tested ✅
