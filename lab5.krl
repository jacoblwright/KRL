ruleset foursquare {
    meta {
        name "lab 3"
        author "Jacob Wright"
        logging off
        use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
    }
    	
    rule process_fs_checkin {
    	select when foursquare checkin
    	pre {
    		
    	}
    	{
    		raise explicit event 'checkin_occured';
    	}
    	
    }
    
    rule init {
    	select when web cloudAppSelected
    	pre {
    		my_html = <<
    			<div id=foursquare><b>Checkin for Jake Wright</b> <br /></div>
    		>>;
    	} 
    	{
    		SquareTag:inject_styling();
  		 	CloudRain:createLoadPanel("Foursquare", {}, my_html);
    	}
	}
    
    rule display_checkin {
    	select when explicit checkin_occured
    	pre {
    		name = ent:venue_name;
    		my_city = ent:city;
    		my_shout = ent:shout;
    		my_created = ent:created;
    		my_html = <<
    			<ul>
    			<li>Venue name: #{name}</li>
    			<li>City: #{my_city}</li>
    			<li>Shout: #{my_shout}</li>
    			<li>Created At: #{my_created}</li>
    			</ul>
    		>>;
    	}
    	{
    		replace_inner("#foursquare", my_html);
    	}
    }
    
}