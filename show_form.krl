ruleset show_form {
    meta {
        name "lab 3"
        author "Jacob Wright"
        logging off
    }
    
    rule clear_rule {
        select when pageview ".*" setting()
        pre {
                query = page:url("query");
                x = query.extract(#clear=(\w*)#);
                clr = x[0] || "0";
                one = "1";
        }
        if(clr eq one) then
                notify("Count has been cleared", "");
        fired {
                clear ent:first_name;
                clear ent:last_name;
        }
    } 

   rule watch_rule {
        select when pageview ".*" setting ()
        pre {
            watch_link = <<
            <form id='watched' action="javascript:void(0)">
			First name: <input type="text" name="FirstName"><br>
			Last name: <input type="text" name="LastName"><br>
			<input type="submit" value="Submit">
			</form>
            >>;
        }
        {
            append('body', watch_link);
            watch("#watched", "submit");
        }
    }
    
	rule div_appender {
		select when pageview ".*" setting ()
		pre {
			
			html_div = << <div id="my_div"></div> >>;
		}
		every {
			append('body', html_div);
		}
	}
    
    rule clicked_rule {
        select when web submit "#watched"
    	pre {
    		first = event:attr("FirstName");
    		last = event:attr("LastName");
    	}
    	every {
        	replace_inner("#my_div", first + " " + last);
        }
    }
}