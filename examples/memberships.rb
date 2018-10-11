require_relative '_client' # Gives access to @client

options = {
    "userUri": "/rest/users/e357ec515398424ba8f421da0108a0cc",
    "membershipRoleUri": "/rest/membership-roles/9fe2ff9ee4384b1894a90878d3e92bab",
    "projectUri": "/rest/projects/b14cc5d55d1a4fdf946f184ccb274951"
}

# Create a membership
membership = OneSphere::Membership.new(@client, options)
membership.create
puts "Created membership \n #{membership}"

# Get all memberships
all_memberships =  OneSphere::Membership.get_all(@client)
puts "Membership roles \n\n #{all_memberships}"

# Delete membership
membership.delete
puts "Membership deleted"

# Delete session
@client.destroy_session

