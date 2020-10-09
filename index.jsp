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

<FORM ACTION="/fabflix/servlet/LoginPage"
      METHOD="POST">
<CENTER>
  Email: <INPUT TYPE="TEXT" NAME="email"><BR></BR>

  Password: <INPUT TYPE="PASSWORD" NAME="password"><BR></BR>

    <INPUT TYPE="SUBMIT" VALUE="Login">
</CENTER>
</FORM>


</body>
</html>
