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
    Rake::Task['db:seedRoomBooking'].invoke
    Rake::Task['db:seedTrainingSession'].invoke
    Rake::Task['db:seedMemberSession'].invoke
    Rake::Task['db:seedAnnouncement'].invoke
    Rake::Task['db:seedReminder'].invoke
    Rake::Task['db:seedEquipment'].invoke
    Rake::Task['db:seedPayment'].invoke
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

  desc "Seed Room Bookings"
  task seedRoomBooking: :environment do
    require 'active_record'
    require 'faker'

    room_booking_seed = "\n\n-- Seed Room Bookings --\n"
    room_booking_seed += "INSERT INTO room_bookings (room_name, location, booking_time, created_at, updated_at) VALUES\n"

    room_bookings = []
    40.times do
      room_name = Faker::Number.between(from: 0, to: 7)
      location = "#{RoomBooking.room_names.key(room_name).to_s.humanize.capitalize} Room"
      booking_time = Faker::Time.between_dates(from: Date.today - 5.days, to: Date.today + 5.days).beginning_of_hour
      created_at = Faker::Date.between(from: 1.week.ago, to: Date.today)
      updated_at = Faker::Date.between(from: created_at, to: Date.today)

      room_bookings << "(#{room_name}, '#{location}', '#{booking_time}', '#{created_at}', '#{updated_at}')"
    end

    room_booking_seed += room_bookings.join(",\n") + ";" + "\n\n\n"
    ActiveRecord::Base.connection.execute(room_booking_seed)

    File.open("db/seeds.sql", "a") do |file|
      file.puts room_booking_seed
    end
  end

  desc "Seed Training Sessions"
  task seedTrainingSession: :environment do
    require 'active_record'
    require 'faker'

    training_session_seed = "\n\n-- Seed Training Sessions --\n"
    training_session_seed += "INSERT INTO training_sessions (name, user_id, room_booking_id, created_at, updated_at) VALUES\n"

    training_sessions = []
    # For 30 of the room bookings, create a training session with a random trainer
    room_booking_ids = RoomBooking.all.pluck(:id)
    room_booking_ids.sample(30).each do |room_booking_id|
      user_id = User.where(role: :trainer).pluck(:id).sample
      name = Faker::Number.between(from: 0, to: 5)
      created_at = Faker::Date.between(from: 1.week.ago, to: Date.today)
      updated_at = Faker::Date.between(from: created_at, to: Date.today)

      training_sessions << "('#{name}', #{user_id}, #{room_booking_id}, '#{created_at}', '#{updated_at}')"
    end

    training_session_seed += training_sessions.join(",\n") + ";" + "\n\n\n"

    ActiveRecord::Base.connection.execute(training_session_seed)
    File.open("db/seeds.sql", "a") do |file|
      file.puts training_session_seed
    end
  end

  desc "Seed Member Session"
  task seedMemberSession: :environment do
    require 'active_record'
    require 'faker'

    member_session_seed = "\n\n-- Seed Member Sessions --\n"
    member_session_seed += "INSERT INTO member_sessions (user_id, training_session_id, created_at, updated_at) VALUES\n"

    member_sessions = []
    # For 30 of the training sessions, create a member session with a random member
    training_session_ids = TrainingSession.all.pluck(:id)
    training_session_ids.sample(25).each do |training_session_id|
      user_ids = User.where(role: :member).pluck(:id)
      user_ids.sample(rand(1..10)).each do |user_id|
        created_at = Faker::Date.between(from: 1.week.ago, to: Date.today)
        updated_at = Faker::Date.between(from: created_at, to: Date.today)

        member_sessions << "(#{user_id}, #{training_session_id}, '#{created_at}', '#{updated_at}')"
      end
    end

    member_session_seed += member_sessions.join(",\n") + ";" + "\n\n\n"

    ActiveRecord::Base.connection.execute(member_session_seed)
    File.open("db/seeds.sql", "a") do |file|
      file.puts member_session_seed
    end
  end

  desc "Seed Announcements"
  task seedAnnouncement: :environment do
    require 'active_record'
    require 'faker'

    announcement_seed = "\n\n-- Seed Announcements --\n"
    announcement_seed += "INSERT INTO announcements (title, content, for_user_type, created_at, updated_at) VALUES\n"

    announcements = []
    6.times do
      title = Faker::Lorem.sentence(word_count: 2)
      content = Faker::Lorem.paragraph(sentence_count: 3)
      for_user_type = [0, 1].sample
      created_at = Faker::Date.between(from: 1.week.ago, to: Date.today)
      updated_at = Faker::Date.between(from: created_at, to: Date.today)

      announcements << "('#{title}', '#{content}', #{for_user_type}, '#{created_at}', '#{updated_at}')"
    end

    announcement_seed += announcements.join(",\n") + ";" + "\n\n\n"

    ActiveRecord::Base.connection.execute(announcement_seed)
    File.open("db/seeds.sql", "a") do |file|
      file.puts announcement_seed
    end
  end

  desc "Seed Reminders"
  task seedReminder: :environment do
    require 'active_record'
    require 'faker'

    reminder_seed = "\n\n-- Seed Reminders --\n"
    reminder_seed += "INSERT INTO reminders (title, content, due_date, created_at, updated_at) VALUES\n"

    reminders = []
    5.times do
      title = Faker::Lorem.sentence(word_count: 2)
      content = Faker::Lorem.paragraph(sentence_count: 3)
      due_date = Faker::Date.between(from: Date.today, to: Date.today + 1.month)
      created_at = Faker::Date.between(from: 1.week.ago, to: Date.today)
      updated_at = Faker::Date.between(from: created_at, to: Date.today)

      reminders << "('#{title}', '#{content}', '#{due_date}', '#{created_at}', '#{updated_at}')"
    end

    reminder_seed += reminders.join(",\n") + ";" + "\n\n\n"

    ActiveRecord::Base.connection.execute(reminder_seed)
    File.open("db/seeds.sql", "a") do |file|
      file.puts reminder_seed
    end
  end

  desc "Seed Equipment"
  task seedEquipment: :environment do
    require 'active_record'
    require 'faker'

    equipment_seed = "\n\n-- Seed Equipment --\n"
    equipment_seed += "INSERT INTO equipment (name, description, location, is_broken, created_at, updated_at) VALUES\n"

    equipments = []
    50.times do
      name = Faker::Appliance.equipment
      description = Faker::Lorem.paragraph(sentence_count: 3)
      location = Faker::Number.between(from: 0, to: 7)
      is_broken = Faker::Boolean.boolean
      created_at = Faker::Date.between(from: 1.week.ago, to: Date.today)
      updated_at = Faker::Date.between(from: created_at, to: Date.today)

      equipments << "('#{name}', '#{description}', #{location}, #{is_broken}, '#{created_at}', '#{updated_at}')"
    end

    equipment_seed += equipments.join(",\n") + ";" + "\n\n\n"

    ActiveRecord::Base.connection.execute(equipment_seed)
    File.open("db/seeds.sql", "a") do |file|
      file.puts equipment_seed
    end
  end

  desc "Seed Payments"
  task seedPayment: :environment do
    require 'active_record'
    require 'faker'

    payment_seed = "\n\n-- Seed Payments --\n"
    payment_seed += "INSERT INTO payments (user_id, payment_date, created_at, updated_at) VALUES\n"

    payments = []

    member_ids = User.where(role: :member).pluck(:id)
    member_ids.each do |user_id|
      starting_date = Faker::Date.between(from: 1.years.ago, to: 2.months.ago)
      ending_date = Faker::Date.between(from: 2.months.ago, to: Date.today)

      while starting_date < ending_date
        payment_date = starting_date
        created_at = Faker::Date.between(from: 1.week.ago, to: Date.today)
        updated_at = Faker::Date.between(from: created_at, to: Date.today)

        payments << "(#{user_id}, '#{payment_date}', '#{created_at}', '#{updated_at}')"
        starting_date = starting_date + 1.month
      end
    end

    payment_seed += payments.join(",\n") + ";" + "\n\n\n"

    ActiveRecord::Base.connection.execute(payment_seed)
    File.open("db/seeds.sql", "a") do |file|
      file.puts payment_seed
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
    created_at = Faker::Date.between(from: 1.year.ago, to: Date.today)
    updated_at = Faker::Date.between(from: created_at, to: Date.today)

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
