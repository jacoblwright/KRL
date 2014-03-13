
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
  			//venue = my_map{"venue_name"};
  			headerString = <<
  				venue: #{my_map{"venue_name"}}
  				
  			>>;
  		}
  		{
  			notify(headerString ,"") with sticky = true;
  		}
  }
  
   
}