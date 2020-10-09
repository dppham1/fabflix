<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<HEAD>
	<TITLE>Stars Info</TITLE>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</HEAD>

<body style="background-color:#FDF5E6">
<div class="row">
    <div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
        <H1 ALIGN="CENTER">Stars Detail</H1>
    </div>
    <div class="col-md-4">
        <FORM ACTION="/fabflix/shoppingCart.jsp">  
            <button style="float:right" type="button" onclick="location.href='shoppingCart.jsp'">My Cart</button> 
        </FORM>
    </div>
</div>

<!-- search bar -->
<FORM ACTION="/fabflix/getSearch.jsp"
      METHOD="GET" style="padding-left: 10px">

<input type="text" name="search" placeholder="Search...">
<input type="hidden" name="page" value=1>
<input type="hidden" name="sortby">
<input type="hidden" name="numItems" value=6>


</FORM>

<!-- list of genres -->
<H3 style="padding-left: 20px">Genres</H3>

<div class="row">

    <div class="col-md-2">
<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();
    
    ResultSet genreQuery = select.executeQuery("Select name, id from genres order by name asc");

    out.println("<ul>");

    while(genreQuery.next()){
        String genreName = genreQuery.getString("name");
        int genreID = genreQuery.getInt("id");
        out.println("<li><a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=6\">" + genreName + "</a></li>");
    }
    out.println("</ul>");
    
%>
	</div>
<%
    int starID = Integer.parseInt(request.getParameter("starid"));
    ResultSet starQuery = select.executeQuery("Select * from stars s, movies m, stars_in_movies sim WHERE s.id =" +  starID + " AND s.id = sim.star_id AND sim.movie_id = m.id");

    String photoURL = "";
    String starName = "";
    String dob = "";
    
    //Get star details
    while(starQuery.next()){
        photoURL = starQuery.getString("photo_url");
        starName = starQuery.getString("first_name") + " " + starQuery.getString("last_name");
        dob = starQuery.getString("dob");
        String movie = starQuery.getString("title");
    }

    //Get movie id and title
    ResultSet movieQuery = select.executeQuery("Select * from stars_in_movies sim, movies m where sim.star_id=" + starID + " AND sim.movie_id=m.id");

    //Print out star photo
    out.println("<div class=\"col-md-3\">");
    out.println("<img src=\"" + photoURL + "\" style=\"width:300px;height:350px;padding-left:50px\">");
    out.println("</div>");

    //Print out star name
    out.println("<div class=\"col-md-7\" style=\"padding-top: 50px;\">");
    out.print("<h5> Name: " + starName + "</h5>");

    //Print out date of birth
    out.println("<h5> Date of Birth: " + dob + "</h5>");
    
    //Print out star id
    out.println("<h5> Star ID: " + starID + "</h5>");

    //Print out movie star starred in
    out.print("<h5>Movies starred in: ");
    while (movieQuery.next()){
    String movieTitle = movieQuery.getString("title");
    int movieID = movieQuery.getInt("id");
        out.print("<a href=\"getMovies.jsp?movieid=" + movieID + "\">" + movieTitle + "</a> ");
    }
    out.println("</h5>");


    out.println("</div>");

%>
</div>

<!-- Browse by characters -->
<div class="row">
    <div class="col-md-2">
    </div>
    <div class="col-md-9" style="padding-bottom:50px">
        <center>
            <h4 style="margin-top:-50px">Browse by Title</h4>
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