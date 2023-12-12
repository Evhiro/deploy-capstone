class Section < ApplicationRecord
    has_many :section_students, foreign_key: 'section_name', primary_key: 'section_name'
    has_many :students, through: :section_students, source: :login, source_type: 'Student'
  
    has_many :subject_teachers, foreign_key: 'section_name', primary_key: 'section_name'
    has_many :teachers, through: :subject_teachers, source: :login, source_type: 'Teacher'
  
    has_many :schedules, foreign_key: 'section_name', primary_key: 'section_name'
    has_many :subjects, foreign_key: 'section_name', primary_key: 'section_name'
end
