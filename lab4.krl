ruleset rotten_tomatoes {
    meta {
        name "lab 3"
        author "Jacob Wright"
        logging off
        use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
    }
    
    global {
    	datasource movie_url <- "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=8j3zn2knpjn27xsrm6g6g3mz";
    	}

   rule watch_rule {
        select when web cloudAppSelected
        pre {
            watch_link = <<
            <div id=rotten>
            <form id='watched' action="javascript:void(0)">
			Movie Title: <input type="text" name="title"><br>
			<input type="submit" value="Submit">
			</form>
			</div>
            >>;
        }
        {
         	SquareTag:inject_styling();
  		 	CloudRain:createLoadPanel("Rotten Tomato", {}, watch_link);
            //append('body', watch_link);
            watch("#watched", "submit");
        }
    }
    
	rule div_appender {
		select when web cloudAppSelected
		pre {
			t = ent:title || "";
			html_div = << <div id="my_div">#{t}</div> >>;
		}
		every {
			prepend('#rotten', html_div);
		}
	}
    
    rule clicked_rule {
        select when web submit "#watched"
    	pre {
    		new_title = event:attr("title");
    		
    		movie_data = datasource:movie_url("&q=" + new_title);
    		total = movie_data.pick("$.total").decode()|| 0;
    		thumbnail = movie_data.pick("$.movies[0].posters.thumbnail");
    		title = movie_data.pick("$.movies[0].title") || "n/a";
    		year = movie_data.pick("$.movies[0].year") || "n/a";
    		synopsis = movie_data.pick("$.movies[0].synopsis") || "n/a";
    		critic_rating = movie_data.pick("$.movies[0].ratings.critics_score");
    		audience_rating = movie_data.pick("$.movies[0].ratings.audience_score");
    		consensus = movie_data.pick("$.movies[0].critics_consensus");
    		my_html = <<
    			<img src="#{thumbnail}" alt="movie pic">
    			<p> <b>Title:</b> #{title} </p>
    			<p> <b>Year:</b> #{year} </p>
    			<p> <b>Synopsis:</b> #{synopsis} </p>
    			<p> <b>Critic Rating:</b> #{critic_rating} </p>
    			<p> <b>Audience Rating:</b> #{audience_rating} </p>
    			<p> <b>Critic Consensus: </b> #{consensus} </p>
    			<hr>
    		>>;
    	}
    	if total > 0 then
    		replace_inner("#my_div", my_html);
    	fired {
    		set ent:title new_title;
    	} else {
			raise explicit event 'title_not_found' with title = new_title; 
    	}
    }
    
    rule title_not_found {
    	select when explicit title_not_found
    	pre {
    		title = event:param("title");
    		my_html = <<
    			<p> <b>Error in finding #{title}</b> </p>
    		>>;
    	}
    	{
    		replace_inner("#my_div", my_html);	
    	}
    }
}