ruleset lab2 {
    meta {
        name "notify example"
        author "Jacob Wright"
        logging off
    }
    dispatch {
        // domain
    }
    rule first_rule {
        select when pageview ".*" setting ()
	every {
       	 // Display notification that will not fade.
       	  notify("First Notification", "CS 462") with position="top-left" and sticky = true;
       	  notify("Second Notification", "CS 462") with position="top-right" and sticky = true;
        }
    }
}
