require 'net/http'
require 'json'

offset = 100

# Fetch the JSON data from the website
uri = URI("https://gameinfo-ams.albiononline.com/api/gameinfo/events?limit=50&offset=#{offset}") # replace with the actual URL
response = Net::HTTP.get(uri)
json_data = JSON.parse(response)

# Initialize a counter for the objects that meet the condition
count = 0

# Iterate over the array of JSON objects
json_data.each do |obj|
  # Check if the ['Id'] field of obj['Killer'] is not present in one of the elements of obj['Participants'] array
  if obj['Participants'].none? { |participant| participant['Id'] == obj['Killer']['Id'] }
    count += 1
    puts obj['groupMemberCount']
    puts obj['numberOfParticipants']
    pp obj['Killer']
  end
end

puts "Count: #{count}"
