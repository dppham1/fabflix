<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<HEAD>
  <TITLE>Shopping Cart</TITLE>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="../css/mainpage.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</HEAD>

<BODY style="background-color:#FDF5E6">

<body style="background-color:#FDF5E6">
<div class="row">
    <div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
        <H1 ALIGN="CENTER">My Cart</H1>
    </div>
    <div class="col-md-4">
        <FORM ACTION="/fabflix/shoppingCart.jsp">  
            <button style="float:right" type="button" onclick="location.href='shoppingCart.jsp'">My Cart</button> 
        </FORM>
    </div>
</div>

<div class="row">
    <div class="col-md-2">
        <FORM ACTION="/fabflix/getSearch.jsp"
          METHOD="GET" style="padding-left: 10px">
            <input type="text" name="search" placeholder="Search...">
            <input type="hidden" name="page" value=1>
            <input type="hidden" name="sortby">
            <input type="hidden" name="numItems" value=6>

        </FORM>
        <div class="dropdown" style="padding-left: 10px">
            <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">Genres
            <span class="caret"></span></button>
            <ul class="dropdown-menu">
<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();

    // Genres

    ResultSet genreQuery = select.executeQuery("Select name, id from genres order by name asc");

    while(genreQuery.next()){
        String genreName = genreQuery.getString("name");
        int genreID = genreQuery.getInt("id");
        out.println("<li><a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=6\">" + genreName + "</a></li>");
    }

    out.println("</ul>");

%>
        </div>
	</div>

<%
    HashMap<Integer, HashMap<String, String>> cartCounter = (HashMap) request.getSession().getAttribute("cartCounter");
  //  ArrayList previousItems = (ArrayList)request.getSession().getAttribute("previousItems");
    if (cartCounter == null) {
      cartCounter = new HashMap<Integer, HashMap<String, String>>();
      request.getSession().setAttribute("cartCounter", cartCounter);
    }
   

    String newItem = request.getParameter("movieid");
    String count = request.getParameter("value");

    response.setContentType("text/html");

    synchronized(cartCounter) {

        if (newItem != null) {
            
            if (count.equals("0")) {
                cartCounter.remove(Integer.parseInt(newItem));
            }
            else {
                ResultSet movieNames = select.executeQuery("SELECT m.title, m.year, m.id FROM movies m WHERE m.id=" + newItem);

                while (movieNames.next()) {
                    int movieID = movieNames.getInt("id");
                    String movieTitle = movieNames.getString("title");
                    int movieYear = movieNames.getInt("year");
                    HashMap<String, String> innerMovie = new HashMap<String, String>();

                    if (cartCounter.containsKey(movieID)) {
                        innerMovie.put("count", count);
                        innerMovie.put("title", movieTitle);

                        cartCounter.put(movieID, innerMovie);

                    }
                    else {
                        innerMovie.put("count", "1");
                        innerMovie.put("title", movieTitle);
                        cartCounter.put(movieID, innerMovie);
                    }
                }
            }
            
      }

//        if (cartCounter.size() == 0) {
  //          out.println("<I>No items</I>");
    //    } 

    
        out.println("<div class=\"col-md-9\">");

        out.println("<div class=\"row\">");

            out.println("<div class=\"col-md-3\">");

                out.println("<H4>Title </H4>");

            out.println("</div>");

            out.println("<div class=\"col-md-3\">");

                out.println("<H4>Quantity </H4>");

            out.println("</div>");

            out.println("<div class=\"col-md-3\">");

                out.println("<H4>Price</H4>");

            out.println("</div>");

        out.println("</div>");

        out.println("<form method=\"GET\" action=\"\">");

            for (Integer id : cartCounter.keySet()){
                out.println("<div class=\"row\">");
                    out.println("<div class=\"col-md-3\">");

                        out.println("<form method=\"GET\" action=\"/fabflix/shoppingCart.jsp\">");

                        out.println("<label for=\"name\">" + cartCounter.get(id).get("title") + "</label>");

                    out.println("</div>");

                    out.println("<div class=\"col-md-3\">");

                        out.println("<input type=\"hidden\" name=\"movieid\" value=" + id + ">");

                        out.println("<input style=\"width: 30px\" type=\"text\" name=\"value\" value=" + cartCounter.get(id).get("count") + "><a href=\"shoppingCart.jsp?movieid=" + id + "&value=0\"> delete </a>");

                    out.println("</form>");

                    out.println("</div>");

                    out.println("<div class=\"col-md-3\">");

                        out.println("<H5> $15.99 </H5>");

                    out.println("</div>");


                out.println("</div>");


            }
            out.println("<hr width=\"60%\" />");

            out.println("<div class=\"row\">");

                out.println("<div class=\"col-md-3\">");

                    out.println("<H5> Total: </H5>");

                out.println("</div>");

                out.println("<div class=\"col-md-3\">");

                out.println("</div>");

                out.println("<div class=\"col-md-3\">");
                    double itemNum = 0;
                    for (Integer id : cartCounter.keySet()){
                        itemNum += Integer.parseInt(cartCounter.get(id).get("count"));
                    }
                    double total = itemNum * 15.99;
                    out.println("<h5>$" +  total + "</h5>");

                out.println("</div>");
            out.println("</div>");

            out.println("<input type=\"submit\" value=\"Checkout\" onclick=location.href='/fabflix/checkout.jsp'>");

        out.println("</form>");

    }
%>

    </div>
</div>
</div>




<!-- Browse by characters -->
<div class="row">
    <div class="col-md-2">
    </div>
    <div class="col-md-9" style="padding-bottom:50px">
        <center>
            <h4>Browse by Title</h4>
            <%
            String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

             for(int letter = 0; letter < alphabet.length(); ++letter){
                out.println("<u><b><a href=\"getTitles.jsp?char=" + alphabet.charAt(letter) + "&page=1&sortby=&numItems=6\">" + alphabet.charAt(letter) + "</a></b></u>");
            }

            for(int i= 0; i < 10; ++i){
                out.println("<u><b><a href=\"getTitles.jsp?char=" + i + "&page=1&sortby=&numItems=6\">" + i + "</a></b></u>");
            }
            %>
        </center>
    </div>
</div>

</BODY>