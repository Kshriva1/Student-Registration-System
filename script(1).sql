drop table prerequisites;
drop table logs;
drop table enrollments;
drop table classes;
drop table tas;
drop table course_credit;
drop table courses;
drop table students;

create table students (B# char(4) primary key check (B# like 'B%'),
first_name varchar2(15) not null, last_name varchar2(15) not null, status varchar2(10) 
check (status in ('freshman', 'sophomore', 'junior', 'senior', 'MS', 'PhD')), 
gpa number(3,2) check (gpa between 0 and 4.0), email varchar2(20) unique,
bdate date, deptname varchar2(4) not null);

create table tas (B# char(4) primary key references students,
ta_level varchar2(3) not null check (ta_level in ('MS', 'PhD')), 
office varchar2(10));  

create table courses (dept_code varchar2(4), course# number(3)
check (course# between 100 and 799), title varchar2(20) not null,
primary key (dept_code, course#));

create table course_credit (course# number(3) primary key
check (course# between 100 and 799), credits number(1) check (credits in (3, 4)),
check ((course# < 500 and credits = 4) or (course# >= 500 and credits = 3)));

create table classes (classid char(5) primary key check (classid like 'c%'), 
dept_code varchar2(4) not null, course# number(3) not null, 
sect# number(2), year number(4), semester varchar2(8) 
check (semester in ('Spring', 'Fall', 'Summer 1', 'Summer 2')), limit number(3), 
class_size number(3), room varchar2(10), ta_B# char(4) references tas,
foreign key (dept_code, course#) references courses on delete cascade, 
unique(dept_code, course#, sect#, year, semester), check (class_size <= limit));

create table enrollments (B# char(4) references students, classid char(5) references classes, 
lgrade varchar2(2) check (lgrade in ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-','D', 
'F', 'I')), primary key (B#, classid));

create table prerequisites (dept_code varchar2(4) not null,
course# number(3) not null, pre_dept_code varchar2(4) not null,
pre_course# number(3) not null,
primary key (dept_code, course#, pre_dept_code, pre_course#),
foreign key (dept_code, course#) references courses on delete cascade,
foreign key (pre_dept_code, pre_course#) references courses on delete cascade);

create table logs (log# number(4) primary key, op_name varchar2(10) not null, op_time date not null,
table_name varchar2(12) not null, operation varchar2(6) not null, key_value varchar2(10));

insert into students values ('B001', 'Anne', 'Broder', 'junior', 3.17, 'broder@bu.edu', '17-JAN-90', 'CS');
insert into students values ('B002', 'Terry', 'Buttler', 'senior', 3.0, 'buttler@bu.edu', '28-MAY-89', 'Math');
insert into students values ('B003', 'Tracy', 'Wang', 'senior', 4.0, 'wang@bu.edu','06-AUG-93', 'CS');
insert into students values ('B004', 'Barbara', 'Callan', 'junior', 2.5, 'callan@bu.edu', '18-OCT-91', 'Math');
insert into students values ('B005', 'Jack', 'Smith', 'MS', 3.2, 'smith@bu.edu', '18-OCT-91', 'CS');
insert into students values ('B006', 'Terry', 'Zillman', 'PhD', 4.0, 'zillman@bu.edu', '15-JUN-88', 'Biol');
insert into students values ('B007', 'Becky', 'Lee', 'senior', 4.0, 'lee@bu.edu', '12-NOV-92', 'CS');
insert into students values ('B008', 'Tom', 'Baker', 'freshman', null, 'baker@bu.edu', '23-DEC-96', 'CS');
insert into students values ('B009', 'Ben', 'Liu', 'MS', 3.8, 'liu@bu.edu', '18-MAR-92', 'Math');
insert into students values ('B010', 'Sata', 'Patel', 'MS', 3.9, 'patel@bu.edu', '12-OCT-90', 'CS');
insert into students values ('B011', 'Art', 'Chang', 'PhD', 4.0, 'chang@bu.edu', '08-JUN-89', 'CS');
insert into students values ('B012', 'Tara', 'Ramesh', 'PhD', 3.98, 'ramesh@bu.edu', '29-JUL-91', 'Math');

insert into tas values ('B005', 'MS', 'EB G26');
insert into tas values ('B009', 'MS', 'WH 112');
insert into tas values ('B010', 'MS', 'EB G26');
insert into tas values ('B011', 'PhD','EB P85');
insert into tas values ('B012', 'PhD','WH 112');

insert into courses values ('CS', 432, 'database systems');
insert into courses values ('Math', 314, 'discrete math');
insert into courses values ('CS', 240, 'data structure');
insert into courses values ('Math', 221, 'calculus I');
insert into courses values ('CS', 532, 'database systems');
insert into courses values ('CS', 552, 'operating systems');
insert into courses values ('Biol', 425, 'molecular biology');

insert into course_credit values (432, 4);
insert into course_credit values (314, 4);
insert into course_credit values (240, 4);
insert into course_credit values (221, 4);
insert into course_credit values (532, 3);
insert into course_credit values (552, 3);
insert into course_credit values (425, 4);

insert into classes values ('c0001', 'CS', 432, 1, 2017, 'Spring', 3, 2, 'LH 005', 'B005');
insert into classes values ('c0002', 'Math', 314, 1, 2016, 'Fall', 3, 2, 'LH 009', 'B012');
insert into classes values ('c0003', 'Math', 314, 2, 2016, 'Fall', 4, 1, 'LH 009', 'B009');
insert into classes values ('c0004', 'CS', 432, 1, 2016, 'Spring', 3, 3, 'SW 222', 'B005');
insert into classes values ('c0005', 'CS', 240, 1, 2017, 'Spring', 4, 3, 'LH 003', 'B010');
insert into classes values ('c0006', 'CS', 532, 1, 2017, 'Spring', 4, 3, 'LH 005', 'B011');
insert into classes values ('c0007', 'Math', 221, 1, 2017, 'Spring', 1, 1, 'WH 155', null);
insert into classes values ('c0008', 'Math', 314, 2, 2018, 'Fall', 4, 1, 'LH 009', 'B009');
insert into classes values ('c0009', 'CS', 432, 1, 2018, 'Fall', 4, 3, 'SW 222', 'B005');
insert into classes values ('c0010', 'CS', 240, 1, 2018, 'Fall', 4, 3, 'LH 003', 'B010');
insert into classes values ('c0011', 'CS', 532, 1, 2018, 'Fall', 4, 3, 'LH 005', 'B011');
insert into classes values ('c0012', 'Math', 221, 1, 2018, 'Fall', 4, 1, 'WH 155', null);
insert into classes values ('c0013', 'Math', 314, 1, 2018, 'Fall', 3, 1, 'WH 156', null);
insert into classes values ('c0014', 'CS', 240, 1, 2018, 'Fall', 2, 1, 'LH 003', null);



insert into enrollments values ('B001', 'c0001', 'A');
insert into enrollments values ('B002', 'c0002', 'B');
insert into enrollments values ('B003', 'c0004', 'A');
insert into enrollments values ('B004', 'c0004', 'A');
insert into enrollments values ('B004', 'c0005', 'B+');
insert into enrollments values ('B005', 'c0006', 'B');
insert into enrollments values ('B006', 'c0006', 'A');
insert into enrollments values ('B001', 'c0002', 'C+');
insert into enrollments values ('B003', 'c0005', 'B+');
insert into enrollments values ('B007', 'c0007', 'A');
insert into enrollments values ('B001', 'c0003', 'B');
insert into enrollments values ('B001', 'c0006', 'B-');
insert into enrollments values ('B001', 'c0004', 'A');
insert into enrollments values ('B001', 'c0005', 'B');
insert into enrollments values ('B003', 'c0001', 'I');
insert into enrollments values ('B003', 'c0008', 'A');
insert into enrollments values ('B001', 'c0009', 'B');
insert into enrollments values ('B003', 'c0010', 'A');
insert into enrollments values ('B003', 'c0011', 'B');
insert into enrollments values ('B003', 'c0012', 'B+');


insert into prerequisites values ('Math',314,'Math',221);



