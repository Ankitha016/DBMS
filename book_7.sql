create database Book;
use Book;
create table Publisher(
pname varchar(15),
phone int,
address varchar(30),
primary key(pname));

create table Book(
book_id int,
title varchar(15),
pub_yr varchar(15),
pname varchar(15),
primary key(book_id),
foreign key (pname) references Publisher(pname));

create table Author(
aname varchar(15),
book_id int,
primary key(book_id,aname),
foreign key(book_id) references Book(book_id) ON DELETE CASCADE);

create table Library_Branch(
branch_id int,
bname varchar(30),
address varchar(30),
primary key(branch_id));

create table Book_Copies(
no_of_copies int,
book_id int,
branch_id int,
primary key(book_id,branch_id),
foreign key(book_id) references Book(book_id) ON DELETE CASCADE,
foreign key(branch_id) references Library_Branch(branch_id) ON DELETE CASCADE);

create table Card(
card_no int,
primary key(card_no));

create table Book_Lending(
date_out date,
due_date date,
book_id int,
branch_id int,
card_no int,
primary key(book_id,branch_id,card_no),
foreign key(book_id) references Book(book_id) ON DELETE CASCADE,
foreign key(branch_id) references Library_Branch(branch_id) ON DELETE CASCADE,
foreign key(card_no) references Card(card_no) ON DELETE CASCADE);

ALTER TABLE Publisher
MODIFY COLUMN phone long;


INSERT INTO PUBLISHER VALUES ('MCGRAW-HILL', 9989076587, 'BANGALORE'), ('PEARSON', 9889076565, 'NEWDELHI'), ('RANDOM HOUSE', 7455679345, 'HYDRABAD'), ('HACHETTE LIVRE', 8970862340, 'CHENAI'), ('GRUPO PLANETA', 7756120238, 'BANGALORE'); 
 select * from Publisher; 
 

INSERT INTO BOOK VALUES (1,'DBMS','JAN-2017', 'MCGRAW-HILL'), (2,'ADBMS','JUN-2016', 'MCGRAW-HILL'), (3,'CN','SEP-2016', 'PEARSON'),(4,'CG','SEP-2015', 'GRUPO PLANETA'),(5,'OS','MAY-2016', 'PEARSON'); 

INSERT INTO AUTHOR VALUES ('NAVATHE', 1), ('NAVATHE', 2), ('TANENBAUM', 3), ('EDWARD ANGEL', 4), ('GALVIN', 5); 

INSERT INTO LIBRARY_BRANCH VALUES (10,'RR NAGAR','BANGALORE'), (11,'RNSIT','BANGALORE'), (12,'RAJAJI NAGAR', 'BANGALORE'),(13,'NITTE','MANGALORE'), (14,'MANIPAL','UDUPI'); 

INSERT INTO BOOK_COPIES VALUES (10, 1, 10),(5, 1, 11),(2, 2, 12),(5, 2, 13), (7, 3, 14), (1, 5, 10), (3, 4, 11); 

INSERT INTO CARD VALUES (100),(101), (102),(103), (104);

INSERT INTO BOOK_LENDING VALUES ('2017-01-01','2017-06-01', 1, 10, 101),('2017-01-11','2017-03-11', 3, 14, 101),('2017-02-21','2017-04-21', 2, 13, 101),('2017-03-15','2017-07-15', 4, 11, 101), ('2017-04-12','2017-05-12', 1, 11, 104); 

/*1. Retrieve details of all books in the library – id, title, name of publisher, authors, number of copies in each branch, etc. */

SELECT B.BOOK_ID, B.TITLE, B.PNAME, A.ANAME, C.NO_OF_COPIES, L.BRANCH_ID 
FROM BOOK B, AUTHOR A, BOOK_COPIES C, LIBRARY_BRANCH L 
WHERE B.BOOK_ID=A.BOOK_ID 
AND B.BOOK_ID=C.BOOK_ID 
AND L.BRANCH_ID=C.BRANCH_ID;	

/*2. Get the particulars of borrowers who have borrowed more than 3 books, but from Jan 2017 to Jun 2017. */
SELECT CARD_NO 
FROM BOOK_LENDING 
WHERE DATE_OUT BETWEEN 2017-01-01 AND 2017-06-01 
GROUP BY CARD_NO 
HAVING COUNT(*)>3;

/* 3.Delete a book in BOOK table. Update the contents of other tables to reflect this data manipulation operation. */
DELETE FROM BOOK
WHERE BOOK_ID=3;

/* 4.Partition the BOOK table based on year of publication. Demonstrate its working with a simple query. */
CREATE VIEW V_PUBLICATION AS 
SELECT PUB_YR 
FROM BOOK;
SELECT * FROM V_PUBLICATION;

/*5. Create a view of all books and its number of copies that are currently available in the Library. */
CREATE VIEW V_BOOKS AS 
SELECT B.BOOK_ID, B.TITLE, C.NO_OF_COPIES 
FROM BOOK B, BOOK_COPIES C, LIBRARY_BRANCH L 
WHERE B.BOOK_ID=C.BOOK_ID 
AND C.BRANCH_ID=L.BRANCH_ID;

SELECT * FROM V_BOOKS;