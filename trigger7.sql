create or replace trigger del_student
AFTER DELETE ON Students
FOR EACH ROW
DECLARE
BEGIN
	DELETE FROM Enrollments WHERE B# = :old.B#;
	--DELETE FROM TAs WHERE B# = :old.B#;
	--UPDATE Classes SET TA_B# = NULL WHERE TA_B# = :old.B#;
END;
/
show errors;
