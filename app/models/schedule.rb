class Schedule < ApplicationRecord
    has_many :subject_teacher_section, foreign_key: "schedule_id"
end
