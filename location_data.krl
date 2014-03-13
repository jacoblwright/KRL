
ruleset location_data {
  meta {
    name "foursquare"
    description <<
      foursquare
    >>
    author "Jacob Wright"
    logging off
    provides get_location_data
  }
  
  global {
  	get_location_data = function (my_key) {
  		ent:my_map{my_key} || {}
  	};
  }
  
  rule add_location_item {
  	select when pds new_location_data
  	pre {
  		my_key = event:attr("key").decode();
  		my_value = event:attr("value").decode();
  		my_map = ent:my_map || {};
  		}
  		always {
  			set ent:my_map my_Map.put(my_key, my_value);
  		}
  }
  
   
}