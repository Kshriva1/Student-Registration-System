/*  student table */

create or replace procedure show_students(student_cursor out
sys_refcursor) AS
BEGIN
        open student_cursor for
        select * from students;
END;
/
show errors;

/* courses table */

create or replace procedure show_courses(student_cursor out
sys_refcursor) AS
BEGIN
        open student_cursor for
        SELECT * FROM COURSES;
END;
/
show errors;


/* TAs table */

create or replace procedure show_TAs(student_cursor out sys_refcursor)
AS
BEGIN
        open student_cursor for
        select * from TAs;
end;
/
show errors;


/* classes table */

Create or replace procedure show_classes(student_cursor out
sys_refcursor) as
BEGIN
        open student_cursor for
        select * from classes;
END;
/


/* enrollments table */

create or replace procedure show_enrollments(student_cursor out
sys_refcursor)
AS
BEGIN
        open student_cursor for
        select * from enrollments;
END;
/


/* prerequisites table */

create or replace procedure show_prerequisites(student_cursor out
sys_refcursor) AS
BEGIN
        open student_cursor for
        select * from prerequisites;
END;
/



/* logs table */

create or replace procedure show_logs(student_cursor out sys_refcursor)
AS
BEGIN
        open student_cursor for
        select * from logs;
END;
/

