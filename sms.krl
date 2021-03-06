ruleset snd_sms {
  meta {
    name "twilio"
    description <<
      Final Project
    >>
    author "Jacob Wright"
    logging on
    
    key twilio {"account_sid" : "ACe5d5cb065ba151124344335e8b0e3a35",
                    "auth_token"  : "9275b16878742f26411eee86bf8895ba"
        }
         
    use module a8x115 alias twilio with twiliokeys = keys:twilio()
  }
  
  rule listen_nearby {
  	select when explicit coupon_found
  	pre {
  		toNumber = event:attr("cell") || "";
  		//message = event:attr("message") || "";
  		name = event:attr("y1");
  		avg_rating = event:attr("y4");
  		y6 = event:attr("y6");
  		c1 = event:attr("c1");
  		c2 = event:attr("c2");
  		//message = "Review  " + name + " Average rating: " + avg_rating + " " + review + "     " +
  		//		  "Coupon  " + c1 + " " + c2;  		
  		message = "Coupon  " + c1 + " " + c2; 
  	}
  	{
  		send_directive("SMS") with 
  			text_message = message;
  		twilio:send_sms(toNumber, "9287354249", message);
  	}
  }
  
   
}