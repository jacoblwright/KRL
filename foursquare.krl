
ruleset foursquare {
  meta {
    name "foursquare"
    description <<
      Hello World
    >>
    author ""
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
   rule process_fs_checkin {
    	select when foursquare checkin
    	pre {
    		json_obj = event:attr("response");
    	
    		name = json_obj.pick("$.venue.name");
    		my_city = json_obj.pick("$.venue.location.city");
    		my_shout = json_obj.pick("$.checkin.shout");
    		my_created = json_obj.pick("$.checkin.createdAt");
    	}
    	fired {
    		set ent:venue_name name;
    		set ent:city my_city;
    		set ent:shout my_shout;
    		set ent:created my_created;
    		raise explicit event 'checkin_occured';
    	}
    	
   }
    
  rule foursquare_init is active {
    select when web cloudAppSelected
    pre {
    	name = ent:venue_name || "n/a";
    	my_city = ent:city || "n/a";
		my_shout = ent:shout || "n/a";
   		my_created = ent:created || "n/a";
        my_html = <<
          <div id=foursquare>
          	Checkin:
    		<ul>
    			<li>Venue name: #{name}</li>
    			<li>City: #{my_city}</li>
    			<li>Shout: #{my_shout}</li>
    			<li>Created At: #{my_created}</li>
    		</ul>
          <div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Foursquare", {}, my_html);
    }
  }
  
  rule display_checkin {
    	select when explicit checkin_occured
    	pre {
    		name = ent:venue_name || "n/a";
    		my_city = ent:city || "n/a";
    		my_shout = ent:shout || "n/a";
    		my_created = ent:created || "n/a";
    		my_html = <<
    			Checkin:
    			<ul>
    			<li>Venue name: #{name}</li>
    			<li>City: #{my_city}</li>
    			<li>Shout: #{my_shout}</li>
    			<li>Created At: #{my_created}</li>
    			</ul>
    		>>;
    	}
    	{
    		replace_inner("#foursquare", my_html);
    	}
    }
}