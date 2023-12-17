class Subject < ApplicationRecord
    has_many :subject_teacher_section, foreign_key: "subject_id"
end
