namespace :db do
  desc "Clear and seed the database with sample data"
  task rebuild: :environment do
    File.open("db/seeds.sql", "w") {}

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:build'].invoke
  end

  desc "Seed the database with sample data"
  task build: :environment do
    Rake::Task['db:seedUser'].invoke
    Rake::Task['db:seedHealthMetric'].invoke
    puts "Database seeded successfully!"
  end

  desc "Seed Users"
  task seedUser: :environment do
    require 'active_record'
    require 'faker'

    user_seed = "\n\n-- Seed Users --\n"
    user_seed += "INSERT INTO users (first_name, last_name, email, role, date_of_birth, created_at, updated_at) VALUES\n"
    # Seed predefined users
    users = [
      "('test', 'member', 'member@test.com', 0, '#{Faker::Date.birthday(min_age: 18, max_age: 65)}', '#{Time.now.utc}', '#{Time.now.utc}')",
      "('test', 'trainer', 'trainer@test.com', 1, '#{Faker::Date.birthday(min_age: 18, max_age: 65)}', '#{Time.now.utc}', '#{Time.now.utc}')",
      "('test', 'admin', 'admin@test.com', 2, '#{Faker::Date.birthday(min_age: 18, max_age: 65)}', '#{Time.now.utc}', '#{Time.now.utc}')"
    ]
    # Create 20 members, 5 trainers, 2 admins
    users.concat(create_user_data(20, 0))
    users.concat(create_user_data(5, 1))
    users.concat(create_user_data(2, 2))

    user_seed += users.join(",\n") + ";" + "\n\n\n"

    ActiveRecord::Base.connection.execute(user_seed)

    File.open("db/seeds.sql", "a") do |file|
      file.puts user_seed
    end
  end

  desc "Seed Health Metrics"
  task seedHealthMetric: :environment do
    require 'active_record'
    require 'faker'

    member_ids = User.where(role: :member).pluck(:id)

    health_metrics_seed = "\n\n-- Seed Health Metrics --\n"
    health_metrics_seed += "INSERT INTO health_metrics (user_id, height, weight, bmi, hydration, muscle_mass, caloric_intake, caloric_burn, steps, sleep_quality, resting_heart_rate, created_at, updated_at) VALUES\n"

    health_metrics = []
    member_ids.map do |user_id|
      health_metrics.concat(create_health_metric_data(user_id))
    end

    health_metrics_seed += health_metrics.join(",\n") + ";" + "\n\n\n"
    ActiveRecord::Base.connection.execute(health_metrics_seed)

    File.open("db/seeds.sql", "a") do |file|
      file.puts health_metrics_seed
    end
  end
end

def create_user_data(times, role)
  sql_fragment = []

  times.times do
    firstName = Faker::Name.first_name.gsub("'", "")
    lastName = Faker::Name.last_name.gsub("'", "")
    email = Faker::Internet.email(name: "#{firstName} #{lastName}", separators: '.')
    dateOfBirth = Faker::Date.birthday(min_age: 18, max_age: 65)
    created_at = Time.now.utc
    updated_at = Time.now.utc

    sql_fragment << "('#{firstName}', '#{lastName}', '#{email}', #{role}, '#{dateOfBirth}', '#{created_at}', '#{updated_at}')"
  end

  sql_fragment
end

def create_health_metric_data(user_id)
  sql_fragment = []

  rand(0..5).times do
    # Generate and return health metrics data
    height = Faker::Number.between(from: 150.0, to: 200.0).round(2)
    weight = Faker::Number.between(from: 50.0, to: 100.0).round(2)
    bmi = (weight / ((height / 100) ** 2)).round(2)
    hydration = Faker::Number.between(from: 50, to: 100)
    muscle_mass = Faker::Number.between(from: 20.0, to: 40.0).round(2)
    caloric_intake = Faker::Number.between(from: 1500, to: 3000)
    caloric_burn = Faker::Number.between(from: 500, to: 1500)
    steps = Faker::Number.between(from: 1000, to: 10000)
    sleep_quality = Faker::Number.between(from: 1, to: 10)
    resting_heart_rate = Faker::Number.between(from: 60, to: 100)
    created_at = Faker::Date.between(from: 1.year.ago, to: Date.today)
    updated_at = Faker::Date.between(from: created_at, to: Date.today)

    sql_fragment << "(#{user_id}, #{height}, #{weight}, #{bmi}, #{hydration}, #{muscle_mass}, #{caloric_intake}, #{caloric_burn}, #{steps}, #{sleep_quality}, #{resting_heart_rate}, '#{created_at}', '#{updated_at}')"
  end

  sql_fragment
end
