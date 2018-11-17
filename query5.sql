create or replace procedure enroll_student(v_B# in students.B#%type,
v_classid in classes.classid%type,error_message out varchar2) is
v_student_B# Number;
v_student_classid Number;
v_class_sem Number;
v_student_in_sem Number;
v_capacity Number;
v_student_overloaded Number;
begin
Select count(*) into v_student_B# from Students where B# = v_B#;
Select count(*) into v_student_classid from Classes where classid = v_classid;
if (v_student_classid > 0) then
select count(*) into v_class_sem from classes where classid = v_classid
and year = 2018 and semester = 'Fall';
select LIMIT-class_size into v_capacity from classes where classid =
v_classid;
end if;
select count(*) into v_student_in_sem from enrollments where B# = v_B#
and classid = v_classid;
select count(*) into v_student_overloaded from enrollments e,classes c
where e.B# = v_B# and e.classid = c.classid and c.year = 2018 and c.semester = 'Fall';
if (v_student_B# = 0) then
error_message := 'The B# is invalid';
elsif (v_student_classid = 0) then
error_message := 'The classid is invalid';
elsif (v_class_sem > 0) then
error_message := 'Cannot enroll into a class from a previous semester';
elsif (v_capacity = 0) then
error_message := 'The class is already full';
elsif (v_student_in_sem = 0) then
error_message := 'The student is already in the class';
elsif (v_student_overloaded = 4) then
error_message := 'The student will be overloaded with the new
enrollment';
INSERT INTO Enrollments(B#,classid) VALUES (v_B#,v_classid);
elsif (v_student_overloaded > 4) then
error_message := 'Students cannot be enrolled in more than five classes
in the same semester';
else
Insert into enrollments (B#,classid) values (v_B#,v_classid);
end if;
end;
/


/* to check */
                                                                                                                  

set serveroutput on
declare
err_message varchar2(1000);
begin
enroll_student('B007','c0007',err_message);
if(LENGTH(err_message) > 0) then
dbms_output.put_line(err_message);
end if;
end;
/



