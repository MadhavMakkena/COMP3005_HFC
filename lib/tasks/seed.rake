namespace :db do
  desc "Seed the database with sample data"
  task seed: :environment do
    require 'active_record'
    require 'faker'

    fileName = "db/seeds.sql"
    sql_statements = []

    sql_statements << "('test', 'member', 'member@test.com', 0, '#{Faker::Date.birthday(min_age: 18, max_age: 65)}', '#{Time.now.utc}', '#{Time.now.utc}')"
    sql_statements << "('test', 'trainer', 'trainer@test.com', 1, '#{Faker::Date.birthday(min_age: 18, max_age: 65)}', '#{Time.now.utc}', '#{Time.now.utc}')"
    sql_statements << "('test', 'admin', 'admin@test.com', 2, '#{Faker::Date.birthday(min_age: 18, max_age: 65)}', '#{Time.now.utc}', '#{Time.now.utc}')"

    # Create 20 members
    sql_statements << createData(20, 0)

    # Create 5 trainers
    sql_statements << createData(5, 1)

    # Create 2 admins
    sql_statements << createData(2, 2)

    File.open(fileName, "w") do |file|
      file.puts "INSERT INTO users (first_name, last_name, email, role, date_of_birth, created_at, updated_at) VALUES"
      file.puts sql_statements.join(",\n") + ";"
    end

    ActiveRecord::Base.connection.execute(File.read(fileName))

    puts "Database seeded successfully!"
  end
end

def createData(times, role)
  sql_statements = []

  times.times do
    firstName = Faker::Name.first_name.gsub("'", "")
    lastName = Faker::Name.last_name.gsub("'", "")
    email = Faker::Internet.email(name: "#{firstName} #{lastName}", separators: '.')
    dateOfBirth = Faker::Date.birthday(min_age: 18, max_age: 65)
    created_at = Time.now.utc
    updated_at = Time.now.utc

    sql_statements << "('#{firstName}', '#{lastName}', '#{email}', #{role}, '#{dateOfBirth}', '#{created_at}', '#{updated_at}')"
  end

  sql_statements
end
