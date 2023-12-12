class SectionStudent < ApplicationRecord
  belongs_to :login, foreign_key: 'name', primary_key: 'name', class_name: 'Student'
  belongs_to :section
end
