# coding: utf-8

User.create!(
  [
    {
      name: "管理者",
      email: "sample@email.com",
      employee_number: "0001",
      uid: "0001",
      password: "password",
      password_confirmation: "password",
      admin: true,
      principal: false,
      instructor: false
    },
    {
      name: "塾長",
      email: "pca@email.com",
      employee_number: "1001",
      uid: "1001",
      password: "password",
      password_confirmation: "password",
      admin: false,
      principal: true,
      instructor: false
    },
    {
      name: "講師A",
      email: "ir-a@email.com",
      employee_number: "1002",
      uid: "1101",
      password: "password",
      password_confirmation: "password",
      admin: false,
      principal: false,
      instructor: true
    },
    {
      name: "講師B",
      email: "ir-b@email.com",
      employee_number: "1102",
      uid: "1102",
      password: "password",
      password_confirmation: "password",
      admin: false,
      principal: false,
      instructor: true
    },
    {
      name: "生徒A",
      email: "sample-1@email.com",
      employee_number: "2001",
      uid: "2001",
      password: "password",
      password_confirmation: "password",
      admin: false,
      principal: false,
      instructor: false
    },
    {
      name: "生徒B",
      email: "sample-1@email.com",
      employee_number: "2002",
      uid: "2002",
      password: "password",
      password_confirmation: "password",
      admin: false,
      principal: false,
      instructor: false
    },
  ]
)  

# 60.times do |n|
#   name = Faker::Name.name
#   email = "sample-#{n+1}@email.com"
#   password = "password"
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password)
# end