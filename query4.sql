Create or replace procedure get_prerequisites(v_dept_code in courses.dept_code%type,v_course# in courses.course#%type,error_message out varchar2,r_cursor out sys_refcursor) is
v_found_dept_code_course# Number;
cursor prereq_cursor is
select dept_code,course# from prerequisites
where pre_dept_code = v_dept_code
and pre_course# = v_course#;

prereq_record prereq_cursor%rowtype;

BEGIN
SELECT count(*) into v_found_dept_code_course# FROM Courses WHERE
dept_code = v_dept_code and course# = v_course#;
if (v_found_dept_code_course# = 0) THEN
        error_message := v_dept_code||','||v_course#||' is invalid';
else
        insert into temp_prerequisites select dept_code,course# from
prerequisites where pre_dept_code = v_dept_code and pre_course# =
v_course#;
open prereq_cursor;
loop
        fetch prereq_cursor into prereq_record;
        exit when prereq_cursor%notfound;

get_prerequisites(prereq_record.dept_code,prereq_record.course#,error_message,r_cursor);
end loop;
open r_cursor for select * from temp_prerequisites;
close prereq_cursor;
end if;
end;
/
show errors;
