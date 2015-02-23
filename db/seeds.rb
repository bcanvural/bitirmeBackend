# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'
include Faker

%w(CS201 CS204 CS300 CS408 CS310 )

#StudentCourse.destroy_all
User.destroy_all
Course.destroy_all

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







# create_table "users", force: true do |t|
#   t.string   "first_name"
#   t.string   "last_name"
#   t.string   "email"
#   t.string   "password_hash"
#   t.string   "password_salt"
#   t.boolean  "email_verification", default: false
#   t.string   "verification_code"
#   t.string   "api_authtoken"
#   t.datetime "authtoken_expiry"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.boolean  "instructor"
#   t.boolean  "student"
#   t.string   "udid"
# end
#
# movie = Movie.create(:name=>Company.bs,
#                      :director=>"#{Name.name}",
#                      :description=>Lorem.paragraphs.join("<br/>"),
#                      :year=> rand(1940..2015),
#                      :length=>rand(20..240),
#                      :format=>formats[rand(formats.length)],
#                      :image=>"movies/"+images[rand(images.length)],
#                      :thumbnail=>"movies/"+images[rand(images.length)]
#
# )