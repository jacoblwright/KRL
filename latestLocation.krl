
ruleset location {
  meta {
    name "foursquare"
    description <<
      foursquare
    >>
    author "Jacob Wright"
    logging on
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  
  dispatch {
  }
  
  global {
  }
  
  rule location_catch {
  	select when location notification
  	 pre {
  		my_name = event:attr("name") || "test";
  		my_city = event:attr("city");
  		my_shout = event:attr("shout");
  		my_created_at = event:attr("created_at");
  	}
  	{
  			send_directive("test") with
  				name = name;
  	}
  	always {
  			set ent:name my_name;
  			set ent:city my_city;
  			set ent:shout my_shout;
  			set ent:created_at my_created_at;
  	}
  }
  
  rule location_show is active {
    	select when web cloudAppSelected
    	pre {
    		name = ent:name || "n/a";
    		my_city = ent:city || "n/a";
			my_shout = ent:shout || "n/a";
   			my_created = ent:created_at || "n/a";
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
  
   
}