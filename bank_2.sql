create database BANK;
use BANK;
create table Branch(
branch_name varchar(30),
branch_city varchar(10),
asssets real,
primary key (branch_name));
insert into Branch values("SBI_Chamrajpet","Bangalore",50000),("SBI_ResidencyRoad","Bangalore",10000),("SBI_ShivajiRoad","Bombay",20000),("SBI_ParliamentRoad","Delhi",10000),("SBI_Jantarmantar","Delhi",20000);
create table BankAccount(
accno int,
branch_name varchar(30),
balance real,
primary key(accno),
foreign key(branch_name) references Branch(branch_name));
insert into BankAccount values(1,"SBI_Chamrajpet",2000),(2,"SBI_ResidencyRoad",5000),(3,"SBI_ShivajiRoad",6000),(4,"SBI_ParliamentRoad",9000),(5,"SBI_Jantarmantar",8000),(6,"SBI_ShivajiRoad",4000),(8,"SBI_ResidencyRoad",4000),(9,"SBI_ParliamentRoad",3000),(10,"SBI_ResidencyRoad",5000),(11,"SBI_Jantarmantar",2000);
create table BankCustomer(
customer_name varchar(30),
customer_street varchar(30),
customer_city varchar(10),
primary key (customer_name));
select * from Branch;
insert into BankCustomer values("Avinash","Bull temple road","Bangalore"),("Dinesh","Bannergatta road","Bangalore"),("Mohan","National college road","Bangalore"),("Nikhil","Akbar road","Delhi"),("Ravi","Prithviraj road","Delhi");
select * from BankCustomer;
create table Depositer(
customer_name varchar(30),
accno int,
primary key(customer_name,accno),
foreign key(customer_name) references BankCustomer(customer_name),
foreign key(accno) references BankAccount(accno));
insert into Depositer values("Avinash",1),("Dinesh",2),("Nikhil",4),("Ravi",5),("Avinash",8),("Nikhil",9),("Dinesh",10),("Nikhil",11);
create table Loan(
loan_number int,
branch_name varchar(30),
amount real,
primary key(loan_number),
foreign key (branch_name) references Branch(branch_name));
insert into Loan values(1,"SBI_Chamrajpet",1000),(2,"SBI_ResidencyRoad",2000),(3,"SBI_ShivajiRoad",3000),(4,"SBI_ParliamentRoad",4000),(5,"SBI_Jantarmantar",5000);
select * from Loan;
select c.customer_name
from BankCustomer c where exists(
									select d.customer_name,count(d.customer_name)
                                    from depositer d,BankAccount ba
                                    where d.accno=ba.accno and c.customer_name=d.customer_name and ba.branch_name="SBI_ResidencyRoad"
                                    group by d.customer_name
                                    having count(d.customer_name)>=2);
                                    
select BC.customer_name from BankCustomer BC where not exists(
	select branch_name from Branch where branch_city = 'Delhi'
	except
    select BA.branch_name from Depositer D, BankAccount BA
	where D.accno = BA.accno and BC.customer_name = D.customer_name
);

delete from BankAccount 
where branch_name in (select branch_name 
					  from Branch
                      where branch_city='Bombay');
select * from BankAccount;