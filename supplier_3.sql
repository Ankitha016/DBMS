create database Supplier;
use Supplier;
create table Supplier(
sid int,
sname varchar(30),
city varchar(30),
primary key(sid));
desc Supplier;
create table Parts(
pid int,
pname varchar(30),
color varchar(30),
primary key(pid));
create table Catalog(
sid int,
pid int,
cost int,
primary key(sid,pid),
foreign key (sid) references Supplier(sid),
foreign key (pid) references Parts(pid));
insert into Supplier values(10001,'Acme Widget','Bangalore'),(10002,'Johns','Kolkata'),(10003,'Vimal','Mumbai'),(10004,'Reliance','Delhi');
insert into Parts values(20001,'Book','Red'),(20002,'Pen','Red'),(20003,'pencil','Green'),(20004,'Mobile','Green'),(20005,'Charger','Black');
insert into Catalog values(10001,20001,10),(10001,20002,10),(10001,20003,30),(10001,20004,10),(10001,20005,10),(10002,20001,10),(10002,20002,20),(10003,20003,30),(10004,20003,40);
select * from Supplier;
select * from Parts;
select * from Catalog;

select distinct pname 
from Parts, Catalog
where Parts.pid=Catalog.pid;

select sname 
from Supplier
where not exists( select pid from Parts
					except
                    select distinct pid 
                    from Catalog
                    where Catalog.sid=Supplier.sid);

select sname 
from Supplier
where not exists( select pid from Parts where color='Red'
					except
                    select distinct Catalog.pid 
                    from Catalog , Parts
                    where Parts.pid=Catalog.pid and Parts.color='Red' and  Catalog.sid=Supplier.sid);
                    

select pname
from Parts,Catalog,Supplier
where Catalog.pid=Parts.pid and Catalog.sid=Supplier.sid 
and Supplier.sname='Acme Widget' and Catalog.pid not in (select c.pid from Catalog c ,Supplier s
							where s.sid=c.sid and s.sname<>'Acme Widget');


select sid
from Catalog c
where c.cost>( select avg(c1.cost)
		from Catalog c1
		where c.pid=c1.pid);
                
                
select p.pid, s.sname
from Parts p, Supplier s, Catalog c
where p.pid=c.pid and s.sid=c.sid
and c.cost=(select max(c1.cost)
	    from Catalog c1
            where c1.pid=c.pid);