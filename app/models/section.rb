class Section < ApplicationRecord
    has_many :student, foreign_key: 'section_id'
    has_many :student_grade, foreign_key: 'section_id'
end
