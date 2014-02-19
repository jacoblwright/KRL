ruleset show_form {
    meta {
        name "lab 3"
        author "Jacob Wright"
        logging off
        //updated version
    }

   rule watch_rule {
        select when pageview ".*" setting ()
        pre {
            watch_link = <<
            <form action="javascript:void(0)">
			First name: <input type="text" name="FirstName" value="Mickey"><br>
			Last name: <input type="text" name="LastName" value="Mouse"><br>
			<input type="submit" value="Submit">
			</form>
            >>;
        }
        {
            append('body', watch_link);
            watch("#watched", "click");
        }
    }
}