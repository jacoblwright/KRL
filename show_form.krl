ruleset show_form {
    meta {
        name "lab 3"
        author "Jacob Wright"
        logging off
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
			html_div = << <div id="my_div">hello</div> >>;
		}
		every {
			append('body', html_div);
		}
	}
    
    rule clicked_rule {
        select when web submit "#watched"
    	pre {
    		username = event:attr("FirstName") + " " + event:attr("LastName");
    	}
        replace_inner("#my_div", username);
        notify(username + ' clicked', 'submit');
    }
}