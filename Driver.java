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
				System.out.println("6.Delete a Student");
				System.out.println("7.Exit");
        int n = 0;
        Scanner sc = new Scanner(System.in);
        System.out.println("Please select an option from the above : ");
        n = sc.nextInt();

        switch(n)
        {


          case 1:
          {

            System.out.println();
				    System.out.println("***Select Table***");
				    System.out.println("1.Students\n"
						+ "2.Courses\n"
						+ "3.TAs\n"
						+ "4.Classes\n"
						+ "5.Enrollments\n"
						+ "6.Prerequisites\n"
            + "7.Logs\n");
            int m = 0;
            try
		        {
			         BufferedReader input_reader = new BufferedReader(new InputStreamReader(System.in));
			      do
			      {
				       System.out.println("Enter Choice");
				       m = Integer.parseInt(input_reader.readLine());
			      }while(m < 1 || m > 7);
		    }
		       catch (Exception e) {
			      System.out.println("getChoice Exception");
			      System.exit(1);
          }
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

          stmt.close();


		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}
	}

  public static void dropStudentClass(Connection conn) {
 		try
 		{
 			BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
 			System.out.println("Student B#: ");
 			String Bno = br.readLine();
 			System.out.println("Enter Class ID: ");
 			String classid = br.readLine();
 			CallableStatement stmt = conn.prepareCall("BEGIN student_registration.drop_student(?,?,?); END;");
 			stmt.setString(1,Bno);
 			stmt.setString(2,classid);
 			stmt.registerOutParameter(3, java.sql.Types.VARCHAR);
 			stmt.execute();

      String err_msg = ((OracleCallableStatement)stmt).getString(3);
		      if(err_msg == null){
		    	  System.out.println("\nStudent dropped from the course successfully.");
		      }
		      else{
		    	  System.out.println(err_msg);
}

  stmt.close();
 		}
 		catch (Exception e)
 		{
 			e.printStackTrace();
 			System.exit(1);
 		}
 	}

  public static void enrollStudentClass(Connection conn) {
		try
		{
			BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
			System.out.println("Student B#: ");
			String Bno = br.readLine();
			System.out.println("Enter Class ID: ");
			String classid = br.readLine();
			CallableStatement stmt = conn.prepareCall("BEGIN student_registration.enroll_student(?,?,?); END;");
			stmt.setString(1,Bno);
			stmt.setString(2,classid);
      stmt.registerOutParameter(3, java.sql.Types.VARCHAR);
		  stmt.execute();

		      String err_msg = ((OracleCallableStatement)stmt).getString(3);
		      if(err_msg == null){
		    	  System.out.println("\nStudent enrolled into course successfully.");
		      }
		      else{
		    	  System.out.println(err_msg);
}

 stmt.close();

		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}


	}

  public static void infoPrerequisites(Connection conn) {
		try
		{
			BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
			System.out.println("Enter Dept Code: ");
			String dept_code = br.readLine();
			System.out.println("Enter Course No: ");
			String course_no = br.readLine();
			CallableStatement stmt = conn.prepareCall("begin student_registration.get_prerequisites(?,?,?,?); end;");
			stmt.setString(1,dept_code);
			stmt.setInt(2, Integer.parseInt(course_no));
      stmt.registerOutParameter(3,java.sql.Types.VARCHAR);
			stmt.registerOutParameter(4,OracleTypes.CURSOR);
			stmt.execute();


      ResultSet rs = null;
  		      try{
  		        rs = ((OracleCallableStatement)stmt).getCursor(4);
  		      }
  		      catch(Exception ex){
  		        String err_msg = ((OracleCallableStatement)stmt).getString(3);
  		        System.out.println(err_msg);
  		      }

  		      if(rs != null){
  		    	  System.out.println("\n\nCOURSE");
  		        while (rs.next()) {
  		          System.out.println(rs.getString(1) + rs.getInt(2));        }
  		      }
  		      else
  		      {
  		        System.out.println("No rows returned.");
  		      }

  		      if(rs != null)
  		      rs.close();

  stmt.close();
}
		catch (Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}
	}

  public static void infoTA(Connection conn)
	{
		try
		{
			BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
			System.out.println("Enter classid: ");
			String classid = br.readLine();
			CallableStatement stmt = conn.prepareCall("begin student_registration.get_student_info(?,?,?); end;");
			stmt.setString(1,classid);
			stmt.registerOutParameter(2,java.sql.Types.VARCHAR);
			stmt.registerOutParameter(3,OracleTypes.CURSOR);
			stmt.execute();

      ResultSet rs = null;
		      try{
		        rs = ((OracleCallableStatement)stmt).getCursor(2);
		      }
		      catch(Exception ex){
		        String err_msg = ((OracleCallableStatement)stmt).getString(3);
		        System.out.println(err_msg);
		      }

		      if(rs != null){
		        while (rs.next()) {
		          System.out.println(rs.getString(1) + "\t\t" + rs.getString(2) + "\t\t" + rs.getString(3));
		        }
		      }
		      else
		      {
		        System.out.println("No rows returned.");
		      }

		      if(rs != null)
		      rs.close();
          stmt.close();

		}
		catch (Exception e)
		{
			System.err.println("Exception in get Student Info.");
			e.printStackTrace();
			System.exit(1);
		}
	}

  public static void showTableInfo(int choice, Connection conn)
	{
		switch(choice)
		{
			case 1:
			{
				try
				{
					CallableStatement stmt = conn.prepareCall("BEGIN student_registration.show_students(?); END;");
					stmt.registerOutParameter(1, OracleTypes.CURSOR);
				      stmt.execute();
				      ResultSet rs = ((OracleCallableStatement)stmt).getCursor(1);

				      while (rs.next())
				      {
				    	  System.out.format(rs.getString(1) + rs.getString(2) + rs.getString(3) + rs.getString(4) + rs.getDouble(5) + rs.getString(6) + rs.getString(7) + rs.getString(8));
				      }
				      rs.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
					System.exit(1);
				}
				break;
			}
			case 2:
			{
				try
				{
					CallableStatement stmt = conn.prepareCall("BEGIN student_registration.show_courses(?); END;");
					stmt.registerOutParameter(1, OracleTypes.CURSOR); //REF CURSOR
				      stmt.execute();
				      ResultSet rs = ((OracleCallableStatement)stmt).getCursor(1);
				      while (rs.next())
				      {
				    	  System.out.format("%-4s --> %-3d --> %-20s\n",rs.getString(1), rs.getInt(2),rs.getString(3));
				      }
				      rs.close();
				      stmt.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
					System.exit(1);
				}
				break;
			}

      case 3:
      {
        try
        {
          CallableStatement stmt = conn.prepareCall("BEGIN student_registration.show_TAs(?); END;");
          stmt.registerOutParameter(1, OracleTypes.CURSOR);
              stmt.execute();
              ResultSet rs = ((OracleCallableStatement)stmt).getCursor(1);

              while (rs.next())
              {
                System.out.format(rs.getString(1) + rs.getString(2) + rs.getString(3));
              }
              rs.close();
        }
        catch (SQLException e)
        {
          e.printStackTrace();
          System.exit(1);
        }
        break;
      }
			case 4:
			{
				try
				{
					CallableStatement stmt = conn.prepareCall("BEGIN student_registration.show_classes(?); END;");
					stmt.registerOutParameter(1, OracleTypes.CURSOR); //REF CURSOR
				      stmt.execute();
				      ResultSet rs = ((OracleCallableStatement)stmt).getCursor(1);
				      while (rs.next())
				      {
				    	  System.out.format(rs.getString(1) + rs.getString(2) + rs.getInt(3) + rs.getInt(4) + rs.getInt(5) + rs.getString(6) + rs.getInt(7) + rs.getInt(8) + rs.getString(9) + rs.getString(10));
				      }
				      rs.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
					System.exit(1);
				}
				break;
			}

      case 5:
      {
        try
        {
          CallableStatement stmt = conn.prepareCall("BEGIN student_registration.show_enrollments(?); END;");
          stmt.registerOutParameter(1, OracleTypes.CURSOR);
              stmt.execute();
              ResultSet rs = ((OracleCallableStatement)stmt).getCursor(1);
              while (rs.next())
              {
                System.out.format(rs.getString(1) + rs.getString(2) + rs.getString(3));
              }
              rs.close();
        }
        catch (SQLException e)
        {
          e.printStackTrace();
          System.exit(1);
        }
        break;
      }

			case 6:
			{
				try
				{
					CallableStatement stmt = conn.prepareCall("BEGIN student_registration.show_prerequisites(?); END;");
					stmt.registerOutParameter(1, OracleTypes.CURSOR); //REF CURSOR
				      stmt.execute();
				      ResultSet rs = ((OracleCallableStatement)stmt).getCursor(1);
				      while (rs.next())
				      {
				    	  System.out.format(rs.getString(1), rs.getInt(2), rs.getString(3),rs.getInt(4));
				      }
				      rs.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
					System.exit(1);
				}
				break;
			}

			case 7:
			{
				try
				{
					CallableStatement stmt = conn.prepareCall("BEGIN databaseproject.show_logs(?); END;");
					stmt.registerOutParameter(1, OracleTypes.CURSOR); //REF CURSOR
				      stmt.execute();
				      ResultSet rs = ((OracleCallableStatement)stmt).getCursor(1);
				      while (rs.next())
				      {
				    	  System.out.format(rs.getInt(1) + rs.getString(2) + rs.getString(3) + rs.getString(4) + rs.getString(5) + rs.getString(6));
				      }
				      rs.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
					System.exit(1);
				}
				break;
			}
		}
	}

}
