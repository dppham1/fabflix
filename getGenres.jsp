<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<HEAD>
	<TITLE>Genres</TITLE>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="../css/mainpage.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</HEAD>


<BODY style="background-color:#FDF5E6">
<div class="row">
    <div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
<%
    int genreID = Integer.parseInt(request.getParameter("genreid"));
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();
    ResultSet titleQuery = select.executeQuery("Select name from genres g where g.id=" + genreID);
    if(titleQuery.next()){
        String genreTitle = titleQuery.getString("name");
        out.println("<center><h1>" + genreTitle + "</h1></center>");
}

%>
    </div>
    <div class="col-md-4">
        <FORM ACTION="/fabflix/shoppingCart.jsp">  
            <button style="float:right" type="button" onclick="location.href='shoppingCart.jsp'">My Cart</button> 
        </FORM>
    </div>
</div>

<!-- search bar -->
<div class="row">
    <div class="col-md-2">
        <FORM ACTION="/fabflix/getSearch.jsp"
              METHOD="GET" style="padding-left: 10px">
            <input type="text" name="search" placeholder="Search...">
            <input type="hidden" name="page" value=1>
            <input type="hidden" name="sortby">
            <input type="hidden" name="numItems" value=6>

        </FORM>
    </div>

    <div class="col-md-1">
        <h6> Sort By: </h6> 
    </div>
<%
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=titleasc&numItems=6\"> <h6>Title <span class=\"glyphicon glyphicon-arrow-up\"></span></h6></a>");
   out.println("</div>");
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=titledesc&numItems=6\"<h6>Title <span class=\"glyphicon glyphicon-arrow-down\"></span></h6>");
    out.println("</div>");
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=yearasc&numItems=6\"<h6>Year<span class=\"glyphicon glyphicon-arrow-up\"></span></h6>");
    out.println("</div>");
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=yeardesc&numItems=6\"<h6>Year<span class=\"glyphicon glyphicon-arrow-down\"></span></h6>");
    out.println("</div>");
%>
    <div class="col-md-2">
       <H6> Results Per Page: </H6>
    </div>
    <div class="col-md-1">
<%
        out.print("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=10\"> 10  </a>");
        out.print("</div>");
        out.print("<div class=\"col-md-1\">");
        out.print("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=20\"> 20  </a>");
        out.print("</div>");
        out.print("<div class=\"col-md-1\">");
        out.print("<a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=50\"> 50  </a>");
        out.print("</div>");


%>
</div>


<!-- list of genres -->
<H3 style="padding-left: 20px">Genres</H3>

<div class="row">

    <div class="col-md-2">
<%
    ResultSet genreQuery = select.executeQuery("Select name, id from genres order by name asc");

    out.println("<ul>");

    while(genreQuery.next()){
        String genreName = genreQuery.getString("name");
        int id = genreQuery.getInt("id");
        out.println("<li><a href=\"getGenres.jsp?genreid=" + id + "&page=1&sortby=&numItems=6\">" + genreName + "</a></li>");
    }
    out.println("</ul>");
    
%>
	</div>

