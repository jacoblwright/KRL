
ruleset foursquare {
  meta {
    name "foursquare"
    description <<
      foursquare
    >>
    author ""
    logging on
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
   rule process_fs_checkin {
    	select when foursquare checkin
    	pre {
    		json_obj = event:attr("checkin").decode();
    	
    		name = json_obj.pick("$.venue.name");
    		my_city = json_obj.pick("$.venue.location.city");
    		my_shout = json_obj.pick("$.shout");
    		my_created = json_obj.pick("$.createdAt");
    		my_long = json_obj.pick("$.venue.location.lng");
    		my_lat = json_obj.pick("$.venue.location.lat");
    		my_map = {
    				"venue_name" : name,
    				"city" : my_city,
    				"shout" : my_shout,
    				"created_at" : my_created,
    				"long" : my_long,
    				"lat" : my_lat
    			};
    		h = "city";
    		w = "Mordor!";
    		a_map = ent:my_map || {}; //my_map.put([h], w);
    		new_map = a_map.put(my_map);
    	}
    	{
    		send_directive(name) with 
    			checkin = name;
    	}
    	always {
    		set ent:my_map new_map;
    		raise pds event 'new_location_data'
    			with key = "fs_checkin"
    			and value = my_map; 
    	}	
   }
	rule foursquare_init is active {
    	select when web cloudAppSelected
    	pre {
    		name = ent:my_map{"venue_name"} || "n/a";
    		my_city = ent:my_map{"city"} || "n/a";
			my_shout = ent:my_map{"shout"} || "n/a";
   			my_created = ent:my_map{"created_at"} || "n/a";
   			my_long = ent:my_map{"long"};
   			my_lat = ent:my_map{"lat"};
       	 my_html = <<
          <div id=foursquare>
          	Checkin:
    		<ul>
    			<li>Venue name: #{name}</li>
    			<li>City: #{my_city}</li>
    			<li>Shout: #{my_shout}</li>
    			<li>Created At: #{my_created}</li>
    			<li>Long: #{my_long}</li>
    			<li>Lat: #{my_latå}</li>
    		</ul>
          <div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Foursquare", {}, my_html);
    }
  }
}