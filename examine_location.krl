
ruleset examine_location {
  meta {
    name "foursquare"
    description <<
      foursquare
    >>
    author "Jacob Wright"
    logging off
     use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    use module b505193x15 alias location_data
  } 
  
  global {
  }
  
  rule show_fs_location is active{
	select when web cloudAppSelected 	
	pre {
  			my_map = location_data:get_location_data("fs_checkin");
  			name = my_map{"venue_name"} || "na";
  		//	name = my_map;
  			city = my_map{"city"} || "na";
  			shout = my_map{"shout"} || "na";
  			created = my_map{"created_at"} || "na";
  			 my_html = <<
          <div id=foursquare>
          	Checkin:
    		<ul>
    			<li>Venue name: #{name}</li>
    			<li>City: #{city}</li>
    			<li>Shout: #{shout}</li>
    			<li>Created At: #{created}</li>
    		</ul>
          <div>
     		 >>;
  		}
  		{
  			 SquareTag:inject_styling();
      		CloudRain:createLoadPanel("Lab 6", {}, my_html);
  		}
  }
  
   
}