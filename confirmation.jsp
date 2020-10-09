<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>


<HEAD>
	<TITLE>Genres</TITLE>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</HEAD>

<body style="background-color:#FDF5E6">
<div class="row">
    <div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
        <H1 ALIGN="CENTER">Search Result</H1>
    </div>
</div>

<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();

    String cardNum = request.getParameter("creditcard");
    String firstName = request.getParameter("firstname");
    String lastName = request.getParameter("lastname");
    String expDate = request.getParameter("year") + "-" + request.getParameter("month") + "-" + request.getParameter("day");
    String customerID = "";
    ResultSet creditCardNumbers = select.executeQuery("SELECT * FROM creditcards c WHERE c.id ='" + cardNum + "' AND c.first_name='" + firstName + "' AND c.last_name='" + lastName + "' AND c.expiration='" + expDate + "'");

    if(creditCardNumbers.next()) {
    	out.println("<h3> Successfully Checked Out</h3>");
    	HashMap<Integer, HashMap<String, String>> cartCounter = (HashMap) request.getSession().getAttribute("cartCounter");

    	ResultSet customerQuery = select.executeQuery("SELECT c.id FROM customers c WHERE c.cc_id=" + cardNum);

    	if (customerQuery.next()) {
    		customerID = customerQuery.getString("id");
    	}

    	for (Integer id : cartCounter.keySet()) {
    		for (int i = 0; i < Integer.parseInt(cartCounter.get(id).get("count")); ++i) {
				PreparedStatement insertQuery = connection.prepareStatement("INSERT into sales (customer_id, movie_id, sale_date) VALUES(" + customerID + ", " + id + ", curDate())");

    			insertQuery.execute();
    		}
    	}

    	session.invalidate();
    	response.sendRedirect(request.getContextPath() + "/success_checkout.jsp");
	}
	else {
		response.sendRedirect("/fabflix/invalid_checkout.jsp");
	}
%>



</BODY>