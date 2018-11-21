SET SERVEROUTPUT ON
DECLARE
l_cursor SYS_REFCURSOR;
l_dept_code courses.dept_code%type;
l_course# courses.course#%type;
err_message varchar2(50);
BEGIN
get_prerequisites('CS',532,err_message,l_cursor);
if (not l_cursor%isopen) then
dbms_output.put_line(err_message);
else
LOOP
fetch l_cursor
into l_dept_code,l_course#;
EXIT when l_cursor%notfound;
dbms_output.put_line(l_dept_code||','||l_course#);
END LOOP;
close l_cursor;
end if;
end;
/
show errors;
