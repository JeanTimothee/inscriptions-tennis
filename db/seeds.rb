User.destroy_all
Registration.destroy_all

User.create!(email:'tim@gmail.com', password:"123456", admin:'true')
