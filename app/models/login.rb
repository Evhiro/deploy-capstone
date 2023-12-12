class Login < ApplicationRecord
    belongs_to :student, foreign_key: 'email', primary_key: 'email', optional: true
    belongs_to :teacher, foreign_key: 'email', primary_key: 'email', optional: true
    belongs_to :section, polymorphic: true, optional: true
    has_secure_password

    enum account_type: { admin: 'admin', student: 'student', teacher: 'teacher' }

    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
end
