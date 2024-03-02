# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

employees = [
  {
    first_name: "Sai",
    last_name: "Ganesh",
    email: "sgt@gmail.com",
    joining_date: Date.new(2022, 2, 10),
    monthly_salary: 90000,
    contact_numbers_attributes: [{ mobile_number: "9988556688" }]
  },
  {
    first_name: "Paul",
    last_name: "Walker",
    email: "paul@gmail.com",
    joining_date: Date.new(2018, 6, 15),
    monthly_salary: 85000,
    contact_numbers_attributes: [{ mobile_number: "7896541257" }]
  },
]

employees.each do |employee|
  Employee.create!(employee)
end
