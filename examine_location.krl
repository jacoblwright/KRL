
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
  	get_location_data = function (my_key) {
  		ent:my_map{my_key} || {};
  	};
  }
  
  rule add_location_item {
  	select when pds new_location_data
  	pre {
  		my_key = event:attr("key");
  		my_value = event:attr("value");
  		my_map = ent:my_map || {};
  		new_map = my_map.put([my_key], my_value);
  	}
  	{
  			send_directive("text") with
  				location = "world";
  	}
  	always {
  			set ent:my_map new_map;
  			set ent:constantString "constant";
  	}
  }
  
  rule show_fs_location is active{
	select when web cloudAppSelected 	
	pre {
  			my_map = location_data:get_location_data("fs_checkin");
  			//name = my_map{"venue_name"} || "na";
  			name = my_map;
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