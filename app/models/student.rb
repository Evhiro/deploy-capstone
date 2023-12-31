class Student < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id', optional: true
    belongs_to :section, foreign_key: 'section_id', optional: true
    has_many :student_grade, foreign_key: "student_id"
end
