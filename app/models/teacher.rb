class Teacher < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id'
    has_many :subject_teacher_section, foreign_key: 'teacher_id'
end
