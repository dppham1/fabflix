import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;


public class SearchQuery extends HttpServlet {

  public void doGet(HttpServletRequest request, HttpServletResponse response)
                               throws ServletException, IOException {

    response.setContentType("text/html");

	PrintWriter out = response.getWriter(); 
	                          	
    try{
    	
	    Class.forName("com.mysql.jdbc.Driver").newInstance();
	    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
	    Statement select = connection.createStatement();

	    String userSearch = request.getParameter("search");
	    out.println(userSearch);  
	    String[] keyWords = userSearch.split(" ");
	    out.println("hi2");  
	    String query = "";
	    out.println(userSearch);
	    if (keyWords.length >= 2){
		    for (int i=0; i < keyWords.length-1; i++){
		    	query = query + "+*" + keyWords[i] + "* ";
		    }
	    }
	    query = query + keyWords[keyWords.length-1] + "*";
	    out.println("<h1>QUERY: " + query + "</h1>");
	    // ResultSet ajaxQuery = select.executeQuery("Select m.title from movies m WHERE MATCH (`title`) AGAINST ('" + query + "' IN BOOLEAN MODE);");
	    ResultSet ajaxQuery = select.executeQuery("Select m.title from movies m");
	    while(ajaxQuery.next()){
	        String movieTitle = ajaxQuery.getString("title");
	        out.println("<li><a href=\"getSearch.jsp?search=" + movieTitle + "&page=1&sortby=&numItems=6\">" + movieTitle + "</a></li>");
	    }	
    }
     catch (SQLException ex) {
              while (ex != null) {
                    System.out.println ("SQL Exception:  " + ex.getMessage ());
                    ex = ex.getNextException ();
                }  // end while
            }  // end catch SQLException
     catch(Exception e){
     	out.println(e.getMessage());

     }
        // catch(java.lang.Exception ex)
        //     {
        //         out.println(ex.getMessage());
        //     }
         out.close();                         
    
  }
}
