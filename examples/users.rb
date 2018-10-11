require_relative '_client' # Gives access to @client

# Data for creating a user
user_data = {
      "email": "someemail@domain.com",
      "name": "name",
      "password": "password",
      "role": "consumer"
}

# Create a user
user = OneSphere::User.new(@client, user_data)
user.create!
puts "Created user #{user['name']}"

# Update user profile
user.update(name: 'other name')
puts "Updated username"

# Get updated data
user.retrieve!
puts "Updated user data \n #{user.data}"

# Get all users
all_users =  OneSphere::User.get_all(@client)
puts "All users #{all_users}"

# Get users with filter
users_with_filter = OneSphere::User.find_by(@client, name:'other name')
puts "Users with filter #{users_with_filter.first['name']}"

# Delete user
user.delete
puts "Deleted user"

# Destroy the session created for this resource
@client.destroy_session
puts "Destroyed session"
