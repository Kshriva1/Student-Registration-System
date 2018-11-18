set serveroutput on;
create or replace procedure del_student(
	delB# IN Students.B#%type) IS

	--local
	tempB# Students.B#%type;

BEGIN
	SELECT B#
	INTO tempB# FROM Students WHERE B# = delB#;
	DELETE Students WHERE B# = delB#;	

EXCEPTION WHEN NO_DATA_FOUND THEN
	IF tempB# is null THEN
		DBMS_output.put_line('The B# is invalid');
	END IF;
END;
/
show errors; 
