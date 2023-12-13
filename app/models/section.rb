class Section < ApplicationRecord
    has_many :section_students, foreign_key: 'section_name', primary_key: 'section_name'
  
    has_many :subject_teachers, foreign_key: 'section_name', primary_key: 'section_name'
  
    has_many :schedules, foreign_key: 'section_name', primary_key: 'section_name'
end
