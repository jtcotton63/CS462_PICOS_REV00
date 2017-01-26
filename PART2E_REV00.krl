ruleset hello_world {
  meta {
    name "track_trips"
    logging on
    sharing on
  }
  rule process_trip {
    select when car new_trip
    pre {
      mileage = event:attr("mileage").defaultsTo(0).klog("car new_trip event selected; mileage is ");
    }
    {
      send_directive("trip") with
        trip = "#{mileage}";
    }
    always {
      raise explicit event trip_processed attributes event:attrs();
    }    
  }
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").defaultsTo(0).klog("explicit trip_processed event selected; mileage is ");
    }
    if(mileage > ent:long_trip) then 
    {
		raise explicit event found_long_trip attributes event:attrs();
		log("Rased found_long_trip event with mileage #{mileage}");
    }
    always {
      log("New trip is of length " + mileage );
      log("Record holding trip is of length " + ent:long_trip);
    }
  }
  rule found_long_trip {
    select when explicit found_long_trip
    pre {
      mileage = event:attr("mileage").defaultsTo(0).klog("explicit trip_processed event selected; mileage is ");
    }
    fired {
      log("Setting long_trip to length " + mileage );
	  set ent:long_trip mileage;
    }
  }
}