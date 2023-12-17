class SubjectTeacherSection < ApplicationRecord
    belongs_to :subject, foreign_key: "subject_id"
    belongs_to :teacher, foreign_key: "teacher_id"
    belongs_to :schedule, foreign_key: "schedule_id"
    belongs_to :section, foreign_key: "section_id"
end
