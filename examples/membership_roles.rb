require_relative '_client' # Gives access to @client

membership_roles =  OneSphere::MembershipRoles.get_all(@client)
puts "Membership roles \n\n #{membership_roles}"

