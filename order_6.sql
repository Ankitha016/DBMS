create database order_6;
use order_6;

create table salesman(
salesman_id int,
sname varchar(15), 
city varchar(15),
commission  int,
primary key(salesman_id));

INSERT INTO SALESMAN VALUES (1000, 'JOHN','BANGALORE',25); 
INSERT INTO SALESMAN VALUES (2000,'RAVI','BANGALORE',20); 
INSERT INTO SALESMAN VALUES (3000, 'KUMAR','MYSORE',15); 
INSERT INTO SALESMAN VALUES (4000, 'SMITH','DELHI',30); 
INSERT INTO SALESMAN VALUES (5000, 'HARSHA','HYDRABAD',15); 
 select * from salesman;
 
 create table CUSTOMER (Customer_id int,
 Cust_Name varchar(15),
 City varchar(15),
 Grade int,
 Salesman_id int,
 primary key(Customer_id),
 foreign key (Salesman_id) references salesman(Salesman_id));
 
INSERT INTO CUSTOMER VALUES (10, 'PREETHI','BANGALORE', 100, 1000); 
INSERT INTO CUSTOMER VALUES (11, 'VIVE','MANGALORE', 300, 1000); 
INSERT INTO CUSTOMER VALUES (12, 'BHASKAR','CHENNAI', 400, 2000); 
INSERT INTO CUSTOMER VALUES (13, 'CHETHAN','BANGALORE', 200, 2000); 
INSERT INTO CUSTOMER VALUES (14, 'MAMATHA','BANGALORE', 400, 3000); 

create table ORDERS (Ord_No int,
Purchase_Amt int,
Ord_Date varchar(15), 
Customer_id int, 
Salesman_id int,
primary key(Ord_No),
foreign key (Salesman_id) references salesman(Salesman_id),
foreign key (Customer_id) references CUSTOMER(Customer_id));

INSERT INTO ORDERS VALUES (50, 5000, '04-MAY-17', 10, 1000); 
INSERT INTO ORDERS VALUES (51, 450, '20-JAN-17', 10, 2000);
INSERT INTO ORDERS VALUES (52, 1000, '24-FEB-17', 13, 2000); 
INSERT INTO ORDERS VALUES (53, 3500, '13-APR-17', 14, 3000); 
INSERT INTO ORDERS VALUES (54, 550, '09-MAR-17', 12, 2000);

/*1. Count the customers with grades above Bangalore’s average. */
select Count(*) 
from CUSTOMER
where Grade>(select avg(Grade)
			from CUSTOMER
			where City='BANGALORE');
            
/*2. Find the name and numbers of all salesmen who had more than one customer. */
select salesman_id,sname
from salesman
where salesman_id=(select Salesman_id
					from CUSTOMER
                    where CUSTOMER.Salesman_id=salesman.salesman_id
                    group by CUSTOMER.Salesman_id
                    having count(*)>1);
                    
/* 2. Find the name and numbers of all salesmen who had more than one customer.  */
select salesman_id, sname
from salesman A 
where 1 < (select count(*) 
from CUSTOMER 
where Salesman_id=A.salesman_id);


/*4. Create a view that finds the salesman who has the customer with the highest order of a day. */
create view BestSalesman AS
select B.Ord_Date, A.salesman_id, A.sname 
from salesman A, ORDERS B
where A.salesman_id = B.Salesman_id 
AND B.Purchase_Amt=(select MAX(Purchase_Amt) 
from ORDERS C 
WHERE C.Ord_Date = B.Ord_Date);

select * from BestSalesman;

/*5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted. */

ALTER TABLE ORDERS
  ADD CONSTRAINT Salesman_id
  FOREIGN KEY (Salesman_id) 
  REFERENCES salesman(salesman_id) 
  ON DELETE CASCADE;
  
ALTER TABLE CUSTOMER 
  ADD CONSTRAINT Salesman_idCust
  FOREIGN KEY (Salesman_id) 
  REFERENCES salesman(salesman_id) 
  ON DELETE SET NULL;
  
delete from salesman 
where salesman_id=1000;
                    
                    