<%
    int numItems = Integer.parseInt(request.getParameter("numItems"));
    ResultSet movieQuery;
    String sortby = request.getParameter("sortby");
    int pageid = Integer.parseInt(request.getParameter("page"));
    int total = numItems;

    if (pageid !=1){
        pageid = pageid-1;
        pageid = pageid*total+1;
    }
    int totalCount = 0;
    ResultSet countQuery = select.executeQuery("Select count(*) from genres g, genres_in_movies gim, movies m where g.id =" + genreID + " AND gim.genre_id = g.id AND gim.movie_id = m.id;");
    if (countQuery.next()){
        totalCount = countQuery.getInt(1);
    }

    if(sortby.equals("titleasc")) {
        movieQuery = select.executeQuery("SELECT m.id, m.banner_url, m.title, m.year, m.director FROM genres g, genres_in_movies gim, movies m where g.id =" + genreID + " AND gim.genre_id = g.id AND gim.movie_id = m.id order by m.title asc limit " + (pageid-1) + ", " + total);
    }
    else if(sortby.equals("titledesc")) {
        movieQuery = select.executeQuery("SELECT m.id, m.banner_url, m.title, m.year, m.director FROM genres g, genres_in_movies gim, movies m where g.id =" + genreID + " AND gim.genre_id = g.id AND gim.movie_id = m.id order by m.title desc limit " + (pageid-1) + ", " + total);
    }
    else if (sortby.equals("yearasc")) {
         movieQuery = select.executeQuery("SELECT m.id, m.banner_url, m.title, m.year, m.director FROM genres g, genres_in_movies gim, movies m where g.id =" + genreID + " AND gim.genre_id = g.id AND gim.movie_id = m.id order by m.year asc limit " + (pageid-1) + ", " + total);
    }
    else if (sortby.equals("yeardesc")) {
         movieQuery = select.executeQuery("SELECT m.id, m.banner_url, m.title, m.year, m.director FROM genres g, genres_in_movies gim, movies m where g.id =" + genreID + " AND gim.genre_id = g.id AND gim.movie_id = m.id order by m.year desc limit " + (pageid-1) + ", " + total);
    }
    else {
         movieQuery = select.executeQuery("SELECT m.id, m.banner_url, m.title, m.year, m.director FROM genres g, genres_in_movies gim, movies m where g.id =" + genreID + " AND gim.genre_id = g.id AND gim.movie_id = m.id limit " + (pageid-1) + ", " + total);
    }

    Boolean emptyTable = true;
    
    //Print out list of movie based on genre
    while(movieQuery.next()){
        out.println("<div class=\"col-md-3\" style=\"padding-bottom:30px\">");
        
        out.println("<center>");
        String movieURL = movieQuery.getString("banner_url");
        String movieTitle = movieQuery.getString("title");
        int movieYear= movieQuery.getInt("year");
        String movieDirector = movieQuery.getString("director");
        String movieID = movieQuery.getString("id");
        out.println("<a href=\"getMovies.jsp?movieid=" + movieID + "\"><img src=\"" + movieURL + "\" style=\"width:250px;height:250px;padding:15px\"></a><br>");

        
        out.println("<font size = \"1\">" + movieTitle + "</font>");
        out.println("<font size = \"1\">" + "(" + movieYear + ")" + "</font>" );
        out.println("<br>");
        out.println("<font size = \"1\">" + "Directed by: " + movieDirector + "</font>");
        out.println("<font size = \"1\"><a href=\"shoppingCart.jsp?movieid=" + movieID+ "&value=1\"> Add to Cart </a></font>");

        out.println("</center>");
        out.println("</div>");
        emptyTable = false;
    }

    if (emptyTable){
        out.println("<div class=\"col-md-8\">");
        out.println("<center>");
        out.println("<h5>No Results Found</h5>");
        out.println("</center>");
        out.println("</div>");
    }
%>
</div>


<div class="row">
    <div style="padding-bottom:50px">
        <center>
        <%
            if(!emptyTable){
                if (totalCount/total == 0) {
                    out.print("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + 1 + "&sortby="+sortby+"&numItems=6\">" + 1 + "</a></b></u> ");
                }
                else {
                    if(Integer.parseInt(request.getParameter("page")) == 1){
                        int nextPage = Integer.parseInt(request.getParameter("page")) + 1;
                        for (int i=0; i < Math.ceil((double)totalCount/total); i++){
                            int pageCounter = i+1;
                            
                           
                            out.print("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + pageCounter + "&sortby="+sortby+"&numItems="+total+"\">" + pageCounter + "</a></b></u> ");
                           
                        }
                        out.println("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + nextPage + "&sortby="+sortby+"&numItems="+total+"\"> Next </a></b></u>");

                    }
                    else if(Integer.parseInt(request.getParameter("page")) == Math.ceil((double)totalCount/total)) {
                        int prevPage = Integer.parseInt(request.getParameter("page")) - 1; 
                        out.println("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + prevPage + "&sortby="+sortby+"&numItems="+total+"\"> Prev </a></b></u>");
                        for (int i=0; i < Math.ceil((double)totalCount/total); i++){
                            int pageCounter = i+1;
                            
                            out.print("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + pageCounter + "&sortby="+sortby+"&numItems="+total+"\">" + pageCounter + "</a></b></u> ");
                        }
                    }
                    else{
                        int prevPage = Integer.parseInt(request.getParameter("page")) - 1; 
                        int nextPage = Integer.parseInt(request.getParameter("page")) + 1;
                        out.println("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + prevPage + "&sortby="+sortby+"&numItems="+total+"\"> Prev </a></b></u>");

                       for (int i=0; i < Math.ceil((double)totalCount/total); i++){
                            int pageCounter = i+1; 

                            out.print("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + pageCounter + "&sortby="+sortby+"&numItems="+total+"\">" + pageCounter + "</a></b></u> ");
                        }
                        out.println("<u><b><a href=\"getGenres.jsp?genreid=" + genreID + "&page=" + nextPage + "&sortby="+sortby+"&numItems="+total+"\"> Next </a></b></u>");

                    }
                }
            }   
        %>
        </center>
    </div>
</div>

<!-- Browse by characters -->
<div class="row" style="padding-top: 20px">
    <div style="padding-bottom:50px">
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