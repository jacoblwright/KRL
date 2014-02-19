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
            watch("#watched", "click");
        }
    }
    
    rule clicked_rule {
        select when web click "#watched"
        notify("You clicked", 'submit');
    }
}