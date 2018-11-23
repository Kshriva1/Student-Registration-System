


   
	tempYear Classes.Year%type;
	dCode Classes.DEPT_CODE%type;
	c# Classes.Course#%type;
	countPre Number;
	newSize Classes.Class_size%type;
	numClasses Number;

BEGIN
  SELECT count(*)
  INTO count_B# FROM Students WHERE B# = dropB#;
  SELECT count(*)
  INTO count_Classid FROM Classes WHERE Classid = dropClassid;
  SELECT count(*)
  INTO count_Enrollment FROM Enrollments WHERE B# = dropB# and Classid = dropClassid;
  IF (count_B# = 0) THEN
    error_message := 'The B# is invalid';
  ELSIF (count_Classid = 0) THEN
    error_message := 'The classid is invalid';
  ELSIF (count_Enrollment = 0) THEN
    error_message := 'The student is not enrolled in the class';
  ELSE

	 SELECT SEMESTER, YEAR
	 INTO tempSemester, tempYear FROM CLASSES WHERE Classid = dropClassid;
	 IF tempSemester != 'Fall' or tempYear != 2018 THEN
		error_message := 'Only enrollment in the current semester can be dropped.';
		RETURN;
	END IF;
	SELECT DEPT_CODE, COURSE#
	INTO dCode, c# FROM CLASSES WHERE Classid = dropClassid;
	SELECT count(DEPT_CODE) INTO countPre
	FROM PREREQUISITES WHERE DEPT_CODE in
		(SELECT DEPT_CODE FROM CLASSES WHERE Classid in
			(SELECT Classid FROM ENROLLMENTS WHERE B# = dropB#)) and
	COURSE# in (SELECT COURSE# FROM Classes WHERE Classid in
				(SELECT Classid FROM Enrollments WHERE B# = dropB#))
	and PRE_DEPT_CODE = dCode and PRE_COURSE# = c#;
	IF countPre != 0 THEN
		error_message := 'The drop is not permitted because another class the student registered uses it as a prerequisite.';
		RETURN;
	END IF;
	DELETE FROM Enrollments WHERE B# = dropB# and Classid = dropClassid;
	SELECT class_size INTO newSize
	FROM Classes WHERE Classid = dropClassid;
	IF newSize = 0 THEN
		error_message := 'The class has no students';
	END IF;
	SELECT COUNT(Classid) into numClasses
	FROM Enrollments WHERE B# = dropB#;
	IF numClasses = 0 THEN
		error_message := 'This student is not enrolled in any classes';
	END IF;
END IF;
END;



--Stored Procedure: del_student
procedure del_student (delB# IN Students.B#%type,error_message out varchar2) AS
count_B# Students.B#%type;

BEGIN
        SELECT COUNT(*) into count_B# FROM Students Where B# = delB#;


        IF (count_B# = 0) THEN
                error_message := 'The B# is invalid';
        ELSE
                DELETE Students WHERE B# = delB#;
        END IF;
END;





end;
/
show errors;





--Trigger: enrollments_insert
create or replace trigger enrollments_insert
after insert on enrollments
for each row
declare
user_log varchar2(20);
operation_log varchar2(20) default 'insert';
key_value_log varchar2(50);
B#_log enrollments.B#%type;
classid_log enrollments.classid%type;
table_name_log nvarchar2(20) default 'enrollments';
id_log Number;
begin
B#_log := :new.B#;
classid_log := :new.classid;
key_value_log := (B#_log||','||classid_log);
id_log := logs_seq.nextval;
select user into user_log from dual;
Insert into logs
values(id_log,user_log,sysdate,table_name_log,operation_log,key_value_log);
Update classes
set class_size = class_size+1
where classid = classid_log;
end;
/
show errors;

--Trigger: Enrollments_delete
create or replace trigger ENROLLMENTS_DELETE
AFTER DELETE ON Enrollments
FOR EACH ROW
DECLARE
  user_log varchar2(20);
  operation_log varchar2(20) default 'delete';
  key_value_log varchar2(50);
  B#_log enrollments.B#%type;
  classid_log enrollments.classid%type;
  table_name_log nvarchar2(20) default 'enrollments';
  id_log Number;
BEGIN
  B#_log := :old.B#;
  classid_log := :old.classid;
  key_value_log := (B#_log||','||classid_log);
  id_log := logs_seq.nextval;
  select user into user_log from dual;
  Insert into logs
  values(id_log,user_log,sysdate,table_name_log,operation_log,key_value_log);
  Update classes
  set class_size = class_size-1
  where classid = classid_log;
END;
/
show errors; 

--Trigger: Student_Delete
create or replace trigger STUDENT_DELETE
AFTER DELETE ON Students
FOR EACH ROW
DECLARE
  user_log varchar2(20);
  operation_log varchar2(20) default 'delete';
  B#_log enrollments.B#%type;
  table_name_log nvarchar2(20) default 'students';
  id_log Number;
BEGIN
  B#_log := :old.B#;
  id_log := logs_seq.nextval;
  select user into user_log from dual;
  Insert into logs
  values(id_log,user_log,sysdate,table_name_log,operation_log,B#_log);
  DELETE FROM Enrollments WHERE B# = B#_log;
END;
/
show errors;
