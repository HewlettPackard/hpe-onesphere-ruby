require_relative '_client' # Gives access to @client

options = {
    "name":	"us-east-1a",
    "rates": [],
    "regionUri": "/rest/regions/1c017adb-a257-4313-bb67-05251514e3c9",
    "zoneTypeUri": "/rest/zone-types/vcenter",
    "providerUri": "/rest/providers/322350335082"
}
zone = OneSphere::Zone.new(@client, options)
# zone.create!
# puts "\nCreated zone '#{zone[:name]}' sucessfully.\n  uri = '#{zone[:uri]}'"

zone['uri'] = '/rest/zones/bd4c0fbb-4e45-44c3-b9e8-b504ee690f50'
# Get all zones
all_zones =  OneSphere::Zone.get_all(@client)
puts "All zones #{all_zones}"

# Get zones with filter
zones_filter_by_name = OneSphere::Zone.find_by(@client, name:'us-east-1a').first
puts "Zones filter by name: #{zones_filter_by_name}"

zones_filter_by_region = OneSphere::Zone.find_by(@client,regionUri:'/rest/regions/19ccc512-1d40-4a17-a9f8-f494e456cb34').first
puts "Zones filter by regions: #{zones_filter_by_region}"

# Update zone
# zones_filter_by_name.update(name: 'us-east-1a')
# puts "Updated zone"

# Get Zone appliance-image url
# uri = zone.get_appliance_image_url
# puts "\nZone appliance-image url = '#{uri}'}"

# Get Zone task-status
task_status = zone.get_zone_task_Status
puts "\nZone task status = '#{task_status}'}"

# Get Zone connections- requires admin rights to get connections for the zone
# connections = zone.get_zone_connections
# puts "\nZone connections = '#{connections}'}"

# Delete zone
# zones_filter_by_name.delete
# puts "Deleted zone"

# Destroy the session created for this resource
@client.destroy_session
puts "Destroyed session"
