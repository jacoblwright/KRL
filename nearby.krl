
ruleset location_nearby {
  meta {
    name "twilio"
    description <<
      lab 7
    >>
    author "Jacob Wright"
    logging on
    use module b505193x15 alias location_data    
  }
  
  rule nearby {
  	select when location curr
  	pre {
  		my_map = location_data:get_location_data("fs_checkin");
  		lnga = my_map{"long"};
  		lata = my_map{"lat"};
  		lngb = event:attr("long");
  		latb = event:attr("lat");

		r90   = math:pi()/2;      
		rEk   = 6378;         // radius of the Earth in km
 
		// convert co-ordinates to radians
		rlata = math:deg2rad(lata);
		rlnga = math:deg2rad(lnga);
		rlatb = math:deg2rad(latb);
		rlngb = math:deg2rad(lngb);
	 
		// distance between two co-ordinates in kilometers
		//dist = math:great_circle_distance(rlnga,r90 - rlata, rlngb,r90 - rlatb, rEk);
		dist = rlata;
  	}
  	//if (dist < 8) then {
  	{
  		send_directive("location") with
  				location = my_map;
  	}
  	fired {
  		raise explicit event 'location_nearby'
    		with distance = dist; 
  	} else {
  		raise explicit event 'location_far'
    		with distance = dist; 
  	}
  }
  
   
}