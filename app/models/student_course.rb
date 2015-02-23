class StudentCourse < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :course_id
end
