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
  	select when coupon user
  	pre {
  		userId = event:attr("userId") || "";
  		email = event:attr("email") || "";
  		cell = event:attr("cell") || "";
  		my_value = { "email" : email, 
  					 "cell" : cell
  					}; 	
  		my_map = {};
  		new_map = my_map.put([userId], my_value);
  	}
  	{
  			send_directive(userId) with
  				userInfo = my_value;
  	}
  	always {
  			set ent:my_map new_map;
  	}
  }
   
}