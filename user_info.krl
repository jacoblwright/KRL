
ruleset user_info {
  meta {
    name "foursquare"
    description <<
      User_Info Module
    >>
    author "Jacob Wright"
    logging on
    provides get_user_info
  }
  
  global {
  	get_user_info = function (userId) {
  		ent:my_map{userId} || {};
  	};
  }
  
  rule add_location_item {
  	select when pds new_location_data
  	pre {
  		my_key = event:attr("key");
  		my_value = event:attr("value");
  		my_map = {};
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