
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginPage extends HttpServlet
{
    private String firstName;
	
	public String getServletInfo()
    {
       return "Servlet connects to MySQL database and displays result of a SELECT";
    }

    // Use http GET
    public String getFirstName(){
    	return firstName;
    }
    
    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        String loginUser = "mytestuser";
        String loginPasswd = "mypassword";
        String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

        response.setContentType("text/html");    // Response mime type

        // Output stream to STDOUT
        PrintWriter out = response.getWriter();

//        out.println("<HTML><HEAD><TITLE>MovieDB: Found Records</TITLE></HEAD>");
//        out.println("<BODY><H1>MovieDB: Found Records</H1>");


        try
           {
              //Class.forName("org.gjt.mm.mysql.Driver");
              Class.forName("com.mysql.jdbc.Driver").newInstance();

              Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
              // Declare our statement
              Statement statement = dbcon.createStatement();

	      String email = request.getParameter("email");
	      String password = request.getParameter("password");
          String query = "SELECT * from customers C where C.email = '" + email + "' AND C.password = '" + password + "'";

              // Perform the query
              ResultSet rs = statement.executeQuery(query);

             if(!rs.next()){
            	 response.sendRedirect("/fabflix/invalid_login.jsp");
             }
             else{
//                 firstName = rs.getString("first_name");
                 response.sendRedirect("/fabflix/MainPage.jsp");
	             rs.close();
	             statement.close();
	             dbcon.close();
             }
            
            }
        catch (SQLException ex) {
              while (ex != null) {
                    System.out.println ("SQL Exception:  " + ex.getMessage ());
                    ex = ex.getNextException ();
                }  // end while
            }  // end catch SQLException

        catch(java.lang.Exception ex)
            {
                out.println("<HTML>" +
                            "<HEAD><TITLE>" +
                            "MovieDB: Error" +
                            "</TITLE></HEAD>\n<BODY>" +
                            "<P>SQL error in doGet: " +
                            ex.getMessage() + "</P></BODY></HTML>");
                return;
            }
         out.close();
    }
    
    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
    	doGet(request, response);
	} 
}
