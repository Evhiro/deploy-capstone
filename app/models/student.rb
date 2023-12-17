class Student < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id'
    belongs_to :section, foreign_key: 'section_id'
end
