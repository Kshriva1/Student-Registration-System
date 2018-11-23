import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.*;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.pool.OracleDataSource;

public class Driver {
  public static void main(String args[]) throws SQLException {
    try {

      OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
      ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
      Connection conn = ds.getConnection("kshriva1","Ilovefcrit1");
      System.out.println("Connection Establish");

      while(true)
      {

                                System.out.println();
                                System.out.println("*****Main Menu*****");

                                System.out.println("1.View Table data");
                                System.out.println("2.View TA Information");
                                System.out.println("3.View Prerequisites Information");
                                System.out.println("4.Enroll a Student in Class");
                                System.out.println("5.Drop a Student from Class");
                                System.out.println("6.Delete a Student:");
                                System.out.println("7.Exit");
        int n = 0;
        Scanner sc = new Scanner(System.in);
        System.out.println("Please select an option from the above : ");
        n = sc.nextInt();

        switch(n)
        {

    /*
          case 1:
          {
                  showTableInfo(m,conn);
                  break;
          }

          case 2:
          {
                  infoTA(conn);
                  break;
          }

          case 3:
          {
                  infoPrerequisites(conn);
                  break;
          }

          case 4:
          {
                  enrollStudentClass(conn);
                  break;
          }

          case 5:
          {
                  dropStudentClass(conn);
                  break;
          }

    */

          case 6:
          {
                  deleteStudent(conn);
                  break;
          }

          case 7:
          {
                  System.exit(1);;
                  break;

           }

        }


      }

    }

    catch (Exception e) {
        System.out.println("Connection not Established. Try Again");
        System.exit(1);
    }


  }

  public static void deleteStudent(Connection conn) {
                try
                {
                        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
                        System.out.println("Student Bno: ");
                        String Bno = br.readLine();
                        CallableStatement stmt = conn.prepareCall("BEGIN student_registration.del_student(?,?); END;");
                        stmt.setString(1,Bno);
                        stmt.registerOutParameter(2, java.sql.Types.VARCHAR);
                        stmt.execute();
                        String err_msg = ((OracleCallableStatement)stmt).getString(2);
                      if(err_msg == null){

			        System.out.println("\nStudent deleted successfully.");
                      }
                      else{
                   System.out.println(err_msg);

                      }


                }
                catch (Exception e)
                {
                        e.printStackTrace();
                        System.exit(1);
                }
        }
}

			      
			      
			      
			      
			      
			      
			      
