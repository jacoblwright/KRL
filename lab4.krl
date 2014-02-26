ruleset rotten_tomatoes {
    meta {
        name "lab 3"
        author "Jacob Wright"
        logging off
        use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
    }
    
    global {
    	//datasource movie_url <- "http://    " // add info here
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
    	}
    	{
    		replace_inner("#my_div", new_title);
    	}
    	fired {
    		set ent:title new_title;
    	}
    }
}