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
    
    rule clear_rule {
        select when web cloudAppSelected
        pre {
                query = page:url("query");
                x = query.extract(#clear=(\w*)#);
                clr = x[0] || "0";
                one = "1";
        }
        if(clr eq one) then
                notify("first and last name cleared", "");
        fired {
                clear ent:first_name;
                clear ent:last_name;
        }
    } 

   rule watch_rule {
        select when web cloudAppSelected
        pre {
            watch_link = <<
            <div id=rotten>
            <form id='watched' action="javascript:void(0)">
			Movie Title: <input type="text" name="FirstName"><br>
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
			f = ent:first_name || "";
			l = ent:last_name || "";
			html_div = << <div id="my_div">#{f} #{l} <br /></div> >>;
		}
		every {
			prepend('#rotten', html_div);
		}
	}
    
    rule clicked_rule {
        select when web submit "#watched"
    	pre {
    		first = event:attr("FirstName");
    		last = event:attr("LastName");
    	}
    	{
    		replace_inner("#my_div", first + " " + last);
    	}
    	fired {
    		set ent:first_name first;
    		set ent:last_name last;
    	}
    }
}