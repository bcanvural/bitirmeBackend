class Course < ActiveRecord::Base
  validates_uniqueness_of :id, scope: :user_id
  has_many :course_entities
end
