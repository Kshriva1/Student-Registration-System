create or replace trigger drop_student
AFTER DELETE ON Enrollments
FOR EACH ROW
DECLARE
	oldSize Classes.Classid%type;
BEGIN
	SELECT CLASS_SIZE INTO oldSize
	FROM CLASSES WHERE Classid = :old.Classid;
	UPDATE Classes
	SET CLASS_SIZE = (oldSize - 1)
	WHERE Classid = :old.Classid;
END;
/
show errors;
