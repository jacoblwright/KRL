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
	      getName = function(n) {
		x = n.extract(#name=(\w*)#);
		x[0] || "Monkey";
	      }
	      //x = query.extract(#name=(\w*)#);
	      name = getName(query);   // x[0] || "Monkey";
        }
	notify("Hello " + name, "") with position="bottom-right" and sticky = true;
    }
    rule fourth_rule {
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
                clear ent:pageCount;
        }
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
}
