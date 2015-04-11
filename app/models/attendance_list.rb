class AttendanceList < ActiveRecord::Base
  belongs_to :user
  belongs_to :course_entity
end
