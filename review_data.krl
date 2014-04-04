ruleset review_data {
  meta {
    name "review"
    description <<
      review_data Module
    >>
    author "Jacob Wright"
    logging on
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    provides get_review
  }
  
  global {
  	get_review = function (term, location) {
  		http:get("http://api.yelp.com/business_review_search",
  		{ 	"term" : term,
   			"location" : location,
   			"ywsid" : "7gH8mdXybsBA0JkbBx47ww"
   		});//.pick("$.businesses[0]").decode();
  	};
  }
  
  rule location_show is active {
    	select when web cloudAppSelected
    	pre {
    		r = get_review("panda express", "84606").decode();
    		img_url = r.pick("$.businesses[0].rating_img_url") || "n/a";
  			review_count = r.pick("$.businesses[0].review_count");
  			name = r.pick("$.businesses[0].name");
  			avg_rating = r.pick("$.businesses[0].avg_rating");
  			review = r.pick("$.businesses[0].reviews[0].text_excerpt");
       	 my_html = <<
          <div id=review>
          	Review:
    		<ul>
    			<li>img_url: #{img_url}</li>
    			<li>review count: #{review_count}</li>
    			<li>name: #{name}</li>
    			<li>avg rating: #{avg_rating}</li>
    			<li>review: #{review}</li>
    		</ul>
          <div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Review", {}, my_html);
    }
  }
  
   
}