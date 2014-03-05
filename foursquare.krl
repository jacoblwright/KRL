
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
  rule foursquare_init is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <div id=foursquare>Checkin:<div>
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
    		name = ent:venue_name;
    		my_city = ent:city;
    		my_shout = ent:shout;
    		my_created = ent:created;
    		my_html = <<
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