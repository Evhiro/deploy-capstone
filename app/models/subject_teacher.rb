class SubjectTeacher < ApplicationRecord
  belongs_to :login, foreign_key: 'name', primary_key: 'name', class_name: 'Teacher'
  belongs_to :section
end
