class StudentGrade < ApplicationRecord
    belongs_to :student, foreign_key: "student_id", optional: true
    belongs_to :section, foreign_key: "section_id", optional: true
    belongs_to :subject, foreign_key: "subject_id", optional: true
end
