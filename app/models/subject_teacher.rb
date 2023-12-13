class SubjectTeacher < ApplicationRecord
  belongs_to :section, foreign_key: 'section_name', primary_key: 'section_name'
end
