# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

cobra = Group.create(name: "Cobra Kai", password: "aaa111")

cobra.users.create(name: "Johnny Lawrence", email: "johnny@karate.com", password: "aaa111")

student_names = ["Miguel Diaz", "Hawk", "Aisha Robinson"]
student_names.each do |name|
  cobra.students.create(name: name)
end

current_time = Time.zone.now
date = current_time.beginning_of_month
start_hour = 12
end_hour = 12
while date <= current_time.end_of_month
  if date.wday == 0
    start_from = Time.zone.local(date.year, date.month, date.day, start_hour)
    ends_at = Time.zone.local(date.year, date.month, date.day, end_hour)
    5.times do
      cobra.class_availabilities.create(from: start_from, to: ends_at)
    end
  end
  date = date.tomorrow
end
