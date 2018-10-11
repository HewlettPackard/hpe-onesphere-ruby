require_relative '_client' # Gives access to @client

status =  OneSphere::Status.get_all(@client)
puts "Status \n\n #{status}"

