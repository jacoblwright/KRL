
ruleset examine_location {
  meta {
    name "foursquare"
    description <<
      foursquare
    >>
    author "Jacob Wright"
    logging off
    use module location_data
  }
  
  global {
  	get_location_data = function (my_key) {
  		ent:my_map{my_key};
  	}
  }
  
  rule show_fs_location {
  	select when pds new_location_data
  	pre {
  		my_map = location_data:get_location_data("fs_checkin");
  		}
  		{
  			notify(my_map,"") with sticky = true;
  		}
  }
  
   
}