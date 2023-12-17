class Student < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id', optional: true
    belongs_to :section, foreign_key: 'section_id', optional: true
end
