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
       	  notify("First Notification", "CS 462") with position="bottom-right" and sticky = true;
       	  notify("Second Notification", "CS 462") with position="bottom-right" and sticky = true;
        }
    }
    rule second_rule {
        select when pageview ".*" setting()        
        pre {
              query = page:url("query");
	      x = query.extract(#name=(\w*)#);
	      name = x[0] || "Monkey";
        }
	notify("Hello " + name, "") with position="bottom-right" and sticky = true;
    }
    rule third_rule {
        select when pageview ".*" setting()
	pre {
	    count = ent:pageCount + 1;
	}
	if(ent:pageCount < 5) then
		notify("Count: " + count, "") with position="bottom-right" and sticky = true;
   	fired {
		ent:pageCount += 1 from 1;
	}
    }
    rule fourth_rule {
	select when pageview ".*" setting()
	pre {
		query = page:url("query");
		x = query.extract(#clear=(/d)#) || 0;
	}
	if(x == 1) then
		notify("Count has been cleared", "");
	fired {
		clear ent:pageCount;
   	}
    }
}
