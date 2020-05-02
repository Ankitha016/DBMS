create database studfaculty_4; 
use studfaculty_4; 
create table Student (
snum int, 
sname varchar(20),
major varchar(20),
lvl varchar(20),
age int,
primary key(snum));

create table Faculty(
fid int,
fname varchar(20),
deptid int,
primary key(fid));

create table Class(
cname varchar(30),
meetsat time,
room varchar(30),
fid int,
primary key(cname),
foreign key (fid) references Faculty(fid));

create table Enrolled(
snum int,
cname varchar(30),
primary key(snum,cname),
foreign key(snum) references Student(snum),
foreign key(cname) references Class(cname));
insert into Student values(1, 'jhon', 'CS', 'Sr', 19),(2, 'Smith', 'CS', 'Jr', 20),(3 , 'Jacob', 'CV', 'Sr', 20),(4, 'Tom ', 'CS', 'Jr', 20),(5, 'Rahul', 'CS', 'Jr', 20),(6, 'Rita', 'CS', 'Sr', 21);
select * from Student;
insert into faculty values(11, 'Harish', 1000),(12, 'MV', 1000),(13 , 'Mira', 1001),(14, 'Shiva', 1002),(15, 'Nupur', 1000);
select * from Faculty;
alter table Class modify column  meetsat timestamp;
insert into Class values('class1', '12/11/15 10:15:16', 'R1', 14),('class10', '12/11/15 10:15:16', 'R128', 14),('class2', '12/11/15 10:15:20', 'R2', 12),('class3', '12/11/15 10:15:25', 'R3', 12),('class4', '12/11/15 20:15:20', 'R4', 14),('class5', '12/11/15 20:15:20', 'R3', 15),('class6', '12/11/15 13:20:20', 'R2', 14),('class7', '12/11/15 10:10:10', 'R3', 14);

select * from Class;

select * from Class;
insert into Enrolled values(1, 'class1'),(2, 'class1'),(3, 'class3'),(4, 'class3'),(5, 'class4'),(1, 'class5'),(2, 'class5'),(3, 'class5'),(4,'class5'),(5,'class5');
select * from enrolled;

/* i.	Find the names of all Juniors (level = JR) who are enrolled in a class taught by  */
select distinct sname 
from Student,Faculty,Class,Enrolled
where fname='MV' AND Faculty.fid=Class.Fid and Student.snum=Enrolled.snum and Class.cname=Enrolled.cname and Student.lvl='Jr'; 


/* ii.	Find the names of all classes that either meet in room R128 or have five or more Students enrolled. */
select cname
from Class
where room='R128' OR cname in ( select distinct cname 
				from Enrolled
                                group by cname
                                having count(*)>=5);
                                
 /* Find the names of all students who are enrolled in two classes that meet at the same time. */                              
select sname
from Student
where snum in (select e1.snum 
		from Enrolled e1,Enrolled e2,Class c1,Class c2
                where e1.snum=e2.snum and e1.cname=c1.cname and e2.cname=c2.cname and e1.cname<>e2.cname and c1.meetsat=c2.meetsat);
                

/* Find the names of faculty members who teach in every room in which some class is taught. */
select fname
from Faculty
where not exists(select room from Class
	             except
                 select distinct c.room 
                 from Class c
                 where c.fid=Faculty.fid);

			
                
/* Find the names of faculty members for whom the combined enrollment of the courses that they teach is less than five.*/              

select distinct fname
from Faculty
where 5>(select count(Enrolled.snum)
		 from Enrolled,Class
		 where Enrolled.cname=Class.cname and Class.fid=Faculty.fid);
         
         
/* Find the names of students who are not enrolled in any class. */         
select sname
from Student
where snum not in (select snum
		   from Enrolled);
                    
 
/* vii.	For each age value that appears in Students, find the level value that appears most often. For example, if there are more FR level students aged 18 than SR, JR, or SO students aged 18, you should print the pair (18, FR). */
select S.age, S.lvl
from Student S
group by S.age, S.lvl
having S.lvl in (select S1.lvl from Student S1
                 where S1.age = S.age
		         group by S1.lvl, S1.age
                 having count(*) >= all (select count(*)
					                     from Student S2
					                     where s1.age = S2.age
					                     group by S2.lvl, S2.age));