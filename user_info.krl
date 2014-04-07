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
  		app:my_map{userId} || {};
  	};
  }
  
  rule add_location_item {
  	select when coupon user
  	pre {
  		userId = event:attr("userId") || "";
  		new_email = event:attr("email") || "";
  		new_cell = event:attr("cell") || "";
  		my_value = { "email" : new_email, 
  					 "cell" : new_cell
  					}; 	
  		my_map = app:my_map || {};
  		new_map = my_map.put([userId], my_value);
  	}
  	{
  			send_directive(userId) with
  				user_info = new_map{userId};
  	}
  	always {
  			set app:my_map new_map;
  	}
  }
   
}