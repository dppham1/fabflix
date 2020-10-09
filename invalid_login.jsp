<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
<HEAD>
  <TITLE>Fabflix Login</TITLE>
</HEAD>

<BODY BGCOLOR="#FDF5E6">

<H1 ALIGN="CENTER">Fabflix Login</H1>

<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection =
    DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();
    ResultSet result = select.executeQuery("Select *  from stars ");
    
    
%>

<FORM ACTION="/fabflix/servlet/LoginPage"
      METHOD="POST">
<CENTER>
    Email: <INPUT TYPE="TEXT" NAME="email"><BR></BR>

    Password: <INPUT TYPE="PASSWORD" NAME="password"><BR></BR>

    <H5 ALIGN="CENTER" STYLE="color:red">Invalid Email or Password</H5>

    <INPUT TYPE="SUBMIT" VALUE="Login">
</CENTER>
</FORM>


</body>
</html>
