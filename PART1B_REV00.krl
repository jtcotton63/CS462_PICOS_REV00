ruleset hello_world {
  meta {
    name "track_trips"
    logging on
    sharing on
  }
  rule process_trip {
    select when echo message
    pre {
    	mileage = event:attr("mileage").defaultsTo(0);
    }
    send_directive("trip") with
      trip = "#{mileage}";
  }
}