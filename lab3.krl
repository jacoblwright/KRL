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
            <form action="demo_form.asp">
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