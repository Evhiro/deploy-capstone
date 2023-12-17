class SubjectTeacherSection < ApplicationRecord
    belongs_to :subject, foreign_key: "subject_id", optional: true
    belongs_to :teacher, foreign_key: "teacher_id", optional: true
    belongs_to :schedule, foreign_key: "schedule_id", optional: true
    belongs_to :section, foreign_key: "section_id", optional: true
end
