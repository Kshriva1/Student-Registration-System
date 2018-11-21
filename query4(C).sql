Create or replace procedure get_prerequisites(v_dept_code in courses.dept_code%type,v_course# in courses.course#%type,error_message out varchar2,r_cursor out sys_refcursor) is
v_found_dept_code_course# Number;
cursor prereq_cursor is
select pre_dept_code,pre_course# from prerequisites
where dept_code = v_dept_code
and course# = v_course#;

prereq_record prereq_cursor%rowtype;

BEGIN
SELECT count(*) into v_found_dept_code_course# FROM Courses WHERE
dept_code = v_dept_code and course# = v_course#;
if (v_found_dept_code_course# = 0) THEN
        error_message := v_dept_code||','||v_course#||' is invalid';


else
        insert into temp_prerequisites select pre_dept_code,pre_course# from
prerequisites where dept_code = v_dept_code and course# =
v_course#;
open prereq_cursor;
loop
        fetch prereq_cursor into prereq_record;
        exit when prereq_cursor%notfound;

get_prerequisites(prereq_record.pre_dept_code,prereq_record.pre_course#,error_message,r_cursor);
end loop;
open r_cursor for select * from temp_prerequisites;
close prereq_cursor;
end if;
end;
/
show errors;


/* to check */


set serveroutput on
DECLARE
f_cursor SYS_REFCURSOR;
f_dept_code prerequisites.dept_code%type;
f_course# prerequisites.course#%type;
err_message varchar2(50);
BEGIN
get_prerequisites('CS',532,err_message,f_cursor);
if (not f_cursor%isopen) then
dbms_output.put_line(err_message);
else
LOOP
fetch f_cursor
into f_dept_code,f_course#;
EXIT when f_cursor%notfound;
dbms_output.put_line(f_dept_code||f_course#);
END LOOP;
close f_cursor;
end if;
DELETE FROM temp_prerequisites;
end;
/
show errors;







