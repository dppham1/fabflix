<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<HEAD>
	<TITLE>Movie Info</TITLE>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</HEAD>


<body style="background-color:#FDF5E6">
<div class="row">
    <div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
        <H1 ALIGN="CENTER">Movie Details</H1>
    </div>
    <div class="col-md-4">
        <FORM ACTION="/fabflix/shoppingCart.jsp">  
            <button style="float:right" type="button" onclick="location.href='shoppingCart.jsp'">My Cart</button> 
        </FORM>
    </div>
</div>

<FORM ACTION="/fabflix/getSearch.jsp"
      METHOD="GET" style="padding-left: 10px">

<input type="text" name="search" placeholder="Search...">
<input type="hidden" name="page" value=1>
<input type="hidden" name="sortby">
<input type="hidden" name="numItems" value=6>


</FORM>

<H3 style="padding-left: 20px">Genres</H3>

<div class="row">

    <div class="col-md-2">
<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();
    // Genres
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
	//Info from movies table
	int movieID = Integer.parseInt(request.getParameter("movieid"));
    ResultSet movieQuery = select.executeQuery("Select * from movies where id=" + movieID);
    String trailer = "";
    //Print info from movies table
    while(movieQuery.next()){
    	String movieURL = movieQuery.getString("banner_url");
    	String title = movieQuery.getString("title");
    	String year = movieQuery.getString("year");
		String director = movieQuery.getString("director");
		String id = movieQuery.getString("id");
    	trailer = movieQuery.getString("trailer_url");

    	out.println("<div class=\"col-md-3\">");
    	out.println("<img src=\"" + movieURL + "\" style=\"width:300px;height:350px;padding-left:50px\">");
    	out.println("</div>");
    	out.println("<div class=\"col-md-7\" style=\"padding-top: 50px;\">");
    	out.println("<h5>Title: " + title + "<h5>");
    	out.println("<h5>Year: " + year +"</h5>");
    	out.println("<h5>Director: " + director + "</h5>");
    	out.println("<h5>ID: " + id + "</h5>");
    	
	}

	ResultSet starQuery = select.executeQuery("SELECT s.id, s.first_name, s.last_name from stars s, stars_in_movies sim, movies m where m.id =" + movieID + " AND sim.movie_id = m.id AND sim.star_id = s.id;");

	//Print stars
	out.print("<h5>Stars: ");
	while (starQuery.next()){
		int starID = starQuery.getInt("id");
		String name = starQuery.getString("first_name") + " " + starQuery.getString("last_name");

		out.print("<a href=\"getStars.jsp?starid=" + starID + "\">" + name + "</a>" + " ");
	
	}
	out.println("</h5>");

	//Info for genres and stars
	ResultSet infoQuery = select.executeQuery("SELECT id, name FROM genres g, genres_in_movies gim where gim.movie_id = " + movieID + " AND gim.genre_id = g.id;");


	//Print genres
	out.print("<h5>Genres: ");
	while(infoQuery.next()){
		String genre = infoQuery.getString("name");
		int genreID = infoQuery.getInt("id");
		out.print("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=6\">" + genre + "</a>" + " ");
	}
 
	out.println("</h5>");

	//Print trailer
	out.println("<h5>Trailer: <a href=\"" + trailer + "\"> "+ trailer + "</a></h5>");
    out.println("<font size = \"3\"><a href=\"shoppingCart.jsp?movieid=" + movieID+ "&value=1\"> Add to Cart </a></font>");

	out.println("</div>");
%>
</div>

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