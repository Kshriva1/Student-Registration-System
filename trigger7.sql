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
  DELETE FROM TAs WHERE B# = B#_log;
  UPDATE Classes SET TA_B# = NULL WHERE TA_B# = B#_log;
END;
/
show errors;

