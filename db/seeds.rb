puts "Cleaning DB..."
Registration.destroy_all
puts "DB cleaned!"

puts "Creating records..."
@registration = Registration.create!

client = Client.new(
  first_name: 'Timothée',
  last_name:'Régis',
  phone_1:'0769181771',
  phone_2:'0145065828',
  re_registration:'true',
  mail: 'registimothee@gmail.com',
  birthdate: Date.new(1993,9,1)
)

client.registration = @registration
client.save!

client = Client.new(
  first_name: 'Alexis',
  last_name:'Régis',
  phone_1:'0607447714',
  re_registration: false,
  mail: 'alexis.regis@hotmail.fr',
  birthdate: Date.new(1997,11,21)
)

client.registration = @registration
client.save!

puts "#{Client.count} clients created!"
