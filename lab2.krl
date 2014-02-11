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
    rule second_rule {
        select when pageview ".*" setting()        
        pre {
              query = page:url("query");
	      empty = "";
	      str = "hello " + query;
        }
//        if query != empty then
		notify("hello", query) with position="bottom-left" and sticky = true;
    }
}
