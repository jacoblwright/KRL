
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
    		my_map = {
    				"venue_name" : name,
    				"city" : my_city,
    				"shout" : my_shout,
    				"created_at" : my_created
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
    		//set ent:my_map new_map;
    		raise pds event 'new_location_data'
    			with key = "fs_checkin"
    			and value = my_map; 
    	}
    	
   }
}