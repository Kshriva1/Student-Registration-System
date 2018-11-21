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
