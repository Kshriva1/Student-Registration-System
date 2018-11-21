set serveroutput on;
create or replace procedure show_prereqs(
	dCode in Courses.dept_code%type, 
	cNum in Courses.course#%type) IS

	--local definitions
	temp_dCode Courses.dept_code%type;
	temp_cNum Courses.course#%type;
	l_dept_code Courses.dept_code%type;
	l_course# Courses.course#%type;

	CURSOR c_prereqs IS
		SELECT pre_dept_code, pre_course# FROM Prerequisites WHERE dept_code = dCode and course# = cNum;

BEGIN
	SELECT dept_code, course# INTO
	temp_dCode, temp_cNum FROM Courses
	WHERE dept_code = dCode and course# = cNum;

	OPEN c_prereqs;
	LOOP
	FETCH c_prereqs into l_dept_code, l_course#;
		EXIT WHEN c_prereqs%notfound;
		DBMS_output.put_line(l_dept_code || l_course#);
		DBMS_output.put_line('----------------------');
		show_prereqs(l_dept_code, l_course#);
		DBMS_output.put_line('----------------------');	
	
	END LOOP;
	CLOSE c_prereqs;
	Return;	


EXCEPTION WHEN NO_DATA_FOUND THEN
	IF temp_dCode is null and temp_cNum is null then	 
		DBMS_output.put_line(dCode || cNum || ' does not exist');
	END IF;	

END;
/
show errors;
