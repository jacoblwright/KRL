
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
}