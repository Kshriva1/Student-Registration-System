create or replace procedure drop_student(
	dropB# in Students.B#%type,
	dropClassid in Classes.Classid%type,error_message out varchar2) IS

	--Local declarations
	count_B# Students.B#%type;
	count_Classid Classes.Classid%type;
	count_Enrollment Enrollments.B#%type;
	tempSemester Classes.Semester%type;
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
/
show errors;
