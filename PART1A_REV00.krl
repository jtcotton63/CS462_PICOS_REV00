ruleset hello_world {
  meta {
    name "Hello World"
    logging on
    sharing on
    provides hello
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
 
  }
  rule hello {
    select when echo hello
    send_directive("say") with
      something = "Hello World";
  }
  rule message {
    select when echo message
    pre {
    	input = event:attr("input").defaultsTo(ent:input,"Using default input");
    }
    send_directive("say") with
      something = "#{input};
  }
}