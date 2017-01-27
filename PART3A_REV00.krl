ruleset trip_store {
  meta {
    name "trip_store"
    logging on
    sharing on
	provides trips, long_trips, short_trips
  }
  global {
  	trips = function() {
  		ent:all_trips;
  	};
  	long_trips = function() {
  		ent:long_trips;
  	};
  	short_trips = function() {
		all_trips = trips();
		short_keys = (ent:all_trips.keys()).difference((ent:long_trips));
		short_trips = ent:all_trips.filter(function(k,v) {
			short_keys.any(function(x) {
				x eq k
			});
		});
		short_trips;
  	};
  }
  rule collect_trips {
	select when explicit trip_processed
	pre {
      mileage = event:attr("mileage").defaultsTo(0).klog("explicit collect_trips event selected; mileage is ");
	  a = event:attrs().klog(" Here they are: ");
	  timestamp = time:now();
	}		
	always {
		set ent:all_trips{timestamp} mileage.klog(" Here is the mileage");
		log("All trips: ");
		log(ent:all_trips);
	}
  }
  rule collect_long_trips {
	select when explicit found_long_trip
	pre {
      mileage = event:attr("mileage").defaultsTo(0).klog("explicit processed_trip event selected; mileage is ");
	  timestamp = time:now();
	}		
	always {
		set ent:long_trips{timestamp} mileage;
		set ent:long_trips_2 mileage;
		log("Long trips: ");
		log(ent:long_trips);
	}

  }
  rule clear_trips {
	select when car trip_reset
	always {
		log("event clear_trips selected");
		clear ent:all_trips;
		clear ent:long_trips;
	}
  }
}