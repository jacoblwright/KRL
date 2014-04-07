ruleset snd_email {
  meta {
    name "sendgrid"
    description <<
      Final Project
    >>
    author "Jacob Wright"
    logging on
  }
  
  rule listen_email {
  	select when explicit coupon_found
  	pre {
  		email = event:attr("email") || "";
  		//message = event:attr("message") || "";
  		subject = event:attr("subject") || "Coupons-N-Reviews";
  		
  		name = event:attr("y1");
  		avg_rating = event:attr("y4");
  		review = event:attr("y6");
  		c1 = event:attr("c1");
  		c2 = event:attr("c2");
  		message = "Review  " + name + " Average rating: " + avg_rating + " " + review + "     " +
  				  "Coupon  " + c1 + " " + c2;  		
  		
  		
  		r =	http:get("https://api.sendgrid.com/api/mail.send.json",
  					{ "api_user" : "jacoblwright",
  					  "api_key" : "computer123",
  					  "to" : email,
  					  "subject" : subject,
  					  "html" : message,
  					  "from" : "jake.wright@byu.edu"
  					  });
  	}
  	{
  		send_directive("email") with 
  			response = r;
  		
  	}
  }
  
   
}