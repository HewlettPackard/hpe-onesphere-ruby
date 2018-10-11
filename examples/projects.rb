require_relative '_client' # Gives access to @client


puts "Creating a Test Project."
options = {
      "name": "Test Project",
      "description": "Nothing11",
      "tagUris": ["consumer", "string"]
}
project = OneSphere::Project.new(@client, options)
project.create!
puts "Created Project '#{project[:name]}' sucessfully.  uri = '#{project[:uri]}'"

puts "\nListing created project."
project.retrieve!
puts project.data

puts "\nUpdating the Test Project."
project.update(name: "Test Project Updated")
puts "Updated Project '#{project[:name]}' sucessfully.  uri = '#{project[:uri]}'"

puts "\nListing Updated project."
project.retrieve!
puts project.data

puts "\nListing all projects."
OneSphere::Project.get_all(@client).each do |projects|
  puts projects['name']
end

puts "\nGetting the available projects filtered by name: onesphere-ruby"
puts "Projects filtered by name found: "
project_with_filter = OneSphere::Project.find_by(@client, {userQuery:'onesphere-ruby', view:'full'})
puts project_with_filter

puts "\nDelete created project."
project.delete
puts "Project removed successfully!"

@client.destroy_session
