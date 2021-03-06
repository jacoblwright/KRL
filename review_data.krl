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
   			"limit" : "1",
   			"ywsid" : "7gH8mdXybsBA0JkbBx47ww"
   		}).pick("$.content").decode();
  	};
  }
  
  rule location_show is active {
    	select when web cloudAppSelected
    	pre {
    		r = get_review("Tucanos", "84606");
    		img_url = r.pick("$.businesses[0].rating_img_url").encode();
  			review_count = r.pick("$.businesses[0].review_count").encode();
  			name = r.pick("$.businesses[0].name").encode();
  			avg_rating = r.pick("$.businesses[0].avg_rating").encode();
  			review = r.pick("$.businesses[0].reviews[0].text_excerpt").encode();
  			photo = r.pick("$.businesses[0].photo_url");
  			new_map = {	"img_url" : img_url,
    			"review_count" : review_count,
    			"name" : name,
    			"avg_rating" : avg_rating,
    			"review" : review
    		};
       	 my_html = <<
          <div id=review>
          	Review:
    		<ul>
    			<li> image url: #{img_url}</li>
    			<li>review count: #{review_count}</li>
    			<li>name: #{name}</li>
    			<li>avg rating: #{avg_rating}</li>
    			<li>review: #{review}</li>
    		</ul>
    		<img src=#{img_url} alt="pic">
    		<img src=#{photo} alt="pic">
    		#{new_map.encode()}
          <div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Review", {}, my_html);
    }
  }
  
   
}