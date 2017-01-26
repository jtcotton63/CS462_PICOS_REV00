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
      send_directive("found_long_trip") with
        status = "Found a new long trip with mileage #{mileage}";
    }
    always {
      log("New trip is of length " + mileage );
      log("Record holding trip is of length " + ent:long_trip);
    }
      
  }
}