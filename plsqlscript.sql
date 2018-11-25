create table prerequisites (dept_code varchar2(4) not null,
course# number(3) not null, pre_dept_code varchar2(4) not null,
pre_course# number(3) not null,
primary key (dept_code, course#, pre_dept_code, pre_course#),
foreign key (dept_code, course#) references courses on delete cascade,
foreign key (pre_dept_code, pre_course#) references courses on delete cascade);

create table logs (log# number(4) primary key, op_name varchar2(10) not null, op_time date not null,
table_name varchar2(12) not null, operation varchar2(6) not null, key_value varchar2(10));

