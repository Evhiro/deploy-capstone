class Section < ApplicationRecord
    has_many :student, foreign_key: 'section_id'
end
