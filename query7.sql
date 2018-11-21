set serveroutput on;
create or replace procedure del_student(
        delB# IN Students.B#%type,error_message out varchar2) IS

        --local
        count_B# Students.B#%type;

BEGIN
        SELECT COUNT(*) into count_B# FROM Students Where B# = delB#;


        IF (count_B# = 0) THEN
                error_message := 'The B# is invalid';
        ELSE
                DELETE Students WHERE B# = delB#;
        END IF;
END;
/
show errors;

