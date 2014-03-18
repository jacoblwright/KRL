
ruleset snd_sms {
  meta {
    name "twilio"
    description <<
      lab 7
    >>
    author "Jacob Wright"
    logging on
    
    key twilio {"account_sid" : "ACe5d5cb065ba151124344335e8b0e3a35",
                    "auth_token"  : "9275b16878742f26411eee86bf8895ba"
        }
         
    use module a8x115 alias twilio with twiliokeys = keys:twilio()
  }
  
  rule listen_nearby {
  	select when explicit location_nearby
  	pre {
  		dist = event:attr("distance");
  	}
  	{
  		send_directive("SMS") with 
  			distance = dist;
  		twilio:send_sms(8019007588, 19287354249, "distance " + dist);
  	}
  }
  
   
}