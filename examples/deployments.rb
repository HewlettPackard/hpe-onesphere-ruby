require_relative '_client' # Gives access to @client
puts "\nCreating a deployment from the available catalog and deploying centos."

options = {
    "name":	"CentOS7",
    "networks": [
      {
        "networkUri": "/rest/networks/eeaddaaa-3aaf-4317-b055-c38ab83691ea"
      }
    ],
    "projectUri":	"/rest/projects/b14cc5d55d1a4fdf946f184ccb274951",
    "serviceUri":	"/rest/services/55fdbb81-5891-4b8e-8057-a9e51736f513",
    "virtualMachineProfileUri":	"/rest/virtual-machine-profiles/2",
    "zoneUri":	"/rest/zones/4dfa3aa8-5d82-4f44-9ba7-3dd366dbe7bb"
}
deployment = OneSphere::Deployment.new(@client, options)
deployment.create!
puts "\nCreated deployment '#{deployment[:name]}' sucessfully.\n  uri = '#{deployment[:uri]}'"

# List deployments
puts "\nDeployments available: "
OneSphere::Deployment.get_all(@client).each do |deployments|
  puts "- Project URI: '#{deployments['projectUri']}' | Region URI: '#{deployments['regionUri']}'"
end

puts "\nGetting the available deployments filtered by name:centos"
deployment_with_filter = OneSphere::Deployment.find_by(@client, userQuery:'CentOS7')
puts "\nDeployments filtered by name found: #{deployment_with_filter}"

puts "\nUpdating the deployment"
deployment.retrieve!

deployment.update_deployments("CentOS7 Updated")
puts "\nDeployment updated successfully with name: CentOS7 Updated."

sleep(45)
deployment.retrieve!

puts "\nGetting the deployment console url"
uri = deployment.get_deployment_console_url
puts "\nDeployment console url = '#{uri}'}"

puts "\nPerforming action on the deployment"
deployment.perform_action(type = 'suspend')
puts "\nPerformed action successfully"

sleep(40)
puts "\nRemoving a deployment..."
deployment.delete
puts "\nDeployment removed successfully!"
@client.destroy_session
