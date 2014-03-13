
ruleset location_data {
  meta {
    name "foursquare"
    description <<
      foursquare
    >>
    author "Jacob Wright"
    logging on
    provides get_location_data
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
  			send_directive(my_key) with
  				location = my_value;
  	}
  	always {
  			set ent:my_map new_map;
  	}
  }
  
   
}