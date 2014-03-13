
ruleset examine_location {
  meta {
    name "foursquare"
    description <<
      foursquare
    >>
    author "Jacob Wright"
    logging off
    use module b505193x15 alias location_data
  } 
  
  global {
  }
  
  rule show_fs_location {
	select when pageview ".*" setting ()  	
	pre {
  			my_map = location_data:get_location_data("fs_checkin");
  			name = my_map{"venue_name"} || "na";
  			city = my_map{"city"} || "na";
  			shout = my_map{"shout"} || "na";
  			created = my_map{"created_at"} || "na";
  			//venue = my_map{"venue_name"};
  			headerString = <<
  				venue: #{name} <br />
  				city: #{city} <br />
  				shout: #{shout} <br />
  				created at: #{created}
  				
  			>>;
  		}
  		{
  			notify(headerString ,"") with sticky = true;
  		}
  }
  
   
}