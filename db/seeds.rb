# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'
include Faker

#User.destroy_all
Course.destroy_all
StudentCourse.destroy_all

50.times do

  user = User.create( :first_name => Name.name,
                      :last_name=>Name.name,
                      :email => Internet.email,
                      :password => '12345678',
                      :instructor => rand(2),
                      :student => rand(2),
                      :udid => Bitcoin.address
  )
user.save

end



  User.where(instructor: true).find_each do |user|
    randNum = rand(1..3)
    randNum.times do
     course = Course.create(
                :name =>Lorem.characters(5),
                :user_id => user.id
      )
      course.save!
    end
  end

User.where(student: true).find_each do |user|
  randNum = rand(3..5)
  randNum.times do
    course = Course.offset(rand(Course.count)).first
    student_course = StudentCourse.create(
        :course_id =>course.id,
        :user_id => user.id
    )
    student_course.save
  end
end