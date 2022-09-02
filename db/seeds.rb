# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

group = Group.create(name: "三宮プログラミング", password: "aaa111")

group.users.create(name: "三宮ひなこ", email: "san-no-miya@mail.com", password: "aaa111")

student_names = %w[越谷幹夫 石橋隆介 安藤まり]
student_names.each do |name|
  group.students.create(name: name)
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
      group.class_availabilities.create(from: start_from, to: ends_at)
    end
  end
  date = date.tomorrow
end

course = group.courses.create(name: "JavaScript基礎")
step_names = ["Hello World!", "データ型", "変数", "演算子", "関数"]
step_names.each do |step|
  course.steps.create(name: step)
end

mikio = group.students.find_by(name: "越谷幹夫")
step_names.each do |step|
  mikio.progresses.create(step: course.steps.find_by(name: step), is_completed: false)
end
